local control = {}

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Bank Button
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

control.ButtonBank = Part.Control.Button.Button:new()

function control.ButtonBank:new(o, parameter)
    o = o or Part.Control.Button.Button:new(o, parameter, 1, "", 1)

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

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Button : Prepare
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.ButtonBank:prepare()

    local w = 14
    local h = 14

    self.draw_w = Part.Functions.rescale(w)
    self.draw_h = Part.Functions.rescale(h)

    self.draw_x = Part.Functions.rescale(self.dim_x + (self.dim_w - w) / 2,true)
    self.draw_y = Part.Functions.rescale(self.dim_y + (self.dim_h - h) / 2,false,true)

    Part.Draw.Graphics.setFont(16, self.font_flags)

    if self.width_from_label then
        self.draw_w = Part.Functions.rescale(20) + gfx.measurestr(self.text)
    end

    self:updateState()
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Button : Draw
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.ButtonBank:draw()
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

return control