-- @version 1.3.2
-- @author Fleeesch
-- @description paRt Theme Adjuster
-- @noIndex

--[[
    Version Handling.

    The theme files themselves and the Theme Adjuster all have individiually set version numbers.
    The theme version number is stored in the WALTER code,
    while the Theme Adjuster needs to call "setVersion" to set its version manually.

    The metadata at the top of the LUA files can safely be ignored
    because it is entirely reserved for ReaPack.

    [Version Naming]
    There is no dogma for naming paRt versions,
    but the safe way would be:

    "1.2.3"

    One can theoretically use even more digits and include letters.
    An algorithm takes care of translating the version string into a numeric value
    that is then used for version comparisons.

    [Version Changes]
    There's a very crude implementation of applying legacy fixes implemented
    in the version handling, but it's not extensive enough to be considered fail-safe.

    [Remote Version Check]
    The Theme Adjuster uses "curl" for loding the contents of a version info file
    from a remote server. It is really just a short string containing the current version
    of the theme.

    Curl should be available on all operating systems and is in this case
    designed to be launched in the background without a fixed timeout.
    Otherwise it would block the Theme Adjuster during it's initial loading phase
    for several seconds if there is no internet connection available.

    The remote version is only requested once per Reaper launch.
    It's the simplest solution for prevent unnecessary web traffic.
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

version.remote_version_link = "https://raw.githubusercontent.com/Fleeesch/ReaPack-Fleeesch/refs/heads/master/themes/paRt/version"
version.remote_version_filepath = Part.Global.config_dir .. "/remote_version"

-- remote version gets checked at least once per startup
version.remote_version_check = 1

-- 2000 frames of timeout for the remote version curl request
version.remote_version_check_timeout = 2000

local ext_section = "Fleeesch - paRt Theme Adjuster"
local ext_key_remote_version = "Remote Version Request"

version.new_version_available = false

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

--  Method : Initialize Remote Version Check
-- -------------------------------------------

function version.initializeRemoteVersionCheck()
    -- check if a previous version already happened
    if not reaper.HasExtState(ext_section, ext_key_remote_version) then
        -- figure out if curl is there by launching it
        local curlRequest = reaper.ExecProcess("curl -V", 100)

        -- filter first line, check if there was an error
        local curlRequestValue = tonumber(curlRequest:match("^(%d+)"))
        local curlAvailable = curlRequestValue == 0

        -- if curl is available request the remote version number to be stored into a file
        if curlAvailable then
            -- clear remote version file if it exists to avoid false positives
            -- local file = io.open(version.remote_version_filepath, "w")
            -- if file then
            --     file:write("")
            --     file:close()
            -- end

            -- request remote version file content to be stored to a local file
            reaper.ExecProcess(
                'curl -fsSL "' ..
                version.remote_version_link ..
                '" -o "' ..
                version.remote_version_filepath ..
                '"'
                , -2)

            -- process happens in the background with a timeout
            version.remote_version_check = version.remote_version_check_timeout;
        end
    end
end

--  Method : Remote Version Check
-- -------------------------------------------

function version.remoteVersionCheck()
    -- try opening remote version file
    local filepath = version.remote_version_filepath
    local file = io.open(filepath, "r")

    -- file needs to be there
    if file then
        -- read the file content
        local content = file:read("*all")
        file:close()

        if #content > 0 then
            reaper.SetExtState(ext_section, ext_key_remote_version, "request used", false)
            -- get the current theme version
            Part.Version.getThemeVersion()

            -- convert numeric version values with each other and store the results
            local remoteVersionNumeric = version.getNumericVersionValue(content)
            version.new_version_available = remoteVersionNumeric > version.version_theme_value

            -- background needs to be redrawn if a new version is available
            -- in order to show the hint message
            if version.new_version_available then
                Part.Draw.Buffer.clearCompleteBuffer()
            end

            -- no need for further checks
            version.remote_version_check = 0
            return
        end
    end

    -- decrement timeout counter
    version.remote_version_check = version.remote_version_check - 1
end

return version
