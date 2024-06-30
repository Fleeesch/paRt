local input_mouse = {}

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Mouse
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

-- mouse position
input_mouse.x = 0
input_mouse.y = 0

-- mouse movement
input_mouse.x_delta = 0
input_mouse.y_delta = 0

-- clicks
input_mouse.l_click = false
input_mouse.r_click = false

-- releases
input_mouse.l_release = false
input_mouse.r_release = false

-- press states
input_mouse.l_on = false
input_mouse.r_on = false
input_mouse.m_on = false

-- modifiers
input_mouse.mod_ctrl = false
input_mouse.mod_shift = false
input_mouse.mod_alt = false

-- drag is active
input_mouse.drag_active = false

-- hover
input_mouse.hover_target = nil

-- timeout for registering lack of movement
input_mouse.stop_time = 15

-- timeout counter
input_mouse.stop_counter = 0

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Mouse : No Action
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function input_mouse.noAction()
    -- check if stop counter is at zero
    return input_mouse.stop_counter == 0
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Mouse : Left Button
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function input_mouse.leftHold()
    return input_mouse.l_on
end

function input_mouse.leftClick()
    return input_mouse.l_click
end

function input_mouse.leftRelease()
    return input_mouse.l_release
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Mouse : Right Button
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function input_mouse.rightHold()
    return input_mouse.r_on
end

function input_mouse.rightClick()
    return input_mouse.r_click
end

function input_mouse.rightRelease()
    return input_mouse.m_release
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Mouse : Middle Button
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function input_mouse.middleHold()
    return input_mouse.m_on
end

function input_mouse.middleClick()
    return input_mouse.m_click
end

function input_mouse.middleRelease()
    return input_mouse.m_release
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Mouse : Modifiers
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function input_mouse.modControl()
    return input_mouse.mod_ctrl
end

function input_mouse.modShift()
    return input_mouse.mod_shift
end

function input_mouse.modAlt()
    return input_mouse.mod_alt
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Mouse : Hover
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function input_mouse.hoverCheck(target, rect_x, rect_y, rect_w, rect_h)
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
        input_mouse.hover_target = target
        return true
    end
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Mouse : Update
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function input_mouse.update()
    input_mouse.hover_target = nil

    -- calcualte movement
    input_mouse.x_delta = input_mouse.x - gfx.mouse_x
    input_mouse.y_delta = input_mouse.y - gfx.mouse_y

    -- get mouse position
    input_mouse.x = gfx.mouse_x
    input_mouse.y = gfx.mouse_y

    -- decrement stop counter
    if input_mouse.stop_counter > 0 then
        input_mouse.stop_counter = input_mouse.stop_counter - 1
    end

    -- reset stop counter if any action is happening
    if input_mouse.x_delta ~= 0 or input_mouse.y_delta ~= 0 or input_mouse.l_on or input_mouse.r_on or input_mouse.m_on then
        input_mouse.stop_counter = input_mouse.stop_time
    end

    -- reset click and release
    input_mouse.l_click = false
    input_mouse.r_click = false
    input_mouse.l_release = false
    input_mouse.r_release = false


    input_mouse.l_release = input_mouse.l_on and gfx.mouse_cap & 1 == 0
    input_mouse.r_release = input_mouse.r_on and gfx.mouse_cap & 2 == 0
    input_mouse.l_click = not input_mouse.l_on and gfx.mouse_cap & 1 ~= 0
    input_mouse.r_click = not input_mouse.r_on and gfx.mouse_cap & 2 ~= 0

    -- reset presses and modifiers
    input_mouse.l_on = false
    input_mouse.r_on = false
    input_mouse.m_on = false
    input_mouse.mod_ctrl = false
    input_mouse.mod_shift = false
    input_mouse.mod_alt = false

    input_mouse.l_on = gfx.mouse_cap & 1 ~= 0
    input_mouse.r_on = gfx.mouse_cap & 2 ~= 0
    input_mouse.m_on = gfx.mouse_cap & 64 ~= 0
    input_mouse.mod_ctrl = gfx.mouse_cap & 4 ~= 0
    input_mouse.mod_shift = gfx.mouse_cap & 8 ~= 0
    input_mouse.mod_alt = gfx.mouse_cap & 16 ~= 0

    input_mouse.Drag.checkRelease()

    input_mouse.drag_active = not input_mouse.l_on
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Mouse in Rect
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function input_mouse.mouseInRect(x, y, w, h)
    -- check if mouse is within a rectangle
    return gfx.mouse_x >= x and gfx.mouse_x <= x + w and gfx.mouse_y >= y and gfx.mouse_y <= y + h
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Check if Drag is active
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function input_mouse.dragIsActive()
    -- mouse is actively dragging?
    return input_mouse.drag_active
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Mouse in Rect
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function input_mouse.activateDrag()
    -- activate a mouse drag
    input_mouse.drag_active = true
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Drag
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

input_mouse.Drag = {}

input_mouse.Drag.active = false

input_mouse.Drag.info = ""
input_mouse.Drag.target = nil

input_mouse.Drag.button_left = false
input_mouse.Drag.button_right = false
input_mouse.Drag.button_middle = false

input_mouse.Drag.mod_control = false
input_mouse.Drag.mod_shift = false
input_mouse.Drag.mod_alt = false


-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Drag : Info
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function input_mouse.Drag.getInfo()
    return input_mouse.Drag.info
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Drag : Is On
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function input_mouse.Drag.isOn()
    return input_mouse.Drag.active, input_mouse.Drag.button_left, input_mouse.Drag.button_right,
        input_mouse.Drag.button_middle, input_mouse.Drag.mod_control, input_mouse.Drag.mod_shift,
        input_mouse.Drag.mod_alt
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Drag : Is Off
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function input_mouse.Drag.isOff()
    return not input_mouse.Drag.active
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Drag : Is Target
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function input_mouse.Drag.isTarget(target)
    if not input_mouse.Drag.active then
        return false
    end

    return input_mouse.Drag.target == target
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Drag : On
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function input_mouse.Drag.on(target, info)
    if input_mouse.Drag.active then
        return
    end

    input_mouse.Drag.active = true

    input_mouse.Drag.target = target
    input_mouse.Drag.info = info or ""

    input_mouse.Drag.button_left = input_mouse.l_on
    input_mouse.Drag.button_right = input_mouse.r_on
    input_mouse.Drag.button_middle = input_mouse.m_on

    input_mouse.Drag.mod_control = input_mouse.mod_ctrl
    input_mouse.Drag.mod_shift = input_mouse.mod_shift
    input_mouse.Drag.mod_alt = input_mouse.mod_alt
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Drag : Off
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function input_mouse.Drag.off()
    input_mouse.Drag.active = false

    input_mouse.Drag.info = ""
    input_mouse.Drag.target = nil

    input_mouse.Drag.button_left = false
    input_mouse.Drag.button_right = false
    input_mouse.Drag.button_middle = false

    input_mouse.Drag.mod_control = false
    input_mouse.Drag.mod_shift = false
    input_mouse.Drag.mod_alt = false
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Drag : Check Release
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function input_mouse.Drag.checkRelease()
    local active, button_left, button_right, button_middle = input_mouse.Drag.isOn()

    if active then
        if (not input_mouse.leftRelease() and not input_mouse.leftHold() and button_left) or
            (not input_mouse.rightRelease() and not input_mouse.rightHold() and button_right) or
            (not input_mouse.middleRelease() and not input_mouse.middleHold() and button_middle)
        then
            input_mouse.Drag.off()
        end
    end
end

return input_mouse
