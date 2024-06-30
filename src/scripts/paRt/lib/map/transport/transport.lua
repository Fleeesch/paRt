-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--      Tab : Transport
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

-- Settings
-- ------------------------------

Part.Tab.Entry.setRecentTab(Part.Gui.Tab.tab_transport)
Part.Gui.Macros.resetCursor()

local group_x = 110
local group_y = Part.Cursor.getCursorY()

local header_w = 220
local label_w = 60
local slider_w = 130

-- Elements
-- ------------------------------

Part.Gui.Macros.drawGroupBox("Elements", group_x + 0, group_y, 185, 380)
Part.Gui.Macros.lastGroup():setTint("arrangement")

-- visibility matrix
local visibility_data = {
    { label = "Rewind",     image = Part.Gui.Macros.icons.transport.rewind,     separator = false, index = 1 },
    { label = "Forward",    image = Part.Gui.Macros.icons.transport.forward,    separator = true,  index = 2 },
    { label = "Stop",       image = Part.Gui.Macros.icons.transport.stop,       separator = false, index = 3 },
    { label = "Pause",      image = Part.Gui.Macros.icons.transport.pause,      separator = false, index = 4 },
    { label = "Play",       image = Part.Gui.Macros.icons.transport.play,       separator = true,  index = 5 },
    { label = "Record",     image = Part.Gui.Macros.icons.transport.record,     separator = true,  index = 6 },
    { label = "Repeat",     image = Part.Gui.Macros.icons.transport.loop,       separator = true,  index = 7 },
    { label = "Automation", image = Part.Gui.Macros.icons.transport.automation, separator = false, index = 8 },
    { label = "Bpm",        image = Part.Gui.Macros.icons.transport.bpm,        separator = false, index = 9 },
    { label = "Status",     image = Part.Gui.Macros.icons.transport.status,     separator = false, index = 10 },
    { label = "Selection",  image = Part.Gui.Macros.icons.transport.selection,  separator = false, index = 11 }
}

local matrix_data = {
    label_width = 70
}


Part.Gui.Macros.drawVisibilityMatrix(matrix_data, visibility_data, Part.Parameter.Map.par_trans_element_vis, nil,
    Part.Parameter.Map.par_trans_element_separator)

-- bank switching buttons
Part.Cursor.incCursor(0, 10)
Part.Cursor.stackCursor()
Part.Gui.Macros.drawSliderGroup(false, Part.Parameter.Map.par_trans_settings_theme_macros, false, 50, "Bank Buttons",
    60)
Part.Gui.Macros.nextInline()
Part.Cursor.setCursorSize(20)
Part.Layout.Text.Text:new(nil, "", Part.Parameter.Map.par_trans_settings_theme_macros)
Part.Draw.Elements.lastElement():parameterMonitor(1)
Part.Cursor.destackCursor()
Part.Gui.Macros.nextLine()

-- separator size
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_trans_element_adj_separator_size, false, 75, "Separator",
    60)
Part.Gui.Macros.nextLine()


-- Spacing
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(true, false, true)
group_x = Part.Cursor.getCursorX()
Part.Gui.Macros.drawGroupBox("Spacing", group_x, group_y, 240, 185)
Part.Gui.Macros.lastGroup():setTint("dimensions")

-- extra padding
Part.Gui.Macros.drawHeader("Extra Padding", header_w)
Part.Gui.Macros.nextLine()

Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_trans_settings_extrapad_x, false, slider_w, "Width", label_w)
Part.Gui.Macros.nextLine()
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_trans_settings_extrapad_y, false, slider_w, "Height",
    label_w)

Part.Gui.Macros.nextLine()

-- spacing
Part.Gui.Macros.drawHeader("Distance", header_w)
Part.Gui.Macros.nextLine()
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_trans_element_adj_spacing_x, false, slider_w, "Buttons",
    label_w)
Part.Gui.Macros.nextLine()
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_trans_element_adj_spacing_time_x, false, slider_w,
    "Tempo",
    label_w)
Part.Gui.Macros.nextLine()
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_trans_element_adj_spacing_section_x, false, slider_w,
    "Section",
    label_w)
Part.Gui.Macros.nextLine()

-- Sizes
-- ------------------------------

local slider_w_sizes = slider_w - 30

Part.Gui.Macros.placeCursorAtLastGroup(false, true, true)
Part.Gui.Macros.drawGroupBox("Sizes", group_x, Part.Cursor.getCursorY(), 240, 80)
Part.Gui.Macros.lastGroup():setTint("dimensions")

Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_trans_element_adj_status_size, false, slider_w_sizes, "Status",
    label_w,
    Part.Parameter.Map.par_trans_element_adj_status_size_scale[1])
Part.Gui.Macros.nextLine()
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_trans_element_adj_selection_size, false, slider_w_sizes,
    "Selection",
    label_w, Part.Parameter.Map.par_trans_element_adj_selection_size_scale[1])


-- Time Elements
-- ------------------------------

label_w = 90

Part.Gui.Macros.placeCursorAtLastGroup(false, true, true)
Part.Gui.Macros.drawGroupBox("Time Elements", group_x, Part.Cursor.getCursorY(), 240, 105)
Part.Gui.Macros.lastGroup():setTint("arrangement")

Part.Gui.Macros.drawButtonToggleGroup(true, Part.Parameter.Map.par_trans_element_adj_bpm_tap, 50, "Tap Button", "Show",
    label_w)
Part.Gui.Macros.nextLine()

local selection = {
    { label = "Knob",  value = 1, width = 50 },
    { label = "Fader", value = 2, width = 45 },
}

Part.Gui.Macros.drawButtonSelectionGroup(true, Part.Parameter.Map.par_trans_playrate_mode, true, selection,
    "Rate Control", label_w)
Part.Gui.Macros.nextLine()
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_trans_playrate_size, false, 100, "Rate Fader Size",
    label_w)
