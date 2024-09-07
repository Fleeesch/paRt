-- @version 1.1.7
-- @author Fleeesch
-- @description paRt Theme Adjuster
-- @noIndex



local cursor = {}

--  Cursor Defaults
-- -------------------------------------------

cursor.cursor_default_top = 60
cursor.cursor_default_left = 0
cursor.cursor_default_group_width = 270
cursor.cursor_default_pad = 4
cursor.cursor_default_row_height = 14
cursor.cursor_default_group_pad_x = 16

--  Initialization
-- -------------------------------------------

cursor = {}

cursor.index = 1

cursor[cursor.index] = {
    x = 0,
    y = 0,
    w = 0,
    h = 0,
    pad_x = 0,
    pad_y = 0
}

--  Method : Apply Cursor to Target
-- -------------------------------------------

function cursor.applyCursorToTarget(o)
    -- transfer cursor dimensions to target element
    o.dim_x = cursor.getCursorX()
    o.dim_y = cursor.getCursorY()
    o.dim_w = cursor.getCursorW()
    o.dim_h = cursor.getCursorH()
end

--  Method : Reset Cursor for Drawing Area
-- -------------------------------------------

function cursor.resetCursor(top, left, center, group_count)
    -- load default values
    local x = cursor.getCursorX()
    local y = cursor.getCursorY()
    local w = cursor.cursor_default_group_width
    local h = cursor.cursor_default_row_height
    local pad_x = cursor.cursor_default_pad
    local pad_y = cursor.cursor_default_pad
    local pad_grp = cursor.cursor_default_group_pad_x

    -- top alignment
    if top ~= nil and top then
        y = cursor.cursor_default_top
    end

    -- left alignment
    if left ~= nil and left then
        x = cursor.cursor_default_left
    end

    -- assume there's only one group
    local count = 1

    -- use optional group count if greater than 1
    if group_count ~= nil and group_count > 1 then
        count = group_count
    end

    -- x position centering
    if center then
        if count <= 1 then
            x = math.floor((Part.Global.win_w - w) / 2)
        else
            x = math.floor((Part.Global.win_w - (w + pad_x + pad_grp) * count) / 2 - pad_grp / 2)
        end
    end

    -- set cursor
    cursor.setCursor(x, y, w, h, pad_x, pad_y)
end

--  Method : Getters
-- -------------------------------------------

-- x
function cursor.getCursorX()
    return cursor[cursor.index].x
end

-- y
function cursor.getCursorY()
    return cursor[cursor.index].y
end

-- w
function cursor.getCursorW()
    return cursor[cursor.index].w
end

-- h
function cursor.getCursorH()
    return cursor[cursor.index].h
end

-- pad x
function cursor.getCursorPadX()
    return cursor[cursor.index].pad_x
end

-- pad y
function cursor.getCursorPadY()
    return cursor[cursor.index].pad_y
end


--  Method : Set Cursor Position
-- -------------------------------------------

function cursor.setCursorPos(pos_x, pos_y)
    -- x position
    if pos_x ~= nil then
        gfx.x = pos_x
        cursor[cursor.index].x = pos_x
    end

    -- y position
    if pos_y ~= nil then
        gfx.y = pos_y
        cursor[cursor.index].y = pos_y
    end
end

--  Method : Stack
-- -------------------------------------------

function cursor.stackCursor()
    -- increment cursor index
    cursor.index = cursor.index + 1

    -- table for next cursor stack
    cursor[cursor.index] = {}

    -- copy previous cursor values
    for i, v in pairs(cursor[cursor.index - 1]) do
        cursor[cursor.index][i] = v
    end
end


--  Method : De-Stack
-- -------------------------------------------

function cursor.destackCursor()
    -- decrement cursor index
    cursor.index = cursor.index - 1

    -- keep above 0
    cursor.index = math.max(cursor.index, 1)
end


--  Method : Set Cursor Size
-- -------------------------------------------

function cursor.setCursorSize(size_w, size_h)
    -- width
    if size_w ~= nil then
        cursor[cursor.index].w = size_w
    end

    -- height
    if size_h ~= nil then
        cursor[cursor.index].h = size_h
    end
end


--  Method : Set Cursor
-- -------------------------------------------

function cursor.setCursor(pos_x, pos_y, size_w, size_h, pad_x, pad_y)
    -- position
    cursor.setCursorPos(pos_x, pos_y)

    -- size
    cursor.setCursorSize(size_w, size_h)

    -- padding
    cursor.setCursorPadding(pad_x, pad_y)
end


--  Method : Set Cursor Padding
-- -------------------------------------------

function cursor.setCursorPadding(pad_x, pad_y)
    -- horizontal padding
    if pad_x ~= nil then
        cursor[cursor.index].pad_x = pad_x
    end

    -- vertical padding
    if pad_y ~= nil then
        cursor[cursor.index].pad_y = pad_y
    end
end


--  Method : Increment Cursor
-- -------------------------------------------

function cursor.incCursor(inc_x, inc_y, pad_or_x, pad_or_y)
    -- get padding
    local pad_x = cursor[cursor.index].pad_x
    local pad_y = cursor[cursor.index].pad_y

    -- overwrite horizontal padding
    if pad_or_x ~= nil then
        pad_x = pad_or_x
    end

    -- overwrite vertical padding
    if pad_or_y ~= nil then
        pad_y = pad_or_y
    end

    -- increment x
    if inc_x > 0 then
        inc_x = inc_x + pad_x
    elseif inc_x < 0 then
        inc_x = inc_x - pad_x
    end

    -- increment y
    if inc_y > 0 then
        inc_y = inc_y + pad_y
    elseif inc_y < 0 then
        inc_y = inc_y - pad_y
    end

    -- set cursor position
    cursor.setCursorPos(cursor[cursor.index].x + inc_x, cursor[cursor.index].y + inc_y)
end

return cursor