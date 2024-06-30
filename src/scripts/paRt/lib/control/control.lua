local control = {}

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Control
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

control.Control = {
    dim_x = 0,
    dim_y = 0,
    dim_w = 100,
    dim_h = 20,
    draw_x=0,
    draw_y=0,
    draw_w=0,
    draw_h=0,
    value = 0
}

function control.Control:new(o, parameter, ignore_element)

    o = o or {}
    setmetatable(o, self)
    self.__index = self

    -- optional control parmeter
    o.parameter = parameter

    -- recent tab during creation 
    o.tab = Part.Tab.Entry.getRecentTab() or nil

    o.value_change = false

    local ignore = ignore_element or false

    -- register as recently created element
    if not ignore then
        Part.Draw.Elements.setLastElement(o)
    end

    return o
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Control : Prepare
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Control:prepare()

end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Control : Value Change
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Control:valueChange()
    self.value_change = true
end

-- - - - - - - - - - -

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Control : Draw
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Control:draw()

end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Control : Tab Check
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Control:tabCheck()

    -- check if tab is active (if one has been set)
    if self.tab == nil or self.tab:active() then
        return true
    end

    return false
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Control : Add Layout Setting
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Control:addLayoutSetting()
end

return control