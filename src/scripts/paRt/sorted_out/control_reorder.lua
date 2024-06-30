local control = {}

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Reorder
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
control.Reorder = Part.Control.Control:new()

reorder_in_progress = false

function control.Reorder:new(o, set, parameter)
    o = o or Part.Control.Control:new(o, parameter)
    setmetatable(o, self)
    self.__index = self

    -- transfer cursor dimensions
    Part.Cursor.applyCursorToTarget(o)

    -- elements included in the reorder, multi-dimensional {element, y-position}
    o.elements = {}

    -- reorder set (collective of reorders)
    o.set = set

    -- add reorder to set, store the current index
    o.original_index = o.set:addReorder(o)

    -- initially use original index
    o.index = o.original_index

    -- base y position uses the current y position
    o.base_y = self.dim_y

    -- y position offset
    o.offset = 0

    -- highlight fx
    o.highlight = 0

    o.color_fg = Part.Functions.deepCopy(Part.Color.color_palette.reorder.fg)
    o.color_fg_hover = Part.Functions.deepCopy(Part.Color.color_palette.reorder.fg_hover)

    -- parameter given?
    if parameter ~= nil then
        -- use index from parameter value
        o.index = parameter:getValue()
    end

    -- register in lists
    table.insert(Part.List.control, o)
    table.insert(Part.List.control_reorder, o)

    return o
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Reorder : Add Elements
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Reorder:addElements(elements)

    -- go through elements
    for k, v in pairs(elements) do

        -- add element with their y position to table
        table.insert(self.elements, {v, v.dim_y})

    end

end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Reorder : Reset Index
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Reorder:resetIndex()
    -- use original index
    self.index = self.original_index
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Reorder : Reload Index
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Reorder:reloadIndex()
    -- get index from parameter value
    self.index = self.parameter:getValue()
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Reorder : Rebase Offsets
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Reorder:rebaseOffsets()

    -- go through elements
    for k, v in pairs(self.elements) do

        -- get element y-position
        local y = v[1].dim_y

        -- overwrite previous entry with original y-position
        self.elements[k] = {v[1], v[1].dim_y}

    end

    -- overwrite base y-position
    self.base_y = self.dim_y

end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Reorder : Apply Offsets
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Reorder:applyOffset(val)

    -- use its own offset value if none is given
    if val == nil then
        val = self.offset
    end

    -- update offset value
    self.offset = val

    -- go through elements
    for k, v in pairs(self.elements) do

        -- update position by using its base y-position + the new offset 
        v[1].dim_y = v[2] + self.offset

    end

    -- update y-position of reorder element
    self.dim_y = self.base_y + self.offset

end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Reorder : Reorder Success
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Reorder:reorderSuccess()
    -- activate highlight fx when reorder was successfull 
    self.highlight = 1

    Part.Draw.Buffer.clearCompleteBuffer()
    
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Reorder : Draw
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Reorder:draw()
    
    -- calculate dimensions
    local x = Part.Functions.rescale(self.dim_x)
    local y = Part.Functions.rescale(self.dim_y)
    local w = Part.Functions.rescale(self.dim_w)
    local h = Part.Functions.rescale(self.dim_h)
    
    -- colors
    local color_fg = self.color_fg
    local color_fg_hover = self.color_fg_hover

    -- get size of arrow
    local size = Part.Functions.rescale(6)

    -- half the width
    local w2 = math.floor(w / 2)

    -- get color of arrow
    local color_arrow = {color_fg, color_fg}

    -- highlight active?
    if self.highlight > 0 then

        -- get highlight factor
        local lighten = self.highlight

        -- lighten the arrow colors
        color_arrow[1] = lightenColor(color_arrow[1], lighten)
        color_arrow[2] = lightenColor(color_arrow[2], lighten)

        -- decrement highlight value
        self.highlight = self.highlight - 0.1
    end

    -- mouse within left arrow?
    if mouseInRect(x, y, w2, h) then

        -- pick hover color
        color_arrow[1] = color_fg_hover

        -- mouse within right arrow?
    elseif mouseInRect(x + w2, y, w2, h) then

        -- pick hover color
        color_arrow[2] = color_fg_hover

    end

    -- reorder is not in progress and mouse is clicked?
    if not reorder_in_progress and mouse.l_click then

        -- mouse within left arrow?
        if mouseInRect(x, y, w2, h) then

            -- activate reorder process
            reorder_in_progress = true

            -- tirgger a reorder action
            self.set:moveEntry(self, false)

            -- mouse within right arrow?
        elseif mouseInRect(x + w2, y, w2, h) then
                
            -- activate reorder process
            reorder_in_progress = true

            -- tirgger a reorder action
            self.set:moveEntry(self, true)

        end
    end

    -- draw arrows
    drawArrow(x, y, w2, h, 3, size, color_arrow[1])
    drawArrow(x + w2, y, w2, h, 1, size, color_arrow[2])

    -- update parameter with new position 
    self.parameter:setValue(self.index)
    -- mouse is not pressed?
    if not mouse.l_on then

        -- deactivate reorder progress
        reorder_in_progress = false
    end
end

return control