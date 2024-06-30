local layout = {}

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Layout
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

layout.LayoutElement = {
    dim_x = 0,
    dim_y = 0,
    dim_w = 100,
    dim_h = 20,
    value = 0
}

function layout.LayoutElement:new(o)

    o = o or {}
    setmetatable(o, self)
    self.__index = self

    -- optionally store tab
    o.tab = Part.Tab.Entry.getRecentTab() or nil

    o.autocenter_position = true

    -- set as recently created element
    Part.Draw.Elements.setLastElement(o)

    return o
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Layout : Draw
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function layout.LayoutElement:draw()

end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Layout : Tab Check
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function layout.LayoutElement:tabCheck()

    if self.tab == nil or self.tab:active() then
        -- tab is active
        return true
    end
    -- tab is inactive
    return false
end

return layout