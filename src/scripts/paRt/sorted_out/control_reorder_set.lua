local control = {}

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Reset Reorder Set
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function control.resetReorderSet(index)
    -- reset reorder-set based on index from list
    Part.List.control_reorder_set[index]:reset()
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Reorder Set
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

control.ReorderSet = {}

function control.ReorderSet:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    -- reorder element
    o.reorder = {}

    -- unsorted reorder elements
    o.reorder_unsorted = {}

    -- pending reorder-actions
    o.pending_entry_move = {}

    -- add to list
    table.insert(Part.List.control_reorder_set, o)

    return o
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Reorder Set : Reload
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.ReorderSet:reload()
    for key, val in pairs(self.reorder) do
        val.index = val.parameter:getValue()
    end

    -- reset index if required
    if self:badIndex() then
        self:reset()
    end

    self:update()
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Reorder Set : Process Pending Entry Moves
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.ReorderSet:processPendingEntryMoves()
    -- go through pending reorder-actions
    for key_move, val_move in pairs(self.pending_entry_move) do
        -- get element and direction
        local element = val_move[1]
        local up = val_move[2]

        -- potential swap-candidate
        local swap_element

        -- go through registered reorder-elements
        for key, val in pairs(self.reorder) do
            -- element matches?
            if val == element then
                -- find neighbours
                if up then
                    swap_element = self.reorder[key - 1]
                else
                    swap_element = self.reorder[key + 1]
                end
            end
        end

        -- swap-candidate found?
        if swap_element ~= nil then
            -- mark reorder as a success
            element:reorderSuccess()

            -- swap index of elements
            local tmp_idx = element.index
            element.index = swap_element.index
            swap_element.index = tmp_idx

            -- update reorder-set
            self:update()
        end
    end

    -- empty pending entry lists
    self.pending_entry_move = {}
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Reorder Set : Add Reorder
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.ReorderSet:addReorder(element)
    -- add reorder element to list
    table.insert(self.reorder, element)
    table.insert(self.reorder_unsorted, element)

    -- return the reorder count
    return #self.reorder
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Reorder Set : Reset
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.ReorderSet:reset()
    -- go through reorder elements, reset their index values
    for k, v in pairs(self.reorder) do
        v:resetIndex()
    end

    -- update reorder-set
    self:update()

    Part.Draw.Buffer.clearCompleteBuffer()
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Reorder Set : Check for bad index
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.ReorderSet:badIndex()
    -- go through reorder elements
    for k, v in pairs(self.reorder) do
        -- index is beyond number of reorder element?
        if v.index > #self.reorder then
            return true
        end

        -- check if index is 0
        if v.index == 0 then
            -- index-reset required
            return true
        else
            -- go through reorder elemenets again
            for k2, v2 in pairs(self.reorder) do
                -- any duplicate index numbers?
                if k ~= k2 and v.index == v2.index then
                    -- index-reset required
                    return true
                end
            end
        end
    end

    return false
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Reorder Set : Init
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.ReorderSet:init()
    -- go through reorder-elements, calibrate y-offset
    for k, v in pairs(self.reorder) do
        v:rebaseOffsets()
    end

    -- reset index if required
    if self:badIndex() then
        self:reset()
    end

    -- update reorder-set
    self:update()
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Reorder Set : Move Entry
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.ReorderSet:moveEntry(element, up)
    -- add pending reorder action
    table.insert(self.pending_entry_move, { element, up })
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Reorder Set : Update
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.ReorderSet:update()
    Part.Draw.Buffer.clearCompleteBuffer()

    -- temporary reorder-array
    local temp = {}
    -- iterate reorder-element range
    for i = 1, #self.reorder do
        -- go through reorder-elements
        for k, v in pairs(self.reorder) do
            -- found a matching index? add to list
            if i == v.index then
                table.insert(temp, v)
            end
        end
    end

    -- swap reorder list with new, organized one
    self.reorder = temp

    -- go through reorder-elements
    for k, v in pairs(self.reorder) do
        -- calculate y-offset
        local y_off = self.reorder_unsorted[v.index].base_y - self.reorder_unsorted[v.original_index].base_y

        -- apply y-offset to element
        v:applyOffset(y_off)
    end
end

return control