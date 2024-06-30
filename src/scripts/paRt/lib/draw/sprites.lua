local draw_sprites = {}

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Sprites : Get Next Image Slot
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function draw_sprites.getNextFreeImageSlot()
    draw_sprites.image_index = draw_sprites.image_index + 1
    return draw_sprites.image_index - 1
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Sprites
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

draw_sprites.value_buffer_done = false

-- sprite slot
draw_sprites.image_index = 1

-- knob dimensions
draw_sprites.knob_sprites = 100
draw_sprites.knob_val_size = 48
draw_sprites.knob_size = 16

-- corner dimensions
draw_sprites.rescale_corner_size = 14
draw_sprites.hint_corner_size = 8

-- knob slots
draw_sprites.slot_knob_line = draw_sprites.getNextFreeImageSlot()
draw_sprites.slot_knob_line_default = draw_sprites.getNextFreeImageSlot()
draw_sprites.slot_knob_val_linear = draw_sprites.getNextFreeImageSlot()
draw_sprites.slot_knob_val_bi = draw_sprites.getNextFreeImageSlot()

-- corner slots
draw_sprites.slot_corner_rescale = draw_sprites.getNextFreeImageSlot()
draw_sprites.slot_corner_hint = draw_sprites.getNextFreeImageSlot()
draw_sprites.slot_corner_hint_alt = draw_sprites.getNextFreeImageSlot()

-- colors    
draw_sprites.color_rescale = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.corner_triangle)
draw_sprites.color_hint = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.color.cyan)
draw_sprites.color_hint_alt = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.hint.symbol_alt)


-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Sprites : Corner Hint
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function draw_sprites.cornerHint()
    return draw_sprites.slot_corner_hint
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Sprites : Create Assets
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function draw_sprites.createAssets()
    draw_sprites.createKnobAssets()
    draw_sprites.createKnobValueAssets()
    draw_sprites.createCornerAssets()
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Sprites : Create Corner Assets
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function draw_sprites.createCornerAssets()

    local last_dest = gfx.dest

    local size = Part.Functions.rescale(draw_sprites.hint_corner_size)
    local dest = draw_sprites.slot_corner_hint

    gfx.setimgdim(dest, -1, -1)
    gfx.setimgdim(dest, size, size)
    
    gfx.dest = dest

    Part.Color.setColor(draw_sprites.color_hint,true)
    gfx.triangle(0,0,size-1,0,0,size-1)
    gfx.line(0,size,size,0,1)

    gfx.dest = last_dest
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Sprites : Create Knob Value Assets
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function draw_sprites.createKnobValueAssets()
    if draw_sprites.value_buffer_done then
        return
    end

    local last_dest = gfx.dest

    -- slots
    local slot_val_linear = draw_sprites.slot_knob_val_linear
    local slot_val_bi = draw_sprites.slot_knob_val_bi


    -- ::: Linear :::

    -- dimensions
    local size = draw_sprites.knob_val_size
    local size2 = math.floor(size / 2)
    local r_inner = size2 - Part.Draw.Graphics.border

    -- setup drawing area
    gfx.dest = slot_val_linear
    gfx.setimgdim(slot_val_linear, -1, -1)
    gfx.setimgdim(slot_val_linear, size, size * (draw_sprites.knob_sprites + 1))

    -- fill
    local color_fill = Part.Color.Lookup.color_palette.color.blue
    Part.Color.setColor(color_fill,true)
    gfx.a = 1

    -- dimensions
    local y = 0
    local offset = -0.1
    local range = 5
    local range2 = range / 2

    -- sprite creation
    for i = 1, draw_sprites.knob_sprites + 1 do
        local rotation = (range / draw_sprites.knob_sprites) * i - range2 + offset

        -- differentiate betwenn <0 and >0
        if rotation > -range2 then
            -- border lines
            gfx.arc(size2, size2 + y, r_inner, rotation + offset, -range2, true)
            gfx.arc(size2, size2 + y, r_inner - 8, rotation + offset, -range2, true)

            -- filler lines
            for i2 = 1, 16  do
                gfx.arc(size2, size2 + y, r_inner + -(i2 - 1) / 4, rotation + offset, -range2, true)
            end
        end

        -- next sprite
        y = y + size
    end

    -- ::: Bi-Directional :::
    gfx.dest = slot_val_bi
    gfx.setimgdim(slot_val_bi, -1, -1)
    gfx.setimgdim(slot_val_bi, size, size * (draw_sprites.knob_sprites + 1))

    -- coordinates
    local y = 0
    local offset = -0.1
    local range = 5
    local range2 = range / 2
    local deadzone = 0.01

    -- sprite creation
    for i = 1, draw_sprites.knob_sprites + 1 do
        -- sprite skipping
        local draw = false

        -- arc values
        local a, b

        -- pick a site
        if i < draw_sprites.knob_sprites / 2 - deadzone then
            a = (range / draw_sprites.knob_sprites) * i - range2 + 0
            b = 0
            draw = true
        elseif i > draw_sprites.knob_sprites / 2 + deadzone then
            a = 0
            b = (range / draw_sprites.knob_sprites) * i - range2 + offset
            draw = true
        end

        -- arc drawing
        if draw then
            gfx.arc(size2, size2 + y, r_inner, a, b, true)
            gfx.arc(size2, size2 + y, r_inner - 8, a, b, true)

            for i2 = 1, 16 do
                gfx.arc(size2, size2 + y, r_inner + -(i2 - 1) / 4, a, b, true)
            end
        end

        -- next sprite
        y = y + size
    end

    gfx.dest = last_dest

    draw_sprites.value_buffer_done = true
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Sprites : Create Knob Assets
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function draw_sprites.createKnobAssets()
    local size = Part.Functions.rescale(16)

    local last_dest = gfx.dest

    -- calculate dimensions
    local dim = size
    local dim2 = dim * 0.5
    local r = Part.Functions.rescale(1)
    local l = Part.Functions.rescale(6)
    local factor = 2

    -- slots
    local slot_line = draw_sprites.slot_knob_line
    local slot_default_line = draw_sprites.slot_knob_line_default

    -- knob line
    gfx.dest = slot_line
    gfx.setimgdim(slot_line, -1, -1)
    gfx.setimgdim(slot_line, dim, dim)

    -- color
    Part.Color.setColor(Part.Color.Lookup.color_palette.knob.fg,true)
    gfx.rect(dim2 - r, r, r * factor, l )

    -- default knob line
    gfx.dest = slot_default_line
    gfx.setimgdim(slot_default_line, -1, -1)
    gfx.setimgdim(slot_default_line, dim, dim)

    Part.Color.setColor(Part.Color.Lookup.color_palette.knob.default,true)
    gfx.rect(dim2 - r, r, r * factor, l - r)

    gfx.dest = last_dest
end

return draw_sprites