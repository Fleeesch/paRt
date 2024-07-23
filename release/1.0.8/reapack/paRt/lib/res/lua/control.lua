-- @version 1.0.8
-- @author Fleeesch
-- @description paRt Theme Adjuster
-- @noIndex



local control = { Button = {}, ButtonBank = {}, Slider = {}, Knob = {}, Marker = {}, Hint = {} }

-- ===============================================================================
--                      Control : Generic
-- ===============================================================================

-- Control
-- -------------------------------------------

control.Control = {
    dim_x = 0,
    dim_y = 0,
    dim_w = 100,
    dim_h = 20,
    draw_x = 0,
    draw_y = 0,
    draw_w = 0,
    draw_h = 0,
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

-- Control : Prepare
-- -------------------------------------------

function control.Control:prepare()

end

-- Control : Value Change
-- -------------------------------------------

function control.Control:valueChange()
    self.value_change = true
end

-- Control : Draw
-- -------------------------------------------

function control.Control:draw()

end

-- Control : Tab Check
-- -------------------------------------------

function control.Control:tabCheck()
    -- check if tab is active (if one has been set)
    if self.tab == nil or self.tab:active() then
        return true
    end

    return false
end

-- Control : Add Layout Setting
-- -------------------------------------------

function control.Control:addLayoutSetting()
end

-- ===============================================================================
--                      Control : Button
-- ===============================================================================


--  Control : Button
-- -------------------------------------------
control.Button.Button = control.Control:new()

function control.Button.Button:new(o, parameter, toggle, text, target_value)
    o = o or control.Control:new(o, parameter)

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

--  Control : Button : Set Font Flags
-- -------------------------------------------

function control.Button.Button:setFontFlags(flags)
    self.font_flags = flags
end

--  Control : Button : Width from Label
-- -------------------------------------------

function control.Button.Button:widthFromLabel()
    self.width_from_label = true
end

--  Control : Button : Is Bank Button
-- -------------------------------------------

function control.Button.Button:isBankButton()
    self:triggerBankUpdate()
end

--  Control : Button : Trigger Bank Update
-- -------------------------------------------

function control.Button.Button:triggerBankUpdate()
    self.trigger_bank_update = true
end

--  Control : Button : Selection Button
-- -------------------------------------------

function control.Button.Button:selectionButton()
    self.color_bg_off = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.button.selection.off_bg)
    self.color_fg_off = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.button.selection.off_fg)
    self.color_bg_on = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.color.blue)
    self.color_fg_on = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.button.selection.on_fg)
    self.color_border = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.button.selection.border)
end

--  Control : Button : Set Color
-- -------------------------------------------

function control.Button.Button:setColor(fg, bg, fg_on, bg_on, border)
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

--  Control : Button : Use Flags
-- -------------------------------------------

function control.Button.Button:useFlags()
    self.use_flags = true
end

--  Control : Button : Bind Action
-- -------------------------------------------

function control.Button.Button:bindAction(action, parameter)
    -- action
    table.insert(self.actions, action)

    -- action parameter
    table.insert(self.actions_parameters, parameter)
end

--  Control : Button : Update State
-- -------------------------------------------

function control.Button.Button:updateState()
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

--  Control : Button : callFunctions
-- -------------------------------------------

function control.Button.Button:callFunctions()
    if #self.functions > 0 then
        for i, v in pairs(self.functions) do
            self.functions[v]()
        end
    end
end

--  Control : Button : triggerActions
-- -------------------------------------------

function control.Button.Button:triggerActions()
    if #self.actions > 0 then
        for i, v in pairs(self.actions) do
            _G[v](self.actions_parameters[i])
        end
    end
end

--  Control : Button : Value Set
-- -------------------------------------------

function control.Button.Button:valueSet()
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

--  Control : Button : Value Toggle
-- -------------------------------------------

function control.Button.Button:valueToggle()
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

--  Control : Button : Prepare
-- -------------------------------------------

function control.Button.Button:prepare()
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

--  Control : Button : Draw
-- -------------------------------------------

function control.Button.Button:draw()
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

-- ===============================================================================
--                      Control : Button : Bank
-- ===============================================================================


--  Control : Bank Button
-- -------------------------------------------

control.ButtonBank.ButtonBank = control.Button.Button:new()

function control.ButtonBank.ButtonBank:new(o, parameter)
    o = o or control.Button.Button:new(o, parameter, 1, "", 1)

    setmetatable(o, self)
    self.__index = self

    o.color_bg_off = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.button.bank.off_bg)
    o.color_fg_off = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.button.bank.off_fg)
    o.color_bg_on = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.color.cyan)
    o.color_fg_on = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.button.bank.on_fg)
    o.color_border_off = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.button.bank.off_border)
    o.color_border_on = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.button.bank.on_border)

    o.text = "B"

    o.trigger_bank_update = true

    return o
end

--  Control : Button : Prepare
-- -------------------------------------------

function control.ButtonBank.ButtonBank:prepare()
    local w = 14
    local h = 14

    self.draw_w = Part.Functions.rescale(w)
    self.draw_h = Part.Functions.rescale(h)

    self.draw_x = Part.Functions.rescale(self.dim_x + (self.dim_w - w) / 2, true)
    self.draw_y = Part.Functions.rescale(self.dim_y + (self.dim_h - h) / 2, false, true)

    Part.Draw.Graphics.setFont(16, self.font_flags)

    if self.width_from_label then
        self.draw_w = Part.Functions.rescale(20) + gfx.measurestr(self.text)
    end

    self:updateState()
end

--  Control : Button : Draw
-- -------------------------------------------

function control.ButtonBank.ButtonBank:draw()
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
    local color_border = self.color_border_off

    if self.state then
        color_bg = self.color_bg_on
        color_fg = self.color_fg_on
        color_border = self.color_border_on
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
    Part.Draw.Graphics.drawRectangle(x, y, w, h, color_bg, color_border)

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

-- ===============================================================================
--                      Control : Marker
-- ===============================================================================


--  Control : Marker
-- -------------------------------------------
control.Marker.Marker = control.Control:new()

function control.Marker.Marker:new(o, parameter, toggle, target_value)
    o = o or control.Control:new(o, parameter)
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

--  Control : Marker : Use Flags
-- -------------------------------------------

function control.Marker.Marker:useFlags()
    self.use_flags = true
end

--  Control : Marker : Bind Action
-- -------------------------------------------

function control.Marker.Marker:bindAction(action, parameter)
    -- action
    table.insert(self.actions, action)

    -- action parameter
    table.insert(self.actions_parameters, parameter)
end

--  Control : Marker : Update State
-- -------------------------------------------

function control.Marker.Marker:updateState()
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

--  Control : Marker : Value Set
-- -------------------------------------------

function control.Marker.Marker:valueSet()
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

--  Control : Marker : Value Toggle
-- -------------------------------------------

function control.Marker.Marker:valueToggle()
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

--  Control : Marker : Copy State
-- -------------------------------------------

function control.Marker.Marker:copyState(state)
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

--  Control : Marker : Activate
-- -------------------------------------------

function control.Marker.Marker:activate()
    -- decide between toggle and set
    if self.parameter ~= nil then
        if self.toggle then
            self:valueToggle()
        else
            self:valueSet()
        end
    end
end

--  Control : Marker : Prepare
-- -------------------------------------------

function control.Marker.Marker:prepare()
    self.draw_x = Part.Functions.rescale(self.dim_x, true)
    self.draw_y = Part.Functions.rescale(self.dim_y, false, true)
    self.draw_w = Part.Functions.rescale(self.dim_w)
    self.draw_h = Part.Functions.rescale(self.dim_h)

    self.draw_symbol_r = math.floor(Part.Functions.rescale(self.size) / 3)
    self.draw_symbol_x = math.floor(self.draw_x + self.draw_w / 2)
    self.draw_symbol_y = math.floor(self.draw_y + self.draw_h / 2)

    self.draw_symbol_r_inner = self.draw_symbol_r - Part.Draw.Graphics.border
end

--  Control : Marker : Draw
-- -------------------------------------------

function control.Marker.Marker:draw()
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

--  Control : Marker : Draw Symbol
-- -------------------------------------------

function control.Marker.Marker:drawSymbol(hover)
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

-- ===============================================================================
--                      Control : Slider
-- ===============================================================================


--  Control : Slider
-- -------------------------------------------
control.Slider.Slider = control.Control:new()

function control.Slider.Slider:new(o, parameter)
    o = o or control.Control:new(o, parameter)
    setmetatable(o, self)
    self.__index = self

    -- transfer cursor dimensions
    Part.Cursor.applyCursorToTarget(o)

    -- float value of slider
    o.value = 0

    -- knob size
    o.knob_size = 14
    o.draw_k = 0

    -- mouse offset
    o.drag_origin_x = 0
    o.drag_origin_y = 0
    o.drag_offset_x = 0
    o.drag_offset_y = 0

    -- color finder mode
    o.color_finder = false

    -- color table used for color finder
    o.color_table = {}

    -- knob coloring when using color finder
    o.color_picker = 0

    -- default colors
    o.color_bg = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.slider.bg)
    o.color_border = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.slider.border)
    o.color_gradient_border = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.slider.gradient_border)
    o.color_knob = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.slider.knob)
    o.color_knob_border = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.slider.knob_border)
    o.color_knob_slot = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.slider.slot)
    o.color_value_fill = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.color.blue)
    o.color_slot_default = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.slider.slot_default)

    if o.color_value_fill[4] == nil then
        o.color_value_fill[4] = 0.25
    else
        o.color_value_fill[4] = o.color_value_fill[4] * 0.25
    end

    -- compression, vertical padding to make the slider slimmer
    o.compression = 2

    -- value fill mode (0=off, 1=linear,2=bidirectional)
    o.value_fill = 1

    o.slider_leftmost = 0
    o.slider_rightmost = 0
    o.slider_space = 0

    -- slow drag state
    o.drag_slow = false

    -- register in lookup lists
    table.insert(Part.List.control, o)
    table.insert(Part.List.control_sliders, o)

    return o
end

--  Control : Slider : No Value Fill Color
-- -------------------------------------------

function control.Slider.Slider:noValueFill()
    self.value_fill = 0
end

--  Control : Slider : Bidirectional Value Fill
-- -----------------------------------------------

function control.Slider.Slider:valueFillBi()
    self.value_fill = 2
end

--  Control : Slider : Set Compression
-- -------------------------------------------

function control.Slider.Slider:setCompression(val)
    self.compression = val or 0
end

--  Control : Slider : Set Colors
-- -------------------------------------------

function control.Slider.Slider:setColors(bg, border, knob, knob_border, knob_slot)
    -- background
    if bg ~= nil then
        self.color_bg = bg
    end

    -- border
    if border ~= nil then
        self.color_border = border
    end

    -- knob
    if knob ~= nil then
        self.color_knob = knob
    end

    -- knob border
    if knob_border ~= nil then
        self.color_knob_border = knob_border
    end

    -- knob slot
    if knob_slot ~= nil then
        self.color_knob_slot = knob_slot
    end
end

--  Control : Slider : Color Finder
-- -------------------------------------------

function control.Slider.Slider:colorFinder(color_picker, color_table)
    -- mark color finder as active, store data
    self.color_finder = true
    self.color_table = color_table
    self.color_picker = color_picker
end

--  Control : Slider : Prepare
-- -------------------------------------------

function control.Slider.Slider:prepare()
    -- calculate dimensions
    self.draw_x = Part.Functions.rescale(self.dim_x, true)
    self.draw_y = Part.Functions.rescale(self.dim_y + self.compression, false, true)
    self.draw_w = Part.Functions.rescale(self.dim_w)
    self.draw_h = Part.Functions.rescale(self.dim_h - self.compression * 2)

    self.draw_inner_x = self.draw_x + Part.Draw.Graphics.border
    self.draw_inner_y = self.draw_y + Part.Draw.Graphics.border
    self.draw_inner_w = self.draw_w - Part.Draw.Graphics.border * 2
    self.draw_inner_h = self.draw_h - Part.Draw.Graphics.border * 2

    self.draw_k = Part.Functions.rescale(self.knob_size)
    self.draw_k2 = Part.Functions.rescale(self.knob_size / 2)
    self.draw_x_center = self.draw_x + self.draw_w / 2

    -- knob value range
    self.knob_leftmost = self.draw_x + self.draw_k2
    self.knob_rightmost = self.draw_x + self.draw_w - self.draw_k2
    self.knob_space = self.knob_rightmost - self.knob_leftmost

    local def_val = self.parameter:defaultValueToFloat(true)
    self.draw_def_slot_x = math.floor(Part.Functions.map(def_val, 0, 1, self.knob_leftmost, self.knob_rightmost) + 0.5)
end

--  Control : Slider : Set Drag Origin
-- -------------------------------------------

function control.Slider.Slider:setDragOrigin(knob_x, knob_y, knob_w, knob_h)
    self.drag_origin_x = gfx.mouse_x
    self.drag_origin_y = gfx.mouse_y
    self.drag_offset_x = gfx.mouse_x - knob_x - math.floor(knob_w / 2 + 0.5)
    self.drag_offset_y = gfx.mouse_y - knob_y - math.floor(knob_h / 2 + 0.5)
end

--  Control : Slider : Calculate Knob Position
-- -----------------------------------------------

function control.Slider.Slider:calculateKnobPosition(val)
    return math.floor(Part.Functions.map(val, 0, 1, self.knob_leftmost, self.knob_rightmost) -
        self.draw_k / 2 + 0.5)
end

--  Control : Slider : Draw
-- -------------------------------------------

function control.Slider.Slider:draw()
    -- dimensions
    local x = self.draw_x
    local y = self.draw_y
    local w = self.draw_w
    local h = self.draw_h
    local inner_x = self.draw_inner_x
    local inner_y = self.draw_inner_y
    local inner_w = self.draw_inner_w
    local inner_h = self.draw_inner_h

    local k = self.draw_k
    local k2 = self.draw_k2

    -- calculate knob x-position
    local float_val = self.parameter:valueToFloat(nil, true)
    local knob_x = self:calculateKnobPosition(float_val)

    local color_bg = self.color_bg
    local color_border = self.color_border
    local color_knob_bg = self.color_knob
    local color_knob_border = self.color_knob_border
    local color_fill = self.color_value_fill

    -- mouse hover detection
    local mouse_over = Part.Gui.Mouse.hoverCheck(self)
    local mouse_over_knob = Part.Gui.Mouse.mouseInRect(knob_x, y, k, h)

    -- mover hover color change
    if (mouse_over and Part.Gui.Mouse.Drag.isOff()) or Part.Gui.Mouse.Drag.isTarget(self) then
        color_bg = Part.Color.lightenColor(color_bg, Part.Color.Lookup.color_palette.mod.lighten_hover)
        color_knob_bg = Part.Color.lightenColor(color_knob_bg, Part.Color.Lookup.color_palette.mod.lighten_hover)
        color_fill = Part.Color.lightenColor(color_fill, Part.Color.Lookup.color_palette.mod.lighten_hover)
    end

    -- initiate drag
    if Part.Gui.Mouse.Drag.isOff() then
        if mouse_over then
            -- parameter reset
            if Part.Gui.Mouse.rightClick() then
                self.parameter:reset()
            end

            local modstate = Part.Gui.Mouse.modControl()

            -- start drag with or without modifier
            if mouse_over_knob or modstate then
                if Part.Gui.Mouse.leftClick() then
                    Part.Gui.Mouse.Drag.on(self, "slider body")
                    self:setDragOrigin(knob_x, y, k, h)
                    self.drag_slow = modstate
                end
            else
                if Part.Gui.Mouse.leftClick() then
                    Part.Gui.Mouse.Drag.on(self, "slider knob")
                    knob_x = gfx.mouse_x
                    self:setDragOrigin(knob_x - k2, y, k, h)
                    self.drag_slow = false
                end
            end
        end
    end

    -- background
    if not self.color_finder then
        Part.Draw.Graphics.drawRectangle(x, y, w, h, color_bg, color_border)
    else
        Part.Draw.Graphics.drawGradient(x, y, w, h, 1, self.color_table, self.color_gradient_border)
    end

    -- drag action
    if Part.Gui.Mouse.Drag.isTarget(self) then
        local mouse_x
        local modstate = Part.Gui.Mouse.modControl()

        -- rebase drag origin on modifier state change
        if self.drag_slow ~= modstate then
            self:setDragOrigin(knob_x, y, k, h)
        end

        self.drag_slow = modstate

        -- slow drag / normal drag
        if self.drag_slow then
            mouse_x = self.drag_origin_x + (gfx.mouse_x - self.drag_origin_x) / 10 - self.drag_offset_x
        else
            mouse_x = gfx.mouse_x - self.drag_offset_x
        end

        -- calculate new knob position
        local float = Part.Functions.map(mouse_x, self.knob_leftmost, self.knob_rightmost, 0, 1)
        float = Part.Functions.cap(float, 0, 1)
        self.parameter:floatToValue(float, true)
        float = self.parameter:valueToFloat(nil, true)
        knob_x = self:calculateKnobPosition(float)
    end


    -- value fill
    if self.value_fill ~= 0 then
        local fill_x
        local fill_w

        local fill_y = y + Part.Draw.Graphics.border
        local fill_h = h - Part.Draw.Graphics.border * 2

        -- left-to-right fill
        if self.value_fill == 1 then
            fill_x = x + Part.Draw.Graphics.border
            fill_w = knob_x - fill_x
            Part.Draw.Graphics.drawRectangle(fill_x, fill_y, fill_w, fill_h, color_fill)
        end

        -- bidirectional fill
        if self.value_fill == 2 then
            if knob_x + k2 <= self.draw_x_center then
                fill_x = knob_x
                fill_w = self.draw_x_center - knob_x + Part.Draw.Graphics.border
            else
                fill_x = self.draw_x_center
                fill_w = knob_x - self.draw_x_center
            end
        end

        Part.Draw.Graphics.drawRectangle(fill_x, fill_y, fill_w, fill_h, color_fill)
    end

    -- knob
    if not self.color_finder then
        Part.Draw.Graphics.drawRectangle(self.draw_def_slot_x, y + Part.Draw.Graphics.border, Part.Draw.Graphics.border,
            h - Part.Draw.Graphics.border * 2, self.color_slot_default)
        Part.Draw.Graphics.drawRectangle(knob_x, y, k, h, color_knob_bg, color_knob_border)
    else
        gfx.x = Part.Functions.map(float_val, 0, 1, self.draw_inner_x, self.draw_x + self.draw_inner_w)

        gfx.y = y + h / 2
        local r, g, b = gfx.getpixel()

        local knob_color = { r, g, b, 1 }

        for i = 1, #knob_color - 1 do
            knob_color[i] = math.min(math.floor(knob_color[i] * 255), 255)
        end

        local m = 0.5
        local a = 0.1

        gfx.muladdrect(inner_x, inner_y, inner_w, inner_h, m, m, m, 1, a, a, a, 0)

        Part.Draw.Graphics.drawRectangle(self.draw_def_slot_x, y + Part.Draw.Graphics.border, Part.Draw.Graphics.border,
            h - Part.Draw.Graphics.border * 2, self.color_slot_default)
        Part.Draw.Graphics.drawRectangle(knob_x, y, k, h, knob_color, color_knob_border)
    end
end

-- ===============================================================================
--                      Control : Knob
-- ===============================================================================


--  Control : Knob
-- -------------------------------------------
control.Knob.Knob = control.Control:new()

function control.Knob.Knob:new(o, parameter)
    o = o or Part.Control.Control:new(o, parameter)
    setmetatable(o, self)
    self.__index = self

    -- transfer cursor dimensions
    Part.Cursor.applyCursorToTarget(o)

    -- float value of slider
    o.value = 0

    -- knob size
    o.knob_size = 16
    o.draw_k = 0
    o.drag_value = 0

    -- rotation value
    o.rotation = 0

    -- center
    o.just_center = false

    -- mouse offset
    o.drag_origin_x = 0
    o.drag_origin_y = 0

    -- default colors
    o.color_bg = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.knob.bg)
    o.color_border = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.knob.border)
    o.color_default = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.knob.default)

    -- slow drag state
    o.drag_slow = false

    -- value fill mode (0=off, 1=linear,2=bidirectional)
    o.value_fill = 1

    -- register in lookup lists
    table.insert(Part.List.control, o)
    table.insert(Part.List.control_knobs, o)

    return o
end

--  Control : Knob : Justify Center
-- -------------------------------------------

function control.Knob.Knob:justCenter()
    self.just_center = true
end

--  Control : Knob : No Value Fill Color
-- -------------------------------------------

function control.Knob.Knob:noValueFill()
    self.value_fill = 0
end

--  Control : Knob : Bidirectional Value Fill
-- -------------------------------------------

function control.Knob.Knob:valueFillBi()
    self.value_fill = 2
end

--  Control : Knob : Set Colors
-- -------------------------------------------

function control.Knob.Knob:setColors(bg, border, knob, knob_border, knob_slot)
    -- background
    if bg ~= nil then
        self.color_bg = bg
    end

    -- border
    if border ~= nil then
        self.color_border = border
    end
end

--  Control : Knob : Prepare
-- -------------------------------------------

function control.Knob.Knob:prepare()
    -- calculate dimensions
    self.draw_x = Part.Functions.rescale(self.dim_x, true)
    self.draw_y = Part.Functions.rescale(self.dim_y, false, true)
    self.draw_w = Part.Functions.rescale(self.dim_w)
    self.draw_h = Part.Functions.rescale(self.dim_h)


    self.draw_k = Part.Functions.rescale(self.knob_size / 2)
    self.draw_k_2 = self.draw_k * 2

    if self.just_center then
        self.draw_x = self.draw_x + math.floor((self.draw_w - self.draw_k_2) / 2)
        self.draw_y = self.draw_y + math.floor((self.draw_h - self.draw_k_2) / 2)
    end

    self.def_rotation = Part.Functions.map(self.parameter:defaultValueToFloat(true), 0, 1, -2.5, 2.5)
end

--  Control : Knob : Set Drag Origin
-- -------------------------------------------

function control.Knob.Knob:setDragOrigin()
    self.drag_origin_x = gfx.mouse_x
    self.drag_origin_y = gfx.mouse_y
    self.drag_value = self.parameter:valueToFloat()
end

--  Control : Knob : Draw
-- -------------------------------------------

function control.Knob.Knob:draw()
    -- dimensions
    local x = self.draw_x
    local y = self.draw_y
    local w = self.draw_w
    local h = self.draw_h
    local k = self.draw_k
    local k_2 = self.draw_k_2

    -- colors
    local color_bg = self.color_bg
    local color_border = self.color_border
    local line_alpha = 1

    -- hover / initial drag
    if Part.Gui.Mouse.Drag.isOff() and Part.Gui.Mouse.hoverCheck(self) then
        color_bg = Part.Color.lightenColor(color_bg, Part.Color.Lookup.color_palette.mod.lighten_hover)

        if Part.Gui.Mouse.leftClick() then
            Part.Gui.Mouse.Drag.on(self)
            self:setDragOrigin()
        end

        if Part.Gui.Mouse.rightClick() then
            self.parameter:reset()
        end
    end

    -- modifier slow drag
    if self.drag_slow ~= Part.Gui.Mouse.modControl() then
        self:setDragOrigin()
        self.drag_slow = Part.Gui.Mouse.modControl()
    end

    -- active drag
    if Part.Gui.Mouse.Drag.isTarget(self) then
        color_bg = Part.Color.lightenColor(color_bg, Part.Color.Lookup.color_palette.mod.lighten_hover)

        local mod_factor = 100

        if Part.Gui.Mouse.modControl() then
            mod_factor = 800
        end

        local val = (gfx.mouse_y - self.drag_origin_y) * -1 / mod_factor
        self.parameter:floatToValue(self.drag_value + val)
    end

    -- roation value
    local rotation = Part.Functions.map(self.parameter:valueToFloat(), 0, 1, -2.5, 2.5)
    local pos = self.parameter:valueToFloat()

    local size = Part.Draw.Sprites.knob_image_size

    -- knob background
    Part.Color.setColor(color_border, true)
    gfx.circle(x + k, y + k, k, true, true)
    Part.Color.setColor(color_bg, true)
    gfx.circle(x + k, y + k, k - Part.Draw.Graphics.border, true, true)

    -- knob fill
    if self.value_fill > 0 then
        local knob_size = Part.Draw.Sprites.knob_val_size
        local knob_pos = math.floor(pos * Part.Draw.Sprites.knob_sprites + 0.5) * knob_size

        if self.value_fill == 1 then
            gfx.blit(Part.Draw.Sprites.slot_knob_val_linear, 1, 0, 0, knob_pos, knob_size, knob_size, x, y, k_2, k_2)
        end

        if self.value_fill == 2 then
            gfx.blit(Part.Draw.Sprites.slot_knob_val_bi, 1, 0, 0, knob_pos, knob_size, knob_size, x, y, k_2, k_2)
        end
    end

    -- knob line
    gfx.a = line_alpha
    Part.Cursor.setCursorPos(x, y)
    gfx.blit(Part.Draw.Sprites.slot_knob_line, 1, rotation)
end

-- ===============================================================================
--                      Control : Hint
-- ===============================================================================


--  Control : Hint
-- -------------------------------------------
control.Hint.Hint = control.Control:new()

function control.Hint.Hint:new(o, text, linked_element, is_parameter_hint, use_cursor)
    o = o or control.Control:new(o, nil, true)

    setmetatable(o, self)
    self.__index = self

    -- hint message
    o.text = text

    -- functions
    o.functions = {}

    -- linked element
    o.linked_element = linked_element or Part.Draw.Elements.lastElement()

    -- use cursor positions for hover detection
    o.use_cursor = use_cursor or false

    Part.Cursor.applyCursorToTarget(o)

    -- delay before hint hover is recognized
    o.show_delay = Part.Global.hint_delay

    -- fade-in time for hint
    o.show_time = o.show_delay + Part.Global.hint_fade

    -- show hint when counter exceeds delay
    o.show_counter = 0

    -- text flags
    o.flags = 0

    -- extra padding
    o.pad = 4

    -- show hint flag
    o.show_hint = false

    -- fade factor
    o.display_factor = 0

    -- optional symbol
    o.draw_symbol = false

    -- alpha level
    o.alpha = 1

    o.symbol_rotation = 1.5708

    -- default colors
    o.color_bg = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.hint.bg)
    o.color_fg = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.hint.fg)
    o.color_border = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.hint.border)
    o.color_shadow = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.hint.shadow)
    o.color_hover = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.hint.hover)
    o.color_symbol = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.color.cyan)

    o.use_alt_color = false

    -- add to lists
    table.insert(Part.List.control, o)
    table.insert(Part.List.control_hint, o)

    if is_parameter_hint then
        o.pad = 0
        o.draw_symbol = true
    end

    return o
end

--  Control : Hint : Add Padding
-- -------------------------------------------

function control.Hint.Hint:setPadding(pad)
    self.pad = math.max(pad, 0)
end

--  Control : Hint : Calculate Display factor
-- ----------------------------------------------

function control.Hint.Hint:displayFactor()
    return (self.show_counter - self.show_delay) / (self.show_time - self.show_delay)
end

--  Control : Prepare
-- -------------------------------------------

function control.Hint.Hint:prepare()
    self.draw_x = Part.Functions.rescale(self.dim_x, true)
    self.draw_y = Part.Functions.rescale(self.dim_y, false, true)
    self.draw_w = Part.Functions.rescale(self.dim_w)
    self.draw_h = Part.Functions.rescale(self.dim_h)
    self.draw_p = Part.Functions.rescale(self.pad)

    self.draw_link_x = Part.Functions.rescale(self.linked_element.dim_x, true)
    self.draw_link_y = Part.Functions.rescale(self.linked_element.dim_y, false, true)
    self.draw_link_w = Part.Functions.rescale(self.linked_element.dim_w)
    self.draw_link_h = Part.Functions.rescale(self.linked_element.dim_h)

    self.draw_symbol_size = Part.Functions.rescale(2)
end

--  Control : Hint : Draw
-- -------------------------------------------

function control.Hint.Hint:draw()
    -- get dimensions
    local link_x = self.draw_link_x
    local link_y = self.draw_link_y
    local link_w = self.draw_link_w
    local link_h = self.draw_link_h

    local x, y, w, h


    if self.use_cursor then
        x = self.draw_x
        y = self.draw_y
        w = self.draw_w
        h = self.draw_h
    else
        x = link_x
        y = link_y
        w = link_w
        h = link_h
    end


    -- hover state
    local hover = false

    -- hover active?
    if Part.Gui.Mouse.hoverCheck(nil, x, y, w, h) then
        if Part.Gui.Mouse.Drag.isOff() then
            hover = true


            -- increment counter
            if self.show_counter < self.show_time then
                self.show_counter = self.show_counter + 1

                if self.show_counter >= self.show_delay then
                    Part.Gui.Hint.hint_message:setSource(self)
                end
            end
        end

        -- no hovering?
    else
        -- decrement or reset counter
        if self.show_counter >= self.show_delay then
            self.show_counter = self.show_counter - 1
        else
            self.show_counter = 0
        end

        -- clear as active hint
        if Part.Gui.Hint.hint_message.source == self then
            Part.Gui.Hint.hint_message:clear()
        end
    end

    -- symbol
    if self.draw_symbol then
        Part.Draw.Graphics.drawRectangle(x - self.draw_symbol_size, y, self.draw_symbol_size, h, Part.Color.Lookup.color_palette.hint.symbol)
    end

    -- custom overlay drawing
    if hover then
        local p = self.draw_p
        local f = Part.Functions.cap((self.show_counter / self.show_delay) - 0.01 * 1.01, 0, 1)
        local r = self.color_hover[1] * f + 1
        local g = self.color_hover[2] * f + 1
        local b = self.color_hover[3] * f + 1
        gfx.muladdrect(link_x - p, link_y - p, link_w + p * 2, link_h + p * 2, r, g, b, 1, 0, 0, 0, 0)
    end
end

return control
