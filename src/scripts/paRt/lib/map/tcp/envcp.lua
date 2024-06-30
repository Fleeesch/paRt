-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--      Tab : TCP : ENVCP
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

-- ------------------------------
-- Settings

Part.Tab.Entry.setRecentTab(Part.Gui.Tab.tab_tcp_envcp)
Part.Gui.Macros.resetCursor()

local group_x = 105
local group_y = Part.Cursor.getCursorY() + 10
local group_x_fader_offset = 0
local slider_size_w = 120
local header_w = 245


-- Settings
-- ------------------------------

Part.Gui.Macros.drawGroupBox("Settings", group_x, group_y, 265, 100)
Part.Gui.Macros.lastGroup():setTint("settings")

-- Show Envelope Symbol
Part.Gui.Macros.drawButtonToggleGroup(true, Part.Parameter.Map.par_tcp_envcp_settings_symbol, 60, "Symbol",
    "Show", 90)
Part.Gui.Macros.nextLine()

-- Include Track Icon Lane
Part.Gui.Macros.drawButtonToggleGroup(true, Part.Parameter.Map.par_tcp_envcp_settings_lane_display, 60, "Track Icon Lane",
    "Include", 90)
Part.Gui.Macros.nextLine()

-- Indentation
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_envcp_settings_indent, false, slider_size_w,
    "Indentation",
    90)
Part.Gui.Macros.nextLine()

Part.Gui.Macros.placeCursorAtLastGroup(true,false,true)
local group_x_elements = Part.Cursor.getCursorX()

-- Label
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(false,true,true)
Part.Gui.Macros.drawGroupBox("Label", group_x, Part.Cursor.getCursorY(), 265, 125)
Part.Gui.Macros.lastGroup():setTint("arrangement")

-- Label Size
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_envcp_label_size, false, slider_size_w, "Size",
    70)
Part.Gui.Macros.nextLine()

local selection = {
    { label = "In Label", value = 1, width = 55 },
    { label = "Separate", value = 2, width = 60 }
}

-- Value Display
Part.Gui.Macros.drawHeader("Value Display", header_w)
Part.Gui.Macros.nextLine()

-- Placement
Part.Gui.Macros.drawButtonSelectionGroup(true, Part.Parameter.Map.par_tcp_envcp_label_readout_placement, true, selection,
    "Placement", 70)
Part.Gui.Macros.nextLine()

-- Size
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_envcp_label_readout_size, false, slider_size_w, "Size",
    70, Part.Parameter.Map.par_tcp_envcp_label_readout_size_scale[1])
Part.Gui.Macros.nextLine()

-- Fader
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(false,true,true)
Part.Gui.Macros.drawGroupBox("Fader", group_x + group_x_fader_offset , Part.Cursor.getCursorY(), 295, 100)
Part.Gui.Macros.lastGroup():setTint("fader")

local selection = {
    { label = "Inline",    value = 1, width = 45 },
    { label = "Separate",  value = 2, width = 60 },
    { label = "Icon Lane", value = 3, width = 60 }
}

-- Placement
Part.Gui.Macros.drawButtonSelectionGroup(true, Part.Parameter.Map.par_tcp_envcp_value_mode, true, selection,
    "Placement", 70)
Part.Gui.Macros.nextLine()

selection = {
    { label = "Horizontal",    value = 0, width = 65 },
    { label = "Vertical",  value = 1, width = 60 }
}

-- Orientation
Part.Gui.Macros.drawButtonSelectionGroup(true, Part.Parameter.Map.par_tcp_envcp_value_vertical, false, selection,
    "Orientation", 70)
Part.Gui.Macros.nextLine()

-- Size
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_envcp_value_size, false, slider_size_w, "Size",
    70, Part.Parameter.Map.par_tcp_envcp_value_scale[1])
Part.Gui.Macros.nextLine()

-- Elements
-- ------------------------------

Part.Gui.Macros.drawGroupBox("Elements", group_x_elements, group_y, 160, 230)
Part.Gui.Macros.lastGroup():setTint("arrangement")

local visibility_data = {
    { label = "Arm",    image = Part.Gui.Macros.icons.envcp.arm,    separator = true,  index = 1 },
    { label = "Bypass", image = Part.Gui.Macros.icons.envcp.bypass, separator = false, index = 2 },
    { label = "Hide",   image = Part.Gui.Macros.icons.envcp.hide,   separator = true,  index = 3 },
    { label = "Mod",    image = Part.Gui.Macros.icons.envcp.mod,    separator = false, index = 4 },
    { label = "Learn",  image = Part.Gui.Macros.icons.envcp.learn,  separator = false, index = 5 }
}

local matrix_data = {
    label_width = 50
}

-- Visibility Matrix
Part.Gui.Macros.drawVisibilityMatrix(matrix_data, visibility_data, Part.Parameter.Map.par_tcp_envcp_element_vis, nil,
    Part.Parameter.Map.par_tcp_envcp_element_separator)
Part.Cursor.incCursor(0, 4)
