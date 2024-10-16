-- @version 1.2.1
-- @author Fleeesch
-- @description paRt Theme Adjuster
-- @noIndex



local version = {}


--  Variables
-- -------------------------------------------

-- internal version of adjuster script (for version handling)
version.version_adjuster = ""

-- paRt version
version.version_theme = ""
version.version_theme_is_dev = false


--  Method : Set Script Version
-- -------------------------------------------

function version.setVersion(version_nr)
    version.version_adjuster = version_nr
    version.getThemeVersion()
    version.handleVersionDifference()
end

--  Method : Theme Version is Valid
-- -------------------------------------------

function version.themeVersionIsValid()
    -- theme version must exist and be above 0
    return version.version_theme_is_dev or (version.version_theme ~= nil and #version.version_theme > 0)
end

--  Method : Get Theme Version
-- -------------------------------------------

function version.getThemeVersion()
    -- get first theme parameter


    local retval, desc, value, defValue, minValue, maxValue = reaper.ThemeLayout_GetParameter(0)

    if desc == nil then
        version.version_theme = ""
        return
    end


    if Part.Functions.stringStarts(desc, "paRt Theme") then
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

    return version.version_theme
end

--  Method : Compare Versions
-- -------------------------------------------

function version.compareVersions(version1, version2)
    local function splitVersion(version)
        local parts = {}
        for part in version:gmatch("([^.]+)") do
            table.insert(parts, tonumber(part))
        end
        return parts
    end

    local v1 = splitVersion(version1)
    local v2 = splitVersion(version2)

    for i = 1, math.max(#v1, #v2) do
        local part1 = v1[i] or 0
        local part2 = v2[i] or 0
        if part1 < part2 then
            return version2
        elseif part1 > part2 then
            return version1
        end
    end

    return "Equal"
end

--  Method : Detect Version Difference
-- -------------------------------------------

function version.handleVersionDifference()
    if version.version_theme ~= version.version_adjuster then
        local version_latest = version.compareVersions(version.version_theme, version.version_adjuster)

        -- Theme Adjuster has a lower version
        if version_latest == version.version_theme then
        end

        -- Theme Adjuster has a higher version
        if version_latest == version.version_adjuster then
        end
    end
end

return version
