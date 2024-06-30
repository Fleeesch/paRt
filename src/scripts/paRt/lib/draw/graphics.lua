local draw = {}

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Globals
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- base border before scaling
draw.border_base = 1

-- border size in pixels
draw.border = 1

-- drawing area blur factor (applied at the end of drawing process)
draw.blur_factor = 0

-- temporary splash message
draw.splash_message = nil

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Draw Theme Error
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -s

function draw.drawThemeError()
    local color_fg = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.theme_error.fg)
    local color_bg = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.theme_error.bg)
    local color_box = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.theme_error.box)
    local color_border = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.theme_error.border)

    -- display dimensions
    local w = gfx.w
    local h = gfx.h

    -- error string
    local str = "no paRt theme detected"

    -- update font size
    draw.setFont(30)

    -- get string width
    local str_w = gfx.measurestr(str)

    -- calculate center drawing dimensions
    local x = (w - str_w) / 2
    local y = (h - 200) / 2

    -- padding
    local pad = Part.Functions.rescale(40)

    -- set cursor
    Part.Cursor.setCursor(x, y, str_w, str_s)

    draw.drawRectangle(0, 0, gfx.w, gfx.h, color_bg)

    gfx.x = Part.Cursor.getCursorX()
    gfx.y = Part.Cursor.getCursorY() - pad

    -- draw background
    draw.drawRectangle(Part.Cursor.getCursorX() - pad, Part.Cursor.getCursorY() - pad, Part.Cursor.getCursorW() + pad * 2, Part.Cursor.getCursorH() + pad * 2, color_box,
        color_border)

    -- font color
    Part.Color.setColor(color_fg,true)

    -- draw string
    gfx.drawstr(str, 5, Part.Cursor.getCursorX() + Part.Cursor.getCursorW(), Part.Cursor.getCursorY() + Part.Cursor.getCursorH() + pad)
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Draw Corner Triangle
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function draw.drawCornerTriangle()
    
    local size = Part.Functions.rescale(Part.Draw.Sprites.rescale_corner_size)
    gfx.x = gfx.w - size
    gfx.y = gfx.h - size

   gfx.blit(Part.Draw.Sprites.slot_corner_rescale,1,3.1)

end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Apply Blur
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function draw.applyBlur()
    if draw.blur_factor <= 0 then
        return
    end

    local mul = Part.Color.Lookup.color_palette.blur.mul
    local add = Part.Color.Lookup.color_palette.blur.add

    gfx.muladdrect(0, 0, gfx.w, gfx.h, mul[1], mul[2], mul[3], mul[4], add[1], add[2], add[3], add[4])

    for i = 0, math.floor(draw.blur_factor * Part.Global.scale ^ 2) do
        gfx.x = 0
        gfx.y = 0

        gfx.blurto(gfx.w, gfx.h)
    end
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Blur Window
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function draw.blurWindow(factor)
    draw.blur_factor = Part.Functions.cap(factor, 0, 30) or 1
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Set Splash Message
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function draw.splashMessage(message)
    draw.splash_message = message
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Draw Splash Message
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function draw.drawSplashMessage()
    -- skip if there's no splash message
    if draw.splash_message == nil or draw.splash_message == "" then
        return
    end

    gfx.dest = -1

    -- blur background
    draw.blurWindow(Part.Color.Lookup.color_palette.blur.factor)
    draw.applyBlur()

    table.insert(Part.List.pending_action, {
        func = draw.blurWindow,
        args = { 0 }
    })

    Part.Cursor.stackCursor()
    Part.Cursor.setCursorPadding(0, 0)

    -- text
    local txt = Part.Functions.textBlock(draw.splash_message, 30)

    -- padding
    local p = Part.Functions.rescale(40)

    -- font
    local font_size = 30
    local line_height = 30
    local line_height_rescaled = Part.Functions.rescale(line_height)

    -- colors
    local color_bg = Part.Color.Lookup.color_palette.splash.bg
    local color_fg = Part.Color.Lookup.color_palette.splash.fg
    local color_border = Part.Color.Lookup.color_palette.splash.border
    local color_shadow = Part.Color.Lookup.color_palette.splash.shadow

    -- shadow
    local draw_shadow = color_shadow[4] > 0
    local shadow_offset = Part.Functions.rescale(2)

    -- font
    draw.setFont(font_size)
    Part.Color.setColor(color_fg,true)

    -- text dimensions
    local str_w = 0
    local str_h = 0

    for key, val in pairs(txt) do
        str_w = math.max(str_w, gfx.measurestr(val))
    end

    str_h = #txt * line_height_rescaled

    -- background
    local bg_x = (gfx.w - str_w) / 2 - p
    local bg_y = (gfx.h - str_h) / 2 - p
    local bg_w = str_w + p * 2
    local bg_h = str_h + p * 2

    if color_bg[4] > 0 then
        gfx.muladdrect(bg_x, bg_y, bg_w, bg_h, color_bg[1], color_bg[2], color_bg[3])
    end

    -- border
    draw.drawRectangle(bg_x, bg_y, bg_w, bg_h, nil, color_border)

    -- text cursor
    Part.Cursor.setCursorPos(bg_x + p, bg_y + p)

    for key, val in pairs(txt) do
        -- shadow
        if draw_shadow then
            local x = gfx.x
            local y = gfx.y

            gfx.x = gfx.x + shadow_offset
            gfx.y = gfx.y + shadow_offset

            Part.Color.setColor(color_shadow,true)

            gfx.drawstr(val, 1, gfx.x + bg_w - p * 2, gfx.y + line_height_rescaled)

            Part.Color.setColor(color_fg,true)

            gfx.x = x
            gfx.y = y
        end

        -- message
        gfx.drawstr(val, 1, gfx.x + bg_w - p * 2, gfx.y + line_height_rescaled)

        Part.Cursor.incCursor(0, line_height)
    end

    Part.Cursor.destackCursor()

    -- clear message
    draw.splash_message = nil
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Draw Background
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function draw.drawBackground()
    -- set color
    Part.Color.setColor(Part.Color.Lookup.color_palette.bg,true)

    -- draw background
    gfx.rect(0,0, gfx.w, gfx.h)
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Draw Info bar
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function draw.drawInfoBar()
    -- calculate size
    local size = Part.Functions.rescale(Part.Global.bank_bar_size)

    -- setup dimensions
    local x = Part.Functions.rescale(0)
    local y = Part.Functions.rescale(Part.Global.win_h - Part.Global.bank_bar_size + Part.Global.win_y_offset)
    local w = gfx.w
    local h = Part.Functions.rescale(Part.Global.corner_triangle_size)

    -- get colors
    local color_bg = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.infobar.bg)
    local color_fg = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.infobar.fg)

    -- y position
    y = y - h

    -- draw background if visible (depending on alpha level)
    if color_bg[4] ~= 0 then
        Part.Color.setColor(color_bg,true)
        gfx.rect(x, y, w, h)
    end

    -- set cursor position
    Part.Cursor.setCursorPos(x + Part.Functions.rescale(10), y)

    -- set color
    Part.Color.setColor(color_fg,true)

    -- udpate font
    draw.setFont(14)

    -- info text table
    local str_data = { { "Esc", "Close" }, { "R", "Reset Window" }, { "L Click", "Set Value" }, { "R Click", "Reset Value" },
        { "Ctrl", "Slow Drag" } }

    -- go through text entries
    for key, val in pairs(str_data) do
        -- draw entry
        gfx.drawstr(val[1] .. ": " .. val[2])

        -- draw divider
        if key < #str_data then
            gfx.drawstr("     -     ")
        end
    end

    gfx.x = Part.Functions.rescale(Part.Global.win_w - 75)
    gfx.drawstr("   v" .. Part.Version.version_theme)

end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Draw Rectangle
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function draw.drawRectangle(x, y, w, h, color_bg, color_border)
    -- background
    if color_bg ~= nil then
        Part.Color.setColor(color_bg,true)

        if gfx.a > 0 then
            gfx.rect(x, y, w, h, true)
        end
    end

    -- border
    if color_border ~= nil then
        Part.Color.setColor(color_border)

        if gfx.a > 0 then
            for i = 0, Part.Draw.Graphics.border - 1 do
                gfx.rect(x + i, y + i, w - i * 2, h - i * 2, false)
            end
        end
    end
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Draw Gradient
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function draw.drawGradient(x, y, w, h, padding, color_table, color_border, source)
    -- gradient coordinates
    local grad_x = x
    local grad_y = y
    local grad_w = w
    local grad_h = h

    -- color table available?
    if color_table ~= nil then
        -- create new color table
        local color_table_new = {}

        -- go trhough color table entries
        for i, v in pairs(color_table) do
            -- store colors from original color table
            color_table_new[i] = v
        end

        -- gradient segment count
        local count = #color_table

        -- segment size
        local segment = math.floor(grad_w / (count - 1))

        -- missing pixels resulting from rounding
        local missing_pixels = grad_w - (count - 1) * segment

        -- go through segments
        for i = 1, count - 1, 1 do
            -- last segment gets missing pixels
            if i == count - 1 then
                segment = segment + missing_pixels
            end

            -- calculate colors
            local r_dif = (color_table_new[i + 1][1] - color_table_new[i][1]) / segment
            local g_dif = (color_table_new[i + 1][2] - color_table_new[i][2]) / segment
            local b_dif = (color_table_new[i + 1][3] - color_table_new[i][3]) / segment
            local a_dif = (color_table_new[i + 1][4] - color_table_new[i][4]) / segment

            -- draw gradient
            gfx.gradrect(grad_x, grad_y, segment, grad_h, color_table_new[i][1], color_table_new[i][2],
                color_table_new[i][3], color_table[i][4], r_dif, g_dif, b_dif, a_dif)

            -- increment gradient position
            grad_x = grad_x + segment
        end
    end

    -- border
    if color_border ~= nil then
        -- set color
        Part.Color.setColor(color_border)

        -- draw border lines
        gfx.rect(x, y, w, draw.border)
        gfx.rect(x, y + h - draw.border, w, draw.border)
        gfx.rect(x, y, draw.border, h)
        gfx.rect(x + w - draw.border, y + draw.border, draw.border, h - draw.border)
    end
end


-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Set Color
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function draw.setColor(color)
    
    -- restore missing alpha value
    if color[4] == nil then
        color[4] = 1
    end

    -- set color for drawing instruments
    gfx.set(color[1], color[2], color[3], color[4])
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Setup Font
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function draw.setFont(size, flag_str)
    -- default windows font
    local face = "Calibri"

    -- non-windows exception
    if reaper.GetOS():match("^Win") == nil then
        face = "Tahoma"
    end

    -- Part.Functions.rescale( font
    size = Part.Functions.rescale(size)

    local flags = 0

    if flag_str ~= nil then
        for i = 1, flag_str:len() do
            flags = flags * 256 + string.byte(flag_str, i)
        end
    end

    -- set attributes
    gfx.setfont(1, face, size, flags)
end

return draw