local control = {}

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Knob
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
control.Knob = Part.Control.Control:new()

function control.Knob:new(o, parameter)
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

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Knob : Justify Center
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Knob:justCenter()
    self.just_center = true
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Knob : No Value Fill Color
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Knob:noValueFill()
    self.value_fill = 0
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Knob : Bidirectional Value Fill
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Knob:valueFillBi()
    self.value_fill = 2
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Knob : Set Colors
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Knob:setColors(bg, border, knob, knob_border, knob_slot)
    -- background
    if bg ~= nil then
        self.color_bg = bg
    end

    -- border
    if border ~= nil then
        self.color_border = border
    end
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Knob : Prepare
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Knob:prepare()
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

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Knob : Set Drag Origin
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Knob:setDragOrigin()
    self.drag_origin_x = gfx.mouse_x
    self.drag_origin_y = gfx.mouse_y
    self.drag_value = self.parameter:valueToFloat()
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Knob : Draw
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Knob:draw()
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

return control
