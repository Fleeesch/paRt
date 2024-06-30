local draw = {}

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Method : Set Current Control Section
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function setCurrentControlSection(s)
    current_control_section = s
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Method : Get Current Control Section
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function getCurrentControlSection()
    return current_control_section
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- OOP : Control Section
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

current_control_section = nil

ControlSection = {
    dim_x = 0,
    dim_y = 0,
    dim_w = 100,
    dim_h = 20,
    value = 0
}

function ControlSection:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    o.tab = nil

    if Part.Tab.Entry.getRecentTab() ~= nil then
        o.tab = Part.Tab.Entry.getRecentTab()
    end

    o.spacer_height = 4

    o.current_set = {}
    o.data = {}

    o.options = {}

    setCurrentControlSection(o)

    return o
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- OOP : Control Section : Get Current Seet
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ControlSection:initSet()
    self.current_set = {}
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- OOP : Control Section : Add to Set
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ControlSection:addToSet(element)
    table.insert(self.current_set, element)
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- OOP : Control Section : Add Row
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ControlSection:addRow()
    table.insert(self.data, self.current_set)
    self:initSet()
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- OOP : Control Section : Add Spacer
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ControlSection:addSpacer(colspan,ignore_cols)
    Spacer:new(nil,colspan,ignore_cols)
    self:addRow()
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- OOP : Control Section : Add Option
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ControlSection:addOption(key, value)
    self.options[key] = value
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- OOP : Control Section : Add Options
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ControlSection:addOptionTable(keys)
    for k, v in pairs(keys) do
        self.options[k] = v
    end
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Apply Control Section
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ControlSection:apply()
    Part.Cursor.stackCursor()

    local options = self.options
    local data = self.data

    local max_x = 0
    local idx_y = 0
    local box_w = Part.Cursor.getCursorW()
    local column_w = {}
    local column_w_auto = true
    local group

    local filler_w_min = 0

    -- get max entry count
    local max_count = 0

    -- box

    if options["box"] ~= nil then
        group = Group:new(nil)

        if options["label"] ~= nil then
            group:open(options["label"])
        else
            group:open()
        end
    end

    -- calculate columns

    if options["cols"] ~= nil then
        column_w_auto = false

        -- get fill-in fraction

        filler_w_min = 0
        local filler_count = 0

        for key, val in pairs(options["cols"]) do
            if val == 0 then
                filler_count = filler_count + 1
            end

            if val > 0 then
                filler_w_min = math.min(filler_w_min + val, 1)
            end
        end


        for key_y, val_y in pairs(data) do
            local idx_x = 0

            for key_x, val_x in pairs(val_y) do
                idx_x = idx_x + 1
                max_count = math.max(max_count + 1, idx_x)
            end
        end

        -- calculate sizes
        for i = 1, max_count do
            if options["cols"][math.min(i, #options["cols"])] == 0 then
                column_w[i - 1] = math.floor(box_w * (1 - filler_w_min) / filler_count)
            else
                column_w[i - 1] = math.floor(box_w * options["cols"][math.min(i, #options["cols"])])
            end
        end
    end

    -- rows

    for key_y, val_y in pairs(data) do
        local spacer = false

        local idx_x = 0

        local row_x1 = Part.Cursor.getCursorX()
        local row_y1 = Part.Cursor.getCursorY()
        local row_x2 = 0
        local row_y2 = 0

        Part.Cursor.stackCursor()

        -- columns

        for key_x, val_x in pairs(val_y) do
            Part.Cursor.stackCursor()

            if val_x.is_spacer ~= nil and val_x.is_spacer then
                spacer = true
            end

            local size = Part.Cursor.getCursorW()

            -- get width
            if column_w_auto or val_x.ignore_cols then
                size = math.floor(box_w / #val_y)
            else
                size = column_w[math.min(idx_x, #column_w)]
            end

            -- column span
            if val_x.colspan ~= nil then
                local idx_col = idx_x

                for i_col = 2, val_x.colspan do
                    if column_w_auto or val_x.ignore_cols then
                        size = size + math.floor(box_w / #val_y)
                    else
                        local idx = math.min(#column_w, idx_col + i_col - 1)
                        size = size + column_w[idx]
                    end

                    idx_x = idx_x + 1
                end
            end


            -- remove pad from width
            Part.Cursor.setCursorSize(size - Part.Cursor.getCursorPadX())

            -- transfer dimensional data
            if val_x ~= nil then
                val_x.dim_x = Part.Cursor.getCursorX()
                val_x.dim_y = Part.Cursor.getCursorY()
                val_x.dim_w = Part.Cursor.getCursorW()
                val_x.dim_h = Part.Cursor.getCursorH()
            end

            Part.Cursor.destackCursor()

            --if idx_x + 1 >= max_count then
            --    Part.Cursor.setCursorPadding(0)
            --end

            Part.Cursor.incCursor(val_x.dim_w, 0)

            max_x = math.max(max_x, Part.Cursor.getCursorX())

            idx_x = idx_x + 1
        end

        -- > columns

        local row_x2 = Part.Cursor.getCursorX()
        local row_y2 = Part.Cursor.getCursorY() + Part.Cursor.getCursorH()

        if group ~= nil then
            group:addRow(row_x1, row_y1, row_x2, row_y2)
        end

        Part.Cursor.destackCursor()

        if idx_y + 1 >= #data then
            Part.Cursor.setCursorPadding(Part.Cursor.getCursorPadX(), 0)
        end

        -- spacer or y-increment
        if spacer then
            val_y[1].dim_h = self.spacer_height
            Part.Cursor.incCursor(0, self.spacer_height)
        else
            Part.Cursor.incCursor(0, Part.Cursor.getCursorH())
        end

        idx_y = idx_y + 1
    end

    -- > rows

    local max_x = max_x
    local max_y = Part.Cursor.getCursorY()

    if group ~= nil then
        Part.Cursor.stackCursor()

        if options["hint"] ~= nil then
            group:addHint(options["hint"])
        end

        if options["sync_parameter"] ~= nil then
            group:addSyncButton(options["sync_parameter"])
        end

        if options["tint"] ~= nil then
            group:setTint(options["tint"])
        end

        Part.Cursor.setCursorPos(max_x, max_y)
        group:close(false, false)

        if options["row_shading"] ~= nil and options["row_shading"] then
            group:applyRowShading(options["row_shading_depth"], options["row_shading_alternate"],
                options["row_shading_offset"], options["row_shading_expand"], options["row_shading_mask"])
        end

        Part.Cursor.destackCursor()
    end

    Part.Cursor.destackCursor()

    if options["increment_x"] ~= nil and options["increment_x"] then
        Part.Cursor.setCursorPos(max_x, Part.Cursor.getCursorY())
        Part.Cursor.incCursor(14, 0)
    end

    if options["increment_y"] ~= nil and options["increment_y"] then
        Part.Cursor.setCursorPos(Part.Cursor.getCursorX(), max_y)
        Part.Cursor.incCursor(0, 14)
    end
end

return draw