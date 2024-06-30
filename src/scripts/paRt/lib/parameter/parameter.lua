local par = {}

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Parameter
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
par.Parameter = {
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

function par.Parameter:new(o, lookup_name, value_default, value_min, value_max, quantize)
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

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Parameter : Link to Bank Handler
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function par.Parameter:linkToBankHandler(bank_link)
    self.bank_link = bank_link
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Parameter : Set to Group
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function par.Parameter:setToGroup(group)
    self.group = group
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Parameter : Rescale
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function par.Parameter:rescale(val_min, val_max)
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

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Parameter : Get Print String
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function par.Parameter:getPrint()
    -- uses percentage?
    if self.percentage then
        -- return value
        local val

        -- rescaling?
        if self.use_rescale then
            val = Part.Functions.map(self.value, self.rescale_min, self.rescale_max, self.percentage_min, self.percentage_max)
        else
            val = Part.Functions.map(self.value, self.value_min, self.value_max, self.percentage_min, self.percentage_max)
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

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Parameter : Use Percentage
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function par.Parameter:usePercentage(float, range_min, range_max)
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

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Parameter : Float to Value
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function par.Parameter:floatToValue(float, use_rescale)
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


-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Parameter : Default Value to Float
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function par.Parameter:defaultValueToFloat(use_rescale)
    -- return basic or Part.Functions.rescale(d default value
    if use_rescale and self.use_rescale then
        return Part.Functions.map(self.value_default, self.rescale_min, self.rescale_max, 0, 1)
    else
        return Part.Functions.map(self.value_default, self.value_min, self.value_max, 0, 1)
    end
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Parameter : Value to Float
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function par.Parameter:valueToFloat(value, use_rescale)
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

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Parameter : Reset
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function par.Parameter:reset()
    self.value = self.value_default
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Parameter : Get Value
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function par.Parameter:getValue()
    return self.value
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Parameter : Set Value
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function par.Parameter:setValue(value)
    -- cap value while setting it
    self.value = Part.Functions.cap(value, self.value_min, self.value_max)

    if self.bank_link ~= nil then
        self.bank_link:updateValue()
    end
    
    Part.Bank.Functions.parameterChange()
end

return par