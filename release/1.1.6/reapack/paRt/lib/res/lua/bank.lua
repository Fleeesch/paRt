-- @version 1.1.6
-- @author Fleeesch
-- @description paRt Theme Adjuster
-- @noIndex
local bank = { Functions = {}, Handler = {}, ParameterSet = {}, Slot = {} }

-- ==========================================================================================
--                      Bank : Functions
-- ==========================================================================================


--  Method : Pending Save
-- -------------------------------------------
function bank.Functions.pendingSave()
    if Part.Global.pending_save > 0 then
        Part.Global.pending_save = Part.Global.pending_save - 1

        if Part.Global.pending_save == 0 then
            bank.Functions.storeParameterFile()
        end
    end
end

--  Method : Changed Parameter
-- -------------------------------------------

function bank.Functions.parameterChange()
    if Part.Global.ticks > Part.Global.startup_delay then
        Part.Global.pending_save = Part.Global.pending_save_delay
    end
end

--  Method : Trigger Bank Copy Process
-- -------------------------------------------

function bank.Functions.triggerBankCopyProcess()
    bank.Handler:copy()
end

--  Method : Copy Parameter Set
-- -------------------------------------------
function bank.Functions.copyParameterBank(bank_a, bank_b)
    -- go through parameter groups
    for _, val in pairs(Part.List.parameter_group) do
        -- copy parameter values
        val.parameters[bank_b]:setValue(val.parameters[bank_a]:getValue())
    end
end

--  Method : Store Parameter File
-- -------------------------------------------

function bank.Functions.storeParameterFile(target_file_name)
    local file_name = target_file_name or Part.Global.config_dir .. "/parameters.partmap"

    local manual = false

    -- detect manually set file target
    if target_file_name ~= nil then
        manual = true
    end

    if not manual then
        -- last theme file
        local filepath = Part.Global.config_dir .. "/last_theme.partmap"
        local last_theme_filepath = reaper.GetLastColorThemeFile()

        -- path has to be valid
        if last_theme_filepath ~= nil then
            local last_theme = Part.Functions.extractFileName(reaper.GetLastColorThemeFile())
            
            -- string has to be valid
            if last_theme ~= nil and #last_theme > 0 then
                -- store last theme
                local file = io.open(filepath, "w")
                file:write()
                file:close()
            end
        end
    end

    -- open file
    local filepath = file_name
    local file = io.open(filepath, "w")
    file:write("return {\n")

    -- version
    file:write("version=" .. '"' .. tostring(Part.Version.version_theme) .. '"' .. ",\n")

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

--  Method : Load Parameter File
-- -------------------------------------------

function bank.Functions.loadParameterFile(force, target_file_name)
    -- store path
    local file_name = target_file_name or Part.Global.config_dir .. "/parameters.partmap"

    -- manual file (not default one)
    local manual_load = false

    if target_file_name ~= nil then
        manual_load = true
    end

    -- assume theme hasn't changed
    local same_theme = true

    -- either force or act on theme change
    if force or not same_theme then
        local file = io.open(file_name, "r")

        -- if previous parameters aren't available load the default file
        if not file then
            file = io.open(Part.Global.config_dir .. "/defaults.partmap", "r")
        end

        if file then
            -- read file content
            local content = file:read("*all")

            file:close()

            -- try loading file content into table
            local success, data = pcall(load(content, nil, nil, _G))

            if success then
                -- clear graphics buffer
                Part.Draw.Buffer.clearCompleteBuffer()

                -- version
                --local load_version = 0

                if data["version"] ~= nil then
                    --load_version = data["version"]
                end

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
                bank.Handler:update(true)

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

--  Method : Restore Parameter Defaults
-- -------------------------------------------

function bank.Functions.restoreParameterDefaults()
    bank.Functions.loadParameterFile(true, ScriptPath .. "conf/defaults.partmap")
end

--  Method : Hard Reset all Parameters
-- -------------------------------------------

function bank.Functions.hardResetAllParameters()
    for i = 1, #Part.List.theme_parameter do
        Part.List.theme_parameter[i]:reset()
    end

    for i = 1, #Part.List.banked_parameter do
        Part.List.banked_parameter[i]:reset()
    end
end

-- ==========================================================================================
--                      Bank : Handler
-- ==========================================================================================


--  Bank Handler
-- -------------------------------------------

bank.Handler.BankHandler = {}

function bank.Handler.BankHandler:new(o, bank_parameter)
    o = o or {}
    setmetatable(o, bank.Handler.BankHandler)
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

--  Bank Handler : Copy Mode
-- -------------------------------------------

function bank.Handler.BankHandler:copyModeActive()
    return self.copy_mode_on
end

--  Bank Handler : Set Copy Mode
-- -------------------------------------------

function bank.Handler.BankHandler:setCopyMode(state, trigger)
    self.copy_mode_on = state
    self.copy_mode_trigger = trigger or self.copy_mode_trigger

    -- reset pending submits
    for i = 1, #Part.List.control_button_bank do
        Part.List.control_button_bank[i]:resetSubmit()
    end
end

--  Bank Bar : Copy
-- -------------------------------------------

function bank.Handler.BankHandler:copy()
    local overwritten_banks = {}

    -- copy prcoess
    for _, val in pairs(Part.List.control_button_bank_select) do
        if val:isCopyTarget() then
            local bank_idx = val.bank:getIndex()
            bank.Functions.copyParameterBank(self.bank_selected:getIndex(), bank_idx)
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

--  Bank Handler : Add Bank
-- -------------------------------------------

function bank.Handler.BankHandler:addBank(bank)
    -- register bank slot
    table.insert(self.bank_slot, bank)

    -- select the first slot that isn't global
    if not bank:isGlobal() and self.bank_selected == nil then
        self.bank_selected = bank
    end
end

--  Bank Handler : Add Parameter Set
-- -------------------------------------------

function bank.Handler.BankHandler:addParameterSet(bank_set)
    -- register parmeter group
    table.insert(self.parameter_set, bank_set)
end

--  Bank Handler : Reset Current Bank
-- -------------------------------------------

function bank.Handler.BankHandler:resetCurrentBank()
    -- go through parameter sets
    for key, val in pairs(self.parameter_set) do
        -- go through parameter groups
        for key2, val2 in pairs(val.parameter_group) do
            -- reset parameter
            val2:reset()
        end
    end
end

--  Bank Handler : Init
-- -------------------------------------------

function bank.Handler.BankHandler:init()
    -- select bank based on bank-select-parameter
    self:selectBank(math.max(self.bank_parameter:getValue(), 2))
    self:update(true)
end

--  Bank Handler : Selected Bank
-- -------------------------------------------

function bank.Handler.BankHandler:selectedBank()
    return self.bank_selected
end

--  Bank Handler : Select Bank
-- -------------------------------------------

function bank.Handler.BankHandler:selectBank(idx)
    -- select bank based on index
    self.bank_selected = self.bank_slot[idx]

    -- update bank-select parameter
    self.bank_parameter:setValue(idx)
end

--  Bank Handler : Update
-- -------------------------------------------

function bank.Handler.BankHandler:update(force)
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
    end

    -- store current bank as last selected
    self.bank_selected_last = self.bank_selected
end

-- ==========================================================================================
--                      Bank : Parameter Set
-- ==========================================================================================


--  Bank Parametr Set
-- -------------------------------------------

bank.ParameterSet.BankParameterSet = {}

function bank.ParameterSet.BankParameterSet:new(o, name, sync, handler)
    o = o or {}
    setmetatable(o, bank.ParameterSet.BankParameterSet)
    self.__index = self

    -- name of set
    o.name = name

    -- bank sync parameter
    o.sync = sync

    -- parameter groups of set
    o.parameter_group = {}
    o.parameter = nil

    -- bank handler
    o.handler = handler or bank.Handler

    -- register to bank handler
    o.handler:addParameterSet(o)

    -- register in lookup list
    table.insert(Part.List.bank_parameter_set, o)

    return o
end

--  Bank Parametr Set : Add Parameter
-- -------------------------------------------

function bank.ParameterSet.BankParameterSet:addParameter(parameter)
    self.parameter = parameter
end

--  Bank Parametr Set : Add Parameter Group
-- -------------------------------------------

function bank.ParameterSet.BankParameterSet:addParameterGroup(parameter_grp)
    table.insert(self.parameter_group, parameter_grp)
end

--  Bank Parametr Set : Load Bank
-- -------------------------------------------

function bank.ParameterSet.BankParameterSet:loadBank(idx)
    -- reset index if bank is not active or no sync parameter is given
    if self.sync ~= nil and self.sync:getValue() <= 0 then
        idx = 1
    end

    -- iterate parameter groups
    if self.parameter ~= nil then
        --self.parameter:setValue()
    end

    for key, val in pairs(self.parameter_group) do
        -- load bank parameter of group
        val:loadParameter(idx)
    end
end

-- ==========================================================================================
--                      Bank : Slot
-- ==========================================================================================


--  Bank Slot
-- -------------------------------------------

bank.Slot.BankSlot = {}

function bank.Slot.BankSlot:new(o, is_global, label, name, index, handler)
    o = o or {}
    setmetatable(o, bank.Slot.BankSlot)
    self.__index = self

    -- bank handler
    o.handler = handler or bank.Handler

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

--  Bank Slot : Is Global
-- -------------------------------------------

function bank.Slot.BankSlot:isGlobal()
    return self.is_global
end

--  Bank Slot : Get Index
-- -------------------------------------------

function bank.Slot.BankSlot:getIndex()
    return self.index
end

return bank
