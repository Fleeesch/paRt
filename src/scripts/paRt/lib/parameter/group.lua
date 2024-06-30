local par = {}

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Parameter Group
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
par.ParameterGroup = Part.Parameter.Parameter:new()

function par.ParameterGroup:new(o, lookup_name, type, bank_to_use)
    
    o = o or Part.Parameter.Parameter:new(o, lookup_name, 0, 0, 0, true)
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

    -- default type is theme parameter

    if type == nil then
        type = "theme"
    elseif type == "" then
        type = "theme"
    end

    o.parameter_theme = Part.Parameter.Theme.ThemeParameter:new(nil, lookup_name)

    -- iterate bank parameter names
    for key, name in pairs(bank_names) do
        -- parameter is a theme parmeter?
        if type == "theme" then
            -- create a theme parameter
            local par = Part.Parameter.Banked.BankedParameter:new(nil, name, o.parameter_theme.value_default, o.parameter_theme.value_min,
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

    -- load fist parameter in group
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
        par_bankchange = Part.Parameter.Banked.BankedParameter:new(nil, lookup_name .. "_banked")
        parameter_set = Part.Bank.ParameterSet.BankParameterSet:new(nil, lookup_name  .. "_bankset" , par_bankchange)
        parameter_set:addParameterGroup(o)
    end
    
    return o, par_bankchange, parameter_set
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Parameter Group : Add to Bank
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function par.ParameterGroup:addToBank(bankedParameterSet)
    bankedParameterSet:addParameterGroup(self)
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Parameter Group : Get Bank Names
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function par.ParameterGroup:getBankNames(name)
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

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Parameter Group : Load Parameter
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function par.ParameterGroup:loadParameter(idx)
    self.loaded_parameter = self.parameters[idx]
    self.loaded_parameter_index = idx
    self:setValue()
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Parameter Group : Reset
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function par.ParameterGroup:reset()
    -- address loaded parameter
    --self.loaded_parameter:reset()
    self:setValue(self.value_default)
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Parameter Group : Get Print
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function par.ParameterGroup:getPrint()
    -- address loaded parameter
    return self.loaded_parameter:getPrint()
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Parameter Group : Get Value
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function par.ParameterGroup:getValue()
    -- address loaded parameter
    return self.loaded_parameter:getValue()
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Parameter Group : Set Value
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function par.ParameterGroup:setValue(value)
    if value == nil then
        if Part.Global.initial_load then
            self.parameter_theme:setValue(self.loaded_parameter:getValue())
        end
        return
    end


    self.loaded_parameter:setValue(value)

    self.parameter_theme:setValue(value)
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Parameter Group : Float to Value
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function par.ParameterGroup:floatToValue(float,use_rescale)
    -- address loaded parameter
    self.loaded_parameter:floatToValue(float, use_rescale)
    self.parameter_theme:floatToValue(float, use_rescale)
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Parameter Group : Value to Float
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function par.ParameterGroup:valueToFloat(value, use_rescale)
    -- address loaded parameter
    return self.loaded_parameter:valueToFloat(value, use_rescale)
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Parameter Group : Rescale
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function par.ParameterGroup:rescale(val_min, val_max)
    -- set rescaling for all parameters
    for key, val in pairs(self.parameters) do
        val:rescale(val_min, val_max)
    end
end

return par