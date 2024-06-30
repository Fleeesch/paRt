-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--      Tab : TCP : Track
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

-- Settings
-- ------------------------------

Part.Tab.Entry.setRecentTab(Part.Gui.Tab.tab_tcp_track)
Part.Gui.Macros.resetCursor()

local group_x = 10
local group_y = Part.Cursor.getCursorY() + 10
local slider_size_w = 90

-- Elements
-- ------------------------------

Part.Gui.Macros.drawGroupBox("Elements", group_x + 0, group_y + 0, 210, 375)
Part.Gui.Macros.lastGroup():setTint("arrangement")

local visibility_data = {
    { label = "Env",      image = Part.Gui.Macros.icons.track.env,     separator = true,  index = 1 },
    { label = "Rec Arm",  image = Part.Gui.Macros.icons.track.recarm,  separator = false, index = 2 },
    { label = "Monitor",  image = Part.Gui.Macros.icons.track.recmon,  separator = true,  index = 3 },
    { label = "Mute",     image = Part.Gui.Macros.icons.track.mute,    separator = false, index = 4 },
    { label = "Solo",     image = Part.Gui.Macros.icons.track.solo,    separator = true,  index = 5 },
    { label = "IO",       image = Part.Gui.Macros.icons.track.io,      separator = false, index = 6 },
    { label = "Phase",    image = Part.Gui.Macros.icons.track.phase,   separator = true,  index = 7 },
    { label = "FX",       image = Part.Gui.Macros.icons.track.fx,      separator = false, index = 8 },
    { label = "In FX",    image = Part.Gui.Macros.icons.track.infx,    separator = true,  index = 9 },
    { label = "Rec Mode", image = Part.Gui.Macros.icons.track.recmode, separator = false, index = 10 },
    { label = "Input",    image = Part.Gui.Macros.icons.track.input,   separator = false, index = 11 },
}

local matrix_data = {
    label_width = 70
}

-- Visibility Matrix
Part.Gui.Macros.drawVisibilityMatrix(matrix_data, visibility_data, Part.Parameter.Map.par_tcp_track_element_vis,
    Part.Parameter.Map.par_tcp_track_element_vis_mixer, Part.Parameter.Map.par_tcp_track_element_separator)
Part.Cursor.incCursor(0, 4)

-- Envelope Button Size
Part.Gui.Macros.drawButtonToggleGroup(true, Part.Parameter.Map.par_tcp_track_element_adj_size_env, 50, "Envelope Button",
    "Large", 100)
Part.Gui.Macros.nextLine()

-- Input Size
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_track_element_adj_size_input, false, 105, "Input Size",
    60)

-- Label
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(true, false, true)
group_x = Part.Cursor.getCursorX()

Part.Gui.Macros.drawGroupBox("Label", group_x, group_y, 195, 80)
Part.Gui.Macros.lastGroup():setTint("arrangement")

-- Label Size
Part.Cursor.stackCursor()
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_track_label_size, false, 115, "Size", 35)
Part.Gui.Macros.nextLine()

local selection = {
    { label = "Separate", value = 1, width = 55 },
    { label = "In Label", value = 2, width = 50 }
}

-- Track Index
Part.Gui.Macros.drawButtonSelectionGroup(true, Part.Parameter.Map.par_tcp_track_label_index_vis, true, selection,
    "Index", 35)
Part.Cursor.destackCursor()
Part.Gui.Macros.nextLine()


-- Inserts
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(true, false, true)
Part.Gui.Macros.drawGroupBox("Inserts", Part.Cursor.getCursorX(), group_y, 205, 80)
Part.Gui.Macros.lastGroup():setTint("inserts")

selection = {
    { label = "Inline",   value = 1, width = 40 },
    { label = "Separate", value = 2, width = 60 }
}

-- Display Mode
Part.Cursor.stackCursor()
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_track_insert_size, false, slider_size_w, "Size", 35,
    Part.Parameter.Map.par_tcp_track_insert_size_scale[1])
Part.Gui.Macros.nextLine()

-- Size
Part.Gui.Macros.drawButtonSelectionGroup(true, Part.Parameter.Map.par_tcp_track_insert_mode, true, selection, "Mode",
    35)
Part.Cursor.destackCursor()
Part.Gui.Macros.nextLine()

-- Meter
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(false, true, true)
Part.Gui.Macros.drawGroupBox("Meter", group_x, Part.Cursor.getCursorY(), 405, 100)
Part.Gui.Macros.lastGroup():setTint("meter")

-- Visibility
Part.Cursor.stackCursor()
Part.Gui.Macros.drawButtonToggleGroup(true, Part.Parameter.Map.par_tcp_track_meter_mode, 40, "Meter", "Show", 90)
Part.Gui.Macros.nextLine()

-- Volume Readout
Part.Gui.Macros.drawButtonToggleGroup(true, Part.Parameter.Map.par_tcp_track_meter_vol_readout, 40, "Vol Readout", "Show",
    90)
Part.Gui.Macros.nextLine()

-- VU Text
Part.Gui.Macros.drawButtonToggleGroup(true, Part.Parameter.Map.par_tcp_track_meter_vu_db, 50, nil, "VU Text")
Part.Gui.Macros.nextInline()

-- Clip Text
Part.Gui.Macros.drawButtonToggleGroup(true, Part.Parameter.Map.par_tcp_track_meter_vu_readout, 60, nil, "Clip Text")
Part.Cursor.destackCursor()

-- Meter Size
Part.Cursor.incCursor(170, 0)
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_track_meter_size, false, 100, "Size",
    55, Part.Parameter.Map.par_tcp_track_meter_size_scale[1])
Part.Gui.Macros.nextLine()

-- Division
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_track_meter_channeldiv, false, 100, "VU Space", 55)


-- Faders
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(false, true, true)
Part.Gui.Macros.drawGroupBox("Faders", group_x, Part.Cursor.getCursorY(), 320, 155)
Part.Gui.Macros.lastGroup():setTint("fader")

local fader_data = {
    { label = "Volume", par_vis = Part.Parameter.Map.par_tcp_track_fader_vol_vis, par_vis_mixer = Part.Parameter.Map.par_tcp_track_fader_vol_vis_mixer, par_size = Part.Parameter.Map.par_tcp_track_fader_vol_size, par_size_scale = Part.Parameter.Map.par_tcp_track_fader_vol_size_scale },
    { label = "Pan",    par_vis = Part.Parameter.Map.par_tcp_track_fader_pan_vis, par_vis_mixer = Part.Parameter.Map.par_tcp_track_fader_pan_vis_mixer, par_size = Part.Parameter.Map.par_tcp_track_fader_pan_size, par_size_scale = Part.Parameter.Map.par_tcp_track_fader_pan_size_scale },
    { label = "Width",  par_vis = Part.Parameter.Map.par_tcp_track_fader_wid_vis, par_vis_mixer = Part.Parameter.Map.par_tcp_track_fader_wid_vis_mixer, par_size = Part.Parameter.Map.par_tcp_track_fader_wid_size, par_size_scale = Part.Parameter.Map.par_tcp_track_fader_wid_size_scale }
}

-- Fader Configuration
Part.Gui.Macros.drawTcpFaderConfiguration(fader_data, 55, 130)
Part.Cursor.incCursor(0, 4)

-- Fader Layout
Part.Gui.Macros.drawTcpFaderLayoutConfiguration(Part.Parameter.Map.par_tcp_track_fader_placement)
