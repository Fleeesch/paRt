local layout = {}

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Group
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

layout.Group = Part.Layout.LayoutElement:new()

function layout.Group:new(o, header_text)
    o = o or Part.Layout.LayoutElement:new(o)
    setmetatable(o, self)
    self.__index = self

    -- transfer cursor dimensions
    Part.Cursor.applyCursorToTarget(o)

    o.header_text = header_text

    -- color values
    o.color_bg = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.group.bg)
    o.color_fg = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.group.fg)
    o.color_border = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.group.border)
    o.color_header_bg = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.group.header.bg)
    o.color_header_fg = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.group.header.fg)
    o.color_header_border = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.group.header.border)
    o.color_bg_tinted = Part.Functions.deepCopy(o.color_bg)

    -- register image in list
    table.insert(Part.List.layout, o)

    return o
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Group : Set Color
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function layout.Group:setColor(fg, bg, border)
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
-- Layout : Group : Set Tint
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function layout.Group:setTint(tint)
    -- check if tint exists
    if Part.Color.Lookup.color_palette.group.tint ~= nil then
        -- get tint
        local tint_color = Part.Color.Lookup.color_palette.group.tint[tint]

        -- inrterpolate color values using the tints alpha value
        self.color_bg_tinted[1] = Part.Functions.interpolate(self.color_bg[1], tint_color[1], tint_color[4])
        self.color_bg_tinted[2] = Part.Functions.interpolate(self.color_bg[2], tint_color[2], tint_color[4])
        self.color_bg_tinted[3] = Part.Functions.interpolate(self.color_bg[3], tint_color[3], tint_color[4])

        -- use the original color alpha value
        self.color_bg_tinted[4] = self.color_bg[4]

        -- mark color as tinted
        self.color_is_tinted = true
    end
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Group : Draw
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function layout.Group:draw()
    -- prepare dimensions
    local x = Part.Functions.rescale(self.dim_x, true)
    local y = Part.Functions.rescale(self.dim_y, false, true)
    local w = Part.Functions.rescale(self.dim_w)
    local h = Part.Functions.rescale(self.dim_h)

    local pad_x = Part.Functions.rescale(10)
    local pad_y = Part.Functions.rescale(4)

    Part.Draw.Graphics.drawRectangle(x, y, w, h, self.color_bg_tinted, self.color_border)

    if self.header_text ~= nil then
        gfx.x = x + pad_x
        gfx.y = y + pad_y

        local line_h = Part.Functions.rescale(16)
        local pad_line = Part.Functions.rescale(20)

        Part.Color.setColor(self.color_fg, true)
        Part.Draw.Graphics.setFont(16)
        gfx.drawstr(self.header_text, 1, gfx.x + w - pad_x * 2, gfx.y + line_h)

        Part.Draw.Graphics.drawRectangle(x + pad_line, gfx.y + line_h, w - pad_line * 2, Part.Draw.Graphics.border,
            self.color_header_border)
    end
end

return layout
