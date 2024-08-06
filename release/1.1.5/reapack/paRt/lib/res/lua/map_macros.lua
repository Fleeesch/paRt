-- @version 1.1.5
-- @author Fleeesch
-- @description paRt Theme Adjuster
-- @noIndex



local map_macros = {}


-- Icons
-- --------------------------------------------------

map_macros.icons = {
    table = {
        visbility = "table_visible",
        separator = "table_padding",
        mixer_hide = "table_mixer_hide",
        fader_size = "table_fader_size",
        mcp_pan_layout_top = "table_mcp_pan_layout_top",
        mcp_pan_layout_strip = "table_mcp_pan_layout_strip",
        mcp_pan_layout_bottom = "table_mcp_pan_layout_bottom",
        mcp_fader_layout_knob = "table_mcp_fader_layout_knob",
        mcp_fader_layout_vert = "table_mcp_fader_layout_vert",
        mcp_fader_layout_horz = "table_mcp_fader_layout_horz",
        tcp_fader_layout_inline = "table_tcp_fader_layout_inline",
        tcp_fader_layout_separate = "table_tcp_fader_layout_separate",
        tcp_fader_layout_explode = "table_tcp_fader_layout_explode",
    },
    transport = {
        rewind = "transport_rewind",
        forward = "transport_forward",
        stop = "transport_stop",
        pause = "transport_pause",
        play = "transport_play",
        record = "transport_record",
        loop = "transport_repeat",
        automation = "transport_env",
        bpm = "transport_bpm",
        status = "transport_status",
        selection = "transport_selection"
    },
    track = {
        fx = "track_fx",
        infx = "track_infx",
        env = "track_env",
        mute = "track_mute",
        solo = "track_solo",
        io = "track_io",
        phase = "track_phase",
        mono = "track_mono",
        input = "track_input",
        recmode = "track_recmode",
        recarm = "track_recarm",
        recmon = "track_monitor"
    },
    envcp = {
        hide = "envcp_hide",
        bypass = "envcp_bypass",
        arm = "envcp_arm",
        mod = "envcp_mod",
        learn = "envcp_learn"
    },

}


-- Variables
-- --------------------------------------------------

map_macros.icon_alpha = 0.75

map_macros.pos_y_top = 55
map_macros.pos_x_left = 30

map_macros.line_h = 16
map_macros.slider_w = 75
map_macros.par_label_w = 50

map_macros.pad_x = 6
map_macros.pad_y = 6
map_macros.pad_group = 5

map_macros.bank_w = 14
map_macros.bank_h = 14

map_macros.knob_w = 16
map_macros.slider_w = 90

map_macros.group_pad_x = 10
map_macros.group_pad_y = 30

map_macros.button_percentage_w = 40
map_macros.button_large_w = 100
map_macros.button_select_w = 75

map_macros.par_label_w = 70

map_macros.table_icon_w = 30
map_macros.table_label_w = 50
map_macros.table_marker_w = 22

map_macros.label = nil

map_macros.last_group_dim = { 0, 0, 0, 0 }
map_macros.last_group = nil

map_macros.icon_path_root = "lib/res/icon"

map_macros.parameter_labels = {}

-- Function : Track Parameter Label
-- --------------------------------------------------

function map_macros.trackParameterLabel(element)
    table.insert(map_macros.parameter_labels, element)
end

-- --------------------------------------------------

function map_macros.getLastParameterLabel(history_index)
    if #map_macros.parameter_labels == 0 then
        return nil
    end

    if history_index == nil then
        history_index = 0
    end

    local index = math.max(1, #map_macros.parameter_labels - history_index)
    return map_macros.parameter_labels[index]
end

-- Function : Reset Cursor
-- --------------------------------------------------

function map_macros.resetCursor()
    Part.Cursor.setCursor(map_macros.pos_x_left, map_macros.pos_y_top, 10, map_macros.line_h, map_macros.pad_x,
        map_macros.pad_y)
end

-- Function : Next Inline
-- --------------------------------------------------

function map_macros.nextInline()
    map_macros.placeCursorAtLastLabel(true, false)
    Part.Cursor.setCursorPos(Part.Cursor.getCursorX() + Part.Cursor.getCursorPadX())
end

-- Function : Next Line
-- --------------------------------------------------

function map_macros.nextLine()
    Part.Cursor.incCursor(0, map_macros.line_h)
end

-- Function : Open Label
-- --------------------------------------------------

function map_macros.openLabel()
    map_macros.label = Part.Layout.Label.Label:new(nil)
    return map_macros.label
end

-- Function : Close Label
-- --------------------------------------------------

function map_macros.closeLabel(x, y)
    local element = Part.Draw.Elements.lastElement()
    local w = element.dim_x + element.dim_w - map_macros.label.dim_x
    local h = element.dim_y + element.dim_h - map_macros.label.dim_y

    -- use last elements borders by default
    if x ~= nil and y ~= nil then
        w = element.dim_x + x - element.dim_x
        h = element.dim_y + y - element.dim_y
    end

    map_macros.label.dim_w = w
    map_macros.label.dim_h = h

    return map_macros.label
end

-- Function : Get Last Group
-- --------------------------------------------------

function map_macros.lastGroup()
    return map_macros.last_group
end

-- Function : Draw Group Box
-- --------------------------------------------------

function map_macros.drawGroupBox(header_text, x, y, w, h)
    Part.Cursor.stackCursor()

    if x ~= nil and y ~= nil then
        Part.Cursor.setCursorPos(x, y)
    end

    if w ~= nil and h ~= nil then
        Part.Cursor.setCursorSize(w, h)
    end

    map_macros.last_group = Part.Layout.Group.Group:new(nil, header_text)

    -- starting position with inner padding
    local x_post_group = Part.Cursor.getCursorX() + map_macros.group_pad_x
    local y_post_group = Part.Cursor.getCursorY() + map_macros.group_pad_y

    -- header text
    if header_text == nil then
        y_post_group = Part.Cursor.getCursorY() + map_macros.group_pad_x
    end

    Part.Cursor.destackCursor()

    -- update cursor position
    Part.Cursor.setCursorPos(x_post_group, y_post_group)

    -- store coordinates of group
    map_macros.last_group_dim = { x = x, y = y, w = w, h = h }
end

-- Function : Place Cursor at last Group
-- --------------------------------------------------

function map_macros.placeCursorAtLastGroup(x_end, y_end, include_pad)
    local x = Part.Cursor.getCursorX()
    local y = Part.Cursor.getCursorY()

    -- just use cursor when there's no available group
    if map_macros.last_group_dim == nil then
        Part.Cursor.setCursorPos(x, y)
        return
    end

    -- x group end position
    if x_end ~= nil and x_end then
        x = map_macros.last_group_dim.x + map_macros.last_group_dim.w
    end

    -- y group end position
    if y_end ~= nil and y_end then
        y = map_macros.last_group_dim.y + map_macros.last_group_dim.h
    end

    if include_pad ~= nil and include_pad then
        x = x + map_macros.pad_group
        y = y + map_macros.pad_group
    end

    Part.Cursor.setCursorPos(x, y)
end

-- Function : Place Cursor at last Label
-- --------------------------------------------------

function map_macros.placeCursorAtLastLabel(x_end, y_end, include_pad)
    -- get last label
    local label = Part.List.layout_label[#Part.List.layout_label]

    local x = Part.Cursor.getCursorX()
    local y = Part.Cursor.getCursorY()

    -- just use cursor position if there's no label
    if label == nil then
        Part.Cursor.setCursorPos(x, y)
        return
    end

    -- label x end positio
    if x_end ~= nil and x_end then
        x = label.dim_x + label.dim_w
    end

    -- label y end positio
    if y_end ~= nil and y_end then
        y = label.dim_y + label.dim_h
    end

    -- include padding
    if include_pad ~= nil and include_pad then
        x = x + Part.Cursor.getCursorPadX()
        y = y + Part.Cursor.getCursorPadY()
    end

    -- update cursor
    Part.Cursor.setCursorPos(x, y)
end

-- Function : Draw Parameter Label
-- --------------------------------------------------

function map_macros.drawParameterLabel(parameter_text, w)
    Part.Cursor.setCursorSize(map_macros.par_label_w, map_macros.line_h)

    -- optional custom width
    if w ~= nil then
        Part.Cursor.setCursorSize(w, nil)
    end

    -- parameter text
    local text = Part.Layout.Text.Text:new(nil, parameter_text)
    text:setColor(Part.Color.Lookup.color_palette.text.parameter.fg, Part.Color.Lookup.color_palette.text.parameter.bg,
        nil)
    text:justRight()

    -- increment cursor
    Part.Cursor.incCursor(Part.Cursor.getCursorW(), 0)
end

-- Function : Draw Header Label
-- --------------------------------------------------

function map_macros.drawHeader(header_text, w)
    Part.Cursor.stackCursor()

    Part.Cursor.setCursorSize(nil, map_macros.line_h)

    -- optional custom width
    if w ~= nil then
        Part.Cursor.setCursorSize(w, nil)
    end

    -- header text
    local text = Part.Layout.Text.Text:new(nil, header_text)
    text:setColor(Part.Color.Lookup.color_palette.group.inline_header.fg,
        Part.Color.Lookup.color_palette.group.inline_header.bg,
        nil)
    text:centerHorz()
    text:centerVert()
    text:setFontFlags("b")

    map_macros.trackParameterLabel(text)

    Part.Cursor.destackCursor()
end

-- Function : Draw Button Toggle Group
-- --------------------------------------------------

function map_macros.drawButtonToggleGroup(has_bank, parameter, button_w, label, button_label, label_w)
    Part.Cursor.stackCursor()

    -- create background label
    map_macros.openLabel()

    -- bank button
    Part.Cursor.setCursorSize(map_macros.bank_w, map_macros.line_h)
    if has_bank then
        Part.Control.ButtonBank.ButtonBank:new(nil, parameter[2])
        Part.Cursor.incCursor(Part.Cursor.getCursorW(), 0)
    end

    -- label
    if label then
        Part.Cursor.setCursorSize(label_w, nil)
        local text = Part.Layout.Text.Text:new(nil, label)
        text:parameterLabel()
        map_macros.trackParameterLabel(text)
        Part.Cursor.incCursor(Part.Cursor.getCursorW(), 0)
    end

    -- default button width
    if button_w == nil then
        button_w = 100
    end

    -- button
    Part.Cursor.setCursorSize(button_w, nil)

    if has_bank then
        Part.Control.Button.Button:new(nil, parameter[1], true, button_label, 1)
    else
        Part.Control.Button.Button:new(nil, parameter, true, button_label, 1)
    end

    -- udpate background label dimensions
    map_macros.closeLabel()

    Part.Cursor.destackCursor()
end

-- Function : Draw Button Selection Group
-- --------------------------------------------------

function map_macros.drawButtonSelectionGroup(has_bank, parameter, is_toggle, selection, label, label_w)
    Part.Cursor.stackCursor()

    -- background label
    map_macros.openLabel()

    -- bank button
    Part.Cursor.setCursorSize(map_macros.bank_w, map_macros.line_h)
    if has_bank then
        Part.Control.ButtonBank.ButtonBank:new(nil, parameter[2])
        Part.Cursor.incCursor(Part.Cursor.getCursorW(), 0)
    end

    -- parameter label
    if label then
        Part.Cursor.setCursorSize(label_w, nil)
        local text = Part.Layout.Text.Text:new(nil, label)
        text:parameterLabel()
        map_macros.trackParameterLabel(text)
        Part.Cursor.incCursor(Part.Cursor.getCursorW(), 0)
    end

    -- iterate buttons
    for idx, sel in pairs(selection) do
        local value = 0
        local button_label = "Button"
        local w = 100

        -- optionally use custom values
        if sel.value ~= nil then value = sel.value end
        if sel.label ~= nil then button_label = sel.label end
        if sel.width ~= nil then w = sel.width end

        -- button
        Part.Cursor.setCursorSize(sel.width, nil)
        local button = Part.Control.Button.Button:new(nil, parameter[1], is_toggle, button_label, sel.value)
        button:selectionButton()

        -- color lookup
        local color_palette = Part.Color.Lookup.color_palette.button.selection

        -- increment cursor
        Part.Cursor.incCursor(Part.Cursor.getCursorW(), 0)
    end

    -- udpate background label
    map_macros.closeLabel()

    Part.Cursor.destackCursor()
end

-- Function : Draw Knob Group with Display
-- --------------------------------------------------

function map_macros.drawKnobGroupWithDisplay(has_bank, parameter, knob_is_bi, label, label_w, value_offset)
    Part.Cursor.stackCursor()

    -- background label
    map_macros.openLabel()

    -- bank button
    Part.Cursor.setCursorSize(map_macros.bank_w, map_macros.line_h)
    if has_bank then
        Part.Control.ButtonBank.ButtonBank:new(nil, parameter[2])
        Part.Cursor.incCursor(Part.Cursor.getCursorW(), 0)
    end

    -- parameter label
    if label then
        Part.Cursor.setCursorSize(label_w, nil)
        local text = Part.Layout.Text.Text:new(nil, label)
        text:parameterLabel()
        map_macros.trackParameterLabel(text)
        Part.Cursor.incCursor(Part.Cursor.getCursorW(), 0)
    end

    -- knob
    Part.Cursor.setCursorSize(map_macros.knob_w, nil)

    local knob

    if has_bank then
        knob = Part.Control.Knob.Knob:new(nil, parameter[1])
    else
        knob = Part.Control.Knob.Knob:new(nil, parameter)
    end

    -- knob bi-directional value display
    if knob_is_bi then
        knob:valueFillBi()
    end

    -- parameter monitor value offset
    if value_offset == nil then value_offset = 0 end

    -- parameter monitor
    Part.Cursor.incCursor(Part.Cursor.getCursorW(), 0)
    Part.Cursor.setCursorSize(30)
    Part.Layout.Text.Text:new(nil, "", parameter[1])
    Part.Draw.Elements.lastElement():parameterMonitor(value_offset)

    -- update background label
    map_macros.closeLabel()

    Part.Cursor.destackCursor()
end

-- Function : Draw Knob Group
-- --------------------------------------------------

function map_macros.drawKnobGroup(has_bank, parameter, knob_is_bi, label, label_w)
    Part.Cursor.stackCursor()

    -- background label
    map_macros.openLabel()

    -- bank button
    Part.Cursor.setCursorSize(map_macros.bank_w, map_macros.line_h)
    if has_bank then
        Part.Control.ButtonBank.ButtonBank:new(nil, parameter[2])
        Part.Cursor.incCursor(Part.Cursor.getCursorW(), 0)
    end

    -- parameter label
    if label then
        Part.Cursor.setCursorSize(label_w, nil)
        local text = Part.Layout.Text.Text:new(nil, label)
        text:parameterLabel()
        Part.Cursor.incCursor(Part.Cursor.getCursorW(), 0)
    end

    -- knob
    Part.Cursor.setCursorSize(map_macros.knob_w, nil)

    local knob

    if has_bank then
        knob = Part.Control.Knob.Knob:new(nil, parameter[1])
    else
        knob = Part.Control.Knob.Knob:new(nil, parameter)
    end

    -- knob bi-directional value display
    if knob_is_bi then
        knob:valueFillBi()
    end

    -- update parameter label
    map_macros.closeLabel()

    Part.Cursor.destackCursor()
end

-- Function : Draw Slider Group
-- --------------------------------------------------

function map_macros.drawSliderGroup(has_bank, parameter_slider, slider_is_bi, slider_w, label, label_w, parameter_toggle,
                                    parameter_toggle_label)
    Part.Cursor.stackCursor()

    -- background label
    map_macros.openLabel()

    -- bank button
    Part.Cursor.setCursorSize(map_macros.bank_w, map_macros.line_h)
    if has_bank then
        Part.Control.ButtonBank.ButtonBank:new(nil, parameter_slider[2])
        Part.Cursor.incCursor(Part.Cursor.getCursorW(), 0)
    else
        label_w = label_w + Part.Cursor.getCursorW() + Part.Cursor.getCursorPadX()
    end

    -- parameter label
    if label then
        Part.Cursor.setCursorSize(label_w, nil)
        local text = Part.Layout.Text.Text:new(nil, label)
        text:parameterLabel()
        map_macros.trackParameterLabel(text)
        Part.Cursor.incCursor(Part.Cursor.getCursorW(), 0)
    end


    -- slider
    Part.Cursor.setCursorSize(slider_w, nil)

    local slider

    if has_bank then
        slider = Part.Control.Slider.Slider:new(nil, parameter_slider[1])
    else
        slider = Part.Control.Slider.Slider:new(nil, parameter_slider)
    end

    -- bi-directional value fill
    if slider_is_bi then
        slider:valueFillBi()
    end

    -- additional toggle parameter
    if parameter_toggle ~= nil then
        local label = "%"

        if parameter_toggle_label ~= nil then
            label = parameter_toggle_label
        end

        -- toggle button
        Part.Cursor.incCursor(Part.Cursor.getCursorW(), 0)
        Part.Cursor.setCursorSize(25, nil)
        Part.Control.Button.Button:new(nil, parameter_toggle, true, label, 1)
    end

    -- update background label
    map_macros.closeLabel()
    Part.Cursor.destackCursor()
end

-- Function : Draw MCP Layout Configuration
-- --------------------------------------------------

function map_macros.drawMcpLayoutConfiguration(row_data, parameter)
    local base_y = Part.Cursor.getCursorY()

    -- images
    local icon_path = map_macros.icon_path_root .. "/" .. Part.Color.Lookup.image_set_table .. "/"
    local images = {
        { image = map_macros.icons.table.mcp_pan_layout_top },
        { image = map_macros.icons.table.mcp_pan_layout_strip },
        { image = map_macros.icons.table.mcp_pan_layout_bottom }
    }

    -- dimensions
    local label_w = 70
    local table_w = 27

    Part.Cursor.stackCursor()

    Part.Cursor.setCursorSize(label_w, map_macros.table_icon_h)

    -- starting corner shading
    local label = Part.Layout.Label.Label:new(nil)
    label:tableEmptySpace()

    -- bank button
    Part.Cursor.setCursorSize(map_macros.bank_w, map_macros.line_h)
    Part.Control.ButtonBank.ButtonBank:new(nil, parameter[2])
    Part.Cursor.incCursor(Part.Cursor.getCursorW(), 0)

    -- parameter label
    Part.Cursor.setCursorSize(50, map_macros.table_icon_h)
    local text = Part.Layout.Text.Text:new(nil, "Layout")
    text:tableEntry()
    text:centerHorz()
    text:centerVert()

    Part.Cursor.destackCursor()

    map_macros.nextLine()

    Part.Cursor.setCursorSize(table_w, map_macros.table_icon_h)

    -- iterate layouts
    for idx, row in pairs(row_data) do
        -- row background shader
        local label = Part.Layout.Label.Label:new(nil)
        label:tableRow(idx % 2)

        Part.Cursor.stackCursor()

        -- image
        Part.Cursor.setCursorSize(table_w, map_macros.table_icon_h)
        Part.Cursor.incCursor(5, 0)
        local image = Part.Layout.Sprite.Sprite:new(nil, Part.Layout.icon_spritesheet, images[idx].image)
        map_macros.trackParameterLabel(image)
        Part.Cursor.incCursor(Part.Cursor.getCursorW(), 0)

        -- marker
        Part.Control.Marker.Marker:new(nil, parameter[1], false, idx - 1)

        -- update row shader
        label:stretch(Part.Cursor.getCursorX() + Part.Cursor.getCursorW())


        -- increment line
        Part.Cursor.destackCursor()
        map_macros.nextLine()
    end

    Part.Cursor.setCursorPos(nil, base_y)
end

-- Function : Draw MCP Fader Configuration
-- --------------------------------------------------

function map_macros.drawMcpPanConfiguration(row_data)
    local base_y = Part.Cursor.getCursorY()

    -- images
    local icon_path = map_macros.icon_path_root .. "/" .. Part.Color.Lookup.image_set_table .. "/"
    local images = {
        { image = map_macros.icons.table.mcp_fader_layout_knob },
        { image = map_macros.icons.table.mcp_fader_layout_vert },
        { image = map_macros.icons.table.mcp_fader_layout_horz }
    }

    -- dimensions
    local label_w = 70
    local table_w = 20

    Part.Cursor.stackCursor()
    Part.Cursor.setCursorSize(label_w, map_macros.table_icon_h)

    -- starting corner shading
    local label = Part.Layout.Label.Label:new(nil)
    label:tableEmptySpace()

    Part.Cursor.setCursorSize(map_macros.bank_w, map_macros.line_h)
    Part.Control.ButtonBank.ButtonBank:new(nil, row_data[1].parameter[2])
    Part.Cursor.incCursor(Part.Cursor.getCursorW(), 0)

    -- starting corner header text
    Part.Cursor.setCursorSize(label_w, map_macros.table_icon_h)
    local text = Part.Layout.Text.Text:new(nil, "Pan Mode")
    text:tableEntry()
    text:centerHorz()
    text:centerVert()
    Part.Cursor.incCursor(Part.Cursor.getCursorW(), 0)

    -- update corner label
    label:stretch(Part.Cursor.getCursorX() - Part.Cursor.getCursorPadX())

    -- table header
    Part.Cursor.setCursorSize(table_w, map_macros.table_icon_h)
    local label_column = {}

    -- iterate header images
    for idx, column in pairs(images) do
        -- column shader
        table.insert(label_column, Part.Layout.Label.Label:new(nil))

        -- header image
        local image = Part.Layout.Sprite.Sprite:new(nil, Part.Layout.icon_spritesheet, column.image)
        map_macros.trackParameterLabel(image)

        -- increment cursor
        Part.Cursor.incCursor(Part.Cursor.getCursorW(), 0)
    end

    Part.Cursor.destackCursor()
    map_macros.nextLine()

    -- iterate rows
    for idx, row in pairs(row_data) do
        -- row shader
        local label = Part.Layout.Label.Label:new(nil)
        label:tableRow(idx % 2)

        Part.Cursor.stackCursor()

        -- row label
        Part.Cursor.setCursorSize(label_w + 20, map_macros.line_h)
        local text = Part.Layout.Text.Text:new(nil, row.label)
        text:tableEntry(true)
        Part.Cursor.incCursor(Part.Cursor.getCursorW(), 0)


        -- iterate row entries
        Part.Cursor.setCursorSize(table_w, map_macros.table_icon_h)
        for idx, column in pairs(images) do
            -- marker
            Part.Control.Marker.Marker:new(nil, row.parameter[1], false, idx - 1)
            -- increment cursor
            Part.Cursor.incCursor(Part.Cursor.getCursorW(), 0)
        end

        -- update row shader
        label:stretch(Part.Cursor.getCursorX() - Part.Cursor.getCursorPadX())
        Part.Cursor.incCursor(Part.Cursor.getCursorW(), 0)

        Part.Cursor.destackCursor()

        -- increment line
        map_macros.nextLine()
    end

    -- iterate columns
    for idx, label in pairs(label_column) do
        -- update column shaders
        label:stretch(nil, Part.Cursor.getCursorY() - Part.Cursor.getCursorPadY())
        label:tableColumn(idx % 2)
    end

    -- place cursor at bottom
    Part.Cursor.setCursorPos(nil, base_y)
end

-- Function : Draw TCP Fader Layout Configuration
-- --------------------------------------------------

function map_macros.drawTcpFaderLayoutConfiguration(parameter)
    -- images
    local icon_path = map_macros.icon_path_root .. "/" .. Part.Color.Lookup.image_set_table .. "/"
    local layouts = {
        { value = 0, image = map_macros.icons.table.tcp_fader_layout_inline },
        { value = 1, image = map_macros.icons.table.tcp_fader_layout_separate },
        { value = 2, image = map_macros.icons.table.tcp_fader_layout_explode }
    }

    Part.Cursor.stackCursor()

    -- background shader
    Part.Cursor.setCursorSize(map_macros.bank_w, map_macros.line_h)
    map_macros.openLabel()

    -- bank button
    Part.Control.ButtonBank.ButtonBank:new(nil, parameter[2])
    Part.Cursor.incCursor(Part.Cursor.getCursorW(), 0)

    -- layout label
    Part.Cursor.setCursorSize(50, map_macros.table_icon_h)
    local text = Part.Layout.Text.Text:new(nil, "Layout")
    text:parameterLabel()
    Part.Cursor.incCursor(Part.Cursor.getCursorW(), 0)

    -- iterate layouts
    for idx, layout in pairs(layouts) do
        -- marker
        Part.Cursor.setCursorSize(10, map_macros.table_icon_h)
        Part.Control.Marker.Marker:new(nil, parameter[1], false, idx - 1)
        Part.Cursor.incCursor(Part.Cursor.getCursorW(), 0)

        -- image
        Part.Cursor.setCursorSize(40, map_macros.table_icon_h)
        local image = Part.Layout.Sprite.Sprite:new(nil, Part.Layout.icon_spritesheet, layout.image)
        Part.Cursor.incCursor(Part.Cursor.getCursorW(), 0)
        map_macros.trackParameterLabel(image)
    end

    Part.Cursor.destackCursor()

    -- update background shader
    map_macros.closeLabel()
end

-- Function : Draw TCP Fader Configuration
-- --------------------------------------------------

function map_macros.drawTcpFaderConfiguration(fader_data, label_w, slider_w)
    local icon_path = map_macros.icon_path_root .. "/" .. Part.Color.Lookup.image_set_table .. "/"

    -- default dimensions
    if label_w == nil then label_w = 50 end
    if slider_w == nil then slider_w = 50 end

    -- icon width
    local icon_w = 20

    Part.Cursor.stackCursor()
    Part.Cursor.setCursorSize(icon_w, map_macros.line_h)
    Part.Cursor.incCursor(label_w + 20, 0)

    -- check if mixer-hide is available
    local has_mixer = false
    for idx, entry in pairs(fader_data) do
        if entry.par_vis_mixer ~= nil then
            has_mixer = true
        end
    end

    -- visibility header image
    local image = Part.Layout.Sprite.Sprite:new(nil, Part.Layout.icon_spritesheet, map_macros.icons.table.visbility)
    Part.Control.Hint.Hint:new(nil, Part.Gui.Hint.Lookup.vismatrix_visbility, image, false)
    Part.Cursor.incCursor(Part.Cursor.getCursorW(), 0)

    -- mixer-hide header image
    if has_mixer then
        local image = Part.Layout.Sprite.Sprite:new(nil, Part.Layout.icon_spritesheet, map_macros.icons.table.mixer_hide)
        Part.Control.Hint.Hint:new(nil, Part.Gui.Hint.Lookup.vismatrix_nomixer, image, false)
        Part.Cursor.incCursor(Part.Cursor.getCursorW(), 0)
    end

    -- fader size header image
    Part.Cursor.setCursorSize(slider_w)
    local image = Part.Layout.Sprite.Sprite:new(nil, Part.Layout.icon_spritesheet, map_macros.icons.table.fader_size)
    Part.Control.Hint.Hint:new(nil, Part.Gui.Hint.Lookup.fader_size, image, false)

    Part.Cursor.destackCursor()
    map_macros.nextLine()

    -- iterate faders
    for idx, entry in pairs(fader_data) do
        Part.Cursor.stackCursor()

        -- row shader
        map_macros.openLabel()

        -- bank button
        Part.Cursor.setCursorSize(map_macros.bank_w, map_macros.line_h)
        Part.Control.ButtonBank.ButtonBank:new(nil, entry.par_vis[2])
        Part.Cursor.incCursor(Part.Cursor.getCursorW(), 0)

        -- fader label
        Part.Cursor.setCursorSize(label_w, Part.Cursor.getCursorH())
        Part.Layout.Text.Text:new(nil, entry.label)
        Part.Draw.Elements.lastElement():parameterLabel()

        -- visibility marker
        Part.Cursor.incCursor(Part.Cursor.getCursorW(), 0)
        Part.Cursor.setCursorSize(icon_w)
        Part.Control.Marker.Marker:new(nil, entry.par_vis[1], true, 1)
        Part.Cursor.incCursor(Part.Cursor.getCursorW(), 0)

        -- mixer-hide marker
        if has_mixer then
            Part.Control.Marker.Marker:new(nil, entry.par_vis_mixer[1], true, 1)
            Part.Cursor.incCursor(Part.Cursor.getCursorW(), 0)
        end

        -- fader size
        Part.Cursor.setCursorSize(slider_w)
        Part.Control.Slider.Slider:new(nil, entry.par_size[1])
        Part.Cursor.incCursor(Part.Cursor.getCursorW(), 0)

        -- scale button
        Part.Cursor.setCursorSize(30)
        Part.Control.Button.Button:new(nil, entry.par_size_scale[1], true, "%", 1)

        -- update row shader
        local label = map_macros.closeLabel()
        label:tableRow(idx % 2)

        Part.Cursor.destackCursor()
        map_macros.nextLine()
    end
end

-- Function : Draw Visibility Matrix
-- --------------------------------------------------

function map_macros.drawVisibilityMatrix(matrix_data, visibility_data, parameter_visibility, parameter_mixer,
                                         parameter_separator)
    Part.Cursor.stackCursor()
    Part.Cursor.stackCursor()

    -- top-left corner shader
    local empty_space = Part.Layout.Label.Label:new(nil)
    empty_space:tableEmptySpace()

    -- dimensions
    local empty_space_y = 0
    local label_w = 100

    -- optionally override label width
    if matrix_data["label_width"] ~= nil then
        label_w = matrix_data["label_width"]
    end

    -- table header left x-axis offset
    local offset = map_macros.table_icon_w + label_w + Part.Cursor.getCursorPadX()
    Part.Cursor.incCursor(offset, 0)

    local empty_space_x = Part.Cursor.getCursorX() - Part.Cursor.getCursorPadX()
    Part.Cursor.setCursorSize(map_macros.table_marker_w, map_macros.line_h)

    local label_rows = {}
    local label_columns = {}

    --  Local Function : Draw Table Header
    -- ::::::::::::::::::::::::::::::::::::::::
    local function drawTableHeader(parameter_set, icon)
        -- column shader
        table.insert(label_columns, Part.Layout.Label.Label:new(nil))

        Part.Cursor.stackCursor()

        -- bank button
        Part.Control.ButtonBank.ButtonBank:new(nil, parameter_set[2])
        Part.Draw.Elements.lastElement():triggerBankUpdate()
        Part.Cursor.incCursor(0, Part.Cursor.getCursorH())

        -- image
        local image = Part.Layout.Sprite.Sprite:new(nil, Part.Layout.icon_spritesheet, icon)
        Part.Cursor.incCursor(0, Part.Cursor.getCursorH())
        empty_space_y = math.max(empty_space_y, Part.Cursor.getCursorY() - Part.Cursor.getCursorPadY())
        map_macros.trackParameterLabel(image)

        Part.Cursor.destackCursor()

        -- next icon
        Part.Cursor.incCursor(Part.Cursor.getCursorW(), 0)
    end

    -- visibility header column
    if parameter_visibility ~= nil then
        drawTableHeader(parameter_visibility, map_macros.icons.table.visbility)
        Part.Control.Hint.Hint:new(nil, Part.Gui.Hint.Lookup.vismatrix_visbility, map_macros.getLastParameterLabel(),
            false)
    end

    -- mixer-hide header column
    if parameter_mixer ~= nil then
        drawTableHeader(parameter_mixer, map_macros.icons.table.mixer_hide)
        Part.Control.Hint.Hint:new(nil, Part.Gui.Hint.Lookup.vismatrix_nomixer, map_macros.getLastParameterLabel(), false)
    end

    -- separator column
    if parameter_separator ~= nil then
        drawTableHeader(parameter_separator, map_macros.icons.table.separator)
        Part.Control.Hint.Hint:new(nil, Part.Gui.Hint.Lookup.vismatrix_separator, map_macros.getLastParameterLabel(),
            false)
    end

    -- update corner shader
    empty_space:stretch(empty_space_x, empty_space_y)

    Part.Cursor.destackCursor()

    -- row starting position
    for i = 0, 1 do
        Part.Cursor.incCursor(0, Part.Cursor.getCursorH())
    end

    -- rigthmost position
    local rows_max_x = 0

    -- iterate rows
    for idx, entry in pairs(visibility_data) do
        -- row shader
        local label = Part.Layout.Label.Label:new(nil)
        table.insert(label_rows, label)

        Part.Cursor.stackCursor()

        -- image
        Part.Cursor.setCursorSize(map_macros.table_icon_w, map_macros.line_h)
        Part.Layout.Sprite.Sprite:new(nil, Part.Layout.icon_spritesheet, entry.image)
        Part.Cursor.incCursor(Part.Cursor.getCursorW(), 0)

        -- parameter label
        Part.Cursor.setCursorSize(label_w, map_macros.line_h)
        Part.Layout.Text.Text:new(nil, entry.label)
        Part.Draw.Elements.lastElement():tableEntry(true)
        Part.Cursor.incCursor(Part.Cursor.getCursorW(), 0)

        Part.Cursor.setCursorSize(map_macros.table_marker_w, map_macros.line_h)

        -- visibility marker
        if parameter_visibility ~= nil then
            Part.Control.Marker.Marker:new(nil, parameter_visibility[1], true, entry.index)
            Part.Draw.Elements.lastElement():useFlags()
            Part.Cursor.incCursor(Part.Cursor.getCursorW(), 0)
        end

        -- mixer-hide marker
        if parameter_mixer ~= nil then
            Part.Control.Marker.Marker:new(nil, parameter_mixer[1], true, entry.index)
            Part.Draw.Elements.lastElement():useFlags()
            Part.Cursor.incCursor(Part.Cursor.getCursorW(), 0)
        end

        -- separator marker
        if parameter_separator ~= nil and entry.separator then
            Part.Control.Marker.Marker:new(nil, parameter_separator[1], true, entry.index)
            Part.Draw.Elements.lastElement():useFlags()
            Part.Cursor.incCursor(Part.Cursor.getCursorW(), 0)
        end

        -- rightmost position
        rows_max_x = math.max(rows_max_x, Part.Cursor.getCursorX() - Part.Cursor.getCursorPadX())

        -- next line
        Part.Cursor.destackCursor()
        Part.Cursor.incCursor(0, Part.Cursor.getCursorH())
    end

    -- upade row shaders
    for idx, label in pairs(label_rows) do
        label:stretch(rows_max_x)
        label:tableRow(idx % 2)
    end

    -- upade column shaders
    for idx, label in pairs(label_columns) do
        label:stretch(nil, Part.Cursor.getCursorY() - Part.Cursor.getCursorPadY())
        label:tableColumn(idx % 2)
    end

    -- place cursor at bottom
    local y_pos = Part.Cursor.getCursorY()
    Part.Cursor.destackCursor()
    Part.Cursor.setCursorPos(nil, y_pos)
end

return map_macros
