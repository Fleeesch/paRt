local gui = {}

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Get Light Theme
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function gui.checkCurrentTheme()

    -- check for dark theme
    if string.find(reaper.GetLastColorThemeFile(), "Dark") then
        Part.Global.par_theme_selected:setValue(0)
    end

    -- check for dark windows theme
    if string.find(reaper.GetLastColorThemeFile(), "Windows") then
        Part.Global.par_theme_selected:setValue(1)
    end

    -- check for light theme
    if string.find(reaper.GetLastColorThemeFile(), "Light") then
        Part.Global.par_theme_selected:setValue(2)
    end

    -- check for light theme, switch color palette
    if string.find(reaper.GetLastColorThemeFile(), "Light") then
        Part.Global.part_light_theme = true
        Part.Color.Lookup.useLightPalette()
    else

        Part.Global.part_light_theme = false
        if string.find(reaper.GetLastColorThemeFile(), "Windows") then
            Part.Color.Lookup.useDarkWindowsPalette()
        else
            Part.Color.Lookup.useDarkPalette()
        end
    end

    return Part.Global.part_light_theme

end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Validate Theme
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function gui.validateTheme(initial_validation)

    Part.Version.getThemeVersion()
    
    if Part.Version.themeVersionIsValid() then

        -- reload theme when switching from a non-part theme
        if not initial_validation and Part.Global.theme_version == "" then
            Part.reload()
            return false
            end
            
        return true
    
    end
        
    return false

end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Lookup available Themes
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function gui.lookupAvailableThemes()

    local themepath = reaper.GetResourcePath() .. "/ColorThemes/"

    -- collected lists
    local reapertheme = Part.Functions.listFilesInFolder(themepath, "ReaperTheme")
    local reapertheme_zip = Part.Functions.listFilesInFolder(themepath, "ReaperThemeZip")

    local theme_list = {reapertheme_zip, reapertheme}

    -- patterns
    local pattern_dark = "^part%s%-%sdark"
    local pattern_dark_win = "^part%s%-%sdark%s%-%swin"
    local pattern_light = "^part%s%-%slight"

    -- theme file names
    local theme_dark = nil
    local theme_dark_win = nil
    local theme_light = nil

    -- iterate themes, prioritizing reaperthemezip files
    for _, theme in pairs(theme_list) do
        for key, val in pairs(theme) do

            -- dark - win theme
            if theme_dark_win == nil and string.find(val:lower(), pattern_dark_win) then
                theme_dark_win = val
            end

            -- dark theme
            if theme_dark == nil and string.find(val:lower(), pattern_dark) then
                theme_dark = val
            end

            -- light theme
            if theme_light == nil and string.find(val:lower(), pattern_light) then
                theme_light = val
            end

        end
    end

    -- return the collected theme files
    return theme_dark, theme_dark_win, theme_light

end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Validate Loading Theme
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function gui.validateLoadingTheme(theme_file, title)

    -- check if theme file is available
    if theme_file == nil then
        Part.Message.Handler.showMessage("No " .. title .. " found", "!", "error")
        return false
    end

    -- unix path conversion
    local now_path = reaper.GetLastColorThemeFile():gsub("\\", "/")
    local target_path = (reaper.GetResourcePath() .. "/ColorThemes/" .. theme_file):gsub("\\", "/")

    -- don't load theme if already loaded
    if now_path == target_path then
        Part.Message.Handler.showMessage("Theme already loaded")
        return false
    end

    return true

end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Load Theme
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function gui.loadTheme(theme_file, title)

    reaper.OpenColorThemeFile(theme_file)

end
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Load Dark Theme
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function loadDarkTheme()

    local dark, darkwin, light = gui.lookupAvailableThemes()

    -- check if theme should or can be loaded
    if not gui.validateLoadingTheme(dark, "Dark Theme") then
        return
    end

    -- pending theme load
    table.insert(Part.List.pending_action, {
        func = gui.loadTheme,
        args = {dark, "Dark Theme"}
    })

    -- loading message
    Part.Draw.Graphics.splashMessage("Loading Dark Theme...")

end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Load Dark Windows Theme
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function loadDimmedTheme()

    local dark, darkwin, light = gui.lookupAvailableThemes()

    -- check if theme should or can be loaded
    if not gui.validateLoadingTheme(darkwin, "Dimmed Theme") then
        return
    end

    -- pending theme load
    table.insert(Part.List.pending_action, {
        func = gui.loadTheme,
        args = {darkwin, "Dimmed Theme"}
    })

    -- loading message
    Part.Draw.Graphics.splashMessage("Loading Dimmed Theme...")

end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Load Light Theme
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function loadLightTheme()

    local dark, darkwin, light = gui.lookupAvailableThemes()

    -- check if theme should or can be loaded
    if not gui.validateLoadingTheme(light, "Light Theme") then
        return
    end

    -- pending theme load
    table.insert(Part.List.pending_action, {
        func = gui.loadTheme,
        args = {light, "Light Theme"}
    })

    -- loading message
    Part.Draw.Graphics.splashMessage("Loading Light Theme...")

end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Check for Theme Change
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function gui.checkForThemeChange()

    -- reload on theme change
    if Part.Global.last_theme_file ~= reaper.GetLastColorThemeFile() then
        Part.reload()
    end

end

return gui