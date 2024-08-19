-- @version 1.1.6
-- @author Fleeesch
-- @description paRt Theme Adjuster
-- @noIndex



local functions = {}


--  Method : Check if String starts with a Phrase
-- ------------------------------------------------

function functions.stringStarts(String, Start)
    return string.sub(String, 1, string.len(Start)) == Start
end

--  Method : List Files in Folder
-- -------------------------------------------
function functions.listFilesInFolder(path, extension)
    reaper.EnumerateFiles(path, -1) -- Rescan
    local i = 0
    local file_list = {}

    -- enumerate files
    while reaper.EnumerateFiles(path, i) do
        local file_name = reaper.EnumerateFiles(path, i)

        -- extension filter
        if extension ~= nil then
            -- turn extension filter into table if necessary
            if type(extension) ~= "table" then
                extension = { extension }
            end

            -- collect matching files
            for key, val in pairs(extension) do
                if string.match(file_name, "%." .. val .. "$") then
                    table.insert(file_list, file_name)
                end
            end
        else
            -- collect files without filter
            table.insert(file_list, file_name)
        end

        i = i + 1
    end

    return file_list
end

--  Method : Deep Merge
-- -------------------------------------------
function functions.deepMerge(table_a, table_b)
    for key, value in pairs(table_a) do
        if type(value) == "table" and table_b[key] and type(table_b[key]) == "table" then
            functions.deepMerge(value, table_b[key])
        else
            table_b[key] = table_b[key] or value
        end
    end
end

--  Method : Deep Copy
-- -------------------------------------------
function functions.deepCopy(orig)
    local orig_type = type(orig)
    local copy

    -- check if entry is table in order to trigger recursion
    if orig_type == 'table' then
        copy = {}

        for orig_key, orig_value in next, orig, nil do
            copy[functions.deepCopy(orig_key)] = functions.deepCopy(orig_value)
        end

        setmetatable(copy, functions.deepCopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end

    return copy
end

--  Method : Text Block
-- -------------------------------------------

function functions.textBlock(input_txt, char_limit)
    -- return table
    local out = {}

    -- line string
    local line = ""

    -- cahracter count and per-line-limit
    local char_count = 0
    local char_max = char_limit or 20

    -- go trough words
    for word in input_txt:gmatch("%S+") do
        -- increment character count
        char_count = char_count + string.len(word)

        -- transform linebreaks into extra lines, using a [Linebreak] markdown entry
        if word == "\\n" then
            char_count = 0
            table.insert(out, line)
            table.insert(out, "[Linebreak]")
            line = ""
        else
            -- insert a new line when character count has been reached
            if char_count > char_max then
                char_count = 0
                table.insert(out, line)
                line = ""
            end

            -- add word to line
            line = line .. word .. " "
        end
    end

    -- add remainder of line if available
    if line ~= "" then
        table.insert(out, line)
    end

    -- return table containing ordered lines
    return out
end

--  Method : Refresh Theme
-- -------------------------------------------
function functions.refreshTheme()
    Part.Global.refresh_theme = true
end

--  Method : Handle Theme Refresh
-- -------------------------------------------

function functions.handleThemeRefresh()
    -- force a delay to prevent high-rate theme refresh
    if Part.Global.refresh_theme then
        if Part.Global.refresh_theme_clock > 0 then
            Part.Global.refresh_theme_clock = Part.Global.refresh_theme_clock - 1
            return
        end

        if Part.Global.refresh_theme_clock == 0 then
            reaper.ThemeLayout_RefreshAll()
            Part.Global.refresh_theme = false

            Part.Global.refresh_theme_clock = Part.Global.refresh_theme_rate
        end
    end
end

--  Method : Extract Extension
-- -------------------------------------------

function functions.extractExtension(path)
    local _, _, extension = string.find(path, "%.([^%.]+)$")

    return extension
end

--  Method : Extract Filename
-- -------------------------------------------
function functions.extractFileName(path)
    -- normalized path
    local normalizedPath = path:gsub("\\", "/")

    -- get filename
    local fileName = normalizedPath:match("/([^/]+)$")

    -- return filename
    return fileName
end

--  Method : Cap
-- -------------------------------------------
function functions.cap(value, v_min, v_max)
    return math.min(math.max(value, v_min), v_max)
end

--  Method : Map
-- -------------------------------------------
function functions.map(x, in_min, in_max, out_min, out_max)
    return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
end

--  Method : Interpolate
-- -------------------------------------------

function functions.interpolate(val_a, val_b, factor)
    -- interpolate between two values based on factor
    return val_a + (val_b - val_a) * factor
end

--  Method : Rescale
-- -------------------------------------------

function functions.rescale(value, center_x, center_y)
    -- rescale value using global scaling factor
    if center_x ~= nil and center_x then
        return math.floor((value + Part.Global.win_x_offset_centered) * Part.Global.scale)
    end

    if center_y ~= nil and center_y then
        return math.floor((value + Part.Global.win_y_offset_centered) * Part.Global.scale)
    end

    return math.floor(value * Part.Global.scale)
end

--  Method : Print
-- -------------------------------------------

function functions.print(...)
    -- print console message
    for key, val in pairs({ ... }) do
        reaper.ShowConsoleMsg(tostring(val) .. "\n")
    end
end

return functions
