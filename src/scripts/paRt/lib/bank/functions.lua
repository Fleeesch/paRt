local bank = {}

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Pending Save
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function bank.pendingSave()
    if Part.Global.pending_save > 0 then
        Part.Global.pending_save = Part.Global.pending_save - 1

        if Part.Global.pending_save == 0 then
            Part.Bank.Functions.storeParameterFile()
        end
    end
end


-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Changed Parameter
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function bank.parameterChange()
    if Part.Global.ticks > Part.Global.startup_delay then
        Part.Global.pending_save = Part.Global.pending_save_delay
    end
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Trigger Bank Copy Process
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function bank.triggerBankCopyProcess()
    Part.Bank.Handler:copy()
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Copy Parameter Set
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function bank.copyParameterBank(bank_a, bank_b)
    -- go through parameter groups
    for _, val in pairs(Part.List.parameter_group) do
        -- copy parameter values
        val.parameters[bank_b]:setValue(val.parameters[bank_a]:getValue())
    end
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Store Parameter File
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function bank.storeParameterFile(target_file_name)
    local file_name = target_file_name or Part.Global.config_dir .. "/parameters.partmap"

    local manual = false

    -- detect manually set file target
    if target_file_name ~= nil then
        manual = true
    end

    if not manual then
        -- last theme file
        local filepath = Part.Global.config_dir .. "/last_theme.partmap"

        -- store last theme
        local file = io.open(filepath, "w")
        file:write(Part.Functions.extractFileName(reaper.GetLastColorThemeFile()))
        file:close()
    end

    -- open file
    local filepath = file_name
    local file = io.open(filepath, "w")
    file:write("return {\n")

    -- theme parameters
    for key, val in pairs(Part.List.theme_parameter) do
        if string.find(val.lookup_name, "par") then
            if val.store then
                file:write(tostring(val.lookup_name) .. "=" .. tostring(val.value) .. ",\n")
            end
        end
    end

    -- banked parameters
    for key, val in pairs(Part.List.banked_parameter) do
        if string.find(val.lookup_name, "par") then
            file:write(tostring(val.lookup_name) .. "=" .. tostring(val.value) .. ",\n")
        end
    end

    -- close file
    file:write("}\n")
    file:close()

    -- message
    if manual then
        Part.Message.Handler.showMessage('Successfully written "' .. Part.Functions.extractFileName(file_name) .. '"')
    end
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Load Parameter File
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function bank.loadParameterFile(force, target_file_name)
    -- store path
    local file_name = target_file_name or Part.Global.config_dir .. "/parameters.partmap"

    -- manual file (not default one)
    local manual_load = false

    if target_file_name ~= nil then
        manual_load = true
    end

    -- assume theme hasn't changed
    local same_theme = true

    if not manual_load then
        -- get last theme
        local filepath = Part.Global.config_dir .. "/last_theme.partmap"
        local file = io.open(filepath, "r")

        if file then
            local content = file:read("*all")

            file:close()
        end

        -- check if theme has changed
        same_theme = Part.Functions.extractFileName(reaper.GetLastColorThemeFile()) == content
    end
    -- either force or act on theme change
    if force or not same_theme then
        -- open file
        local file = io.open(file_name, "r")

        if file then
            -- read file content
            local content = file:read("*all")
            file:close()

            -- try loading file content into table
            local success, data = pcall(load(content, nil, nil, _G))

            if success then
                -- clear graphics buffer
                Part.Draw.Buffer.clearCompleteBuffer()

                -- theme parameters
                for key, val in pairs(data) do
                    if Part.Parameter.Theme.theme_parameter_by_name[key] ~= nil then
                        Part.Parameter.Theme.theme_parameter_by_name[key]:setValue(tonumber(val))
                    end
                end

                -- banked parmeters
                for key, val in pairs(data) do
                    if Part.Parameter.Banked.banked_parameter_by_name[key] ~= nil then
                        Part.Parameter.Banked.banked_parameter_by_name[key]:setValue(tonumber(val))
                    end
                end

                -- force a bank update
                Part.Bank.Handler:update(true)

                -- success message
                if manual_load then
                    Part.Message.Handler.showMessage('Successfully loaded "' ..
                    Part.Functions.extractFileName(file_name) .. '"')
                end
            else
                -- error message
                if not manual_load then
                    Part.Message.Handler.showMessage("Error restoring configuration", "!", "error")
                else
                    Part.Message.Handler.showMessage(
                    'Error loading "' .. Part.Functions.extractFileName(file_name) .. '"', "!", "error")
                end
            end
        end
    end
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Restore Parameter Defaults
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function bank.restoreParameterDefaults()
    Part.Bank.Functions.loadParameterFile(true, ScriptPath .. "defaults.partmap")
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Hard Reset all Parameters
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function bank.hardResetAllParameters()
    for i = 1, #Part.List.theme_parameter do
        Part.List.theme_parameter[i]:reset()
    end

    for i = 1, #Part.List.banked_parameter do
        Part.List.banked_parameter[i]:reset()
    end
end

return bank
