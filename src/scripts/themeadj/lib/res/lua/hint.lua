-- @version 1.2.5
-- @author Fleeesch
-- @description paRt Theme Adjuster
-- @noIndex

--[[
    Hint message display.
    Messages itself are contained in hint_messages.lua
]] --

local hinthandling = { Hint = {} }

-- ====================================================================================
--              Hint Message
-- ====================================================================================

--  Hint Message
-- -------------------------------------------

function hinthandling.Hint:new(o)
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

hinthandling.hint_message = hinthandling.Hint:new()

--  Hint Message : Buffer
-- -------------------------------------------

function hinthandling.Hint:buffer()
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
            block.type == Part.Hint.Lookup.HintTypes.warning or
            --block.type == Part.Hint.Lookup.HintTypes.attention or
            --block.type == Part.Hint.Lookup.HintTypes.info or
            --block.type == Part.Hint.Lookup.HintTypes.tip or
            block.type == Part.Hint.Lookup.HintTypes.highlight
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
        if block.type == Part.Hint.Lookup.HintTypes.warning then
            Part.Color.setColor(Part.Color.Lookup.color_palette.hint.warning_bg, true)
            draw_callout_bg(pos_x, pos_y, block.w, block.h)

            Part.Draw.Graphics.setFont(font_size, "b")
            Part.Color.setColor(Part.Color.Lookup.color_palette.hint.warning_fg, true)

            -- attention
        elseif block.type == Part.Hint.Lookup.HintTypes.attention then
            Part.Color.setColor(Part.Color.Lookup.color_palette.hint.attention_bg, true)
            draw_callout_bg(pos_x, pos_y, block.w, block.h)

            --Part.Draw.Graphics.setFont(font_size, "b")
            Part.Color.setColor(Part.Color.Lookup.color_palette.hint.attention_fg, true)

            -- tip
        elseif block.type == Part.Hint.Lookup.HintTypes.tip then
            Part.Color.setColor(Part.Color.Lookup.color_palette.hint.tip_bg, true)
            draw_callout_bg(pos_x, pos_y, block.w, block.h)

            --Part.Draw.Graphics.setFont(font_size, "b")
            Part.Color.setColor(Part.Color.Lookup.color_palette.hint.tip_fg, true)

            -- highlight
        elseif block.type == Part.Hint.Lookup.HintTypes.highlight then
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

function hinthandling.Hint:setSource(source)
    if source ~= self.source then
        self.do_buffer = true
    end

    self.source = source
end

--  Hint Message : Clear
-- -------------------------------------------

function hinthandling.Hint:clear()
    self.source = nil
end

--  Hint Message : Draw
-- -------------------------------------------

function hinthandling.Hint:draw()
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

return hinthandling
