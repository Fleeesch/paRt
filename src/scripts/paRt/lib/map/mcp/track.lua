-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--      Tab : MCP : Track
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

-- Settings
-- ------------------------------

Part.Tab.Entry.setRecentTab(Part.Gui.Tab.tab_mcp_track)
Part.Gui.Macros.resetCursor()

local group_x = 10
local group_y = Part.Cursor.getCursorY()

-- Meter
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(false, true, true)
Part.Gui.Macros.drawGroupBox("Meter", group_x, group_y, 450, 120)
Part.Gui.Macros.lastGroup():setTint("meter")

local column_b_x = Part.Cursor.getCursorX() + 210

local selection = {
    { label = "Top",    value = 1, width = 35 },
    { label = "Bottom", value = 2, width = 50 }
}

-- Position
Part.Cursor.stackCursor()
Part.Gui.Macros.drawButtonSelectionGroup(true, Part.Parameter.Map.par_mcp_track_meter_pos, true, selection,
    "Position", 50)
Part.Gui.Macros.nextInline()

selection = {
    { label = "Minimal", value = 1, width = 65 },
    { label = "Full",    value = 2, width = 50 }
}

-- Side Padding
Part.Cursor.setCursorPos(column_b_x)
Part.Gui.Macros.drawButtonSelectionGroup(true, Part.Parameter.Map.par_mcp_track_meter_padding, true, selection,
    "Padding", 75)
Part.Cursor.destackCursor()
Part.Gui.Macros.nextLine()

-- VU Text
Part.Cursor.stackCursor()
Part.Gui.Macros.drawButtonToggleGroup(true, Part.Parameter.Map.par_mcp_track_meter_vu_db, 55, nil, "VU Text")
Part.Gui.Macros.nextInline()

-- Clip Text
Part.Gui.Macros.drawButtonToggleGroup(true, Part.Parameter.Map.par_mcp_track_meter_vu_readout, 65, nil, "Clip Text")
Part.Gui.Macros.nextInline()

selection = {
    { label = "Horizontal", value = 1, width = 65 },
    { label = "Vertical",   value = 2, width = 50 },
}

-- Volume Readout
Part.Cursor.setCursorPos(column_b_x)
Part.Gui.Macros.drawButtonSelectionGroup(true, Part.Parameter.Map.par_mcp_track_meter_vol_readout, true, selection,
    "Vol Readout", 75)
Part.Cursor.destackCursor()
Part.Gui.Macros.nextLine()


-- Size
Part.Cursor.stackCursor()
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_track_meter_size, false, 85, "Size", 55,
    Part.Parameter.Map.par_mcp_track_meter_size_scale[1])
Part.Gui.Macros.nextLine()

-- VU Spacing
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_track_meter_channeldiv, false, 85, "VU Space", 55)
Part.Cursor.destackCursor()

-- Expand
Part.Cursor.setCursorPos(column_b_x)
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_track_meter_expand, false, 85, "Expand", 75,
    Part.Parameter.Map.par_mcp_track_meter_expand_mode[1], "Fix")
Part.Gui.Macros.nextLine()

-- Expand Threshold
Part.Gui.Macros.drawKnobGroupWithDisplay(true, Part.Parameter.Map.par_mcp_track_meter_expand_threshold, false,
    "Expand Min Channel", 120, 2)
Part.Gui.Macros.nextLine()

Part.Gui.Macros.placeCursorAtLastGroup(true, false, true)
local group_x_elements = Part.Cursor.getCursorX()

-- Faders
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(false, true, true)
Part.Gui.Macros.drawGroupBox("Faders", group_x, Part.Cursor.getCursorY(), 450, 125)
Part.Gui.Macros.lastGroup():setTint("fader")

local selection = {
    { label = "Separate Pan Section", value = 0, width = 125 },
    { label = "Strip",                value = 1, width = 40 },
    { label = "Pan Next to Fader",    value = 2, width = 110 }
}

Part.Gui.Macros.drawMcpLayoutConfiguration(selection, Part.Parameter.Map.par_mcp_track_fader_layout)
Part.Gui.Macros.nextInline()

local matrix_rows = {
    { label = "Mono",   value = 0, width = 40, parameter = Part.Parameter.Map.par_mcp_track_fader_pan_mode_mono },
    { label = "Stereo", value = 1, width = 70, parameter = Part.Parameter.Map.par_mcp_track_fader_pan_mode_stereo },
    { label = "Dual",   value = 2, width = 80, parameter = Part.Parameter.Map.par_mcp_track_fader_pan_mode_dual }
}

Part.Gui.Macros.drawMcpPanConfiguration(matrix_rows)
Part.Gui.Macros.nextInline()


-- Always Show Width
Part.Cursor.incCursor(5, 0)
Part.Gui.Macros.drawButtonToggleGroup(true, Part.Parameter.Map.par_mcp_track_fader_wid_always, 120, nil,
    "Always Show Width")
Part.Gui.Macros.nextLine()

-- Width
Part.Cursor.stackCursor()
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_track_fader_pan_width, false, 65, "Width", 45)
Part.Gui.Macros.nextLine()

-- Height
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_track_fader_pan_height, false, 65, "Height", 45,
    Part.Parameter.Map.par_mcp_track_fader_pan_height_scale[1])
Part.Cursor.destackCursor()
Part.Gui.Macros.nextLine()

-- Settings
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(false, true, true)
local group_y_settings = Part.Cursor.getCursorY()
Part.Gui.Macros.drawGroupBox("Settings", group_x, Part.Cursor.getCursorY(), 195, 55)
Part.Gui.Macros.lastGroup():setTint("arrangement")

-- Extend Width
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_track_settings_extrapad, false, 90, "Width +", 60)
Part.Gui.Macros.nextLine()

-- Label
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(false, true, true)
Part.Gui.Macros.drawGroupBox("Label", group_x, Part.Cursor.getCursorY(), 195, 100)
Part.Gui.Macros.lastGroup():setTint("arrangement")

-- Size
Part.Cursor.stackCursor()
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_track_settings_label_size, false, 90, "Size", 30)
Part.Gui.Macros.nextLine()

-- Vertical
Part.Gui.Macros.drawButtonToggleGroup(true, Part.Parameter.Map.par_mcp_track_settings_label_vertical, 50, "Oriantation",
    "Vertical", 70)
Part.Gui.Macros.nextLine()

selection = {
    { label = "In Label", value = 1, width = 50 },
    { label = "Separate", value = 2, width = 60 }
}

-- Index Placement
Part.Gui.Macros.drawButtonSelectionGroup(true, Part.Parameter.Map.par_mcp_track_settings_label_index, true, selection,
    "Index", 35)
Part.Cursor.destackCursor()
Part.Gui.Macros.nextLine()

Part.Gui.Macros.placeCursorAtLastGroup(false, true, true)


-- Inserts
-- ------------------------------

local label_w_insert = 65

Part.Gui.Macros.placeCursorAtLastGroup(true, false, true)
Part.Gui.Macros.drawGroupBox("Inserts", Part.Cursor.getCursorX(), group_y_settings, 250, 160)
Part.Gui.Macros.lastGroup():setTint("inserts")

selection = {
    { label = "Top", value = 1, width = 60 },
}

-- Position
Part.Gui.Macros.drawButtonSelectionGroup(true, Part.Parameter.Map.par_mcp_track_insert_mode, true, selection,
    "Position", label_w_insert)
Part.Gui.Macros.nextLine()

selection = {
    { label = "Always",   value = 3, width = 60 },
    { label = "on Embed", value = 2, width = 60 },
}

-- Position
Part.Gui.Macros.drawButtonSelectionGroup(true, Part.Parameter.Map.par_mcp_track_insert_mode, true, selection,
    "Sidebar", label_w_insert)
Part.Gui.Macros.nextLine()

selection = {
    { label = "Minimal", value = 1, width = 60 },
    { label = "Full",    value = 2, width = 60 }
}

-- Side Padding
Part.Gui.Macros.drawButtonSelectionGroup(true, Part.Parameter.Map.par_mcp_track_insert_pad, true, selection,
    "Padding", label_w_insert)
Part.Gui.Macros.nextLine()

-- Size
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_track_insert_size, false, 100, "Size", label_w_insert,
    Part.Parameter.Map.par_mcp_track_insert_size_scale[1])
Part.Gui.Macros.nextLine()

-- Size on Embed
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_track_insert_size_embed, false, 100, "on Embed",
    label_w_insert)
Part.Gui.Macros.nextLine()


-- Elements
-- ------------------------------

Part.Gui.Macros.drawGroupBox("Buttons", group_x_elements, group_y, 170, 415)
Part.Gui.Macros.lastGroup():setTint("arrangement")

local visibility_data = {
    { label = "Input",    image = Part.Gui.Macros.icons.track.input,   separator = false, index = 1 },
    { label = "Rec Mode", image = Part.Gui.Macros.icons.track.recmode, separator = true,  index = 2 },
    { label = "Rec Arm",  image = Part.Gui.Macros.icons.track.recarm,  separator = false, index = 3 },
    { label = "Rec Mon",  image = Part.Gui.Macros.icons.track.recmon,  separator = true,  index = 4 },
    { label = "In FX",    image = Part.Gui.Macros.icons.track.infx,    separator = false, index = 5 },
    { label = "FX",       image = Part.Gui.Macros.icons.track.fx,      separator = true,  index = 6 },
    { label = "Env",      image = Part.Gui.Macros.icons.track.env,     separator = true,  index = 7 },
    { label = "IO",       image = Part.Gui.Macros.icons.track.io,      separator = false, index = 8 },
    { label = "Phase",    image = Part.Gui.Macros.icons.track.phase,   separator = true,  index = 9 },
    { label = "Mute",     image = Part.Gui.Macros.icons.track.mute,    separator = false, index = 10 },
    { label = "Solo",     image = Part.Gui.Macros.icons.track.solo,    separator = false,  index = 11 },
}

local matrix_data = {
    label_width = 60
}


-- Visibility Matrix
Part.Gui.Macros.drawVisibilityMatrix(matrix_data, visibility_data, Part.Parameter.Map.par_mcp_track_element_vis,
    nil, Part.Parameter.Map.par_mcp_track_element_separator)
Part.Cursor.incCursor(0, 4)

local selection = {
    { label = "Slim", value = 0, width = 35 },
    { label = "Wide", value = 1, width = 40 }
}

-- Layout
Part.Gui.Macros.drawButtonSelectionGroup(true, Part.Parameter.Map.par_mcp_track_element_width, false, selection,
    "Layout", 45)
Part.Gui.Macros.nextLine()

-- Input Size
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_track_element_input_size, false, 65, "Input Size",
    60)
Part.Gui.Macros.nextLine()
