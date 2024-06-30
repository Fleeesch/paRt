-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--      Tab : TCP : Master
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

-- Settings
-- ------------------------------

Part.Tab.Entry.setRecentTab(Part.Gui.Tab.tab_tcp_master)
Part.Gui.Macros.resetCursor()

local group_x = 30
local group_y = Part.Cursor.getCursorY() + 10
local slider_size_w = 90

-- Elements
-- ------------------------------

Part.Gui.Macros.drawGroupBox("Elements", group_x, group_y, 200, 240)
Part.Gui.Macros.lastGroup():setTint("arrangement")

local visibility_data = {
    { label = "Env",      image = Part.Gui.Macros.icons.track.env,     separator = true,  index = 1 },
    { label = "Mute",     image = Part.Gui.Macros.icons.track.mute,    separator = false, index = 2 },
    { label = "Solo",     image = Part.Gui.Macros.icons.track.solo,    separator = true,  index = 3 },
    { label = "IO",       image = Part.Gui.Macros.icons.track.io,      separator = false, index = 4 },
    { label = "Mono",     image = Part.Gui.Macros.icons.track.mono,    separator = true,  index = 5 },
    { label = "FX",       image = Part.Gui.Macros.icons.track.fx,      separator = false, index = 6 },
}

local matrix_data = {
    label_width = 70
}

-- Visibility Matrix
Part.Gui.Macros.drawVisibilityMatrix(matrix_data, visibility_data, Part.Parameter.Map.par_tcp_master_element_vis,
    nil, Part.Parameter.Map.par_tcp_master_element_separator)
Part.Cursor.incCursor(0, 4)

-- Envelope Button Size
Part.Gui.Macros.drawButtonToggleGroup(true, Part.Parameter.Map.par_tcp_master_element_adj_size_env, 50, "Envelope Button",
    "Large", 100)


-- Inserts
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(false, true, true)
Part.Gui.Macros.drawGroupBox("Inserts", group_x, Part.Cursor.getCursorY(), 200, 80)
Part.Gui.Macros.lastGroup():setTint("inserts")

local selection = {
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

Part.Gui.Macros.placeCursorAtLastGroup(true, false, true)
local group_x = Part.Cursor.getCursorX()
Part.Gui.Macros.drawGroupBox("Meter", group_x, group_y, 375, 100)
Part.Gui.Macros.lastGroup():setTint("meter")

-- Visibility
Part.Cursor.stackCursor()
Part.Gui.Macros.drawButtonToggleGroup(true, Part.Parameter.Map.par_tcp_master_meter_mode, 40, "Meter", "Show", 90)
Part.Gui.Macros.nextLine()

-- Volume Readout
Part.Gui.Macros.drawButtonToggleGroup(true, Part.Parameter.Map.par_tcp_master_meter_vol_readout, 40, "Vol Readout",
    "Show", 90)
Part.Gui.Macros.nextLine()

-- VU Text
Part.Gui.Macros.drawButtonToggleGroup(true, Part.Parameter.Map.par_tcp_master_meter_vu_db, 50, nil, "VU Text")
Part.Gui.Macros.nextInline()

-- Clip Text
Part.Gui.Macros.drawButtonToggleGroup(true, Part.Parameter.Map.par_tcp_master_meter_vu_readout, 60, nil, "Clip Text")
Part.Cursor.destackCursor()

-- Meter Size
Part.Cursor.incCursor(170, 0)
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_master_meter_size, false, 100, "Size",
    55)
Part.Gui.Macros.nextLine()

-- Division
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_master_meter_channeldiv, false, 100, "VU Space", 55)


-- Faders
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(false, true, true)
Part.Gui.Macros.drawGroupBox("Faders", group_x, Part.Cursor.getCursorY(), 300, 155)
Part.Gui.Macros.lastGroup():setTint("fader")

local fader_data = {
    { label = "Volume", par_vis = Part.Parameter.Map.par_tcp_master_fader_vol_vis, par_size = Part.Parameter.Map.par_tcp_master_fader_vol_size, par_size_scale = Part.Parameter.Map.par_tcp_master_fader_vol_size_scale },
    { label = "Pan",    par_vis = Part.Parameter.Map.par_tcp_master_fader_pan_vis, par_size = Part.Parameter.Map.par_tcp_master_fader_pan_size, par_size_scale = Part.Parameter.Map.par_tcp_master_fader_pan_size_scale },
    { label = "Width",  par_vis = Part.Parameter.Map.par_tcp_master_fader_wid_vis, par_size = Part.Parameter.Map.par_tcp_master_fader_wid_size, par_size_scale = Part.Parameter.Map.par_tcp_master_fader_wid_size_scale }
}

-- Fader Configuration
Part.Gui.Macros.drawTcpFaderConfiguration(fader_data, 55, 130)
Part.Cursor.incCursor(0, 4)

-- Fader Layout
Part.Gui.Macros.drawTcpFaderLayoutConfiguration(Part.Parameter.Map.par_tcp_master_fader_placement)
