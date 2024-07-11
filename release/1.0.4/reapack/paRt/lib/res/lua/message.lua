-- @version 1.0.4
-- @author Fleeesch
-- @description paRt Theme Adjuster
-- @noIndex
local message = { Entry = {}, Handler = {} }

-- =======================================================================
--                      Message : Entry
-- =======================================================================


--  Message Entry
-- -------------------------------------------

message.Entry.MessageEntry = {}

function message.Entry.MessageEntry:new(o, text, symbol, type, handler)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    Part.Cursor.applyCursorToTarget(o)

    -- message handler
    o.handler = handler or Gui.MessageHandler

    -- displayed message
    o.text = Part.Functions.textBlock(tostring(text), o.handler.char_limit)

    -- line height and font size
    o.line_height = 16
    o.font_size = 16

    -- type of message (for extra-formatting)
    o.type = type or ""

    -- message box padding
    o.pad = 8

    -- shadow diagonal offset
    o.shadow_offset = 4

    -- pre-calculate height
    o.height = 0

    for key, val in pairs(o.text) do
        o.height = o.height + o.line_height
    end

    o.height = o.height + o.pad * 2

    -- set position
    self:setPosition(o.handler.y_pos)

    -- display time
    o.life = o.handler.fade_out
    o.clock = o.life + o.handler.delay

    -- kill flag (marks a pending kill)
    o.kill = false

    -- colors
    o.color_bg = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.message.bg)
    o.color_fg = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.message.fg)
    o.color_border = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.message.border)
    o.color_shadow = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.message.shadow)
    o.color_error_bg = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.message.error_bg)
    o.color_error_fg = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.message.error_fg)

    -- shadow alpha
    o.shadow_depth = o.color_shadow[4]

    -- extra symbol dimensions
    o.symbol = symbol or ""
    o.symbol_margin_x = -6
    o.symbol_margin_y = -16
    o.symbol_size = 30

    return o
end

--  Message Entry : Set Position
-- -------------------------------------------

function message.Entry.MessageEntry:setPosition(pos)
    self.pos_offset = pos
    self.pos_offset_last = pos
    self.pos = pos
end

--  Message Entry : Draw
-- -------------------------------------------

function message.Entry.MessageEntry:draw()
    -- calculate alpha
    local alpha = math.min(self.clock / self.life, 1)

    -- move to target position
    self.pos = Part.Functions.interpolate(self.pos_offset_last, self.pos_offset, 0.25)

    -- store position
    self.pos_offset_last = self.pos

    -- kill after fade-out
    if alpha <= 0 then
        self.kill = true
        return
    end

    -- set scaled font size
    Part.Draw.Graphics.setFont(self.font_size)

    -- calculate maximal width
    local str_w = 0
    local symbol_offset = 0

    for key, val in pairs(self.text) do
        str_w = math.max(gfx.measurestr(val), str_w)
    end

    -- calculate extra symbol padding
    if self.symbol ~= "" then
        symbol_offset = Part.Functions.rescale(40)
    end

    -- dimensions
    local p = Part.Functions.rescale(self.pad)
    local x = Part.Functions.rescale(self.handler.dim_x + self.handler.dim_w) - str_w - p - symbol_offset
    local y = Part.Functions.rescale(self.handler.dim_y + self.pos)
    local w = str_w + symbol_offset
    local h = Part.Functions.rescale(self.height)
    local s = Part.Functions.rescale(self.shadow_offset)

    -- decrement clock
    if self.clock > 0 then
        self.clock = self.clock - 1
    end

    -- pick colors
    local color_bg = self.color_bg
    local color_fg = self.color_fg

    if self.type == "error" then
        color_bg = self.color_error_bg
        color_fg = self.color_error_fg
    end

    -- fade-out calculation
    color_bg[4] = alpha
    color_fg[4] = alpha
    self.color_border[4] = alpha * Part.Color.Lookup.color_palette.message.border[4]
    self.color_shadow[4] = (alpha ^ 4) * self.shadow_depth

    -- shadow
    Part.Draw.Graphics.drawRectangle(x - p + s, y - p + s, w + p * 2, h, self.color_shadow)

    -- border
    Part.Draw.Graphics.drawRectangle(x - p, y - p, w + p * 2, h, color_bg, self.color_border)

    -- font color
    Part.Color.setColor(color_fg, true)

    -- draw extra symbol
    if self.symbol ~= "" then
        gfx.x = x + Part.Functions.rescale(self.symbol_margin_x)
        gfx.y = y + Part.Functions.rescale(self.symbol_margin_y)

        Part.Draw.Graphics.setFont(self.symbol_size, self.font_flags)

        gfx.drawstr(self.symbol, 5, x + symbol_offset, y + h)
    end

    -- draw text line by line
    Part.Draw.Graphics.setFont(self.font_size)

    gfx.x = x + symbol_offset
    gfx.y = y

    for key, val in pairs(self.text) do
        gfx.drawstr(val)

        gfx.x = x + symbol_offset
        gfx.y = gfx.y + Part.Functions.rescale(self.line_height)
    end
end

-- =======================================================================
--                      Message : Handler
-- =======================================================================


--  Method : Block Messages
-- -------------------------------------------

message.Handler.block_messages = false

function message.Handler.blockMessages(block)
    message.Handler.block_messages = block
end

--  Method : Show Message
-- -------------------------------------------

function message.Handler.showMessage(text, symbol, type)
    -- only show messages when allowed
    if message.Handler.block_messages then
        return
    end

    -- requires message handler
    if Part.Gui.MessageHandler ~= nil then
        Part.Gui.MessageHandler:showMessage(text, symbol, type)
    end
end

--  Message Handler
-- -------------------------------------------

message.Handler.MessageHandler = {}

function message.Handler.MessageHandler:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    Part.Cursor.applyCursorToTarget(o)

    -- messages to be displayed
    o.messages = {}

    -- delay and fade-out-time
    o.delay = 50
    o.fade_out = 20

    -- original y-position (for message placement)
    o.y_pos = 0

    -- padding between messages
    o.message_pad = 10

    -- character limit before line-break
    o.char_limit = 80

    return o
end

--  Message Handler : Add Message
-- -------------------------------------------

function message.Handler.MessageHandler:showMessage(text, symbol, type)
    -- create message
    local msg = Part.Message.Entry.MessageEntry:new(nil, text, symbol, type, self)

    -- shift handler position
    self:shiftOffset(-msg.height)

    -- update created message position
    msg:setPosition(self.y_pos)

    -- register message
    table.insert(self.messages, msg)
end

--  Message Handler : Shift Offset
-- -------------------------------------------

function message.Handler.MessageHandler:shiftOffset(offset)
    -- get padding
    local pad = self.message_pad

    -- flip padding depending on the shift direction
    if offset < 0 then
        pad = -pad
    end

    -- apply offset
    self.y_pos = self.y_pos + offset + pad
end

--  Message Handler : Draw
-- -------------------------------------------

function message.Handler.MessageHandler:draw()
    -- skip if there are no messages
    if #self.messages <= 0 then
        return
    end

    -- dimensions
    local x = Part.Functions.rescale(self.dim_x)
    local y = Part.Functions.rescale(self.dim_y)
    local w = Part.Functions.rescale(self.dim_w)
    local h = Part.Functions.rescale(self.dim_h)

    -- daw messages
    for key, val in pairs(self.messages) do
        val:draw()
    end

    -- required message shift
    local total_shift = 0

    -- go through messages
    for key, val in pairs(self.messages) do
        -- message can be killed?
        if val.kill then
            -- reshift the offset
            self:shiftOffset(val.height)

            -- increment total shift
            total_shift = total_shift - val.height - self.message_pad

            -- remove message from lookup table
            table.remove(self.messages, key)
            break
        end
    end

    -- apply total shift to messages
    if total_shift ~= 0 then
        for key, val in pairs(self.messages) do
            val.pos_offset = val.pos_offset - total_shift
        end
    end
end

return message
