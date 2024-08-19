-- @version 1.1.6
-- @author Fleeesch
-- @description paRt Theme Adjuster
-- @noIndex
local draw = { Buffer = {}, Elements = {}, Graphics = {}, Sprites = {} }

-- ===========================================================================
--                          Sprites
-- ===========================================================================


-- Sprites : Get Next Image Slot
-- -------------------------------------------

function draw.Sprites.getNextFreeImageSlot()
    draw.Sprites.image_index = draw.Sprites.image_index + 1
    return draw.Sprites.image_index - 1
end

--  Sprites
-- -------------------------------------------

draw.Sprites.value_buffer_done = false

-- sprite slot
draw.Sprites.image_index = 1

-- knob dimensions
draw.Sprites.knob_sprites = 100
draw.Sprites.knob_val_size = 48
draw.Sprites.knob_size = 16

-- corner dimensions
draw.Sprites.rescale_corner_size = 14
draw.Sprites.hint_corner_size = 7

-- knob slots
draw.Sprites.slot_knob_line = draw.Sprites.getNextFreeImageSlot()
draw.Sprites.slot_knob_line_default = draw.Sprites.getNextFreeImageSlot()
draw.Sprites.slot_knob_val_linear = draw.Sprites.getNextFreeImageSlot()
draw.Sprites.slot_knob_val_bi = draw.Sprites.getNextFreeImageSlot()

-- corner slots
draw.Sprites.slot_corner_rescale = draw.Sprites.getNextFreeImageSlot()
draw.Sprites.slot_corner_hint = draw.Sprites.getNextFreeImageSlot()
draw.Sprites.slot_corner_hint_alt = draw.Sprites.getNextFreeImageSlot()

-- colors
draw.Sprites.color_rescale = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.corner_triangle)
draw.Sprites.color_hint = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.color.red)
draw.Sprites.color_hint_alt = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.color.cyan)



--  Sprites : Corner Hint
-- -------------------------------------------

function draw.Sprites.cornerHint()
    return draw.Sprites.slot_corner_hint
end

--  Sprites : Create Assets
-- -------------------------------------------

function draw.Sprites.createAssets()
    draw.Sprites.createKnobAssets()
    draw.Sprites.createKnobValueAssets()
    draw.Sprites.createCornerAssets()
end

--  Sprites : Create Corner Assets
-- -------------------------------------------

function draw.Sprites.createCornerAssets()
    local last_dest = gfx.dest

    local size = Part.Functions.rescale(draw.Sprites.hint_corner_size)
    local dest = draw.Sprites.slot_corner_hint

    gfx.setimgdim(dest, -1, -1)
    gfx.setimgdim(dest, size, size)

    gfx.dest = dest

    Part.Color.setColor(draw.Sprites.color_hint, true)
    gfx.triangle(0, 0, size-1, 0, 0, size-1)

    gfx.dest = last_dest
end

--  Sprites : Create Knob Value Assets
-- -------------------------------------------

function draw.Sprites.createKnobValueAssets()
    if draw.Sprites.value_buffer_done then
        return
    end

    local last_dest = gfx.dest

    -- slots
    local slot_val_linear = draw.Sprites.slot_knob_val_linear
    local slot_val_bi = draw.Sprites.slot_knob_val_bi


    -- ::: Linear :::

    -- dimensions
    local size = draw.Sprites.knob_val_size
    local size2 = math.floor(size / 2)
    local r_inner = size2 - draw.Graphics.border

    -- setup drawing area
    gfx.dest = slot_val_linear
    gfx.setimgdim(slot_val_linear, -1, -1)
    gfx.setimgdim(slot_val_linear, size, size * (draw.Sprites.knob_sprites + 1))

    -- fill
    local color_fill = Part.Color.Lookup.color_palette.color.blue
    Part.Color.setColor(color_fill, true)
    gfx.a = 1

    -- dimensions
    local y = 0
    local offset = -0.1
    local range = 5
    local range2 = range / 2

    -- sprite creation
    for i = 1, draw.Sprites.knob_sprites + 1 do
        local rotation = (range / draw.Sprites.knob_sprites) * i - range2 + offset

        -- differentiate betwenn <0 and >0
        if rotation > -range2 then
            -- border lines
            gfx.arc(size2, size2 + y, r_inner, rotation + offset, -range2, true)
            --gfx.arc(size2, size2 + y, r_inner - 8, rotation + offset, -range2, true)

            -- filler lines
            for i2 = 1, 32 do
                gfx.arc(size2, size2 + y, r_inner + -(i2 - 1) / 4, rotation + offset, -range2, true)
            end
        end

        -- next sprite
        y = y + size
    end

    -- ::: Bi-Directional :::
    gfx.dest = slot_val_bi
    gfx.setimgdim(slot_val_bi, -1, -1)
    gfx.setimgdim(slot_val_bi, size, size * (draw.Sprites.knob_sprites + 1))

    -- coordinates
    local y = 0
    local offset = -0.1
    local range = 5
    local range2 = range / 2
    local deadzone = 0.01

    -- sprite creation
    for i = 1, draw.Sprites.knob_sprites + 1 do
        -- sprite skipping
        local draw_arc = false

        -- arc values
        local a, b

        -- pick a site
        if i < draw.Sprites.knob_sprites / 2 - deadzone then
            a = (range / draw.Sprites.knob_sprites) * i - range2 + 0
            b = 0
            draw_arc = true
        elseif i > draw.Sprites.knob_sprites / 2 + deadzone then
            a = 0
            b = (range / draw.Sprites.knob_sprites) * i - range2 + offset
            draw_arc = true
        end

        -- arc drawing
        if draw_arc then
            --gfx.arc(size2, size2 + y, r_inner, a, b, true)
            --gfx.arc(size2, size2 + y, r_inner - 8, a, b, true)

            for i2 = 1, 32 do
                gfx.arc(size2, size2 + y, r_inner + -(i2 - 1) / 4, a, b, true)
            end
        end

        -- next sprite
        y = y + size
    end

    gfx.dest = last_dest

    draw.Sprites.value_buffer_done = true
end

--  Sprites : Create Knob Assets
-- -------------------------------------------

function draw.Sprites.createKnobAssets()
    local size = Part.Functions.rescale(16)

    local last_dest = gfx.dest

    -- calculate dimensions
    local dim = size
    local dim2 = dim * 0.5
    local r = Part.Functions.rescale(1)
    local l = Part.Functions.rescale(6)
    local factor = 2

    -- slots
    local slot_line = draw.Sprites.slot_knob_line
    local slot_default_line = draw.Sprites.slot_knob_line_default

    -- knob line
    gfx.dest = slot_line
    gfx.setimgdim(slot_line, -1, -1)
    gfx.setimgdim(slot_line, dim, dim)

    -- color
    Part.Color.setColor(Part.Color.Lookup.color_palette.knob.fg, true)
    gfx.rect(dim2 - r, r, r * factor, l)

    -- default knob line
    gfx.dest = slot_default_line
    gfx.setimgdim(slot_default_line, -1, -1)
    gfx.setimgdim(slot_default_line, dim, dim)

    Part.Color.setColor(Part.Color.Lookup.color_palette.knob.default, true)
    gfx.rect(dim2 - r, r, r * factor, l - r)

    gfx.dest = last_dest
end

-- ===========================================================================
--                          Buffer
-- ===========================================================================


--  Clear Complete Buffer
-- -------------------------------------------

function draw.Buffer.clearCompleteBuffer()
    Part.Global.update_visible_elements = true

    for i, buffer in pairs(draw.Buffer.buffer_list) do
        buffer:clear()
    end
end

--  Buffer
-- -------------------------------------------

draw.Buffer.Buffer = {}

function draw.Buffer.Buffer:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    o.closed = false

    -- graphics slot
    o.slot = draw.Sprites.getNextFreeImageSlot()
    o.slot_snapshot = draw.Sprites.getNextFreeImageSlot()

    -- snapshot
    o.snapshot_s = 0
    o.snapshot_available = false

    -- about to be cleared
    o.pending_clear = false

    -- ready to write
    o.available = true


    return o
end

draw.Buffer.buffer_bg = draw.Buffer.Buffer:new(nil)
draw.Buffer.buffer_control = draw.Buffer.Buffer:new(nil)

draw.Buffer.buffer_list = { draw.Buffer.buffer_bg, draw.Buffer.buffer_control }



--  Buffer : Is Open
-- -------------------------------------------

function draw.Buffer.Buffer:isOpen()
    return not self.closed
end

--  Buffer : Is Closed
-- -------------------------------------------

function draw.Buffer.Buffer:isClosed()
    return self.closed
end

--  Buffer : Close
-- -------------------------------------------

function draw.Buffer.Buffer:close()
    self.closed = true
end

--  Buffer : Activate
-- -------------------------------------------

function draw.Buffer.Buffer:activate()
    gfx.dest = self.slot
    self.available = true
end

--  Buffer : Deactivate
-- -------------------------------------------

function draw.Buffer.Buffer:deactivate()
    gfx.dest = -1
end

--  Buffer : Init
-- -------------------------------------------

function draw.Buffer.Buffer:init()
    self:clear()
end

--  Buffer : Output
-- -------------------------------------------

function draw.Buffer.Buffer:output()
    gfx.dest = -1

    gfx.x = 0
    gfx.y = 0

    gfx.mode = 0
    gfx.a = 1

    gfx.blit(self.slot, 1, 0)
end

--  Buffer : Process Pending Clearing
-- -------------------------------------------

function draw.Buffer.Buffer:processPendingClearing()
    if not self.pending_clear then
        return
    end

    gfx.setimgdim(self.slot, -1, -1)
    gfx.setimgdim(self.slot, gfx.w, gfx.h)

    gfx.dest = -1

    self.closed = false

    self.pending_clear = false

    draw.Elements.prepareElements()
end

--  Buffer : Clear
-- -------------------------------------------

function draw.Buffer.Buffer:clear()
    self.pending_clear = true
end

-- ===========================================================================
--                          Elements
-- ===========================================================================

-- last element created
draw.Elements.last_element = nil


--  Method : Set last Element
-- -------------------------------------------

function draw.Elements.setLastElement(e)
    draw.Elements.last_element = e
end

--  Method : Get last Element
-- -------------------------------------------

function draw.Elements.lastElement()
    -- return last element
    return draw.Elements.last_element
end

--  Method : Prepare Elements
-- -------------------------------------------

function draw.Elements.prepareElements()
    local element_lists = { Part.List.tab_group, Part.List.control, Part.List.control_hint }

    for i = 1, #element_lists do
        for z = 1, #element_lists[i] do
            element_lists[i][z]:prepare()
        end
    end
end

--  Method : Filter Visible Elements
-- -------------------------------------------

function draw.Elements.filterVisibleElements()
    Part.List.visible_elements = {}
    Part.List.visible_layout = {}
    Part.List.visible_layout_redraw = {}
    Part.List.visible_control = {}
    Part.List.visible_control_hint = {}

    local element_lists = { Part.List.layout, Part.List.layout_redraw, Part.List.control, Part.List.control_hint }

    local visible_lists = { Part.List.visible_layout, Part.List.visible_layout_redraw, Part.List.visible_control, Part
        .List.visible_control_hint }

    for i = 1, #element_lists do
        for z = 1, #element_lists[i] do
            if element_lists[i][z]:tabCheck() then
                table.insert(visible_lists[i], element_lists[i][z])
                table.insert(Part.List.visible_elements, element_lists[i][z])
            end
        end
    end

    Part.Global.update_visible_elements = false
end

-- ===========================================================================
--                          Graphics
-- ===========================================================================


--  Globals
-- -------------------------------------------

-- base border before scaling
draw.Graphics.border_base = 1

-- border size in pixels
draw.Graphics.border = 1

-- drawing area blur factor (applied at the end of drawing process)
draw.Graphics.blur_factor = 0

-- temporary splash message
draw.Graphics.splash_message = nil


--  Method : Draw Theme Error
-- -------------------------------------------s

function draw.Graphics.drawThemeError()
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
    draw.Graphics.setFont(30)

    -- get string width
    local str_w = gfx.measurestr(str)

    -- calculate center drawing dimensions
    local x = (w - str_w) / 2
    local y = (h - 200) / 2

    -- padding
    local pad = Part.Functions.rescale(40)

    -- set cursor
    Part.Cursor.setCursor(x, y, str_w, str_s)

    draw.Graphics.drawRectangle(0, 0, gfx.w, gfx.h, color_bg)

    gfx.x = Part.Cursor.getCursorX()
    gfx.y = Part.Cursor.getCursorY() - pad

    -- draw background
    draw.Graphics.drawRectangle(Part.Cursor.getCursorX() - pad, Part.Cursor.getCursorY() - pad,
        Part.Cursor.getCursorW() + pad * 2, Part.Cursor.getCursorH() + pad * 2, color_box,
        color_border)

    -- font color
    Part.Color.setColor(color_fg, true)

    -- draw string
    gfx.drawstr(str, 5, Part.Cursor.getCursorX() + Part.Cursor.getCursorW(),
        Part.Cursor.getCursorY() + Part.Cursor.getCursorH() + pad)
end

--  Method : Draw Corner Triangle
-- -------------------------------------------

function draw.Graphics.drawCornerTriangle()
    local size = Part.Functions.rescale(draw.Sprites.rescale_corner_size)
    gfx.x = gfx.w - size
    gfx.y = gfx.h - size

    gfx.blit(draw.Sprites.slot_corner_rescale, 1, 3.1)
end

--  Method : Apply Blur
-- -------------------------------------------

function draw.Graphics.applyBlur()
    if draw.Graphics.blur_factor <= 0 then
        return
    end

    local mul = Part.Color.Lookup.color_palette.blur.mul
    local add = Part.Color.Lookup.color_palette.blur.add

    gfx.muladdrect(0, 0, gfx.w, gfx.h, mul[1], mul[2], mul[3], mul[4], add[1], add[2], add[3], add[4])

    for i = 0, math.floor(draw.Graphics.blur_factor * Part.Global.scale ^ 2) do
        gfx.x = 0
        gfx.y = 0

        gfx.blurto(gfx.w, gfx.h)
    end
end

--  Method : Blur Window
-- -------------------------------------------

function draw.Graphics.blurWindow(factor)
    draw.Graphics.blur_factor = Part.Functions.cap(factor, 0, 30) or 1
end

--  Method : Set Splash Message
-- -------------------------------------------

function draw.Graphics.splashMessage(message)
    draw.Graphics.splash_message = message
end

--  Method : Draw Splash Message
-- -------------------------------------------

function draw.Graphics.drawSplashMessage()
    -- skip if there's no splash message
    if draw.Graphics.splash_message == nil or draw.Graphics.splash_message == "" then
        return
    end

    gfx.dest = -1

    -- blur background
    draw.Graphics.blurWindow(Part.Color.Lookup.color_palette.blur.factor)
    draw.Graphics.applyBlur()

    table.insert(Part.List.pending_action, {
        func = draw.Graphics.blurWindow,
        args = { 0 }
    })

    Part.Cursor.stackCursor()
    Part.Cursor.setCursorPadding(0, 0)

    -- text
    local txt = Part.Functions.textBlock(draw.Graphics.splash_message, 30)

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
    draw.Graphics.setFont(font_size)
    Part.Color.setColor(color_fg, true)

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
    draw.Graphics.drawRectangle(bg_x, bg_y, bg_w, bg_h, nil, color_border)

    -- text cursor
    Part.Cursor.setCursorPos(bg_x + p, bg_y + p)

    for key, val in pairs(txt) do
        -- shadow
        if draw_shadow then
            local x = gfx.x
            local y = gfx.y

            gfx.x = gfx.x + shadow_offset
            gfx.y = gfx.y + shadow_offset

            Part.Color.setColor(color_shadow, true)

            gfx.drawstr(val, 1, gfx.x + bg_w - p * 2, gfx.y + line_height_rescaled)

            Part.Color.setColor(color_fg, true)

            gfx.x = x
            gfx.y = y
        end

        -- message
        gfx.drawstr(val, 1, gfx.x + bg_w - p * 2, gfx.y + line_height_rescaled)

        Part.Cursor.incCursor(0, line_height)
    end

    Part.Cursor.destackCursor()

    -- clear message
    draw.Graphics.splash_message = nil
end

--  Method : Draw Background
-- -------------------------------------------

function draw.Graphics.drawBackground()
    -- set color
    Part.Color.setColor(Part.Color.Lookup.color_palette.bg, true)

    -- draw background
    gfx.rect(0, 0, gfx.w, gfx.h)
end

--  Method : Draw Info bar
-- -------------------------------------------

function draw.Graphics.drawInfoBar()
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
        Part.Color.setColor(color_bg, true)
        gfx.rect(x, y, w, h)
    end

    -- set cursor position
    Part.Cursor.setCursorPos(x + Part.Functions.rescale(10), y)

    -- set color
    Part.Color.setColor(color_fg, true)

    -- udpate font
    draw.Graphics.setFont(12)

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

--  Method : Draw Rectangle
-- -------------------------------------------

function draw.Graphics.drawRectangle(x, y, w, h, color_bg, color_border)
    -- background
    if color_bg ~= nil then
        Part.Color.setColor(color_bg, true)

        if gfx.a > 0 then
            gfx.rect(x, y, w, h, true)
        end
    end

    -- border
    if color_border ~= nil then
        Part.Color.setColor(color_border)

        if gfx.a > 0 then
            for i = 0, draw.Graphics.border - 1 do
                gfx.rect(x + i, y + i, w - i * 2, h - i * 2, false)
            end
        end
    end
end

--  Method : Draw Gradient
-- -------------------------------------------

function draw.Graphics.drawGradient(x, y, w, h, padding, color_table, color_border, source)
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
        gfx.rect(x, y, w, draw.Graphics.border)
        gfx.rect(x, y + h - draw.Graphics.border, w, draw.Graphics.border)
        gfx.rect(x, y, draw.Graphics.border, h)
        gfx.rect(x + w - draw.Graphics.border, y + draw.Graphics.border, draw.Graphics.border, h - draw.Graphics.border)
    end
end

--  Method : Set Color
-- -------------------------------------------

function draw.Graphics.setColor(color)
    -- restore missing alpha value
    if color[4] == nil then
        color[4] = 1
    end

    -- set color for drawing instruments
    gfx.set(color[1], color[2], color[3], color[4])
end

--  Method : Setup Font
-- -------------------------------------------
function draw.Graphics.setFont(size, flag_str)
    
    -- default windows font
    local face = "Tahoma"
    
    -- mac os 
    if Part.Global.os_macos == true then
        size = size * 0.7
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
