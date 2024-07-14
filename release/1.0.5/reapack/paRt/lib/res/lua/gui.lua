-- @version 1.0.5
-- @author Fleeesch
-- @description paRt Theme Adjuster
-- @noIndex
local gui = {
    Window = {},
    Theme = {},
    Keyboard = {},
    Mouse = {},
    Hint = {
        Hint = {},
        Lookup = {}
    }
}

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
    Part.Global.scale = gfx.ext_retina
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
    local w = Part.Functions.rescale(Part.Global.win_w)
    local h = Part.Functions.rescale(Part.Global.win_h)

    gfx.init(nil, w, h, false, x, y)

    gui.Window.storeLastWindowPosition()
end

--  Method : Set Scale Factor
-- -------------------------------------------

function gui.Window.setScale(scale_factor)
    -- calculate width and height
    local w = math.floor(Part.Global.win_w * scale_factor)
    local h = math.floor(Part.Global.win_h * scale_factor)

    -- adjust window
    gfx.init(nil, w, h, false, Part.Global.win_x, Part.Global.win_y)
end

--  Method : Update Window Dimensions
-- -------------------------------------------

function gui.Window.updateWindowDimensions()
    -- calculate width and height
    local w = math.floor(Part.Global.win_w * Part.Global.scale)
    local h = math.floor(Part.Global.win_h * Part.Global.scale)

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


--  Method : Get Light Theme
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

        return true
    end

    return false
end

--  Method : Lookup available Themes
-- -------------------------------------------

function gui.Theme.loofForPartThemes()
    -- Sub-Function : Look for Words in String
    local function find_words_in_order(str, word1, word2)
        str = string.lower(str)
        word1 = string.lower(word1)
        word2 = string.lower(word2)

        local w1_start_pos, w1_end_pos = string.find(str, word1)
        local w2_start_pos, w2_end_pos = string.find(str, word2)


        if w1_start_pos == nil or w2_start_pos == nil then
            return false
        end

        if w2_start_pos > w1_start_pos then
            return true
        end

        return false
    end

    local themepath = reaper.GetResourcePath() .. "/ColorThemes/"

    -- collected theme file lists
    local reapertheme = Part.Functions.listFilesInFolder(themepath, "ReaperTheme")
    local reapertheme_zip = Part.Functions.listFilesInFolder(themepath, "ReaperThemeZip")
    local theme_list = { reapertheme_zip, reapertheme }

    -- theme file names
    local theme_dark = nil
    local theme_dimmed = nil
    local theme_light = nil

    -- iterate themes, prioritizing reaperthemezip files
    for _, theme_files in pairs(theme_list) do
        for key, val in pairs(theme_files) do
            if find_words_in_order(val, "part", "dark") then
                theme_dark = val
            end

            if find_words_in_order(val, "part", "dimmed") then
                theme_dimmed = val
            end

            if find_words_in_order(val, "part", "light") then
                theme_light = val
            end
        end
    end

    -- return theme lists based on keywords
    return { Dark = theme_dark, Dimmed = theme_dimmed, Light = theme_light }
end

--  Method : Validate Loading Theme
-- -------------------------------------------

function gui.Theme.validateLoadingTheme(title)
    -- get theme file
    local themes = gui.Theme.loofForPartThemes()
    local theme_file = themes[title]

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

--  Method : Load Dark Theme
-- -------------------------------------------

function loadDarkTheme()
    gui.Theme.initiateLoadingTheme("Dark")
end

--  Method : Load Dark Windows Theme
-- -------------------------------------------

function loadDimmedTheme()
    gui.Theme.initiateLoadingTheme("Dimmed")
end

--  Method : Load Light Theme
-- -------------------------------------------

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

-- timeout for registering lack of movement
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
    null = -1,
    esc = 27,
    r = 114,
    t = 116
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
    o.height_size = 20
    o.paragraph_line_size = 8
    o.padding = 6
    o.shadow_size = 3

    o.source = nil

    o.remove = false

    return o
end

gui.Hint.hint_message = gui.Hint.Hint:new()


--  Hint Message : Buffer
-- -------------------------------------------

function gui.Hint.Hint:buffer()
    local source = self.source

    -- padding
    local p = Part.Functions.rescale(self.padding)
    local s = Part.Functions.rescale(self.shadow_size)

    -- colors
    local color_bg = Part.Functions.deepCopy(source.color_bg)
    local color_border = Part.Functions.deepCopy(source.color_border)
    local color_fg = Part.Functions.deepCopy(source.color_fg)
    local color_shadow = Part.Functions.deepCopy(source.color_shadow)

    -- attributes
    local font_size = self.font_size
    local line_height = Part.Functions.rescale(self.height_size)
    local paragraph_line_height = Part.Functions.rescale(self.paragraph_line_size)

    -- generate text block
    local lines = Part.Functions.textBlock(source.text, 30)

    -- calculate max width from string measurements, record line height
    local max_w = 0
    local max_h = 0

    -- measure string
    Part.Draw.Graphics.setFont(self.font_size)

    for _, line in pairs(lines) do
        max_w = math.max(gfx.measurestr(line), max_w)

        if line == "[Linebreak]" then
            max_h = max_h + paragraph_line_height
        else
            max_h = max_h + line_height
        end
    end

    -- add padding to max dimnesions
    max_w = max_w + p * 2
    max_h = max_h + p * 2

    -- dimensions
    local x = 0
    local y = 0
    local w = max_w
    local h = max_h

    self.draw_w = w
    self.draw_h = h

    -- clear buffer
    gfx.setimgdim(self.buffer_slot, -1, -1)
    gfx.setimgdim(self.buffer_slot, w + s, h + s)

    local last_dest = gfx.dest
    gfx.dest = self.buffer_slot

    -- background
    Part.Cursor.setCursorPos(0, 0)
    Part.Draw.Graphics.drawRectangle(s, s, w, h, color_shadow)
    Part.Draw.Graphics.drawRectangle(0, 0, w, h, color_bg, color_border)

    -- draw text line by line
    Part.Cursor.setCursorPos(0 + p, 0 + p)

    Part.Color.setColor(color_fg,true)

    local color_text_highlight = Part.Color.Lookup.color_palette.hint.text_highlight

    -- iterate lines
    for _, line in pairs(lines) do
        -- linebreak exception
        if line == "[Linebreak]" then
            gfx.x = Part.Cursor.getCursorX()
            gfx.y = gfx.y + paragraph_line_height
        else
            -- iterate words
            for word in line:gmatch("%S+") do
                -- highlight
                if word:match("%[.*%]") then
                    -- filter extra symbols
                    word = word:gsub("%[([^%[%]]*)%]", "%1")
                    word = word:gsub("|", " ")

                    -- change formatting
                    Part.Color.setColor(color_text_highlight, true)
                    Part.Draw.Graphics.setFont(font_size, "b")
                end

                -- print word
                gfx.drawstr(word .. " ")
                Part.Draw.Graphics.setFont(font_size)
                Part.Color.setColor(color_fg, true)
            end

            gfx.x = Part.Cursor.getCursorX()
            gfx.y = gfx.y + line_height
        end
    end
end

--  Hint Message : Set Source
-- -------------------------------------------

function gui.Hint.Hint:setSource(source)
    local show = source ~= self.source

    self.source = source
end

--  Hint Message : Clear
-- -------------------------------------------

function gui.Hint.Hint:clear()
    self.remove = true
end

--  Hint Message : Draw
-- -------------------------------------------

function gui.Hint.Hint:draw()
    if self.source == nil then
        return
    end


    -- cursor offset
    local offset = 12
    local padding = 10
    local p = Part.Functions.rescale(padding)
    local o = Part.Functions.rescale(offset)

    -- get fade-in factor
    local alpha = self.source:displayFactor()

    if alpha > 0 and self.last_alpha <= 0 then
        self:buffer()
    end

    local track_mouse = alpha >= self.last_alpha
    self.last_alpha = alpha

    -- clear hint after fade-out
    if self.remove and alpha <= 0 then
        self.source = nil
        return
    end

    -- mouse trakcing
    if track_mouse then
        self.draw_x = gfx.mouse_x
        self.draw_y = gfx.mouse_y
    end

    -- coordinates
    local x = self.draw_x + o
    local y = self.draw_y + o

    -- x axis overshoot flip
    if x + self.draw_w + p > gfx.w then
        x = x - self.draw_w - p * 2
    end

    -- y axis overshoot flip
    if y + self.draw_h + p > gfx.h then
        y = y - self.draw_h - p * 2
    end

    -- draw buffered images
    local dest_last = gfx.dest
    gfx.dest = -1
    gfx.x = x
    gfx.y = y
    gfx.a = alpha
    gfx.blit(self.buffer_slot, 1, 0)
    gfx.dest = dest_last
end


return gui
