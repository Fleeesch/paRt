-- @version 1.2.2
-- @author Fleeesch
-- @description paRt Theme Adjuster
-- @noIndex

local parameter = { Group = {}, Reaper = {}, Theme = {}, Banked = {}, Lookup = {}, Map = {}, CustomParameterSettings = {} }

-- ==========================================================================================
--                      Parameter : Generic
-- ==========================================================================================


-- Parameter
-- -------------------------------------------

parameter.Parameter = {
    value = 0,
    value_min = 0,
    value_max = 1,
    quantize = false,
    percentage = false,
    percentage_float = false,
    scale = 0,
    rescale_min = 0,
    rescale_max = 1
}

function parameter.Parameter:new(o, lookup_name, value_default, value_min, value_max, quantize)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    -- individual name, acting as an id
    o.lookup_name = lookup_name

    -- value
    o.value = 0

    -- default value
    o.value_default = value_default

    -- value range
    o.value_min = value_min or 0
    o.value_max = value_max or 1

    -- last value (for registering changes)
    o.value_last = value_default or 0

    -- quantization (is integer)
    o.quantize = quantize or true

    -- rescale
    o.use_rescale = false

    -- Part.Functions.rescale( range
    o.rescale_min = o.value_min
    o.rescale_max = o.value_max

    -- use percentage
    o.percentage = false

    -- float-point precision percentage values
    o.percentage_float = false

    -- percentage range
    o.percentage_min = 0
    o.percentage_max = 10

    -- group, optional when parameter is part of a parameter group
    o.group = nil

    o.bank_link = nil

    return o
end

-- Parameter : Store in Settings
-- -------------------------------------------

function parameter.Parameter:storeInSettings()
    table.insert(Part.List.banked_parameter, self)
end

-- Parameter : Link to Bank Handler
-- -------------------------------------------

function parameter.Parameter:linkToBankHandler(bank_link)
    self.bank_link = bank_link
end

-- Parameter : Set to Group
-- -------------------------------------------

function parameter.Parameter:setToGroup(group)
    self.group = group
end

-- Parameter : Rescale
-- -------------------------------------------

function parameter.Parameter:rescale(val_min, val_max)
    -- set Part.Functions.rescale( range
    self.rescale_min = val_min
    self.rescale_max = val_max

    -- notify that parameter uses rescaling
    self.use_rescale = true

    -- parameter is part of group?
    if self.group ~= nil then
        self.group.rescale_min = val_min
        self.group.rescale_max = val_max
        self.group.rescale = true
    end
end

-- Parameter : Get Print String
-- -------------------------------------------

function parameter.Parameter:getPrint()
    -- uses percentage?
    if self.percentage then
        -- return value
        local val

        -- rescaling?
        if self.use_rescale then
            val = Part.Functions.map(self.value, self.rescale_min, self.rescale_max, self.percentage_min,
                self.percentage_max)
        else
            val = Part.Functions.map(self.value, self.value_min, self.value_max, self.percentage_min, self
                .percentage_max)
        end

        -- round if percentage doesn't use float point
        if not self.percentage_float then
            val = math.floor(val + 0.5)
        end

        -- return transformed value
        return tostring(val)
    end

    -- return direct string conversion
    return tostring(self.value)
end

-- Parameter : Use Percentage
-- -------------------------------------------

function parameter.Parameter:usePercentage(float, range_min, range_max)
    -- float point precision
    if float == nil or not float then
        self.percentage_float = false
    end

    -- minimum range
    if range_min ~= nil then
        self.percentage_min = range_min
    end

    -- maximum range
    if range_max ~= nil then
        self.percentage_max = range_max
    end

    -- activate percentag
    self.percentage = true
end

-- Parameter : Float to Value
-- -------------------------------------------

function parameter.Parameter:floatToValue(float, use_rescale)
    -- cap float value
    float = Part.Functions.cap(float, 0, 1)

    -- translate float to value
    local value = float * (self.value_max - self.value_min) + self.value_min

    -- optional rescaling
    if use_rescale and self.use_rescale then
        value = float * (self.rescale_max - self.rescale_min) + self.rescale_min
    end

    -- optional quantization
    if self.quantize then
        value = math.floor(value + 0.5)
    end

    -- set value
    self:setValue(value)
end

-- Parameter : Default Value to Float
-- -------------------------------------------

function parameter.Parameter:defaultValueToFloat(use_rescale)
    -- return basic or Part.Functions.rescale(d default value
    if use_rescale and self.use_rescale then
        return Part.Functions.map(self.value_default, self.rescale_min, self.rescale_max, 0, 1)
    else
        return Part.Functions.map(self.value_default, self.value_min, self.value_max, 0, 1)
    end
end

-- Parameter : Value to Float
-- -------------------------------------------

function parameter.Parameter:valueToFloat(value, use_rescale)
    -- use either passed or available value
    if value == nil then
        value = self.value
    end

    -- transfer value to float
    local float = Part.Functions.map(value, self.value_min, self.value_max, 0, 1)

    -- optional rescaling
    if use_rescale and self.rescale then
        float = Part.Functions.map(value, self.rescale_min, self.rescale_max, 0, 1)
    end

    -- cap float
    float = Part.Functions.cap(float, 0, 1)

    -- return float
    return float
end

-- Parameter : Reset
-- -------------------------------------------

function parameter.Parameter:reset()
    self.value = self.value_default
end

-- Parameter : Get Value
-- -------------------------------------------

function parameter.Parameter:getValue()
    return self.value
end

-- Parameter : Set Value
-- -------------------------------------------

function parameter.Parameter:setValue(value)
    -- cap value while setting it
    self.value = Part.Functions.cap(value, self.value_min, self.value_max)

    if self.bank_link ~= nil then
        self.bank_link:updateValue()
    end

    Part.Bank.Functions.parameterChange()
end

-- ==========================================================================================
--                      Parameter : Banked
-- ==========================================================================================


-- Banked Parameter
-- -------------------------------------------
parameter.Banked.BankedParameter = parameter.Parameter:new()

parameter.Banked.banked_parameter_by_name = {}

function parameter.Banked.BankedParameter:new(o, lookup_name, value_default, value_min, value_max, quantize)
    o = o or parameter.Parameter:new(o, lookup_name, value_default, value_min, value_max, quantize)
    setmetatable(o, self)
    self.__index = self

    -- register parameter for lookup
    parameter.Banked.banked_parameter_by_name[lookup_name] = o

    -- register in lookup lists
    table.insert(Part.List.parameter, o)
    table.insert(Part.List.banked_parameter, o)

    return o
end

-- ==========================================================================================
--                      Parameter : Group
-- ==========================================================================================


-- Parameter Group
-- -------------------------------------------
parameter.Group.ParameterGroup = parameter.Parameter:new()

function parameter.Group.ParameterGroup:new(o, lookup_name, type, bank_to_use)
    o = o or parameter.Parameter:new(o, lookup_name, 0, 0, 0, true)
    setmetatable(o, self)
    self.__index = self

    -- get bank name variations from parameter
    local bank_names = o:getBankNames(lookup_name)

    -- parameteres of group
    o.parameters = {}

    -- type of group
    o.type = type

    -- mark parameter as group
    o.is_group = true

    -- if no type is given create a bunch of banks
    if type == nil then
        type = "theme_autobank"
    elseif type == "" then
        type = "theme_autobank"
    end

    o.parameter_theme = parameter.Theme.ThemeParameter:new(nil, lookup_name)

    -- iterate bank parameter names
    for _, name in pairs(bank_names) do
        -- parameter is a theme parmeter?
        if type == "theme_autobank" then
            -- create a theme parameter
            local par = parameter.Banked.BankedParameter:new(nil, name, o.parameter_theme.value_default,
                o.parameter_theme.value_min,
                o.parameter_theme.value_max, true)

            -- register parameter
            table.insert(o.parameters, par)

            -- inform parameter that it is par of this group
            par:setToGroup(o)
        end
    end

    -- copy values of first bank parameters
    o.value_default = o.parameters[1].value_default
    o.value_min = o.parameters[1].value_min
    o.value_max = o.parameters[1].value_max

    -- currently loaded parameter with its index
    o.loaded_parameter = nil
    o.loaded_parameter_index = nil

    -- load first parameter in group
    o:loadParameter(1)

    -- update value
    o:getValue()

    -- register in lists
    table.insert(Part.List.parameter, o)
    table.insert(Part.List.parameter_group, o)

    -- banking
    local par_bankchange
    local parameter_set

    if bank_to_use then
        bank_to_use:addParameterGroup(o)
    else
        par_bankchange = parameter.Banked.BankedParameter:new(nil, lookup_name .. "_banksync")
        parameter_set = Part.Bank.ParameterSet.BankParameterSet:new(nil, lookup_name .. "_bankset", par_bankchange)
        parameter_set:addParameterGroup(o)
    end

    return o, par_bankchange, parameter_set
end

-- Parameter Group : Add to Bank
-- -------------------------------------------

function parameter.Group.ParameterGroup:addToBank(bankedParameterSet)
    bankedParameterSet:addParameterGroup(self)
end

-- Parameter Group : Get Bank Names
-- -------------------------------------------

function parameter.Group.ParameterGroup:getBankNames(name)
    -- return string table
    local bank_str = {}

    -- go through bank numbers
    for i = 0, Part.Global.bank_count do
        -- generate new string using replace
        local new_str = name .. "_bank_" .. tostring(i)

        -- add string to return table
        table.insert(bank_str, new_str)
    end

    -- return formatted strings
    return bank_str
end

-- Parameter Group : Load Parameter
-- -------------------------------------------

function parameter.Group.ParameterGroup:loadParameter(idx)
    self.loaded_parameter = self.parameters[idx]
    self.loaded_parameter_index = idx
    self:setValue()
end

-- Parameter Group : Reset
-- -------------------------------------------

function parameter.Group.ParameterGroup:reset()
    -- address loaded parameter
    --self.loaded_parameter:reset()
    self:setValue(self.value_default)
end

-- Parameter Group : Get Print
-- -------------------------------------------

function parameter.Group.ParameterGroup:getPrint()
    -- address loaded parameter
    return self.loaded_parameter:getPrint()
end

-- Parameter Group : Get Value
-- -------------------------------------------

function parameter.Group.ParameterGroup:getValue()
    -- address loaded parameter
    return self.loaded_parameter:getValue()
end

-- Parameter Group : Set Value
-- -------------------------------------------

function parameter.Group.ParameterGroup:setValue(value, force)
    if value == nil then
        if Part.Global.initial_load or (force ~= nil and force) then
            self.parameter_theme:setValue(self.loaded_parameter:getValue())
        end
        return
    end


    self.loaded_parameter:setValue(value)

    self.parameter_theme:setValue(value)
end

-- Parameter Group : Float to Value
-- -------------------------------------------

function parameter.Group.ParameterGroup:floatToValue(float, use_rescale)
    -- address loaded parameter
    self.loaded_parameter:floatToValue(float, use_rescale)
    self.parameter_theme:floatToValue(float, use_rescale)
end

-- Parameter Group : Value to Float
-- -------------------------------------------

function parameter.Group.ParameterGroup:valueToFloat(value, use_rescale)
    -- address loaded parameter
    return self.loaded_parameter:valueToFloat(value, use_rescale)
end

-- Parameter Group : Rescale
-- -------------------------------------------

function parameter.Group.ParameterGroup:rescale(val_min, val_max)
    -- set rescaling for all parameters
    for key, val in pairs(self.parameters) do
        val:rescale(val_min, val_max)
    end
end

-- ==========================================================================================
--                      Parameter : Reaper
-- ==========================================================================================


-- Parameter : Reaper Parameter
-- -------------------------------------------
parameter.Reaper.ReaperParameter = parameter.Parameter:new()

function parameter.Reaper.ReaperParameter:new(o, lookup_name, description, command_id, is_string)
    o = o or parameter.Parameter:new(o, lookup_name, 0, 0, 1, true)
    setmetatable(o, self)
    self.__index = self

    -- title
    o.description = description

    -- mark parameter as group
    o.is_group = false

    -- command id (can be string)
    o.command_id = command_id

    -- whether the command is a string or not
    o.command_is_string = is_string

    -- linked theme parameter
    o.theme_par_link = nil

    -- sync value
    o:getValue()

    -- insert to lookup lists
    table.insert(Part.List.parameter, o)
    table.insert(Part.List.reaper_parameter, o)

    return o
end

-- Parameter : Reaper Parameter : Routine
-- -------------------------------------------

function parameter.Reaper.ReaperParameter:routine()
    -- has theme parameter link?
    if self.theme_par_link ~= nil then
        -- get theme parameter value
        local link_val = self.theme_par_link:getValue()

        -- value is different?
        if link_val ~= self:getValue() then
            -- update its value
            self:setValue(link_val)
        end
    end
end

-- Parameter : Reaper Parameter : Link to Theme Parameter
-- ----------------------------------------------------------

function parameter.Reaper.ReaperParameter:linkToThemeParameter(parameter)
    -- store parmeter link
    self.theme_par_link = parameter

    -- register routine
    table.insert(Part.List.routine, self)
end

-- Parameter : Reaper Parameter : Get Value
-- -------------------------------------------

function parameter.Reaper.ReaperParameter:getValue()
    -- get value from action command state
    self.value = reaper.GetToggleCommandState(self.command_id)

    return self.value
end

-- Parameter : Reaper Parameter : Set Value
-- -------------------------------------------

function parameter.Reaper.ReaperParameter:setValue(value)
    -- value has to be binary
    value = Part.Functions.cap(value, 0, 1)

    -- value from 0 to 1
    if value ~= 0 and reaper.GetToggleCommandState(self.command_id) == 0 then
        reaper.Main_OnCommand(self.command_id, 0)
    end

    -- value from 1 to 0
    if value == 0 and reaper.GetToggleCommandState(self.command_id) ~= 0 then
        reaper.Main_OnCommand(self.command_id, 0)
    end

    Part.Bank.Functions.parameterChange()
end

-- ==========================================================================================
--                      Parameter : Theme
-- ==========================================================================================


--  Method : Update Theme Parameter Refresh Rate
-- ------------------------------------------------

parameter.Theme.last_track_count = -1
function parameter.Theme.updateThemeParameterRefreshRate()
    if parameter.Theme.last_track_count ~= reaper.CountTracks(0) then
        parameter.Theme.last_track_count = reaper.CountTracks(0)
        Part.Global.refresh_theme_rate = math.floor(reaper.CountTracks(0) / Part.Global.refresh_theme_rate_threshold)
    end
end

-- Theme Parameter
-- -------------------------------------------
parameter.Theme.ThemeParameter = parameter.Parameter:new()

parameter.Theme.theme_parameter_by_name = {}

function parameter.Theme.ThemeParameter:new(o, lookup_name, buffered, store)
    local parameter_missing = false

    -- check if parameter is available
    if parameter.Lookup.theme_par_lookup[lookup_name] == nil then
        parameter_missing = true
        --reaper.ShowConsoleMsg('Missing Theme Parameter "' .. lookup_name .. '"\n')
    end

    local retval, desc, value, defValue, minValue, maxValue = 0, "", 0, 0, 0, 0

    -- get theme parameter values
    if not parameter_missing then
        retval, desc, value, defValue, minValue, maxValue =
            reaper.ThemeLayout_GetParameter(parameter.Lookup.theme_par_lookup[lookup_name])
    end


    -- create parent object, passing values
    o = o or parameter.Parameter:new(o, lookup_name, defValue, minValue, maxValue, true)
    setmetatable(o, self)
    self.__index = self

    o.parameter_missing = parameter_missing

    -- theme parameter index number
    if o.parameter_missing then
        o.index = 0
    else
        o.index = parameter.Lookup.theme_par_lookup[lookup_name]

        -- lookup name
        o.lookup_name = lookup_name

        -- mark parameter as group
        o.is_group = false

        -- register parameter for lookup
        parameter.Theme.theme_parameter_by_name[lookup_name] = o

        -- description
        o.description = desc

        -- buffered processing (don't apply values immediately)
        o.buffered = false

        -- timestamp, used for buffering
        o.timestamp = 0

        -- any nonging buffering?
        o.buffer_to_process = false

        -- buffer time
        o.timeout = Part.Global.parameter_buffer_time or 10

        -- store during save
        o.store = store or false


        -- buffering argument available?
        if buffered ~= nil and buffered then
            -- activate buffering
            o.buffered = true

            -- register in buffer list for continuous processing
            table.insert(Part.List.theme_parameter_buffer, o)
        end

        -- load value from theme, initialize last value
        o:getValue()
        o.value_last = o.value

        -- register in lookup lists
        table.insert(Part.List.parameter, o)
        table.insert(Part.List.theme_parameter, o)
    end


    return o
end

-- Theme Parameter : Reset
-- -------------------------------------------

function parameter.Theme.ThemeParameter:reset()
    -- skip missing parameter
    if self.parameter_missing then return end

    self:setValue(self.value_default)
end

-- Theme Parameter : Get Value
-- -------------------------------------------

function parameter.Theme.ThemeParameter:getValue()
    -- skip missing parameter
    if self.parameter_missing then return end

    -- no ongoing buffering?
    if not self.buffer_to_process then
        -- get theme value
        local retval, desc, value, defValue, minValue, maxValue = reaper.ThemeLayout_GetParameter(self.index)

        -- store last value
        self.value_last = self.value
        -- update value

        self.value = value
    end

    -- return updated value
    return self.value
end

-- Theme Parameter : Set Value
-- -------------------------------------------

function parameter.Theme.ThemeParameter:setValue(value)
    -- skip missing parameter
    if self.parameter_missing then return end

    -- don't process if value hasn't changed
    if self.value_last == value then
        return
    end

    -- cap value
    self.value = Part.Functions.cap(value, self.value_min, self.value_max)

    -- buffering disabled?
    if not self.buffered then
        -- directly set theme parameter
        reaper.ThemeLayout_SetParameter(self.index, self.value, true)
        Part.Functions.refreshTheme()

        -- buffering enabled?
    else
        -- value has changed?
        if self.value_last ~= value then
            -- update buffer timestamp
            self.timestamp = Part.Global.ticks + self.timeout

            -- buffering started
            self.buffer_to_process = true
        end
    end

    -- update last value
    self.value_last = self.value

    Part.Bank.Functions.parameterChange()

    if self.bank_link ~= nil then
        self.bank_link:updateValue()
    end
end

-- -------------------------------------------
-- Theme Parameter : Buffer
-- -------------------------------------------

function parameter.Theme.ThemeParameter:buffer()
    -- skip missing parameter
    if self.parameter_missing then return end

    -- buffer is active and enough time has passed?
    if self.buffer_to_process and Part.Global.ticks > self.timestamp then
        -- set theme paremeter
        reaper.ThemeLayout_SetParameter(self.index, self.value, true)
        Part.Functions.refreshTheme()

        -- disable buffering
        self.buffer_to_process = false
    end
end

-- ==========================================================================================
--                      Parameter : Lookup
-- ==========================================================================================


-- Theme Parmaeter Lookup Table
-- -------------------------------------------
-- contanis index numbers of parameters
parameter.Lookup.theme_par_lookup = {
    hue = -1005,
    saturation = -1004,
    gamma = -1000,
    highlights = -1003,
    shadows = -1002,
    midtones = -1001,
    custom_color_mod = -1006
}


-- Method : Import Theme Parameters
-- -------------------------------------------

function parameter.Lookup.importThemeParameters()
    local end_reached = false
    local index = 0

    while not end_reached do
        local retval, desc, value, defValue, minValue, maxValue = reaper.ThemeLayout_GetParameter(index)

        -- [?] not sure if there really was an actual parameter limit
        -- max parmeter limit, end reached when retval is none
        --if index > 1000 or retval == nil then
        
        -- check if end has been reached
        if retval == nil then
            end_reached = true
        else
            -- store parameter index of name
            parameter.Lookup.theme_par_lookup[retval] = index
        end
        index = index + 1
    end
end

-- ==========================================================================================
--                      Parameter : Custom
-- ==========================================================================================

-- fallback configuration
parameter.CustomParameterSettings = {
    version = nil,
    adjustments = {
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
    },
    buttons = {
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
    },
    choices = {
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
    }
}


-- Method : Import Custom Parameter Settings
-- -------------------------------------------

function parameter.Lookup.importCustomParameterSettings()
    -- get target path
    local config_path = Part.Global.config_dir
    local target_path = config_path .. "/" .. Part.Global.config_custom_parameter_settings_file

    -- try loading file
    local file = io.open(target_path, "r")
    if file then
        -- try reading content
        local content = file:read("*all")
        file:close()

        -- try parsing content
        local success, data = pcall(load(content, nil, nil, _G))

        -- parsing successfully completed
        if success then

            -- try storing version
            if data["version"] then
                parameter.CustomParameterSettings.version = data["version"]
            end

            -- data entries to gather
            local lookup = {
                { label = "adjustments", size = 16 },
                { label = "buttons",     size = 8 },
                { label = "choices",     size = 8 }
            }

            -- iterate sections of lookup table
            for _, section in ipairs(lookup) do
                -- check if the original and custom settings data structure has the same label
                if parameter.CustomParameterSettings[section.label] ~= nil and data[section.label] ~= nil then
                    -- iterate section entries
                    for idx, entry in ipairs(data[section.label]) do
                        -- stay within the given limit
                        if idx > section.size then
                            break
                        end

                        -- overwrite default config
                        parameter.CustomParameterSettings[section.label][idx] = entry
                    end
                end
            end
        end
    end
end

return parameter
