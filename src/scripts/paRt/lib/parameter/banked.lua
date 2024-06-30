local par = {}

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Banked Parameter
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
par.BankedParameter = Part.Parameter.Parameter:new()

par.banked_parameter_by_name = {}

function par.BankedParameter:new(o, lookup_name, value_default, value_min, value_max, quantize)

    o = o or Part.Parameter.Parameter:new(o, lookup_name, value_default, value_min, value_max, quantize)
    setmetatable(o, self)
    self.__index = self

    -- register parameter for lookup
    par.banked_parameter_by_name[lookup_name] = o

    -- register in lookup lists
    table.insert(Part.List.parameter, o)
    table.insert(Part.List.banked_parameter, o)

    return o
end

return par