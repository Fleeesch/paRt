local layout = {}

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Output : Text
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
layout.Label = Part.Layout.LayoutElement:new()

function layout.Label:new(o)
    o = o or Part.Layout.LayoutElement:new(o)
    setmetatable(o, self)
    self.__index = self

    -- get cursor values
    Part.Cursor.applyCursorToTarget(o)

    -- color values
    o.color_bg = Part.Color.Lookup.color_palette.label.bg
    o.color_border = Part.Color.Lookup.color_palette.label.border

    o.expand_w = 1
    o.expand_h = 1

    -- register in lists
    table.insert(Part.List.layout, o)
    table.insert(Part.List.layout_label, o)

    return o
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Output : Text : Stretch
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function layout.Label:stretch(x, y)
    if x ~= nil then self.dim_w = x - self.dim_x end
    if y ~= nil then self.dim_h = y - self.dim_y end
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Output : Text : Table Row
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function layout.Label:tableRow(uneven)
    if uneven ~= nil and uneven ~= 0 then
        self:setColor(Part.Color.Lookup.color_palette.table.row_uneven)
    else
        self:setColor(Part.Color.Lookup.color_palette.table.row_even)
    end
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Output : Text : Table Column
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function layout.Label:tableColumn(uneven)
    if uneven ~= nil and uneven ~= 0 then
        self:setColor(Part.Color.Lookup.color_palette.table.column_uneven)
    else
        self:setColor(Part.Color.Lookup.color_palette.table.column_even)
    end
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Output : Text : Table Empty Space
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function layout.Label:tableEmptySpace()
    self:setColor(Part.Color.Lookup.color_palette.table.empty_space)
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Output : Text : Set Color
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function layout.Label:setColor(bg, border)
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
-- Output : Text : Draw
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function layout.Label:draw()
    -- initialize dimensions
    local x = Part.Functions.rescale(self.dim_x - self.expand_w, self.autocenter_position)
    local y = Part.Functions.rescale(self.dim_y - self.expand_h, false, self.autocenter_position)
    local w = Part.Functions.rescale(self.dim_w + self.expand_w * 2)
    local h = Part.Functions.rescale(self.dim_h + self.expand_h * 2)


    -- background color available?
    if self.color_bg ~= nil then
        Part.Draw.Graphics.drawRectangle(x, y, w, h, self.color_bg, self.color_border)
    end
end

return layout
