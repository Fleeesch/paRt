local bank = {}

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Bank Slot
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

bank.BankSlot = {}

function bank.BankSlot:new(o, is_global, label, name, index, handler)

    o = o or {}
    setmetatable(o, bank.BankSlot)
    self.__index = self

    -- bank handler
    o.handler = handler or Part.Bank.Handler

    -- is a global bank
    o.is_global = is_global

    -- label of slot, for output labels
    o.label = label

    -- name, for identification
    o.name = name

    -- bank index number
    o.index = index

    -- register in list
    table.insert(Part.List.bank_slot, o)

    -- add slot to bank handler
    o.handler:addBank(o)

    return o

end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Bank Slot : Is Global
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function bank.BankSlot:isGlobal()
    return self.is_global
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Bank Slot : Get Index
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function bank.BankSlot:getIndex()
    return self.index
end

return bank