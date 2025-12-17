-- @version 1.2.9
-- @author Fleeesch
-- @description paRt Theme Adjuster
-- @noIndex

--[[
    Windows management and input device tracking (keyboard, mouse).
]] --

local gui = { Window = {}, Keyboard = {}, Mouse = {} }

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

return gui
