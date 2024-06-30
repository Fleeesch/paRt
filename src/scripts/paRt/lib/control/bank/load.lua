local control = {}

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Bank Button Load
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
control.ButtonBankLoad = Part.Control.Bank.ButtonBank:new()

function control.ButtonBankLoad:new(o, handler, text)
    o = o or Part.Control.Bank.ButtonBank:new(o, handler, text)
    setmetatable(o, self)
    self.__index = self

    return o
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Bank Button Load : Action
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.ButtonBankLoad:action()

    if self.handler:copyModeActive() then
        return
    end

    local retval, file_name = reaper.JS_Dialog_BrowseForOpenFiles(nil, nil, nil, "Lua Files\0*.partmap", false)

    if retval == 1 then
        -- pending load
        table.insert(Part.List.pending_action, {
            func = Part.Bank.Functions.loadParameterFile,
            args = { true, file_name }
        })

        Part.Draw.Graphics.splashMessage('Loading ' .. Part.Functions.extractFileName(file_name) .. '...')
    end
end

return control