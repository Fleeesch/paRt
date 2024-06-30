local layout = {}

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Output : Text
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
layout.Text = Part.Layout.LayoutElement:new()

function layout.Text:new(o, text_blank, parameter)
    o = o or Part.Layout.LayoutElement:new(o)
    setmetatable(o, self)
    self.__index = self

    -- padding
    self.pad_x = 2
    self.pad_y = 1

    -- get cursor values
    Part.Cursor.applyCursorToTarget(o)

    -- label text
    o.text_blank = text_blank

    -- linked parameter (replacing text_blank)
    o.parameter = parameter
    o.parameter_multiplier = 1

    -- flags for display formatting
    o.flags = 0

    -- lookup table (for dynamic output text)
    o.lookup = nil

    -- custom expansion (for dealing with clipping)
    o.expand_w = 0
    o.expand_h = 0

    -- color values
    o.color_font = Part.Color.Lookup.color_palette.text.fg
    o.color_bg = Part.Color.Lookup.color_palette.text.bg
    o.color_border = Part.Color.Lookup.color_palette.text.border

    -- is a divider (sub-heading)
    o.is_divider = false

    -- font flags
    self.font_flags = ""

    -- formatting flags
    o.flags = {
        center_horz = 0,
        center_vert = 0,
        right_just = 0,
        bottom_just = 0,
        ignore_right_bottom = 0
    }

    -- register in lists
    table.insert(Part.List.layout, o)
    table.insert(Part.List.layout_text, o)

    return o
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Output : Text : Set Font Flags
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function layout.Text:setFontFlags(flags)
    self.font_flags = flags
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Output : Text : Expand
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function layout.Text:expand(expand_w, expand_h)
    -- horizontal expansion
    if expand_w ~= nil then
        self.expand_w = expand_w
    end

    -- vertical expansion
    if expand_h ~= nil then
        self.expand_h = expand_h
    end
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Output : Text : Parameter Label
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function layout.Text:parameterLabel()
    self:justRight()
    self:centerVert()
    self:setColor(Part.Color.Lookup.color_palette.text.parameter.fg, Part.Color.Lookup.color_palette.text.parameter.bg,
        nil)
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Output : Text : Info Label
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function layout.Text:infoLabel()
    self:centerHorz()
    self:centerVert()
    self:setColor(Part.Color.Lookup.color_palette.text.info_fg, Part.Color.Lookup.color_palette.text.info_bg,
        nil)
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Output : Text : Table Header
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function layout.Text:tableHeader(colspan)
    self:centerHorz()
    self:expand(20)

    self:setColor(Part.Color.Lookup.table.header_fg, nil, nil)

    if colspan ~= nil and colspan > 1 then
        self.colspan = colspan
    end
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Output : Text : Table Entry
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function layout.Text:tableEntry(just_right)
    if just_right ~= nil and just_right then
        self:justRight()
    end

    self:setColor(Part.Color.Lookup.color_palette.table.entry_fg, nil, nil)
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Output : Text : Parameter Monitor
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function layout.Text:parameterMonitor(multiplier)
    
    self:setColor(Part.Color.Lookup.color_palette.text.monitor.fg, Part.Color.Lookup.color_palette.text.monitor.bg,
        Part.Color.Lookup.color_palette.text.monitor.border)

    self.parameter_multiplier = multiplier or 1

    self:centerHorz()
    self:centerVert()

    table.insert(Part.List.layout_redraw, self)
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Output : Text : Divider
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function layout.Text:divider(keep_width)
    local keep_width = keep_width or false

    -- divider settings
    self.ignore_cols = not keep_width

    self:centerHorz()
    self:setColors(Part.Color.Lookup.color_palette.label.divider, Part.Color.Lookup.color_palette.label.divider_bg, nil)
    --self:setFontFlags("b")

    -- register itself as divider
    self.is_divider = true
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Output : Text : Set Color
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function layout.Text:setColor(fg, bg, border)
    -- foreground
    if type(fg) == "table" or fg == nil then
        self.color_font = fg
    end

    -- background
    if type(bg) == "table" or bg == nil then
        self.color_bg = bg
    end

    -- border
    if type(border) == "table" or border == nil then
        self.color_border = border
    end
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Output : Text : Get Flags
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function layout.Text:getFlags()
    -- return value
    local rtn = 0

    -- construct flag number
    for i, v in pairs(self.flags) do
        rtn = rtn + v
    end

    -- return flags
    return rtn
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Output : Text : Center Horizontally
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function layout.Text:centerHorz(on)
    if on == nil or on then
        self.flags["center_horz"] = 1
    else
        self.flags["center_horz"] = 0
    end
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Output : Text : Center Vertically
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function layout.Text:centerVert(on)
    if on == nil or on then
        self.flags["center_vert"] = 4
    else
        self.flags["center_vert"] = 0
    end
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Output : Text : Justify Right
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function layout.Text:justRight(on)
    if on == nil or on then
        self.flags["just_right"] = 2
    else
        self.flags["just_right"] = 0
    end
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Output : Text : Justify Bottom
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function layout.Text:justBottom(on)
    if on == nil or on then
        self.flags["just_bottom"] = 8
    else
        self.flags["just_bottom"] = 0
    end
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Output : Text : Ignore Right Bottom
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function layout.Text:ignoreRightBottom(on)
    if on == nil or on then
        self.flags["ignore_right_bottom"] = 256
    else
        self.flags["ignore_right_bottom"] = 0
    end
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Output : Text : Set Lookup Table
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function layout.Text:setLookupTable(lookup)
    -- convert lookup table values to string
    for i, v in pairs(lookup) do
        lookup[i] = tostring(v)
    end

    -- store lookup values
    self.lookup = lookup
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Output : Text : Draw
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function layout.Text:draw()
    -- initialize dimensions
    local x = Part.Functions.rescale(self.dim_x - self.expand_w, self.autocenter_position)
    local y = Part.Functions.rescale(self.dim_y - self.expand_h, false, self.autocenter_position)
    local w = Part.Functions.rescale(self.dim_w + self.expand_w * 2)
    local h = Part.Functions.rescale(self.dim_h + self.expand_h * 2)

    -- font y position
    local y_f = Part.Functions.rescale(self.dim_y - 2 - -self.expand_h, false, self.autocenter_position)

    -- padding
    local p_x = Part.Functions.rescale(self.pad_x)
    local p_y = Part.Functions.rescale(self.pad_y)

    -- background color available?
    if self.color_bg ~= nil then
        Part.Draw.Graphics.drawRectangle(x, y, w, h, self.color_bg, self.color_border)
    end

    -- font color
    Part.Color.setColor(self.color_font, true)

    -- custom font position
    Part.Cursor.setCursorPos(x + p_x, y_f + p_y)

    -- output text
    local text = self.text_blank

    -- direct parameter value
    if self.parameter ~= nil then
        text = tostring(self.parameter:getValue() * self.parameter_multiplier)
    end

    -- lookup table
    if self.lookup ~= nil then
        -- calculate index based on value
        local idx = math.floor(self.parameter:getValue() - self.parameter.value_min) + 1

        -- cap index
        idx = math.min(idx, #self.lookup)

        -- pick text from lookup
        text = self.lookup[idx]
    end

    -- draw
    Part.Draw.Graphics.setFont(16, self.font_flags)

    gfx.drawstr(text, self:getFlags(), x + w - p_x * 2, y + h - p_y * 2)
end

return layout
