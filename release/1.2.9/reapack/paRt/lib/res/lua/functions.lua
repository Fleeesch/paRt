-- @version 1.2.9
-- @author Fleeesch
-- @description paRt Theme Adjuster
-- @noIndex

--[[
    Various functions to help out with calculations, data management and string conversions.
    A little toolkit that can be used everywhere.
]]

local functions = {}

--  Method : Print
-- ------------------------------------------------
function print(data)
    reaper.ShowConsoleMsg(tostring(data) .. "\n")
end

--  Method : Print Table to Console
-- ------------------------------------------------

function printTableToConsole(table, indent)
    indent = indent or ""
    for k, v in pairs(table) do
        local key = tostring(k)
        if type(v) == "table" then
            reaper.ShowConsoleMsg(indent .. key .. ":\n")
            functions.printTableToConsole(v, indent .. "  ")
        else
            reaper.ShowConsoleMsg(indent .. key .. " = " .. tostring(v) .. "\n")
        end
    end
end

--  Method : Check if String starts with a Phrase
-- ------------------------------------------------

function functions.stringStarts(String, Start)
    return string.sub(String, 1, string.len(Start)) == Start
end

--  Method : Get File Name from Path
-- -------------------------------------------

function functions.getFileNameFromPath(path)
    -- last element
    local name = path:match("([^/\\]+)$")

    -- split name and extension
    local base, ext = name:match("^(.*)%.([^%.]+)$")
    return base or name, ext or ""
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

    if extension == nil then
        return ""
    end

    return extension
end

--  Method : Extract Filename
-- -------------------------------------------
function functions.extractFileName(path)
    -- normalized path
    local normalizedPath = path:gsub("\\", "/")

    -- get filename
    local fileName = normalizedPath:match("/([^/]+)$")

    if fileName == nil then
        return ""
    end

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

--  Method : Print
-- -------------------------------------------

function functions.match_array(value, array)
    local closest = array[1]
    local min_diff = math.abs(value - closest)

    for i = 2, #array do
        local diff = math.abs(value - array[i])
        if diff < min_diff then
            closest = array[i]
            min_diff = diff
        end
    end

    return closest
end

--  Method : Wrap Text block
-- -------------------------------------------
function functions.wrap_text_block(input_string, width_limit, font_size, font_flags)
    font_flags = font_flags or ""
    width_limit = width_limit or 200
    font_size = font_size or 12

    Part.Draw.Graphics.setFont(font_size, font_flags)
    local output_lines = {}
    local line = ""

    -- iterate words
    for word in input_string:gmatch("%S+") do
        -- handle words that extend width
        if gfx.measurestr(word) > width_limit then
            -- character-by-character splitting
            local chunk = ""
            for i = 1, #word do
                -- get character
                local character = word:sub(i, i)
                -- start a new line when added character exceeds width
                if gfx.measurestr(chunk .. character) > width_limit then
                    table.insert(output_lines, chunk)
                    chunk = character
                else
                    -- simply add character to form word
                    chunk = chunk .. character
                end
            end

            -- if there is any: add remaining text to output
            if chunk ~= "" then
                table.insert(output_lines, chunk)
            end
        else
            -- start with word if empty or append with space
            local target_string = word
            if line ~= "" then
                target_string = line .. " " .. word
            end

            -- words exceeds width limit
            if gfx.measurestr(target_string) > width_limit then
                table.insert(output_lines, line)
                line = word
            else
                line = target_string
            end
        end
    end

    -- add remaining line content if there is any
    if line ~= "" then
        table.insert(output_lines, line)
    end

    return output_lines
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

return functions
