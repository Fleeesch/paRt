-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--      Tab : MCP : Master
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

-- Settings
-- ------------------------------

Part.Tab.Entry.setRecentTab(Part.Gui.Tab.tab_mcp_master)
Part.Gui.Macros.resetCursor()

local group_x = 10
local group_y = Part.Cursor.getCursorY()

-- Meter
-- ------------------------------

Part.Gui.Macros.drawGroupBox("Meter", group_x, group_y, 450, 100)
Part.Gui.Macros.lastGroup():setTint("meter")

local column_b_x = Part.Cursor.getCursorX() + 210

local selection = {
    { label = "Top",    value = 1, width = 35 },
    { label = "Bottom", value = 2, width = 50 }
}

-- Position
Part.Cursor.stackCursor()
Part.Gui.Macros.drawButtonSelectionGroup(true, Part.Parameter.Map.par_mcp_master_meter_pos, true, selection,
    "Position", 50)
Part.Gui.Macros.nextInline()

selection = {
    { label = "Minimal", value = 1, width = 65 },
    { label = "Full",    value = 2, width = 50 }
}

-- Side Padding
Part.Cursor.setCursorPos(column_b_x)
Part.Gui.Macros.drawButtonSelectionGroup(true, Part.Parameter.Map.par_mcp_master_meter_padding, true, selection,
    "Padding", 75)
Part.Cursor.destackCursor()
Part.Gui.Macros.nextLine()

-- VU Text
Part.Cursor.stackCursor()
Part.Gui.Macros.drawButtonToggleGroup(true, Part.Parameter.Map.par_mcp_master_meter_vu_db, 55, nil, "VU Text")
Part.Gui.Macros.nextInline()

-- Clip Text
Part.Gui.Macros.drawButtonToggleGroup(true, Part.Parameter.Map.par_mcp_master_meter_vu_readout, 65, nil, "Clip Text")
Part.Gui.Macros.nextInline()

selection = {
    { label = "Horizontal", value = 1, width = 65 },
    { label = "Vertical",   value = 2, width = 50 },
}

-- Volume Readout
Part.Cursor.setCursorPos(column_b_x)
Part.Gui.Macros.drawButtonSelectionGroup(true, Part.Parameter.Map.par_mcp_master_meter_vol_readout, true, selection,
    "Vol Readout", 75)
Part.Cursor.destackCursor()
Part.Gui.Macros.nextLine()


-- Size
Part.Cursor.stackCursor()
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_master_meter_size, false, 85, "Size", 55,
    Part.Parameter.Map.par_mcp_master_meter_size_scale[1])

-- VU Spacing
Part.Cursor.setCursorPos(column_b_x)
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_master_meter_channeldiv, false, 85, "VU Space", 75)
Part.Cursor.destackCursor()

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

Part.Gui.Macros.drawMcpLayoutConfiguration(selection, Part.Parameter.Map.par_mcp_master_fader_layout)
Part.Gui.Macros.nextInline()

local matrix_rows = {
    { label = "Mono",   value = 0, width = 40, parameter = Part.Parameter.Map.par_mcp_master_fader_pan_mode_mono },
    { label = "Stereo", value = 1, width = 70, parameter = Part.Parameter.Map.par_mcp_master_fader_pan_mode_stereo },
    { label = "Dual",   value = 2, width = 80, parameter = Part.Parameter.Map.par_mcp_master_fader_pan_mode_dual }
}

Part.Gui.Macros.drawMcpPanConfiguration(matrix_rows)
Part.Gui.Macros.nextInline()


-- Always Show Width
Part.Cursor.incCursor(5, 0)
Part.Gui.Macros.drawButtonToggleGroup(true, Part.Parameter.Map.par_mcp_master_fader_wid_always, 120, nil,
    "Always Show Width")
Part.Gui.Macros.nextLine()

-- Width
Part.Cursor.stackCursor()
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_master_fader_pan_width, false, 65, "Width", 45)
Part.Gui.Macros.nextLine()

-- Height
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_master_fader_pan_height, false, 65, "Height", 45,
    Part.Parameter.Map.par_mcp_master_fader_pan_height_scale[1])
Part.Cursor.destackCursor()
Part.Gui.Macros.nextLine()

-- Inserts
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(false,true, true)
local group_y_inserts = Part.Cursor.getCursorY()
Part.Gui.Macros.drawGroupBox("Inserts", group_x, Part.Cursor.getCursorY(), 240, 100)
Part.Gui.Macros.lastGroup():setTint("inserts")

local label_w_insert = 65

selection = {
    { label = "Top",     value = 1, width = 60 },
    { label = "Sidebar", value = 2, width = 60 },
}

-- Position
Part.Gui.Macros.drawButtonSelectionGroup(true, Part.Parameter.Map.par_mcp_master_insert_mode, true, selection,
    "Position", label_w_insert)
Part.Gui.Macros.nextLine()

selection = {
    { label = "Minimal", value = 1, width = 60 },
    { label = "Full",    value = 2, width = 60 }
}

-- Side Padding
Part.Gui.Macros.drawButtonSelectionGroup(true, Part.Parameter.Map.par_mcp_master_insert_pad, true, selection,
    "Padding", label_w_insert)
Part.Gui.Macros.nextLine()

-- Size
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_master_insert_size, false, 100, "Size", label_w_insert,
    Part.Parameter.Map.par_mcp_master_insert_size_scale[1])
Part.Gui.Macros.nextLine()

-- Settings
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(true,false, true)
Part.Gui.Macros.drawGroupBox("Settings", Part.Cursor.getCursorX(), group_y_inserts, 205, 100)
Part.Gui.Macros.lastGroup():setTint("arrangement")

-- Extend Width
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_master_settings_extrapad, false, 75, "Width +", 75)
Part.Gui.Macros.nextLine()

-- Menu Button Size
Part.Cursor.stackCursor()
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_master_settings_label_size, false, 75, "Menu Button", 75)
Part.Gui.Macros.nextLine()


-- Elements
-- ------------------------------

Part.Gui.Macros.drawGroupBox("Buttons", group_x_elements, group_y, 170, 335)
Part.Gui.Macros.lastGroup():setTint("arrangement")

local visibility_data = {
    { label = "FX",   image = Part.Gui.Macros.icons.track.fx,   separator = true,  index = 1 },
    { label = "Env",  image = Part.Gui.Macros.icons.track.env,  separator = true,  index = 2 },
    { label = "IO",   image = Part.Gui.Macros.icons.track.io,   separator = false, index = 3 },
    { label = "Mono", image = Part.Gui.Macros.icons.track.mono, separator = true,  index = 4 },
    { label = "Mute", image = Part.Gui.Macros.icons.track.mute, separator = false, index = 5 },
    { label = "Solo", image = Part.Gui.Macros.icons.track.solo, separator = false,  index = 6 },
}

local matrix_data = {
    label_width = 55
}


-- Visibility Matrix
Part.Gui.Macros.drawVisibilityMatrix(matrix_data, visibility_data, Part.Parameter.Map.par_mcp_master_element_vis,
    nil, Part.Parameter.Map.par_mcp_master_element_separator)
Part.Cursor.incCursor(0, 4)

local selection = {
    { label = "Slim", value = 0, width = 35 },
    { label = "Wide", value = 1, width = 40 }
}

-- Layout
Part.Gui.Macros.drawButtonSelectionGroup(true, Part.Parameter.Map.par_mcp_master_element_width, false, selection,
    "Layout", 45)
Part.Gui.Macros.nextLine()
