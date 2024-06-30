local par = {}
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Update Theme Parameter Refresh Rate
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

par.last_track_count = -1
function par.updateThemeParameterRefreshRate()
    if par.last_track_count ~= reaper.CountTracks(0) then
        par.last_track_count = reaper.CountTracks(0)
        Part.Global.refresh_theme_rate = math.floor(reaper.CountTracks(0) / Part.Global.refresh_theme_rate_threshold)
    end
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Theme Parameter
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
par.ThemeParameter = Part.Parameter.Parameter:new()

par.theme_parameter_by_name = {}

function par.ThemeParameter:new(o, lookup_name, buffered, store)
    -- check if parameter is available using its lookup name, print error if missing
    if Part.Parameter.Lookup.theme_par_lookup[lookup_name] == nil then
        reaper.ShowConsoleMsg('Missing Theme Parameter "' .. lookup_name .. '"\n')
    end

    -- get theme parameter values
    local retval, desc, value, defValue, minValue, maxValue =
        reaper.ThemeLayout_GetParameter(Part.Parameter.Lookup.theme_par_lookup[lookup_name])

    -- create parent object, passing values
    o = o or Part.Parameter.Parameter:new(o, lookup_name, defValue, minValue, maxValue, true)
    setmetatable(o, self)
    self.__index = self

    -- theme parameter index number
    o.index = Part.Parameter.Lookup.theme_par_lookup[lookup_name]

    -- lookup name
    o.lookup_name = lookup_name

    -- mark parameter as group
    o.is_group = false

    -- register parameter for lookup
    par.theme_parameter_by_name[lookup_name] = o

    -- description
    o.description = desc

    -- buffered processing (don't apply values immediately)
    o.buffered = false

    -- timestamp, used for buffering
    o.timestamp = 0

    -- any nonging buffering?
    o.buffer_to_process = false

    -- buffer time
    o.timeout = 20

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

    return o
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Theme Parameter : Reset
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function par.ThemeParameter:reset()
    self:setValue(self.value_default)
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Theme Parameter : Get Value
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function par.ThemeParameter:getValue()
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

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Theme Parameter : Set Value
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function par.ThemeParameter:setValue(value)
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

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Theme Parameter : Buffer
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function par.ThemeParameter:buffer()
    -- buffer is active and enough time has passed?
    if self.buffer_to_process and Part.Global.ticks > self.timestamp then
        -- set theme paremeter
        reaper.ThemeLayout_SetParameter(self.index, self.value, true)
        Part.Functions.refreshTheme()

        -- disable buffering
        self.buffer_to_process = false
    end
end

return par
