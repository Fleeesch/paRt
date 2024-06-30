local control = {}

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Button
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
control.Button = Part.Control.Control:new()

function control.Button:new(o, parameter, toggle, text, target_value)
    o = o or Part.Control.Control:new(o, parameter)

    setmetatable(o, self)
    self.__index = self

    -- use cursor dimensions
    Part.Cursor.applyCursorToTarget(o)

    -- button toggle state
    o.state = false

    -- button is set / toggle
    o.toggle = toggle

    -- on-value
    o.target_value = target_value

    -- text displayed within button
    o.text = text

    -- use bit mask instead of target value
    o.use_flags = false

    -- font flags
    o.flags = 5
    o.font_flags = ""

    -- trigger bank update with value change
    o.trigger_bank_update = false

    -- actions and their parameters
    o.actions = {}
    o.actions_parameters = {}

    -- use label for calculating the button width
    o.width_from_label = false

    o.functions = {}

    -- default colors
    o.color_bg_off = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.button.off_bg)
    o.color_fg_off = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.button.off_fg)
    o.color_bg_on = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.color.blue)
    o.color_fg_on = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.button.on_fg)
    o.color_border = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.button.border)

    -- add to lists
    if parameter ~= nil then
        table.insert(Part.List.control_button, o)
        table.insert(Part.List.control, o)
    end

    return o
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Button : Set Font Flags
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Button:setFontFlags(flags)
    self.font_flags = flags
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Button : Width from Label
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Button:widthFromLabel()
    self.width_from_label = true
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Button : Is Bank Button
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Button:isBankButton()
    self:triggerBankUpdate()
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Button : Trigger Bank Update
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Button:triggerBankUpdate()
    self.trigger_bank_update = true
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Button : Selection Button
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Button:selectionButton()
    self.color_bg_off = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.button.selection.off_bg)
    self.color_fg_off = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.button.selection.off_fg)
    self.color_bg_on = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.color.blue)
    self.color_fg_on = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.button.selection.on_fg)
    self.color_border = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.button.selection.border)
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Button : Set Color
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Button:setColor(fg, bg, fg_on, bg_on, border)
    -- foreground
    if type(fg) == "table" or fg == nil then
        self.color_fg_off = fg
    end

    -- background
    if type(bg) == "table" or bg == nil then
        self.color_bg_off = bg
    end

    -- foreground on-state
    if type(fg_on) == "table" or fg_on == nil then
        self.color_fg_on = fg_on
    end

    -- background on-state
    if type(bg_on) == "table" or bg_on == nil then
        self.color_bg_on = bg_on
    end

    -- border
    if type(border) == "table" or border == nil then
        self.color_border = border
    end
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Button : Use Flags
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Button:useFlags()
    self.use_flags = true
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Button : Bind Action
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Button:bindAction(action, parameter)
    -- action
    table.insert(self.actions, action)

    -- action parameter
    table.insert(self.actions_parameters, parameter)
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Button : Update State
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Button:updateState()
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
--  Control : Button : callFunctions
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Button:callFunctions()
    if #self.functions > 0 then
        for i, v in pairs(self.functions) do
            self.functions[v]()
        end
    end
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Button : triggerActions
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Button:triggerActions()
    if #self.actions > 0 then
        for i, v in pairs(self.actions) do
            _G[v](self.actions_parameters[i])
        end
    end
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Button : Value Set
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Button:valueSet()
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
--  Control : Button : Value Toggle
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Button:valueToggle()
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
--  Control : Button : Prepare
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Button:prepare()
    self.draw_x = Part.Functions.rescale(self.dim_x, true)
    self.draw_y = Part.Functions.rescale(self.dim_y, false, true)
    self.draw_w = Part.Functions.rescale(self.dim_w)
    self.draw_h = Part.Functions.rescale(self.dim_h)

    Part.Draw.Graphics.setFont(16, self.font_flags)

    if self.width_from_label then
        self.draw_w = Part.Functions.rescale(20) + gfx.measurestr(self.text)
    end

    self:updateState()
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Button : Draw
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Button:draw()
    -- get dimensions
    local x = self.draw_x
    local y = self.draw_y
    local w = self.draw_w
    local h = self.draw_h

    -- mouse sates
    local hover = false
    local click = false
    local action = false

    -- intiate press
    if Part.Gui.Mouse.hoverCheck(self) and Part.Gui.Mouse.Drag.isOff() then
        hover = true

        if Part.Gui.Mouse.leftClick() then
            hover = false
            Part.Gui.Mouse.Drag.on(self)
        end
    end

    -- activation
    if Part.Gui.Mouse.Drag.isTarget(self) then
        click = true

        if Part.Gui.Mouse.leftRelease() and Part.Gui.Mouse.hoverCheck(self) then
            action = true
        end
    end

    -- get colors
    local color_bg = self.color_bg_off
    local color_fg = self.color_fg_off

    if self.state then
        color_bg = self.color_bg_on
        color_fg = self.color_fg_on
    end

    -- hover light
    if hover then
        color_bg = Part.Color.lightenColor(color_bg, Part.Color.Lookup.color_palette.mod.lighten_hover)
        color_fg = Part.Color.lightenColor(color_fg, Part.Color.Lookup.color_palette.mod.lighten_hover)
    end

    -- click light
    if click then
        color_bg = Part.Color.lightenColor(color_bg, Part.Color.Lookup.color_palette.mod.lighten_click)
        color_fg = Part.Color.lightenColor(color_fg, Part.Color.Lookup.color_palette.mod.lighten_click)
    end

    -- draw background
    Part.Draw.Graphics.drawRectangle(x, y, w, h, color_bg, self.color_border)

    -- draw text
    Part.Cursor.setCursorPos(x, y)
    Part.Color.setColor(color_fg, true)
    gfx.drawstr(self.text, self.flags, x + w, y + h)

    -- activation
    if action then
        -- function calls
        if #self.functions > 0 then
            self:callFunctions()
        end

        -- action triggers
        if #self.actions > 0 then
            self:triggerActions()
        end

        -- parameter set / toggle
        if self.parameter ~= nil then
            if self.toggle then
                self:valueToggle()
            else
                self:valueSet()
            end
        end

        -- bank update trigger
        if self.trigger_bank_update then
            Part.Bank.Handler:update(true)
        end
    end

    self:updateState()
end

return control
