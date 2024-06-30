local message = {}

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Message Entry
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

message.MessageEntry = {}

function message.MessageEntry:new(o, text, symbol, type, handler)
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

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Message Entry : Set Position
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function message.MessageEntry:setPosition(pos)

    self.pos_offset = pos
    self.pos_offset_last = pos
    self.pos = pos

end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Message Entry : Draw
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function message.MessageEntry:draw()

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
    self.color_border[4] = alpha
    self.color_shadow[4] = (alpha ^ 4) * self.shadow_depth

    -- shadow
    Part.Draw.Graphics.drawRectangle(x - p + s, y - p + s, w + p * 2, h, self.color_shadow)

    -- border
    Part.Draw.Graphics.drawRectangle(x - p, y - p, w + p * 2, h, color_bg, self.color_border)

    -- font color
    Part.Color.setColor(color_fg,true)

    -- draw extra symbol
    if self.symbol ~= "" then

        gfx.x = x + Part.Functions.rescale(self.symbol_margin_x)
        gfx.y = y + Part.Functions.rescale(self.symbol_margin_y)

        Part.Draw.Graphics.setFont(self.symbol_size,self.font_flags)

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

return message