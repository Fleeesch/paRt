local bank = {}

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Globals
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- last created bank parameter set
current_bank_parameter_set = nil


-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Set Parameter Group
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function bank.setParameterGroup(group)
    current_bank_parameter_set = group
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Clear Recent Bank Parameter Set
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function bank.clearParameterGroup()
    -- reset last created bank parameter set
    current_bank_parameter_set = nil
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Add Parameter to Recent Bank Parameter Set
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function bank.registerParameterGroup(parameter)
    -- skip if there's no current bank parameter set
    if current_bank_parameter_set == nil then
        return
    end

    -- add parameter group to bank parameter set
    current_bank_parameter_set:addParameterGroup(parameter)

    -- reuturn current bank parameter set
    return current_bank_parameter_set
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Bank Parametr Set
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

bank.BankParameterSet = {}

function bank.BankParameterSet:new(o, name, sync, handler)
    o = o or {}
    setmetatable(o, bank.BankParameterSet)
    self.__index = self

    -- name of set
    o.name = name

    -- bank sync parameter
    o.sync = sync

    -- parameter groups of set
    o.parameter_group = {}

    -- bank handler
    o.handler = handler or Part.Bank.Handler

    -- register as curernt bank parameter set
    current_bank_parameter_set = o

    -- register to bank handler
    o.handler:addParameterSet(o)

    -- register in lookup list
    table.insert(Part.List.bank_parameter_set, o)

    return o
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Bank Parametr Set : Add Parameter Bank
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function bank.BankParameterSet:addParameterGroup(parameter_grp)
    -- add parameter group to bank set
    table.insert(self.parameter_group, parameter_grp)
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Bank Parametr Set : Load Bank
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function bank.BankParameterSet:loadBank(idx)
    
    -- reset index if bank is not active or no sync parameter is given
    if self.sync ~= nil and self.sync:getValue() <= 0 then
        idx = 1
    end

    -- iterate parameter groups
    for key, val in pairs(self.parameter_group) do
        -- load bank parameter of group
        val:loadParameter(idx)
    end

end

return bank