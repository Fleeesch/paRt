local control = {}

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Marker
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
control.Marker = Part.Control.Control:new()

function control.Marker:new(o, parameter, toggle, target_value)
    o = o or Part.Control.Control:new(o, parameter)
    setmetatable(o, self)
    self.__index = self

    -- use cursor dimensions
    Part.Cursor.applyCursorToTarget(o)

    -- activation state
    o.state = false

    -- toggle mode
    o.toggle = toggle

    -- target value
    o.target_value = target_value

    -- size of symbol
    o.size = 12

    -- use bit mask instead of target value
    o.use_flags = false

    -- actions and their parameters
    o.actions = {}
    o.actions_parameters = {}

    o.label = nil
    o.just_right = false

    -- colors
    o.color_border = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.marker.border)
    o.color_bg_off = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.marker.bg_off)
    o.color_bg_on = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.color.blue)

    -- add to lists
    table.insert(Part.List.control, o)
    table.insert(Part.List.control_marker, o)

    return o
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Marker : Use Flags
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Marker:useFlags()
    self.use_flags = true
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Marker : Bind Action
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Marker:bindAction(action, parameter)
    -- action
    table.insert(self.actions, action)

    -- action parameter
    table.insert(self.actions_parameters, parameter)
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Marker : Update State
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Marker:updateState()
    -- don't do anything if there's no parameter
    if self.parameter == nil then
        return
    end

    -- > use direct values
    if not self.use_flags then
        -- check if value matches
        if self.parameter:getValue() == self.target_value then
            self.state = true
        else
            self.state = false
        end

        -- > use bit flags
    else
        -- check if flag is active
        if self.parameter:getValue() & (1 << self.target_value) ~= 0 then
            self.state = true
        else
            self.state = false
        end
    end
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Marker : Value Set
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Marker:valueSet()
    -- direct value set
    if not self.use_flags then
        self.parameter:setValue(self.target_value)
    end

    -- bit flags
    if self.use_flags then
        local set_value = self.parameter:getValue() | (1 << (self.target_value))
        self.parameter:setValue(set_value)
    end
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Marker : Value Toggle
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Marker:valueToggle()
    -- value toggle
    if not self.use_flags then
        if self.parameter:getValue() == self.target_value then
            self.parameter:setValue(self.parameter.value_min)
        else
            self.parameter:setValue(self.target_value)
        end
    end

    -- bit flag toggle
    if self.use_flags then
        if self.parameter:getValue() & (1 << self.target_value) == 0 then
            local set_value = self.parameter:getValue() | (1 << (self.target_value))
            self.parameter:setValue(set_value)
        else
            local set_value = self.parameter:getValue() & ~(1 << (self.target_value))
            self.parameter:setValue(set_value)
        end
    end
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Marker : Copy State
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Marker:copyState(state)
    -- direct copy
    if not self.use_flags then
        if not state then
            self.parameter:setValue(self.parameter.value_min)
        else
            self.parameter:setValue(self.target_value)
        end
    end

    -- bit flag copy
    if self.use_flags then
        if state then
            local set_value = self.parameter:getValue() | (1 << (self.target_value))
            self.parameter:setValue(set_value)
        else
            local set_value = self.parameter:getValue() & ~(1 << (self.target_value))
            self.parameter:setValue(set_value)
        end
    end
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Marker : Activate
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Marker:activate()
    -- decide between toggle and set
    if self.parameter ~= nil then
        if self.toggle then
            self:valueToggle()
        else
            self:valueSet()
        end
    end
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Marker : Prepare
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Marker:prepare()
    self.draw_x = Part.Functions.rescale(self.dim_x, true)
    self.draw_y = Part.Functions.rescale(self.dim_y, false, true)
    self.draw_w = Part.Functions.rescale(self.dim_w)
    self.draw_h = Part.Functions.rescale(self.dim_h)

    self.draw_symbol_r = math.floor(Part.Functions.rescale(self.size) / 3)
    self.draw_symbol_x = math.floor(self.draw_x + self.draw_w / 2)
    self.draw_symbol_y = math.floor(self.draw_y + self.draw_h / 2)

    self.draw_symbol_r_inner = self.draw_symbol_r - Part.Draw.Graphics.border
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Marker : Draw
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Marker:draw()
    -- get dimensions
    local x = self.draw_x
    local y = self.draw_y
    local w = self.draw_w
    local h = self.draw_h


    -- hvoer flag
    local hover = Part.Gui.Mouse.hoverCheck(self)

    -- get button state
    self:updateState()

    -- initial trigger
    if Part.Gui.Mouse.Drag.isOff() then
        if hover and Part.Gui.Mouse.leftClick() then
            self:activate()
            self:updateState()
            Part.Gui.Mouse.Drag.on(self, "marker " .. tostring(self.state))
        end
    else
        -- marker state copy when drag is already going
        if hover then
            -- copy marker on state
            if string.find(Part.Gui.Mouse.Drag.getInfo(), "marker true") then
                self:copyState(true)
            end

            -- copy marker off state
            if string.find(Part.Gui.Mouse.Drag.getInfo(), "marker false") then
                self:copyState(false)
            end
        end
    end

    local hover_draw = hover and (Part.Gui.Mouse.Drag.isOff() or Part.Gui.Mouse.Drag.isTarget(self))

    -- draw marker
    self:drawSymbol(hover_draw)
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Marker : Draw Symbol
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Marker:drawSymbol(hover)
    -- get dimensions
    local r = self.draw_symbol_r
    local x = self.draw_symbol_x
    local y = self.draw_symbol_y

    -- border
    Part.Color.setColor(self.color_border)
    gfx.circle(x, y, r, true, true)

    -- fill color
    local color_fill

    if not self.state then
        color_fill = self.color_bg_off
    else
        color_fill = self.color_bg_on
    end

    -- hover lightening
    if hover then
        color_fill = Part.Color.lightenColor(color_fill, Part.Color.Lookup.color_palette.mod.lighten_hover)
    end


    -- fill
    Part.Color.setColor(color_fill, true)
    r = self.draw_symbol_r_inner
    gfx.circle(x, y, r, true, true)
end

return control
