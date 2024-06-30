local control = {}

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Bank Button Reset
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
control.ButtonBankReset = Part.Control.Bank.ButtonBank:new()

function control.ButtonBankReset:new(o, handler, text)
    o = o or Part.Control.Bank.ButtonBank:new(o, handler, text)
    setmetatable(o, self)
    self.__index = self

    o:useSubmit()

    return o
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Bank Button : Get Output Text
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.ButtonBankReset:getOutputText()
    if self:submitPending() then
        return "Sure?"
    end

    return self.text
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Bank Button Reset : Submit
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.ButtonBankReset:submit()

    if self.handler:copyModeActive() then
        return
    end

    if self:submitPending() then
        self:action()
        self.submit_counter = 0
        return
    else
        self.submit_counter = self.submit_time
    end
end


-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Bank Button Reset : Action
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.ButtonBankReset:action()

    if self.handler:copyModeActive() then
        return
    end

    self:highlight()

    table.insert(Part.List.pending_action, {
        func = Part.Bank.Functions.restoreParameterDefaults,
        args = {}
    })

    Part.Draw.Graphics.splashMessage("Loading Default Settings...")
end

return control