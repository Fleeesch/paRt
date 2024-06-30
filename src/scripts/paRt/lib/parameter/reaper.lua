local par = {}

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Parameter : Reaper Parameter
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
par.ReaperParameter = Part.Parameter.Parameter:new()

function par.ReaperParameter:new(o, lookup_name, description, command_id, is_string)

    o = o or Part.Parameter.Parameter:new(o, lookup_name, 0, 0, 1, true)
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
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Parameter : Reaper Parameter : Routine
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function par.ReaperParameter:routine()

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

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Parameter : Reaper Parameter : Link to Theme Parameter
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function par.ReaperParameter:linkToThemeParameter(parameter)

    -- store parmeter link
    self.theme_par_link = parameter

    -- register routine
    table.insert(Part.List.routine, self)

end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Parameter : Reaper Parameter : Get Value
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function par.ReaperParameter:getValue()

    -- get value from action command state
    self.value = reaper.GetToggleCommandState(self.command_id)

    return self.value

end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Parameter : Reaper Parameter : Set Value
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function par.ReaperParameter:setValue(value)

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

return par