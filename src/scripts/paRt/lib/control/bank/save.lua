local control = {}

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Bank Button Save
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
control.ButtonBankSave = Part.Control.Bank.ButtonBank:new()

function control.ButtonBankSave:new(o, handler, text)
    o = o or Part.Control.Bank.ButtonBank:new(o, handler, text)
    setmetatable(o, self)
    self.__index = self


    return o
end


-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Bank Button Save : Action
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.ButtonBankSave:action()

    if self.handler:copyModeActive() then
        return
    end

    local retval, file_name = reaper.JS_Dialog_BrowseForSaveFile(nil, nil, nil, "Lua Files\0*.partmap")

    if retval == 1 then
        if Part.Functions.extractExtension(file_name) ~= "partmap" then
            file_name = file_name .. ".partmap"
        end

        -- pending save
        table.insert(Part.List.pending_action, {
            func = Part.Bank.Functions.storeParameterFile,
            args = { file_name }
        })

        Part.Draw.Graphics.splashMessage('Saving ' .. Part.Functions.extractFileName(file_name) .. '...')
    end

end

return control