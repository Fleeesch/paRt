local draw = {}

-- last element created
draw.last_element = nil

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Set last Element
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function draw.setLastElement(e)
    draw.last_element = e
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Get last Element
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function draw.lastElement()
    -- return last element
    return draw.last_element
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Prepare Elements
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function draw.prepareElements()
    local element_lists = { Part.List.tab_group, Part.List.control, Part.List.control_hint }

    for i = 1, #element_lists do
        for z = 1, #element_lists[i] do
            element_lists[i][z]:prepare()
        end
    end
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Filter Visible Elements
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function draw.filterVisibleElements()
    Part.List.visible_elements = {}
    Part.List.visible_layout = {}
    Part.List.visible_layout_redraw = {}
    Part.List.visible_control = {}
    Part.List.visible_control_hint = {}

    local element_lists = { Part.List.layout, Part.List.layout_redraw, Part.List.control, Part.List.control_hint }

    local visible_lists = { Part.List.visible_layout, Part.List.visible_layout_redraw, Part.List.visible_control, Part
        .List.visible_control_hint }

    for i = 1, #element_lists do
        for z = 1, #element_lists[i] do
            if element_lists[i][z]:tabCheck() then
                table.insert(visible_lists[i], element_lists[i][z])
                table.insert(Part.List.visible_elements, element_lists[i][z])
            end
        end
    end

    Part.Global.update_visible_elements = false
end

return draw
