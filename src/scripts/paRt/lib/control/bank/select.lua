local control = {}

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Bank Button Select
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
control.ButtonBankSelect = Part.Control.Bank.ButtonBank:new()

function control.ButtonBankSelect:new(o, handler, text, bank)
    o = o or Part.Control.Bank.ButtonBank:new(o, handler, text)
    setmetatable(o, self)
    self.__index = self

    o.bank = bank

    o.copy_target = false

    o.color_select_bg_off = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.bank_bar.button.off_bg)
    o.color_select_fg_off = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.bank_bar.button.off_fg)
    o.color_select_bg_on = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.color.cyan)
    o.color_select_fg_on = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.bank_bar.button.on_fg)
    o.color_copy_bg_off = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.color.red)
    o.color_copy_fg_off = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.bank_bar.button.copy.of_fg)
    o.color_copy_bg_on = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.color.red)
    o.color_copy_fg_on = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.bank_bar.button.copy.on_fg)
    o.color_copy_bg_src = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.color.red)
    o.color_copy_fg_src = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.bank_bar.button.copy.on_fg)

    -- adjust copy brightness
    for i = 1, 3 do
        o.color_copy_bg_src[i] = math.min(o.color_copy_bg_src[i] + 100, 255)
        o.color_copy_bg_off[i] = math.min(o.color_copy_bg_off[i] * 0.25, 255)
    end

    o:colorsDefault()

    table.insert(Part.List.control_button_bank_select, o)

    return o
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Bank Button Select : Colors Default
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.ButtonBankSelect:colorsDefault()
    self.color_bg_off = self.color_select_bg_off
    self.color_fg_off = self.color_select_fg_off
    self.color_bg_on = self.color_select_bg_on
    self.color_fg_on = self.color_select_fg_on
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Bank Button Select : Colors Copy
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.ButtonBankSelect:colorsCopy()
    self.color_bg_off = self.color_copy_bg_off
    self.color_fg_off = self.color_copy_fg_off

    if self:isCopySource() then
        self.color_bg_on = self.color_copy_bg_src
        self.color_fg_on = self.color_copy_fg_src
    else
        self.color_bg_on = self.color_copy_bg_on
        self.color_fg_on = self.color_copy_fg_on
    end
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Bank Button Select : Clear Copy State
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.ButtonBankSelect:clearCopyState()
    self.copy_target = false
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Bank Button Select : Is Copy Source
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.ButtonBankSelect:isCopySource()
    return self.handler.copy_mode_trigger == self.bank
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Bank Button Select : Is Copy Target
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.ButtonBankSelect:isCopyTarget()
    if self:isCopySource() then
        return false
    end

    return self.copy_target
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Bank Button Select : Update State
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.ButtonBankSelect:updateState()
    if not self.handler:copyModeActive() then
        self:colorsDefault()

        self.state = self.handler.bank_selected == self.bank
    else
        self:colorsCopy()

        if self:isCopySource() then
            self.state = true
        else
            self.state = self.copy_target
        end
    end
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Bank Button Select : Action
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.ButtonBankSelect:action()
    if not self.handler:copyModeActive() then
        self.handler:selectBank(self.bank:getIndex())
    else
        if not self:isCopySource() then
            self.copy_target = not self.copy_target
        end
    end
end

return control
