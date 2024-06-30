local control = {}

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Slider
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
control.Slider = Part.Control.Control:new()

function control.Slider:new(o, parameter)
    o = o or Part.Control.Control:new(o, parameter)
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

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Slider : No Value Fill Color
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Slider:noValueFill()
    self.value_fill = 0
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Slider : Bidirectional Value Fill
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Slider:valueFillBi()
    self.value_fill = 2
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Slider : Set Compression
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Slider:setCompression(val)
    self.compression = val or 0
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Slider : Set Colors
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Slider:setColors(bg, border, knob, knob_border, knob_slot)
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

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Slider : Color Finder
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Slider:colorFinder(color_picker, color_table)
    -- mark color finder as active, store data
    self.color_finder = true
    self.color_table = color_table
    self.color_picker = color_picker
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Slider : Prepare
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Slider:prepare()
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

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Slider : Set Drag Origin
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Slider:setDragOrigin(knob_x, knob_y, knob_w, knob_h)
    self.drag_origin_x = gfx.mouse_x
    self.drag_origin_y = gfx.mouse_y
    self.drag_offset_x = gfx.mouse_x - knob_x - math.floor(knob_w / 2 + 0.5)
    self.drag_offset_y = gfx.mouse_y - knob_y - math.floor(knob_h / 2 + 0.5)
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Slider : Calculate Knob Position
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Slider:calculateKnobPosition(val)
    return math.floor(Part.Functions.map(val, 0, 1, self.knob_leftmost, self.knob_rightmost) -
        self.draw_k / 2 + 0.5)
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Slider : Draw
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Slider:draw()
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

return control
