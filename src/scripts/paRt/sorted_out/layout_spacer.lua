local layout = {}

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Spacer
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

layout.Spacer = Part.Layout.LayoutElement:new()

function layout.Spacer:new(o,colspan,ignore_cols)
    o = o or Part.Layout.LayoutElement:new(o)
    setmetatable(o, self)
    self.__index = self

    Part.Cursor.applyCursorToTarget(o)

    o.is_spacer = true

    o.colspan = colspan or 0
    o.ignore_cols = ignore_cols or false

    o.color_bg = Part.Color.Lookup.color_palette.group.spacer

    table.insert(Part.List.layout_spacer, o)
    return o
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Image : Draw
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function layout.Spacer:draw()
    local x = Part.Functions.rescale(self.dim_x)
    local y = Part.Functions.rescale(self.dim_y)
    local w = Part.Functions.rescale(self.dim_w)
    local h = Part.Functions.rescale(self.dim_h / 2)

    y = math.floor(y + h/2)

    Part.Draw.Graphics.drawRectangle(x, y, w, Part.Draw.Graphics.border, self.color_bg)
end

return layout