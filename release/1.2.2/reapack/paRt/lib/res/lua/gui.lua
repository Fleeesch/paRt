-- @version 1.2.2
-- @author Fleeesch
-- @description paRt Theme Adjuster
-- @noIndex

--[[
    Windows and Theme management; handles dpi tracking and theme file analysis.

    Also contains mouse-over-hint management.
]] --

local gui = { Window = {}, Theme = {}, Keyboard = {}, Mouse = {}, Hint = { Hint = {}, Lookup = {} } }

-- ================================================================================
--                          Window Management
-- ================================================================================

gui.Window.dpi_detection_delay = 10
gui.Window.dpi_detection_clock = 0

--  Method : Store Dock State
-- -------------------------------------------

function gui.Window.storeDockState()
    local dock_state, gfx_x, gfx_y, gfx_w, gfx_h = gfx.dock(-1, 0, 0, 0, 0)

    if dock_state == 0 then
        reaper.DeleteExtState(Part.Global.ext_section, "Window Position - Dock", true)
    else
        reaper.SetExtState(Part.Global.ext_section, "Window Position - Dock", tostring(dock_state), true)
    end
end

--  Method : Was Docked
-- -------------------------------------------

function gui.Window.wasDocked()
    if reaper.HasExtState(Part.Global.ext_section, "Window Position - Dock") then
        if reaper.GetExtState(Part.Global.ext_section, "Window Position - Dock") == "true" then
            return true
        end
    end

    return false
end

--  Method : Is Docked
-- -------------------------------------------

function gui.Window.isDocked()
    return gfx.dock(-1) == 1
end

--  Method : Get Window Scaling Factor
-- -------------------------------------------
function gui.Window.calcScale()
    Part.Global.scale = Part.Functions.match_array(gfx.ext_retina, Part.Global.zoom_levels)
    Part.Draw.Graphics.border = math.max(math.floor(Part.Draw.Graphics.border_base * Part.Global.scale), 1)
    return Part.Global.scale
end

--  Method : Store Window Position
-- -------------------------------------------

function gui.Window.storeWindow()
    -- get window dimensions
    local dock_state, gfx_x, gfx_y, gfx_w, gfx_h = gfx.dock(-1, 0, 0, 0, 0)

    -- window position
    Part.Global.win_x = gfx_x
    Part.Global.win_y = gfx_y

    -- store dimensiosn as ext states
    reaper.SetExtState(Part.Global.ext_section, "Window Position - X", tostring(gfx_x), true)
    reaper.SetExtState(Part.Global.ext_section, "Window Position - Y", tostring(gfx_y), true)

    gui.Window.storeDockState()

    -- ext state indicating that window data is available
    reaper.SetExtState(Part.Global.ext_section, "Window Position - Available", "true", true)
end

--  Method : Get Window Position
-- -------------------------------------------

function gui.Window.restoreWindow()
    -- check if data is available
    local has_pos = reaper.GetExtState(Part.Global.ext_section, "Window Position - Available")

    -- default values
    local x = Part.Global.winpos_default_x
    local y = Part.Global.winpos_default_y

    -- data available?
    if has_pos then
        x = tonumber(reaper.GetExtState(Part.Global.ext_section, "Window Position - X"))
        y = tonumber(reaper.GetExtState(Part.Global.ext_section, "Window Position - Y"))
    end

    return x, y
end

--  Method : Store Last Window Position
-- -------------------------------------------

function gui.Window.storeLastWindowPosition()
    Part.Global.win_w_last = gfx.w
    Part.Global.win_h_last = gfx.h
end

--  Method : Set Window Position
-- -------------------------------------------

function gui.Window.setWindowPosition(x, y)
    -- set window x and y position
    local w, h

    if Part.Global.os_macos then
        w = Part.Global.win_w
        h = Part.Global.win_h
    else
        w = Part.Functions.rescale(Part.Global.win_w)
        h = Part.Functions.rescale(Part.Global.win_h)
    end

    gfx.init(nil, w, h, false, x, y)

    gui.Window.storeLastWindowPosition()
end

--  Method : Set Scale Factor
-- -------------------------------------------

function gui.Window.setScale(scale_factor)
    -- calculate width and height
    local w, h

    if Part.Global.os_macos then
        w = Part.Global.win_w
        h = Part.Global.win_h
    else
        w = math.floor(Part.Global.win_w * scale_factor)
        h = math.floor(Part.Global.win_h * scale_factor)
    end
    -- adjust window
    gfx.init(nil, w, h, false, Part.Global.win_x, Part.Global.win_y)
end

--  Method : Update Window Dimensions
-- -------------------------------------------

function gui.Window.updateWindowDimensions()
    -- calculate width and height
    local w, h

    if Part.Global.os_macos then
        w = Part.Global.win_w
        h = Part.Global.win_h
    else
        w = math.floor(Part.Global.win_w * Part.Global.scale)
        h = math.floor(Part.Global.win_h * Part.Global.scale)
    end

    -- adjust window
    gfx.init(nil, w, h, false, Part.Global.win_x, Part.Global.win_y)
end

--  Method : Detect DPI Change
-- -------------------------------------------

function gui.Window.detectDpiChange(force)
    if Part.Global.scale ~= gfx.ext_retina then
        if gui.Window.dpi_detection_clock == gui.Window.dpi_detection_delay or force then
            gui.Window.calcScale()
            gui.Window.calculateWindowSizeData()
            Part.Draw.Sprites.createAssets()
            Part.Draw.Elements.prepareElements()
            Part.Draw.Buffer.clearCompleteBuffer()
        end

        if not force then
            gui.Window.dpi_detection_clock = gui.Window.dpi_detection_clock + 1
        end
    else
        gui.Window.dpi_detection_clock = 0
    end
end

--  Method : Calculate Window Size Data
-- -------------------------------------------

function gui.Window.calculateWindowSizeData()
    Part.Global.win_x_offset = math.floor(math.max(gfx.w / Part.Global.scale - Part.Global.win_w, 0))
    Part.Global.win_y_offset = math.floor(math.max(gfx.h / Part.Global.scale - Part.Global.win_h, 0))
    Part.Global.win_x_offset_centered = math.floor(Part.Global.win_x_offset * 0.5 + 0.5)
    Part.Global.win_y_offset_centered = math.floor(Part.Global.win_y_offset * 0.5 + 0.5)
end

--  Method : Detect Window Resize
-- -------------------------------------------

function gui.Window.detectWindowResize()
    if gfx.w ~= Part.Global.win_w_last or gfx.h ~= Part.Global.win_h_last then
        gui.Window.calculateWindowSizeData()
        Part.Draw.Buffer.clearCompleteBuffer()
    end

    gui.Window.storeLastWindowPosition()
end

--  Method : Init Window
-- -------------------------------------------

function gui.Window.initWindow()
    Part.Draw.Elements.prepareElements()

    -- restore window coordinates
    Part.Global.win_x, Part.Global.win_y = gui.Window.restoreWindow()

    local win_title = Part.Global.win_title

    -- open window
    gfx.init(win_title, Part.Global.win_w, Part.Global.win_h, false, Part.Global.win_x, Part.Global.win_y)
    gfx.ext_retina = 1
    gfx.quit()

    gfx.init(win_title, Part.Global.win_w, Part.Global.win_h, false, Part.Global.win_x, Part.Global.win_y)

    gui.Window.detectDpiChange(true)

    -- dock state
    if reaper.HasExtState(Part.Global.ext_section, "Window Position - Dock") then
        local dock_state = tonumber(reaper.GetExtState(Part.Global.ext_section, "Window Position - Dock"))
        gfx.dock(dock_state)
    end

    gui.Window.updateWindowDimensions()
    gui.Window.calculateWindowSizeData()
end

-- ================================================================================
--                          Theme Handling
-- ================================================================================

gui.last_theme_layout = "default"

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

function gui.Theme.checkCurrentTheme()
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

function gui.Theme.validateTheme(initial_validation)
    Part.Version.getThemeVersion()

    -- reload if theme suddenly became valid
    if Part.Version.themeVersionIsValid() then
        if not initial_validation and Part.Global.theme_version == "" then
            Part.reload()
            return false
        end

        -- update global theme data
        local theme_path, theme_name = reaper.BR_GetCurrentTheme()
        local theme_data = gui.Theme.getThemeMetaData(theme_name)
        Part.Global.theme_is_unpacked = not theme_data.zipped
        Part.Global.theme_is_modded = theme_data.mod

        return true
    end

    return false
end

--  Method : Get Theme Meta Data
-- -------------------------------------------

function gui.Theme.getThemeMetaData(theme_path)
    local file_name, file_extension = Part.Functions.getFileNameFromPath(theme_path)

    local modded = false
    local unpacked = false
    local zip = words_match(file_extension, "ReaperThemeZip")


    if words_match(theme_path, { "mod", "modded", "modified" }) then
        modded = theme_path
    elseif words_match(theme_path, "unpacked") then
        unpacked = theme_path
    end

    return { mod = modded, unpacked = unpacked, zipped = zip }
end

--  Method : Lookup available Themes
-- -------------------------------------------

function gui.Theme.lookForPartThemes()
    -- Helper-Function : Theme Match
    -- ==============================================
    local function theme_matches(input_string, target_theme)
        return words_match(input_string, "part") and words_match(input_string, target_theme)
    end

    -- Helper-Function : Prioritize Theme
    -- ==============================================
    local function parse_them(theme_collection)
        -- filter targets
        local original = nil
        local modded = nil
        local unpacked = nil

        -- iterate theme collection
        for _, theme in pairs(theme_collection) do
            -- ignore themes that are meant to be skipped
            if not words_match(theme, { "skip" }) then
                local theme_data = gui.Theme.getThemeMetaData(theme)

                if theme_data.mod then
                    modded = theme
                elseif theme_data.unpacked then
                    unpacked = theme
                elseif theme_data.zipped then
                    original = theme
                end
            end
        end

        -- prioritize modded themes over everything
        if modded ~= nil then
            return { file = modded, mod = true, unpacked = true }
        end

        -- prioritize unpacked themes over zipped ones
        if unpacked ~= nil then
            return { file = unpacked, mod = false, unpacked = true }
        end

        -- use original theme if there's nothing else
        if original ~= nil then
            return { file = original, mod = false, unpacked = false }
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
    theme_dark = parse_them(theme_collection_dark)
    theme_dimmed = parse_them(theme_collection_dimmed)
    theme_light = parse_them(theme_collection_light)

    -- return theme lists based on keywords
    return { Dark = theme_dark, Dimmed = theme_dimmed, Light = theme_light }
end

--  Method : Validate Loading Theme
-- -------------------------------------------

function gui.Theme.validateLoadingTheme(title)
    -- get theme file
    local themes = gui.Theme.lookForPartThemes()

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

function gui.Theme.checkForThemeChange()
    -- reload on theme change
    if Part.Global.last_theme_file ~= reaper.GetLastColorThemeFile() then
        Part.reload()
    end
end

--  Method : Load Theme
-- -------------------------------------------

function gui.Theme.loadTheme(theme_file)
    reaper.OpenColorThemeFile(theme_file)
end

--  Method : Initiate loading Theme
-- -------------------------------------------

function gui.Theme.initiateLoadingTheme(title)
    local theme_file = gui.Theme.validateLoadingTheme(title)
    -- theme needs to be loadable
    if theme_file == nil then
        return
    end
    -- pending theme load
    table.insert(Part.List.pending_action, {
        func = gui.Theme.loadTheme,
        args = { theme_file }
    })

    -- splash message
    Part.Draw.Graphics.splashMessage("Loading " .. title .. " Theme...")
end

--  Method : Freeze Theme
-- -------------------------------------------

-- gets called whenever a large amount of theme parameters are changed
-- -> this is not an actual freeze in a technical sense, there is no functionality provided by Reaper for this

function gui.Theme.freezeTheme()
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

function gui.Theme.unfreezeTheme()
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
    gui.Theme.initiateLoadingTheme("Dark")
end

--  Method : Load Dark Windows Theme
-- -------------------------------------------
-- has to be global because of an externally stored function call

function loadDimmedTheme()
    gui.Theme.initiateLoadingTheme("Dimmed")
end

--  Method : Load Light Theme
-- -------------------------------------------
-- has to be global because of an externally stored function call

function loadLightTheme()
    gui.Theme.initiateLoadingTheme("Light")
end

-- ================================================================================
--                          Mouse Input
-- ================================================================================


--  Mouse
-- -------------------------------------------

-- mouse position
gui.Mouse.x = 0
gui.Mouse.y = 0

-- mouse movement
gui.Mouse.x_delta = 0
gui.Mouse.y_delta = 0

-- clicks
gui.Mouse.l_click = false
gui.Mouse.r_click = false

-- releases
gui.Mouse.l_release = false
gui.Mouse.r_release = false

-- press states
gui.Mouse.l_on = false
gui.Mouse.r_on = false
gui.Mouse.m_on = false

-- modifiers
gui.Mouse.mod_ctrl = false
gui.Mouse.mod_shift = false
gui.Mouse.mod_alt = false

-- drag is active
gui.Mouse.drag_active = false

-- hover
gui.Mouse.hover_target = nil

-- timeout frames for registering lack of movement
gui.Mouse.stop_time = 15

-- timeout counter
gui.Mouse.stop_counter = 0


--  Mouse : No Action
-- -------------------------------------------

function gui.Mouse.noAction()
    -- check if stop counter is at zero
    return gui.Mouse.stop_counter == 0
end

--  Mouse : Left Button
-- -------------------------------------------

function gui.Mouse.leftHold()
    return gui.Mouse.l_on
end

function gui.Mouse.leftClick()
    return gui.Mouse.l_click
end

function gui.Mouse.leftRelease()
    return gui.Mouse.l_release
end

--  Mouse : Right Button
-- -------------------------------------------

function gui.Mouse.rightHold()
    return gui.Mouse.r_on
end

function gui.Mouse.rightClick()
    return gui.Mouse.r_click
end

function gui.Mouse.rightRelease()
    return gui.Mouse.m_release
end

--  Mouse : Middle Button
-- -------------------------------------------

function gui.Mouse.middleHold()
    return gui.Mouse.m_on
end

function gui.Mouse.middleClick()
    return gui.Mouse.m_click
end

function gui.Mouse.middleRelease()
    return gui.Mouse.m_release
end

--  Mouse : Modifiers
-- -------------------------------------------

function gui.Mouse.modControl()
    return gui.Mouse.mod_ctrl
end

function gui.Mouse.modShift()
    return gui.Mouse.mod_shift
end

function gui.Mouse.modAlt()
    return gui.Mouse.mod_alt
end

--  Mouse : Hover
-- -------------------------------------------

function gui.Mouse.hoverCheck(target, rect_x, rect_y, rect_w, rect_h)
    local x, y, w, h


    if target ~= nil then
        x = target.draw_x
        y = target.draw_y
        w = target.draw_w
        h = target.draw_h
    else
        x = rect_x
        y = rect_y
        w = rect_w
        h = rect_h
    end

    if gfx.mouse_x >= x and gfx.mouse_x <= x + w and gfx.mouse_y >= y and gfx.mouse_y <= y + h then
        gui.Mouse.hover_target = target
        return true
    end
end

--  Mouse : Update
-- -------------------------------------------

function gui.Mouse.update()
    gui.Mouse.hover_target = nil

    -- calcualte movement
    gui.Mouse.x_delta = gui.Mouse.x - gfx.mouse_x
    gui.Mouse.y_delta = gui.Mouse.y - gfx.mouse_y

    -- get mouse position
    gui.Mouse.x = gfx.mouse_x
    gui.Mouse.y = gfx.mouse_y

    -- decrement stop counter
    if gui.Mouse.stop_counter > 0 then
        gui.Mouse.stop_counter = gui.Mouse.stop_counter - 1
    end

    -- reset stop counter if any action is happening
    if gui.Mouse.x_delta ~= 0 or gui.Mouse.y_delta ~= 0 or gui.Mouse.l_on or gui.Mouse.r_on or gui.Mouse.m_on then
        gui.Mouse.stop_counter = gui.Mouse.stop_time
    end

    -- reset click and release
    gui.Mouse.l_click = false
    gui.Mouse.r_click = false
    gui.Mouse.l_release = false
    gui.Mouse.r_release = false


    gui.Mouse.l_release = gui.Mouse.l_on and gfx.mouse_cap & 1 == 0
    gui.Mouse.r_release = gui.Mouse.r_on and gfx.mouse_cap & 2 == 0
    gui.Mouse.l_click = not gui.Mouse.l_on and gfx.mouse_cap & 1 ~= 0
    gui.Mouse.r_click = not gui.Mouse.r_on and gfx.mouse_cap & 2 ~= 0

    -- reset presses and modifiers
    gui.Mouse.l_on = false
    gui.Mouse.r_on = false
    gui.Mouse.m_on = false
    gui.Mouse.mod_ctrl = false
    gui.Mouse.mod_shift = false
    gui.Mouse.mod_alt = false

    gui.Mouse.l_on = gfx.mouse_cap & 1 ~= 0
    gui.Mouse.r_on = gfx.mouse_cap & 2 ~= 0
    gui.Mouse.m_on = gfx.mouse_cap & 64 ~= 0
    gui.Mouse.mod_ctrl = gfx.mouse_cap & 4 ~= 0
    gui.Mouse.mod_shift = gfx.mouse_cap & 8 ~= 0
    gui.Mouse.mod_alt = gfx.mouse_cap & 16 ~= 0

    gui.Mouse.Drag.checkRelease()

    gui.Mouse.drag_active = not gui.Mouse.l_on
end

--  Method : Mouse in Rect
-- -------------------------------------------

function gui.Mouse.mouseInRect(x, y, w, h)
    -- check if mouse is within a rectangle
    return gfx.mouse_x >= x and gfx.mouse_x <= x + w and gfx.mouse_y >= y and gfx.mouse_y <= y + h
end

--  Method : Check if Drag is active
-- -------------------------------------------

function gui.Mouse.dragIsActive()
    -- mouse is actively dragging?
    return gui.Mouse.drag_active
end

--  Method : Mouse in Rect
-- -------------------------------------------

function gui.Mouse.activateDrag()
    -- activate a mouse drag
    gui.Mouse.drag_active = true
end

--  Drag
-- -------------------------------------------

gui.Mouse.Drag = {}

gui.Mouse.Drag.active = false

gui.Mouse.Drag.info = ""
gui.Mouse.Drag.target = nil

gui.Mouse.Drag.button_left = false
gui.Mouse.Drag.button_right = false
gui.Mouse.Drag.button_middle = false

gui.Mouse.Drag.mod_control = false
gui.Mouse.Drag.mod_shift = false
gui.Mouse.Drag.mod_alt = false



--  Drag : Info
-- -------------------------------------------

function gui.Mouse.Drag.getInfo()
    return gui.Mouse.Drag.info
end

--  Drag : Is On
-- -------------------------------------------

function gui.Mouse.Drag.isOn()
    return gui.Mouse.Drag.active, gui.Mouse.Drag.button_left, gui.Mouse.Drag.button_right,
        gui.Mouse.Drag.button_middle, gui.Mouse.Drag.mod_control, gui.Mouse.Drag.mod_shift,
        gui.Mouse.Drag.mod_alt
end

--  Drag : Is Off
-- -------------------------------------------

function gui.Mouse.Drag.isOff()
    return not gui.Mouse.Drag.active
end

--  Drag : Is Target
-- -------------------------------------------

function gui.Mouse.Drag.isTarget(target)
    if not gui.Mouse.Drag.active then
        return false
    end

    return gui.Mouse.Drag.target == target
end

--  Drag : On
-- -------------------------------------------

function gui.Mouse.Drag.on(target, info)
    if gui.Mouse.Drag.active then
        return
    end

    gui.Mouse.Drag.active = true

    gui.Mouse.Drag.target = target
    gui.Mouse.Drag.info = info or ""

    gui.Mouse.Drag.button_left = gui.Mouse.l_on
    gui.Mouse.Drag.button_right = gui.Mouse.r_on
    gui.Mouse.Drag.button_middle = gui.Mouse.m_on

    gui.Mouse.Drag.mod_control = gui.Mouse.mod_ctrl
    gui.Mouse.Drag.mod_shift = gui.Mouse.mod_shift
    gui.Mouse.Drag.mod_alt = gui.Mouse.mod_alt
end

--  Drag : Off
-- -------------------------------------------

function gui.Mouse.Drag.off()
    gui.Mouse.Drag.active = false

    gui.Mouse.Drag.info = ""
    gui.Mouse.Drag.target = nil

    gui.Mouse.Drag.button_left = false
    gui.Mouse.Drag.button_right = false
    gui.Mouse.Drag.button_middle = false

    gui.Mouse.Drag.mod_control = false
    gui.Mouse.Drag.mod_shift = false
    gui.Mouse.Drag.mod_alt = false
end

--  Drag : Check Release
-- -------------------------------------------

function gui.Mouse.Drag.checkRelease()
    local active, button_left, button_right, button_middle = gui.Mouse.Drag.isOn()

    if active then
        if (not gui.Mouse.leftRelease() and not gui.Mouse.leftHold() and button_left) or
            (not gui.Mouse.rightRelease() and not gui.Mouse.rightHold() and button_right) or
            (not gui.Mouse.middleRelease() and not gui.Mouse.middleHold() and button_middle)
        then
            gui.Mouse.Drag.off()
        end
    end
end

-- ================================================================================
--                          Keyboard Input
-- ================================================================================


--  Keyboard
-- -------------------------------------------

-- input keyboard code
gui.Keyboard.input = 0

-- character codes lookup table
gui.Keyboard.charcode = {
    null    = -1,
    esc     = 27,
    r       = 114,
    t       = 116,
    up      = 30064,
    down    = 1685026670,
    left    = 1818584692,
    right   = 1919379572,
    insert  = 6909555,
    delete  = 6579564,
    home    = 1752132965,
    key_end = 6647396,
    pgup    = 1885825906,
    pgdn    = 1885828460,
    f1      = 26161,
    f2      = 26162,
    f3      = 26163,
    f4      = 26164,
    f5      = 26165,
    f6      = 26166,
    f7      = 26167,
    f8      = 26168,
    f9      = 26169,
    f10     = 6697264,
    f11     = 6697265,
    f12     = 6697266,
    key_0   = 48,
    key_1   = 49,
    key_2   = 50,
    key_3   = 51,
    key_4   = 52,
    key_5   = 53,
    key_6   = 54,
    key_7   = 55,
    key_8   = 56,
    key_9   = 57,

}


--  Keyboard : Update
-- -------------------------------------------

function gui.Keyboard.update()
    -- get keyboard input
    gui.Keyboard.input = gfx.getchar()

    -- use character code to detect closed gui
    if gui.Keyboard.input == gui.Keyboard.charcode["null"] then
        -- mark gui as closed
        Part.Global.gui_closed = true
    end
end

--  Keyboard : Key is pressed
-- -------------------------------------------

function gui.Keyboard.isPressed(char)
    -- key is released
    if gui.Keyboard.charcode[char] == nil then
        return false
    end

    -- key is pressed
    if gui.Keyboard.input == gui.Keyboard.charcode[char] then
        return true
    end

    return false
end

-- ====================================================================================
--              Hint Message
-- ====================================================================================


--  Hint Message
-- -------------------------------------------

function gui.Hint.Hint:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    o.draw_x = 0
    o.draw_y = 0
    o.draw_w = 0
    o.draw_h = 0
    o.last_alpha = 0
    o.buffer_slot = 10

    o.font_size = 16
    o.height_size = 16
    o.block_space = 20
    o.paragraph_line_size = 8
    o.padding = 10
    o.shadow_size = 3

    -- hard-coded coordinates
    o.hint_pos_x = Part.Global.hint_x
    o.hint_pos_y = Part.Global.hint_y
    o.hint_width = Part.Global.hint_w
    o.hint_height = Part.Global.hint_h
    o.hint_pad = 0

    o.source = nil

    o.remove = false

    o.do_buffer = false

    return o
end

gui.Hint.hint_message = gui.Hint.Hint:new()


--  Hint Message : Buffer
-- -------------------------------------------

function gui.Hint.Hint:buffer()
    local source = self.source

    -- padding and shadow offsets
    local pad = Part.Functions.rescale(self.padding)
    local pad_callout = Part.Functions.rescale(4)

    -- text attributes
    local font_size = self.font_size
    local line_height = Part.Functions.rescale(self.height_size)
    local block_space = Part.Functions.rescale(self.block_space)

    -- initial buffer dimensions (temporary, will resize later)
    local w = self.hint_width - pad * 2
    local h = self.hint_height - pad * 2
    gfx.setimgdim(self.buffer_slot, -1, -1)
    gfx.setimgdim(self.buffer_slot, w, h)

    -- store current buffer slot
    local buffer_slot_last = gfx.dest

    -- destination buffer slot
    gfx.dest = self.buffer_slot

    -- output block width
    local width_limit = Part.Functions.rescale(w)

    -- block storage and starting values
    local blocks = {}
    local block_max_width = 0
    local block_total_height = 0

    -- iterate blocks
    for _, block in ipairs(source.text) do
        -- get type (default to "normal")
        local block_type = block.type or "normal"
        local font_flags = ""

        -- bold font
        if
            block.type == Part.Gui.Hint.Lookup.HintTypes.warning or
            --block.type == Part.Gui.Hint.Lookup.HintTypes.attention or
            --block.type == Part.Gui.Hint.Lookup.HintTypes.info or
            --block.type == Part.Gui.Hint.Lookup.HintTypes.tip or
            block.type == Part.Gui.Hint.Lookup.HintTypes.highlight
        then
            font_flags = "b"
        end

        -- get lines using width limit
        local lines = Part.Functions.wrap_text_block(block.text, width_limit, font_size, font_flags)

        -- get block dimensions
        local block_width, block_height = 0, 0
        for _, line in ipairs(lines) do
            block_width = math.max(block_width, gfx.measurestr(line))
            block_height = block_height + line_height
        end

        -- append block data to output table
        table.insert(blocks, { type = block_type, lines = lines, w = block_width, h = block_height })

        -- record max dimensions
        block_max_width = math.max(block_max_width, block_width)
        block_total_height = block_total_height + block_height
    end

    -- calculate final block size
    local block_out_width = block_max_width + pad * 2
    local block_out_height = block_total_height + pad * 2 + block_space * (#blocks - 1)

    -- height of background
    local background_w = Part.Functions.rescale(Part.Global.hint_w)
    local background_h = Part.Functions.rescale(Part.Global.hint_h - 20)

    -- resize buffer to final dimensions
    gfx.setimgdim(self.buffer_slot, -1, -1)
    gfx.setimgdim(self.buffer_slot, background_w, background_h)

    -- set target buffer slot
    gfx.dest = self.buffer_slot

    -- draw background
    Part.Draw.Graphics.drawRectangle(0, 0, background_w, background_h, Part.Color.Lookup.color_palette.hint.stage_bg, nil)


    -- starting position
    local pos_x = pad
    local pos_y = pad

    local function draw_callout_bg(x, y, w, h)
        gfx.rect(x - pad_callout, y - pad_callout, w + 2 * pad_callout, h + 3 * pad_callout)
    end

    -- iterate blocks
    for _, block in ipairs(blocks) do
        -- select color based on type

        -- warning
        if block.type == Part.Gui.Hint.Lookup.HintTypes.warning then
            Part.Color.setColor(Part.Color.Lookup.color_palette.hint.warning_bg, true)
            draw_callout_bg(pos_x, pos_y, block.w, block.h)

            Part.Draw.Graphics.setFont(font_size, "b")
            Part.Color.setColor(Part.Color.Lookup.color_palette.hint.warning_fg, true)

            -- attention
        elseif block.type == Part.Gui.Hint.Lookup.HintTypes.attention then
            Part.Color.setColor(Part.Color.Lookup.color_palette.hint.attention_bg, true)
            draw_callout_bg(pos_x, pos_y, block.w, block.h)

            --Part.Draw.Graphics.setFont(font_size, "b")
            Part.Color.setColor(Part.Color.Lookup.color_palette.hint.attention_fg, true)

            -- tip
        elseif block.type == Part.Gui.Hint.Lookup.HintTypes.tip then
            Part.Color.setColor(Part.Color.Lookup.color_palette.hint.tip_bg, true)
            draw_callout_bg(pos_x, pos_y, block.w, block.h)

            --Part.Draw.Graphics.setFont(font_size, "b")
            Part.Color.setColor(Part.Color.Lookup.color_palette.hint.tip_fg, true)

            -- highlight
        elseif block.type == Part.Gui.Hint.Lookup.HintTypes.highlight then
            Part.Draw.Graphics.setFont(font_size, "b")
            Part.Color.setColor(Part.Color.Lookup.color_palette.hint.highlight_fg, true)
        else
            -- neutral
            Part.Draw.Graphics.setFont(font_size, "")
            Part.Color.setColor(Part.Color.Lookup.color_palette.hint.fg, true)
        end

        -- draw each wrapped line
        for _, ln in ipairs(block.lines) do
            gfx.x = pos_x
            gfx.y = pos_y
            gfx.drawstr(ln)

            -- space after line
            pos_y = pos_y + line_height
        end

        -- space after block
        pos_y = pos_y + block_space
    end

    -- restore previous buffer slot
    gfx.dest = buffer_slot_last
end

--  Hint Message : Set Source
-- -------------------------------------------

function gui.Hint.Hint:setSource(source)
    if source ~= self.source then
        self.do_buffer = true
    end

    self.source = source
end

--  Hint Message : Clear
-- -------------------------------------------

function gui.Hint.Hint:clear()
    self.source = nil
end

--  Hint Message : Draw
-- -------------------------------------------

function gui.Hint.Hint:draw()
    if self.source == nil then
        return
    end

    self.draw_x = Part.Functions.rescale(self.hint_pos_x + self.hint_pad, true, false)
    self.draw_y = Part.Functions.rescale(self.hint_pos_y, false, true)

    if self.do_buffer then
        self:buffer()
        self.do_buffer = false
    end

    -- draw buffered images
    local dest_last = gfx.dest
    gfx.dest = -1
    gfx.x = self.draw_x
    gfx.y = self.draw_y
    gfx.a = 1
    gfx.blit(self.buffer_slot, 1, 0)
    gfx.dest = dest_last
end

return gui
