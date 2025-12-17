-- @version 1.2.9
-- @author Fleeesch
-- @description paRt Theme Adjuster
-- @noIndex

--[[
    Tools for drawing stuff; anything that actually puts the graphics on display.

    Includes:
      - spritesheet creation
      - screenbuffer processing
      - graphical tools
      - background drawing processes
]]

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
    gfx.triangle(0, 0, size - 1, 0, 0, size - 1)

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
    local color_fg_info = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.theme_error.fg_info)

    -- display dimensions
    local w = gfx.w
    local h = gfx.h

    -- header string
    local str_header = "No paRt theme detected"

    -- info string
    local str_info = {
        {
            "Make sure you have a valid paRt theme and",
            "its filename contains a combination of \"part\" and a theme color"
        },
        {
            "Examples:",
            "Part - Dark.ReaperThemeZip",
            "part_dimmed.ReaperThemeZip",
            "part is light.ReaperTheme"
        }
    }

    -- alterantive string on version mismatch
    if Part.Global.theme_is_part and Part.Version.theme_version_is_lower then
        str_header = "paRt Theme Version is outdated"

        str_info = {
            {
                "Theme Adjuster Version: " .. Part.Version.version_adjuster,
                "Theme Version: " .. Part.Version.version_theme
            },
            {
                "Make sure your theme version is equal to or higher",
                "than the Theme Adjuster version."
            }
        }
    end


    -- update font size
    draw.Graphics.setFont(30)

    -- get string width
    local str_w = gfx.measurestr(str_header)

    -- calculate center drawing dimensions
    local x = (w - str_w) / 2
    local y = (h - 280) / 2

    -- padding
    local pad = Part.Functions.rescale(40)

    -- set cursor
    Part.Cursor.setCursor(x, y, str_w, str_s)
    gfx.x = Part.Cursor.getCursorX()
    gfx.y = Part.Cursor.getCursorY() - pad

    -- font color
    Part.Color.setColor(color_fg, true)

    -- draw string
    gfx.drawstr(str_header, 5, Part.Cursor.getCursorX() + Part.Cursor.getCursorW(), Part.Cursor.getCursorY() + Part.Cursor.getCursorH() + pad)

    -- update font
    draw.Graphics.setFont(18)
    Part.Color.setColor(color_fg_info, true)

    -- draw info text using separated blocks
    Part.Cursor.incCursor(-40, 60)
    gfx.x = Part.Cursor.getCursorX()
    gfx.y = Part.Cursor.getCursorY()
    local line_x = gfx.x

    -- iterate blocks
    for _, block in pairs(str_info) do
        -- iterate lines
        for _, line in pairs(block) do
            -- draw line
            gfx.drawstr(line, 5)
            gfx.x = line_x
            Part.Cursor.incCursor(0, 20)
            gfx.y = Part.Cursor.getCursorY()
        end

        -- block separator
        Part.Cursor.incCursor(0, 10)
    end
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

--  Method : Draw Controls
-- -------------------------------------------

function draw.Graphics.drawControlHints()
    --
    --  Helper Function: Draw Command Line
    -- =======================================
    local function draw_command_line(input, description, start_x, space)
        -- dimensions
        local line_h = 20
        local column_offset = 80

        -- extra space
        if space then
            line_h = line_h + 10
        end

        -- input
        Part.Color.setColor(Part.Color.Lookup.color_palette.hint.controls_fg, true)
        gfx.drawstr(input .. "")
        gfx.x = start_x + Part.Functions.rescale(column_offset)

        -- description
        Part.Color.setColor(Part.Color.Lookup.color_palette.hint.controls_fg_desc, true)
        gfx.drawstr(description)

        -- next line
        gfx.x = start_x
        gfx.y = gfx.y + Part.Functions.rescale(line_h)
    end

    -- initial position
    local x = Part.Functions.rescale(Part.Global.hint_x + 10, true, false)
    local y = Part.Functions.rescale(Part.Global.hint_y + 20, false, true)
    gfx.x = x
    gfx.y = y

    -- font setup
    draw.Graphics.setFont(14)

    -- shortcuts
    local commands = {
        { label = "Mouse L",     description = "Set Value",           space = false },
        { label = "Mouse R",     description = "Reset Value",         space = false },
        { label = "CTRL / CMD",  description = "Fine Adjustment",     space = true },
        { label = "Left, Right", description = "Browse Tabs",         space = false },
        { label = "Up, Down",    description = "Browse Sub-Tabs",     space = true },
        { label = "1-8",         description = "Bank Select",         space = false },
        { label = "F1-F8",       description = "Config Select",       space = true },
        { label = "R",           description = "Reset Window",        space = false },
        { label = "T",           description = "Restart T. Adjuster", space = false },
        { label = "ESC",         description = "Close Window",        space = false },
    }

    for _, command in ipairs(commands) do
        draw_command_line(command.label, command.description, x, command.space)
    end
end

--  Method : Draw Background
-- -------------------------------------------

function draw.Graphics.drawBackground()
    -- set color
    Part.Color.setColor(Part.Color.Lookup.color_palette.bg, true)

    -- draw background
    gfx.rect(0, 0, gfx.w, gfx.h)

    -- only draw hint background if theme version is valid
    if not (Part.Global.theme_is_part and Part.Version.theme_version_is_lower) then
        -- hint background
        local x = Part.Functions.rescale(Part.Global.hint_x, true, false)
        local y = Part.Functions.rescale(Part.Global.hint_y, false, true)
        local w = Part.Functions.rescale(Part.Global.hint_w)
        local h = Part.Functions.rescale(Part.Global.hint_h)

        Part.Color.setColor(Part.Color.Lookup.color_palette.hint.stage_bg, true)
        gfx.rect(x, y, w, h)

        -- theme hint coordinates
        gfx.x = x + Part.Functions.rescale(10)
        gfx.y = y + h - Part.Functions.rescale(20)
        draw.Graphics.setFont(16)

        -- unpacked
        if Part.Global.theme_is_unpacked then
            Part.Color.setColor(Part.Color.Lookup.color_palette.theme_hint.unpacked, true)
            gfx.drawstr("UNPACKED")
            gfx.drawstr("  ")
        end

        -- modded
        if Part.Global.theme_is_modded then
            Part.Color.setColor(Part.Color.Lookup.color_palette.theme_hint.modded, true)
            gfx.drawstr("MOD")
        end
    end
end

--  Method : Draw Theme Palette Sample
-- -------------------------------------------

function draw.Graphics.drawThemePaletteSample(palette_address, width)
    local total_w = width or 200
    local sample_h = Part.Functions.rescale(20)
    local pad = 5

    -- palette has to be valid
    if Part.Color.Lookup[palette_address] == nil then
        return
    end

    local palette = Part.Color.Lookup[palette_address]

    -- background
    local x = Part.Cursor.getCursorX()
    local y = Part.Cursor.getCursorY()
    local shadow_offset = Part.Functions.rescale(4)
    local draw_x = x
    local draw_y = y
    local w = Part.Functions.rescale(total_w)
    local h = sample_h + pad * 2

    -- shadow
    Part.Color.setColor(palette.sample.shadow, true)
    draw.Graphics.drawRectangle(draw_x + shadow_offset, draw_y + shadow_offset, w, h,
        Part.Color.Lookup.color_palette.sample.drop_shadow)

    -- fill
    Part.Color.setColor(palette.sample.shadow, true)
    gfx.rect(x, y, w, h)

    -- border
    draw.Graphics.drawRectangle(draw_x, draw_y, w, h, nil, Part.Color.Lookup.color_palette.sample.border)

    -- coordinates
    x = Part.Cursor.getCursorX() + pad
    y = Part.Cursor.getCursorY() + pad

    -- colors
    local colors = Part.Functions.deepCopy(palette.sample.palette)

    -- color size
    local sample_w = Part.Functions.rescale(math.floor((total_w - pad * 2) / #colors))

    -- draw palettes
    for _, color in ipairs(colors) do
        Part.Color.setColor(color, true)
        gfx.rect(x, y, sample_w, sample_h)
        x = x + sample_w
    end
end

--  Method : Draw Info bar
-- -------------------------------------------

function draw.Graphics.drawInfoBar()
    -- setup dimensions
    local x = Part.Functions.rescale(0)
    local y = Part.Functions.rescale(Part.Global.win_h - Part.Global.bank_bar_size + Part.Global.win_y_offset)
    local w = gfx.w
    local h = Part.Functions.rescale(Part.Global.infobar_h)
    local h_backdrop = Part.Functions.rescale(Part.Global.bank_bar_size + Part.Global.win_y_offset) + h

    -- get colors
    local color_backdrop = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.infobar.backdrop)
    local color_bg = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.infobar.bg)
    local color_fg = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.infobar.fg)
    local color_label_fg = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.infobar.label.fg)
    local color_label_frame = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.infobar.label.frame)


    -- y position
    y = y - h

    Part.Color.setColor(color_backdrop, true)
    gfx.rect(x, y, w, h_backdrop)

    -- draw background if visible (depending on alpha level)
    if color_bg[4] ~= 0 then
        Part.Color.setColor(color_bg, true)
        gfx.rect(x, y, w, h)
    end

    -- set cursor position
    Part.Cursor.setCursorPos(x + Part.Functions.rescale(10), y)

    -- set color
    Part.Color.setColor(color_fg, true)

    -- update font
    draw.Graphics.setFont(12)

    -- version string
    gfx.drawstr("paRt Theme Adjuster " .. Part.Version.version_adjuster .. "                 Theme Version " .. Part.Version.version_theme)

    --  Helper: Place Label
    -- =======================================

    local function place_label(x, y, text)
        gfx.x = x
        gfx.y = y
        draw.Graphics.setFont(13)
        Part.Color.setColor(color_label_fg, true)
        gfx.drawstr(text)
    end

    --  Helper: Place Frame
    -- =======================================

    local function place_frame(x, y, w, h)
        Part.Color.setColor(color_label_fg, true)
        draw.Graphics.drawRectangle(x, y, Part.Functions.rescale(w), Part.Functions.rescale(h), nil, color_label_frame)
    end
    -- =======================================

    -- labels
    local label_x
    local label_y
    local icon_size = 16

    -- bank plus symbol
    label_x = x + Part.Functions.rescale(16)
    label_y = y + h + Part.Functions.rescale(6)

    -- place_frame(label_x, label_y, icon_size, icon_size)

    gfx.x = label_x
    gfx.y = label_y
    Part.Color.setColor(color_label_frame, true)
    draw.Graphics.setFont(20)

    -- bank label
    label_x = x + Part.Functions.rescale(40)
    label_y = y + h + Part.Functions.rescale(7)
    place_label(label_x, label_y, "Bank")
    place_frame(label_x + Part.Functions.rescale(30), y + h + Part.Functions.rescale(2), 260, 25)
    label_x = label_x + Part.Functions.rescale(3)

    -- config
    label_x = x + Part.Functions.rescale(380)
    place_label(label_x, label_y, "Config")
    place_frame(label_x + Part.Functions.rescale(40), y + h + Part.Functions.rescale(2), 355, 25)
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
        Part.Color.setColor(color_border, true)

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
        Part.Color.setColor(color_border, true)

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
    size = size or 12

    -- default windows font
    local face = "Tahoma"

    -- mac os
    if Part.Global.os_macos == true then
        size = size * 0.7
    end

    -- linux
    if Part.Global.os_linux == true then
        size = size * 0.825
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
