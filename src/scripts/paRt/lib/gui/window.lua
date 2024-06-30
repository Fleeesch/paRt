local gui = {}

gui.dpi_detection_delay = 10
gui.dpi_detection_clock = 0

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Store Dock State
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function gui.storeDockState()
    local dock_state, gfx_x, gfx_y, gfx_w, gfx_h = gfx.dock(-1, 0, 0, 0, 0)

    if dock_state == 0 then
        reaper.DeleteExtState(Part.Global.ext_section, "Window Position - Dock", true)
    else
        reaper.SetExtState(Part.Global.ext_section, "Window Position - Dock", tostring(dock_state), true)
    end
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Was Docked
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function gui.wasDocked()
    if reaper.HasExtState(Part.Global.ext_section, "Window Position - Dock") then
        if reaper.GetExtState(Part.Global.ext_section, "Window Position - Dock") == "true" then
            return true
        end
    end

    return false
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Is Docked
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function gui.isDocked()
    return gfx.dock(-1) == 1
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Get Window Scaling Factor
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function gui.calcScale()
    Part.Global.scale = gfx.ext_retina
    Part.Draw.Graphics.border = math.max(math.floor(Part.Draw.Graphics.border_base * Part.Global.scale), 1)
    return Part.Global.scale
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Store Window Position
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function gui.storeWindow()
    -- get window dimensions
    local dock_state, gfx_x, gfx_y, gfx_w, gfx_h = gfx.dock(-1, 0, 0, 0, 0)

    -- window position
    Part.Global.win_x = gfx_x
    Part.Global.win_y = gfx_y

    -- store dimensiosn as ext states
    reaper.SetExtState(Part.Global.ext_section, "Window Position - X", tostring(gfx_x), true)
    reaper.SetExtState(Part.Global.ext_section, "Window Position - Y", tostring(gfx_y), true)

    gui.storeDockState()

    -- ext state indicating that window data is available
    reaper.SetExtState(Part.Global.ext_section, "Window Position - Available", "true", true)
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Get Window Position
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function gui.restoreWindow()
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

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Store Last Window Position
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function gui.storeLastWindowPosition()
    Part.Global.win_w_last = gfx.w
    Part.Global.win_h_last = gfx.h
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Set Window Position
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function gui.setWindowPosition(x, y)
    -- set window x and y position
    local w = Part.Functions.rescale(Part.Global.win_w)
    local h = Part.Functions.rescale(Part.Global.win_h)

    gfx.init(nil, w, h, false, x, y)

    gui.storeLastWindowPosition()
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Set Scale Factor
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function gui.setScale(scale_factor)
    -- calculate width and height
    local w = math.floor(Part.Global.win_w * scale_factor)
    local h = math.floor(Part.Global.win_h * scale_factor)

    -- adjust window
    gfx.init(nil, w, h, false, Part.Global.win_x, Part.Global.win_y)
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Update Window Dimensions
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function gui.updateWindowDimensions()
    -- calculate width and height
    local w = math.floor(Part.Global.win_w * Part.Global.scale)
    local h = math.floor(Part.Global.win_h * Part.Global.scale)

    -- adjust window
    gfx.init(nil, w, h, false, Part.Global.win_x, Part.Global.win_y)
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Detect DPI Change
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function gui.detectDpiChange(force)
    if Part.Global.scale ~= gfx.ext_retina then
        if gui.dpi_detection_clock == gui.dpi_detection_delay or force then
            gui.calcScale()
            gui.calculateWindowSizeData()
            Part.Draw.Sprites.createAssets()
            Part.Draw.Elements.prepareElements()
            Part.Draw.Buffer.clearCompleteBuffer()
        end

        if not force then
            gui.dpi_detection_clock = gui.dpi_detection_clock + 1
        end
    else
        gui.dpi_detection_clock = 0
    end
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Calculate Window Size Data
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function gui.calculateWindowSizeData()
    Part.Global.win_x_offset = math.floor(math.max(gfx.w / Part.Global.scale - Part.Global.win_w, 0))
    Part.Global.win_y_offset = math.floor(math.max(gfx.h / Part.Global.scale - Part.Global.win_h, 0))
    Part.Global.win_x_offset_centered = math.floor(Part.Global.win_x_offset * 0.5 + 0.5)
    Part.Global.win_y_offset_centered = math.floor(Part.Global.win_y_offset * 0.5 + 0.5)
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Detect Window Resize
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function gui.detectWindowResize()
    if gfx.w ~= Part.Global.win_w_last or gfx.h ~= Part.Global.win_h_last then
        gui.calculateWindowSizeData()
        Part.Draw.Buffer.clearCompleteBuffer()
    end

    gui.storeLastWindowPosition()
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Init Window
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function gui.initWindow()
    Part.Draw.Elements.prepareElements()

    -- restore window coordinates
    Part.Global.win_x, Part.Global.win_y = gui.restoreWindow()

    -- open window
    gfx.init(Part.Global.win_title, Part.Global.win_w, Part.Global.win_h, false, Part.Global.win_x, Part.Global.win_y)
    gfx.ext_retina = 1
    gfx.quit()

    gfx.init(Part.Global.win_title, Part.Global.win_w, Part.Global.win_h, false, Part.Global.win_x, Part.Global.win_y)

    gui.detectDpiChange(true)

    -- dock state
    if reaper.HasExtState(Part.Global.ext_section, "Window Position - Dock") then
        local dock_state = tonumber(reaper.GetExtState(Part.Global.ext_section, "Window Position - Dock"))
        gfx.dock(dock_state)
    end

    gui.updateWindowDimensions()
    gui.calculateWindowSizeData()
end

return gui
