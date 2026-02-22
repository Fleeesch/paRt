-- @version 1.2.7
-- @author Fleeesch
-- @description paRt Theme Adjuster
-- @noIndex

--[[
    Version Management.

    Is still very limited and only contains some basic legacy fixes.
]]

local version = {}


--  Variables
-- -------------------------------------------

-- internal version of adjuster script (for version handling)
version.version_adjuster = ""

-- paRt version
version.version_theme = ""
version.version_theme_is_dev = false

-- version nummeric values
version.version_theme_value = 0
version.version_adjuster_value = 0

-- initial fixes
version.universal_fixes_applied = false

-- version comparison results
version.theme_version_is_lower = false
version.theme_is_part = false

--  Method : Apply Legacy Fixes
-- -------------------------------------------

-- fixes based on configuration changes
-- no requirement for version comparison in this case

function version.applyLegacyFixes()
    --
    --      Helper Function : Correct Parameter Values of a Group
    -- ==============================================================
    local function set_parameter_group_value(parameter_group, condition_value, target_value)
        -- check if group has parameters
        if parameter_group.parameters ~= nil then
            -- detect necessary update
            local update_group = false

            -- iterate parameters
            for _, parameter in ipairs(parameter_group.parameters) do
                -- correct value
                if parameter.value == condition_value then
                    parameter.value = target_value
                    update_group = true
                end
            end

            -- set value again to refresh theme
            if update_group then
                parameter_group:setValue(nil, true)
            end
        end
    end

    -- ===============================================
    --  Fix : TCP Fader Placement
    -- ===============================================

    -- track
    if Part.Parameter.Map.par_tcp_track_fader_placement[1] ~= nil then
        set_parameter_group_value(Part.Parameter.Map.par_tcp_track_fader_placement[1], 1, 2)
    end

    -- master
    if Part.Parameter.Map.par_tcp_master_fader_placement[1] ~= nil then
        set_parameter_group_value(Part.Parameter.Map.par_tcp_master_fader_placement[1], 1, 2)
    end

    -- envcp
    if Part.Parameter.Map.par_tcp_envcp_value_mode[1] ~= nil then
        set_parameter_group_value(Part.Parameter.Map.par_tcp_envcp_value_mode[1], 2, 1)
    end

    version.universal_fixes_applied = true
end

--  Method : Set Script Version
-- -------------------------------------------

function version.setVersion(version_nr)
    version.version_adjuster = version_nr
    version.version_adjuster_value = version.getNumericVersionValue(version.version_adjuster)
    version.getThemeVersion()
    version.handleVersionDifference()
end

--  Method : Theme Version is Valid
-- -------------------------------------------

function version.themeVersionIsValid()
    -- theme version must exist and be above 0
    return version.version_theme_is_dev or
        (version.version_theme ~= nil and #version.version_theme > 0)
end

--  Method : Numeric Version from Version String
-- --------------------------------------------------

function version.getNumericVersionValue(version_string)
    local sum = 0
    local idx = 0
    local range = 10
    for number in version_string:gmatch("%d") do
        local value = (10 ^ range) * tonumber(number)

        sum = sum + value

        idx = idx + 1
        range = range - 1
        if range <= 0 then
            break
        end
    end
    return sum
end

--  Method : Get Theme Version
-- -------------------------------------------

function version.getThemeVersion()
    
    -- initially assume we're not dealing with a paRt theme
    version.theme_is_part = false

    -- get first theme parameter
    local retval, desc, value, defValue, minValue, maxValue = reaper.ThemeLayout_GetParameter(0)

    if desc == nil then
        version.version_theme = ""
        return
    end

    if Part.Functions.stringStarts(desc, "paRt Theme") then
        
        -- paRt theme detected if the version parameter is there
        version.theme_is_part = true

        local version_string = desc:match("v([0-9%.]+)")

        -- developer version exception
        if string.find(desc, "dev") or string.find(desc, "vdev") then
            version.version_theme_is_dev = true
            version.version_theme = "_DEV"
            -- actual version number available
        elseif version_string ~= nil and #version_string > 0 then
            version.version_theme_is_dev = false
            version.version_theme = version_string
        end
    else
        version.version_theme = ""
    end

    -- numeric value
    version.version_theme_value = version.getNumericVersionValue(version.version_theme)

    return version.version_theme
end

--  Method : Detect Version Difference
-- -------------------------------------------

function version.handleVersionDifference()
    -- default values
    version.theme_version_is_lower = false

    if version.version_theme ~= version.version_adjuster then
        -- Theme Adjuster has a lower version
        if version.version_theme_value > version.version_adjuster_value then
        end

        -- Theme Adjuster has a higher version
        if version.version_theme_value < version.version_adjuster_value then
            version.theme_version_is_lower = true
        end
    end

    -- universal fixes are always applied
    version.applyLegacyFixes()
end

return version
