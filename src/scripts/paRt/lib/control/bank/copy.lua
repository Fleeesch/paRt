local control = {}

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Bank Button Copy
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
control.ButtonBankCopy = Part.Control.Bank.ButtonBank:new()

function control.ButtonBankCopy:new(o, handler, text)
    o = o or Part.Control.Bank.ButtonBank:new(o, handler, text)
    setmetatable(o, self)
    self.__index = self

    o.color_bg_on = Part.Color.Lookup.color_palette.color.red
    o.color_fg_on = Part.Color.Lookup.color_palette.bank_bar.button.on_fg


    return o
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Bank Button Copy : Update State
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.ButtonBankCopy:updateState()
    self.state = self.handler:copyModeActive()
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Bank Button Copy : Action
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.ButtonBankCopy:action()
    local copy_state = self.handler:copyModeActive()

    if copy_state then
        local do_copy = false

        -- trigger a copy process when at least one bank is marked for copying
        for _, val in pairs(Part.List.control_button_bank_select) do
            if val:isCopyTarget() then
                val:highlight()
                do_copy = true
            end
        end

        -- copy success
        if do_copy then
            Part.Draw.Graphics.splashMessage('Copying Part.Bank...')

            table.insert(Part.List.pending_action, {
                func = Part.Bank.Functions.triggerBankCopyProcess,
                args = {}
            })
        end

        --deactivate copy mode
        self.handler:setCopyMode(not copy_state, nil)
    else
        for i = 1, #Part.List.control_button_bank_select do
            Part.List.control_button_bank_select[i]:clearCopyState()
        end

        self.handler:setCopyMode(not copy_state, self.handler:selectedBank())
    end
end

return control