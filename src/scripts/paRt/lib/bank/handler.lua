local bank = {}

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Bank Handler
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

bank.BankHandler = {}

function bank.BankHandler:new(o, bank_parameter)
    o = o or {}
    setmetatable(o, bank.BankHandler)
    self.__index = self

    -- bank select parameter
    o.bank_parameter = bank_parameter

    -- banks
    o.bank_slot = {}

    -- parameter sets
    o.parameter_set = {}

    -- delayed save counter
    o.save_counter = 0

    -- delayed save time
    o.save_delay = 25

    -- selected bank
    o.bank_selected = nil

    -- last slected bank, for detecting bank changes
    o.bank_selected_last = nil

    -- copy mode related
    o.copy_mode_on = false
    o.copy_mode_trigger = nil

    return o
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Bank Handler : Copy Mode
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function bank.BankHandler:copyModeActive()
    return self.copy_mode_on
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Bank Handler : Set Copy Mode
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function bank.BankHandler:setCopyMode(state, trigger)
    self.copy_mode_on = state
    self.copy_mode_trigger = trigger or self.copy_mode_trigger

    -- reset pending submits
    for i = 1, #Part.List.control_button_bank do
        Part.List.control_button_bank[i]:resetSubmit()
    end
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Bank Bar : Copy
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function bank.BankHandler:copy()
    local overwritten_banks = {}

    -- copy prcoess
    for _, val in pairs(Part.List.control_button_bank_select) do
        if val:isCopyTarget() then
            local bank_idx = val.bank:getIndex()
            Part.Bank.Functions.copyParameterBank(self.bank_selected:getIndex(), bank_idx)
            table.insert(overwritten_banks, bank_idx - 1)
        end
    end


    -- create target bank string
    local bank_str = ""

    for key, val in pairs(overwritten_banks) do
        bank_str = bank_str .. val

        if key < #overwritten_banks then
            bank_str = bank_str .. ", "
        end
    end

    -- info message
    local trigger_idx = self.copy_mode_trigger:getIndex()
    Part.Message.Handler.showMessage("Successfully copied Bank " .. tostring(trigger_idx - 1) .. " to Bank " .. bank_str)
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Bank Handler : Add Bank
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function bank.BankHandler:addBank(bank)
    -- register bank slot
    table.insert(self.bank_slot, bank)

    -- select the first slot that isn't global
    if not bank:isGlobal() and self.bank_selected == nil then
        self.bank_selected = bank
    end
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Bank Handler : Add Parameter Set
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function bank.BankHandler:addParameterSet(bank_set)
    -- register parmeter group
    table.insert(self.parameter_set, bank_set)
end


-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Bank Handler : Reset Current Bank
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function bank.BankHandler:resetCurrentBank()
    -- go through parameter sets
    for key, val in pairs(self.parameter_set) do
        -- go through parameter groups
        for key2, val2 in pairs(val.parameter_group) do
            -- reset parameter
            val2:reset()
        end
    end

    -- go through reorder sets
    for key, val in pairs(Part.List.control_reorder_set) do
        -- reload them, fixing faulty lists along the way
        val:reload()
    end
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Bank Handler : Init
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function bank.BankHandler:init()
    -- select bank based on bank-select-parameter
    self:selectBank(math.max(self.bank_parameter:getValue(), 2))

end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Bank Handler : Selected Bank
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function bank.BankHandler:selectedBank()
    return self.bank_selected
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Bank Handler : Select Bank
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function bank.BankHandler:selectBank(idx)
    -- select bank based on index
    self.bank_selected = self.bank_slot[idx]
    
    -- update bank-select parameter
    self.bank_parameter:setValue(idx)
    
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Bank Handler : Update
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function bank.BankHandler:update(force)
    
    -- update current bank if changed externally
    if not force and self.bank_parameter:getValue() ~= self.bank_selected:getIndex() then
        force = true
        self:selectBank(self.bank_parameter:getValue())
    end

    -- there has to be a bank selected
    if self.bank_selected == nil then
        return
    end

    -- bank selection happened or force is active?
    if self.bank_selected_last ~= self.bank_selected or (force ~= nil and force) then
    
        -- go through parameter sets
        for key, val in pairs(self.parameter_set) do
            -- load bank of parameter set
            val:loadBank(self.bank_selected:getIndex())
        end

        -- reload reorder sets
        for key, val in pairs(Part.List.control_reorder_set) do
            val:reload()
        end

    end

    -- store current bank as last selected
    self.bank_selected_last = self.bank_selected
end

return bank