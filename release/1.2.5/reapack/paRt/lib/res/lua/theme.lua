-- @version 1.2.2
-- @author Fleeesch
-- @description paRt Theme Adjuster
-- @noIndex

--[[
    Reaper Theme file management; validation and enumeration of color themes.
]] --

local themehandling = {}

-- ================================================================================
--                          Theme Handling
-- ================================================================================

themehandling.last_theme_layout = "default"

themehandling.error_theme_version_is_too_low = false

--  Helper Method : Words Match
-- -------------------------------------------

-- OR logic, single match counts as proper match

local function words_match(input, words)
    -- words must be table
    if type(words) ~= "table" then
        words = { words }
    end

    -- case-insensitive
    input = input:lower()

    -- iterate words
    for _, w in ipairs(words) do
        -- look for a match
        if input:find(w:lower(), 1, true) then
            return true
        end
    end
    return false
end

--  Method : Check Current Theme
-- -------------------------------------------

function themehandling.checkCurrentTheme()
    local current_theme_file = string.lower(reaper.GetLastColorThemeFile())

    -- check for dark theme
    if string.find(current_theme_file, "dark") then
        Part.Global.par_theme_selected:setValue(0)
        Part.Color.Lookup.useDarkPalette()
    end

    -- check for dimmed theme
    if string.find(current_theme_file, "dimmed") then
        Part.Global.par_theme_selected:setValue(1)
        Part.Color.Lookup.useDimmedPalette()
    end

    -- check for light theme
    if string.find(current_theme_file, "light") then
        Part.Global.par_theme_selected:setValue(2)
        Part.Color.Lookup.useLightPalette()
    end
end

--  Method : Validate Theme
-- -------------------------------------------

function themehandling.validateTheme(initial_validation)
    Part.Version.getThemeVersion()

    -- reload if theme suddenly became valid
    if Part.Version.themeVersionIsValid() then
        --
        -- switching from a non-paRt theme will force a reload
        if not initial_validation and Part.Global.theme_version == "" then
            Part.reload()
            return false
        end

        -- theme version must not be lower that theme adjuster version
        if Part.Version.theme_version_is_lower then
            return false
        end

        -- update global theme data
        local theme_path, theme_name = reaper.BR_GetCurrentTheme()
        local theme_data = themehandling.getThemeMetaData(theme_name)
        Part.Global.theme_is_unpacked = theme_data.unpacked
        Part.Global.theme_is_modded = theme_data.mod

        return true
    end

    return false
end

--  Method : Get Theme Meta Data
-- -------------------------------------------

function themehandling.getThemeMetaData(theme_name)
    local modded = false
    local unpacked = false

    if words_match(theme_name, { "mod", "modded", "modified" }) then
        modded = theme_name
    elseif words_match(theme_name, "unpacked") then
        unpacked = theme_name
    end

    return { mod = modded, unpacked = unpacked }
end

--  Method : Lookup available Themes
-- -------------------------------------------

function themehandling.lookForPartThemes()
    -- Helper-Function : Theme Match
    -- ==============================================
    local function theme_matches(input_string, target_theme)
        return words_match(input_string, "part") and words_match(input_string, target_theme)
    end

    -- Helper-Function : Prioritize Theme
    -- ==============================================
    local function parse_theme(theme_collection)
        -- filter targets
        local them_file_remains = nil
        local theme_file_modded = nil
        local theme_file_modded_unpacked = false
        local theme_file_unpacked = nil

        -- iterate theme collection
        for _, theme in pairs(theme_collection) do
            -- ignore themes that are meant to be skipped
            if not words_match(theme, { "skip" }) then
                local theme_data = themehandling.getThemeMetaData(theme)

                if theme_data.mod then
                    theme_file_modded = theme
                elseif theme_data.unpacked then
                    theme_file_unpacked = theme
                else
                    them_file_remains = theme
                end
            end
        end

        -- prioritize modded themes over everything
        if theme_file_modded ~= nil then
            return { file = theme_file_modded, mod = true, unpacked = true }
        end

        -- prioritize unpacked themes over potentially zipped ones
        if theme_file_unpacked ~= nil then
            return { file = theme_file_unpacked, mod = false, unpacked = true }
        end

        -- use original theme if there's nothing else
        if them_file_remains ~= nil then
            return { file = them_file_remains, mod = false, unpacked = false }
        end

        return nil
    end

    -- ==============================================

    local themepath = reaper.GetResourcePath() .. "/ColorThemes/"

    -- collected theme file lists
    local reapertheme = Part.Functions.listFilesInFolder(themepath, "ReaperTheme")
    local reapertheme_zip = Part.Functions.listFilesInFolder(themepath, "ReaperThemeZip")
    local theme_list = { reapertheme_zip, reapertheme }

    -- theme file collections separated by color scheme
    local theme_collection_dark = {}
    local theme_collection_dimmed = {}
    local theme_collection_light = {}

    -- target theme files
    local theme_dark = nil
    local theme_dimmed = nil
    local theme_light = nil

    -- iterate themes, prioritizing reaperthemezip files
    for _, theme_files in pairs(theme_list) do
        for _, theme in pairs(theme_files) do
            -- dark themes
            if theme_matches(theme, "dark") then
                table.insert(theme_collection_dark, theme)
            end
            -- dimmed themes
            if theme_matches(theme, "dimmed") then
                table.insert(theme_collection_dimmed, theme)
            end
            -- light themes
            if theme_matches(theme, "light") then
                table.insert(theme_collection_light, theme)
            end
        end
    end

    -- filter themes by prioritization
    theme_dark = parse_theme(theme_collection_dark)
    theme_dimmed = parse_theme(theme_collection_dimmed)
    theme_light = parse_theme(theme_collection_light)

    -- return theme lists based on keywords
    return { Dark = theme_dark, Dimmed = theme_dimmed, Light = theme_light }
end

--  Method : Validate Loading Theme
-- -------------------------------------------

function themehandling.validateLoadingTheme(title)
    -- get theme file
    local themes = themehandling.lookForPartThemes()

    -- abort if no theme found
    if themes[title] == nil then
        return nil
    end

    local theme_file = themes[title].file

    -- theme file must exist
    if theme_file == nil then
        Part.Message.Handler.showMessage("No " .. title .. " theme found", "!", "error")
        return
    end

    -- unix path conversion
    local now_path = reaper.GetLastColorThemeFile():gsub("\\", "/")
    local target_path = (reaper.GetResourcePath() .. "/ColorThemes/" .. theme_file):gsub("\\", "/")

    -- don't load theme if already loaded
    if now_path == target_path then
        Part.Message.Handler.showMessage("Theme already loaded")
        return nil
    end

    return theme_file
end

--  Method : Check for Theme Change
-- -------------------------------------------

function themehandling.checkForThemeChange()
    -- reload on theme change
    if Part.Global.last_theme_file ~= reaper.GetLastColorThemeFile() then
        Part.reload()
    end
end

--  Method : Load Theme
-- -------------------------------------------

function themehandling.loadTheme(theme_file)
    reaper.OpenColorThemeFile(theme_file)
end

--  Method : Initiate loading Theme
-- -------------------------------------------

function themehandling.initiateLoadingTheme(title)
    local theme_file = themehandling.validateLoadingTheme(title)
    -- theme needs to be loadable
    if theme_file == nil then
        return
    end
    -- pending theme load
    table.insert(Part.List.pending_action, {
        func = themehandling.loadTheme,
        args = { theme_file }
    })

    -- splash message
    Part.Draw.Graphics.splashMessage("Loading " .. title .. " Theme...")
end

--  Method : Freeze Theme
-- -------------------------------------------

-- gets called whenever a large amount of theme parameters are changed
-- -> this is not an actual freeze in a technical sense, there is no functionality provided by Reaper for this

function themehandling.freezeTheme()
    -- only allow freezing after startup, otherwise you'll be dealing with slowdown
    if Part.Global.ticks < Part.Global.startup_delay then
        return
    end

    -- load a layout that doesn't exist (seems to halt individual parameter updates during this layout)
    reaper.ThemeLayout_SetLayout("global", "freeze")
end

--  Method : Unfreeze Theme
-- -------------------------------------------

-- gets called whenever a large amount of theme parameters are changed

function themehandling.unfreezeTheme()
    -- only allow freezing after startup, otherwise you'll be dealing with slowdown
    if Part.Global.ticks < Part.Global.startup_delay then
        return
    end

    -- back to default layout
    reaper.ThemeLayout_SetLayout("global", "")
end

--  Method : Load Dark Theme
-- -------------------------------------------
-- has to be global because of an externally stored function call

function loadDarkTheme()
    themehandling.initiateLoadingTheme("Dark")
end

--  Method : Load Dark Windows Theme
-- -------------------------------------------
-- has to be global because of an externally stored function call

function loadDimmedTheme()
    themehandling.initiateLoadingTheme("Dimmed")
end

--  Method : Load Light Theme
-- -------------------------------------------
-- has to be global because of an externally stored function call

function loadLightTheme()
    themehandling.initiateLoadingTheme("Light")
end

return themehandling
