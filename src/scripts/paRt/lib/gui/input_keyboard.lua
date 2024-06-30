local input_keyboard = {}

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Keyboard
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

-- input keyboard code
input_keyboard.input = 0

-- character codes lookup table
input_keyboard.charcode = {
    null = -1,
    esc = 27,
    r = 114,
    t = 116
}

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Keyboard : Update
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function input_keyboard.update()
    -- get keyboard input
    input_keyboard.input = gfx.getchar()

    -- use character code to detect closed gui
    if input_keyboard.input == input_keyboard.charcode["null"] then
        -- mark gui as closed
        Part.Global.gui_closed = true
    end
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Keyboard : Key is pressed
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function input_keyboard.isPressed(char)
    -- key is released
    if input_keyboard.charcode[char] == nil then
        return false
    end

    -- key is pressed
    if input_keyboard.input == input_keyboard.charcode[char] then
        return true
    end

    return false
end

return input_keyboard