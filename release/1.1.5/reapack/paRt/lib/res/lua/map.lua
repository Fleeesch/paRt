-- @version 1.1.5
-- @author Fleeesch
-- @description paRt Theme Adjuster
-- @noIndex

-- ===========================================================================
--      Spritesheet
-- ===========================================================================

Part.Layout.icon_spritesheet = Part.Layout.Spritesheet:new(nil, "lib/res/icon/themeadj_sprites.png",
    "lib.res.icon.themeadj_sprites")

-- ===========================================================================
--      Tab Header Bar
-- ===========================================================================

Part.Gui.Tab = {}

Part.Cursor.stackCursor()

Part.Cursor.setCursor(0, 0, Part.Global.win_w, Part.Global.tab_height, 0, 0)

-- Tab Bar
Part.Gui.Tab.tab_top = Part.Tab.Group.TabGroup:new(nil, "Top Menu")

-- Tab Sub-Entries
Part.Gui.Tab.tab_colors = Part.Tab.Entry.TabEntry:new(nil, Part.Gui.Tab.tab_top, "Colors")
Part.Gui.Tab.tab_transport = Part.Tab.Entry.TabEntry:new(nil, Part.Gui.Tab.tab_top, "Transport")
Part.Gui.Tab.tab_tcp = Part.Tab.Entry.TabEntry:new(nil, Part.Gui.Tab.tab_top, "TCP")
Part.Gui.Tab.tab_mcp = Part.Tab.Entry.TabEntry:new(nil, Part.Gui.Tab.tab_top, "MCP")

Part.Cursor.incCursor(0, Part.Cursor.getCursorH())

-- Global
Part.Gui.Tab.tab_colors_sub = Part.Tab.Group.TabGroup:new(nil, "Global", Part.Gui.Tab.tab_colors, 1)
Part.Gui.Tab.tab_colors_themes = Part.Tab.EntrySub.TabEntrySub:new(nil, Part.Gui.Tab.tab_colors_sub,
    "Themes / Adjustments")
Part.Gui.Tab.tab_colors_tracks = Part.Tab.EntrySub.TabEntrySub:new(nil, Part.Gui.Tab.tab_colors_sub,
    "Track / Envelope / Meter")

-- Transport
Part.Gui.Tab.tab_transport_sub = Part.Tab.Group.TabGroup:new(nil, "Transport", Part.Gui.Tab.tab_transport, 1)

-- Tcp
Part.Gui.Tab.tab_tcp_sub = Part.Tab.Group.TabGroup:new(nil, "TCP", Part.Gui.Tab.tab_tcp, 1)
Part.Gui.Tab.tab_tcp_general = Part.Tab.EntrySub.TabEntrySub:new(nil, Part.Gui.Tab.tab_tcp_sub, "General")
Part.Gui.Tab.tab_tcp_track = Part.Tab.EntrySub.TabEntrySub:new(nil, Part.Gui.Tab.tab_tcp_sub, "Track")
Part.Gui.Tab.tab_tcp_envcp = Part.Tab.EntrySub.TabEntrySub:new(nil, Part.Gui.Tab.tab_tcp_sub, "ENVCP")
Part.Gui.Tab.tab_tcp_master = Part.Tab.EntrySub.TabEntrySub:new(nil, Part.Gui.Tab.tab_tcp_sub, "Master")

-- Mcp
Part.Gui.Tab.tab_mcp_sub = Part.Tab.Group.TabGroup:new(nil, "MCP", Part.Gui.Tab.tab_mcp, 1)
Part.Gui.Tab.tab_mcp_general = Part.Tab.EntrySub.TabEntrySub:new(nil, Part.Gui.Tab.tab_mcp_sub, "General")
Part.Gui.Tab.tab_mcp_track = Part.Tab.EntrySub.TabEntrySub:new(nil, Part.Gui.Tab.tab_mcp_sub, "Track")
Part.Gui.Tab.tab_mcp_master = Part.Tab.EntrySub.TabEntrySub:new(nil, Part.Gui.Tab.tab_mcp_sub, "Master")

-- Bank Bar
Part.Cursor.setCursorSize(Part.Global.win_w, Part.Global.bank_bar_size)
Part.Cursor.setCursorPos(0, Part.Global.win_h - Part.Cursor.getCursorH())

-- create bank bar
Part.Cursor.stackCursor()

Part.Gui.BankBar = Part.Layout.BankBar.BankBar:new(nil, Part.Bank.Handler)

Part.Cursor.destackCursor()

-- ===========================================================================
--      Message Handler
-- ===========================================================================

Part.Cursor.incCursor(0, -10)
Part.Cursor.setCursorPos(0, Part.Cursor.getCursorY())
Part.Cursor.setCursorSize(Part.Global.win_w - 10, Part.Cursor.getCursorH())

Part.Gui.MessageHandler = Part.Message.Handler.MessageHandler:new()

Part.Cursor.destackCursor()


-- ===========================================================================
--      Tab : Colors : Themes / Adjustments
-- ===========================================================================

-- Settings
-- ------------------------------

Part.Tab.Entry.setRecentTab(Part.Gui.Tab.tab_colors_themes)
Part.Gui.Macros.resetCursor()

local group_x = 180
local group_y = Part.Cursor.getCursorY() + 20

local label_w = 75
local slider_w = 200
local subheader_w = 280

-- Themes
-- ------------------------------

Part.Gui.Macros.drawGroupBox("Theme File", group_x + 90, group_y, 120, 100)

local theme_list = {
    { label = "Dark",   function_call = "loadDarkTheme" },
    { label = "Dimmed", function_call = "loadDimmedTheme" },
    { label = "Light",  function_call = "loadLightTheme" }
}

Part.Cursor.setCursorSize(100, nil)

for idx, theme in pairs(theme_list) do
    Part.Control.Button.Button:new(nil, Part.Global.par_theme_selected, false, theme.label, idx - 1)
    Part.Draw.Elements.lastElement():bindAction(theme.function_call)
    Part.Gui.Macros.nextLine()
end

-- Color Adjustments
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(false, true)
group_y = Part.Cursor.getCursorY() + Part.Gui.Macros.pad_group

Part.Gui.Macros.drawGroupBox("Color Adjustments", group_x, group_y, 300, 230)

Part.Cursor.stackCursor()
Part.Cursor.incCursor(50, 0)
Part.Cursor.setCursorSize(160, nil)
Part.Control.Button.Button:new(nil, Part.Parameter.Map.par_global_color_custom_overwrite, true, "Apply to Custom Colors",
    1)
Part.Cursor.destackCursor()
Part.Gui.Macros.nextLine()

Part.Gui.Macros.lastGroup():setTint("colors")

local color_adj_list = {
    { subheader = "Colors",     label = "Hue",        paramter = Part.Parameter.Map.par_global_color_hue,        thumb_opcaity = 0.5, gradient = Part.Color.Lookup.color_palette.gradient.slider.hue },
    { subheader = nil,          label = "Saturation", paramter = Part.Parameter.Map.par_global_color_saturation, thumb_opcaity = 0.5, gradient = Part.Color.Lookup.color_palette.gradient.slider.saturation },
    { subheader = "Brightness", label = "Gamma",      paramter = Part.Parameter.Map.par_global_color_gamma,      thumb_opcaity = 0.5, gradient = Part.Color.Lookup.color_palette.gradient.slider.gamma },
    { subheader = nil,          label = "Highlights", paramter = Part.Parameter.Map.par_global_color_highlights, thumb_opcaity = 0,   gradient = Part.Color.Lookup.color_palette.gradient.slider.highlights },
    { subheader = nil,          label = "Midtones",   paramter = Part.Parameter.Map.par_global_color_midtones,   thumb_opcaity = 0,   gradient = Part.Color.Lookup.color_palette.gradient.slider.midtones },
    { subheader = nil,          label = "Shadows",    paramter = Part.Parameter.Map.par_global_color_shadows,    thumb_opcaity = 0,   gradient = Part.Color.Lookup.color_palette.gradient.slider.shadows }
}

for idx, color_adj in pairs(color_adj_list) do
    if color_adj.subheader ~= nil then
        Part.Gui.Macros.drawHeader(color_adj.subheader, subheader_w)
        Part.Cursor.incCursor(0, Part.Cursor.getCursorH())
    end

    Part.Cursor.stackCursor()
    Part.Gui.Macros.openLabel()
    Part.Gui.Macros.drawParameterLabel(color_adj.label, label_w)
    Part.Cursor.setCursorSize(slider_w, nil)
    Part.Control.Slider.Slider:new(nil, color_adj.paramter)
    Part.Draw.Elements.lastElement():colorFinder(color_adj.thumb_opcaity, color_adj.gradient)
    Part.Draw.Elements.lastElement():noValueFill()
    Part.Gui.Macros.closeLabel()
    Part.Cursor.destackCursor()
    Part.Cursor.incCursor(0, Part.Cursor.getCursorH())
end

-- ===========================================================================
--      Tab : Colors : Track / Envelope / Meter
-- ===========================================================================

-- Settings
-- ------------------------------

Part.Tab.Entry.setRecentTab(Part.Gui.Tab.tab_colors_tracks)
Part.Gui.Macros.resetCursor()

local group_x = 25
local group_y = Part.Cursor.getCursorY() + 5

local label_w = 75
local knob_list = {}
local header_w = 250

-- Functions
-- ------------------------------

local function drawTintMatrix(list)
    for idx, knob in pairs(list) do
        Part.Gui.Macros.drawKnobGroup(knob.bank, knob.parameter, knob.knob_bi, knob.label, label_w)

        Part.Cursor.stackCursor()
        Part.Gui.Macros.nextInline()
        Part.Cursor.setCursorSize(Part.Gui.Macros.bank_w, nil)
        Part.Gui.Macros.drawKnobGroup(knob.bank, knob.parameter_select, false, knob.label_select, 80)
        Part.Cursor.destackCursor()
        Part.Cursor.incCursor(0, Part.Gui.Macros.line_h)
    end
end

-- Track
-- ------------------------------

Part.Gui.Macros.drawGroupBox("Tracks", group_x + 0, group_y, 270, 254)
Part.Gui.Macros.lastGroup():setTint("colors")

-- Colobar
Part.Gui.Macros.drawKnobGroup(true, Part.Parameter.Map.par_colors_track_track_colorbar_intensity, false,
    "Colorbar Intensity",
    120)
Part.Gui.Macros.nextLine()

knob_list = {
    { label = "Tone", label_select = "on Selection", bank = true, knob_bi = true,  parameter = Part.Parameter.Map.par_colors_track_track_bg_tone, parameter_select = Part.Parameter.Map.par_colors_track_track_bg_select_tone },
    { label = "Tint", label_select = "on Selection", bank = true, knob_bi = false, parameter = Part.Parameter.Map.par_colors_track_track_bg_tint, parameter_select = Part.Parameter.Map.par_colors_track_track_bg_select_tint }
}

-- Background
Part.Gui.Macros.drawHeader("Background", header_w)
Part.Gui.Macros.nextLine()

drawTintMatrix(knob_list)

-- Label
Part.Gui.Macros.drawHeader("Label", header_w)
Part.Gui.Macros.nextLine()

knob_list = {
    { label = "Tone", label_select = "on Selection", bank = true, knob_bi = true,  parameter = Part.Parameter.Map.par_colors_track_track_label_bg_tone, parameter_select = Part.Parameter.Map.par_colors_track_track_label_select_tone },
    { label = "Tint", label_select = "on Selection", bank = true, knob_bi = false, parameter = Part.Parameter.Map.par_colors_track_track_label_bg_tint, parameter_select = Part.Parameter.Map.par_colors_track_track_label_select_tint }
}

drawTintMatrix(knob_list)

Part.Gui.Macros.drawKnobGroup(true, Part.Parameter.Map.par_colors_track_track_label_text_tone, true, "Text Tone",
    label_w)
Part.Gui.Macros.nextLine()

-- Track Index
Part.Gui.Macros.drawHeader("Track Index", header_w)
Part.Gui.Macros.nextLine()

Part.Gui.Macros.drawKnobGroup(true, Part.Parameter.Map.par_colors_track_track_index_tone_tcp, true, "TCP", label_w)
Part.Gui.Macros.nextInline()
Part.Gui.Macros.drawKnobGroup(true, Part.Parameter.Map.par_colors_track_track_index_tone_mcp, true, "MCP", label_w)

-- Envelopes
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(false, true, true)

Part.Gui.Macros.drawGroupBox("Envelopes", group_x, Part.Cursor.getCursorY(), 270, 146)
Part.Gui.Macros.lastGroup():setTint("colors")

-- Background
Part.Gui.Macros.drawHeader("Background", header_w)
Part.Cursor.incCursor(0, Part.Gui.Macros.line_h)

Part.Cursor.stackCursor()
Part.Gui.Macros.drawKnobGroup(true, Part.Parameter.Map.par_colors_track_envcp_bg_tone, true, "Tone", label_w)
Part.Gui.Macros.nextInline()
Part.Gui.Macros.drawKnobGroup(true, Part.Parameter.Map.par_colors_track_envcp_bg_tint, false, "Tint", label_w)
Part.Cursor.destackCursor()
Part.Gui.Macros.nextLine()

-- Label
Part.Gui.Macros.drawHeader("Label", header_w)
Part.Gui.Macros.nextLine()

Part.Cursor.stackCursor()
Part.Gui.Macros.drawKnobGroup(true, Part.Parameter.Map.par_colors_track_envcp_label_bg_Tone, true, "Tone", label_w)
Part.Gui.Macros.nextInline()
Part.Gui.Macros.drawKnobGroup(true, Part.Parameter.Map.par_colors_track_envcp_label_bg_tint, false, "Tint", label_w)
Part.Cursor.destackCursor()
Part.Gui.Macros.nextLine()

Part.Gui.Macros.drawKnobGroup(true, Part.Parameter.Map.par_colors_track_envcp_label_text_tone, true, "Text Tone",
    label_w)
Part.Gui.Macros.nextInline()
Part.Gui.Macros.drawKnobGroup(true, Part.Parameter.Map.par_colors_track_envcp_label_readout_tone, true, "Value Tone",
    label_w)

-- Meter Text
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(true, false, true)
group_x = Part.Cursor.getCursorX()
Part.Gui.Macros.drawGroupBox("Meter Text", group_x, group_y, 310, 234)
Part.Gui.Macros.lastGroup():setTint("meter")

local label_w_meter_2 = 80
local label_w_meter_3 = 50
local header_w = 290

-- Unlit
Part.Gui.Macros.drawHeader("Unlit", header_w)
Part.Gui.Macros.nextLine()

Part.Cursor.stackCursor()
Part.Gui.Macros.drawKnobGroup(true, Part.Parameter.Map.par_colors_track_meter_text_tone_unlit, true, "Tone",
    label_w_meter_3)
Part.Gui.Macros.nextInline()
Part.Gui.Macros.drawKnobGroup(true, Part.Parameter.Map.par_colors_track_meter_text_alpha_unlit, false, "Alpha",
    label_w_meter_3)
Part.Gui.Macros.nextInline()
Part.Gui.Macros.drawKnobGroup(true, Part.Parameter.Map.par_colors_track_meter_text_shadow_unlit, false, "Shadow",
    label_w_meter_3)
Part.Cursor.destackCursor()
Part.Gui.Macros.nextLine()

-- Lit
Part.Gui.Macros.drawHeader("Lit", header_w)
Part.Gui.Macros.nextLine()

Part.Cursor.stackCursor()
Part.Gui.Macros.drawKnobGroup(true, Part.Parameter.Map.par_colors_track_meter_text_tone_lit, true, "Tone",
    label_w_meter_3)
Part.Gui.Macros.nextInline()
Part.Gui.Macros.drawKnobGroup(true, Part.Parameter.Map.par_colors_track_meter_text_alpha_lit, false, "Alpha",
    label_w_meter_3)
Part.Gui.Macros.nextInline()
Part.Gui.Macros.drawKnobGroup(true, Part.Parameter.Map.par_colors_track_meter_text_shadow_lit, false, "Shadow",
    label_w_meter_3)
Part.Cursor.destackCursor()
Part.Gui.Macros.nextLine()

-- Alpha
Part.Gui.Macros.drawHeader("Alpha", header_w)
Part.Gui.Macros.nextLine()

Part.Cursor.stackCursor()
Part.Gui.Macros.drawKnobGroup(true, Part.Parameter.Map.par_colors_track_meter_text_alpha_track, false, "Track",
    label_w_meter_2)
Part.Gui.Macros.nextInline()
Part.Gui.Macros.drawKnobGroup(true, Part.Parameter.Map.par_colors_track_meter_text_alpha_master, false, "Master",
    label_w_meter_2)
Part.Cursor.destackCursor()
Part.Gui.Macros.nextLine()

-- Readout
Part.Gui.Macros.drawHeader("Readout", header_w)
Part.Gui.Macros.nextLine()

Part.Cursor.stackCursor()
Part.Gui.Macros.drawKnobGroup(true, Part.Parameter.Map.par_colors_track_meter_text_tone_readout, true, "Tone",
    label_w_meter_2)
Part.Gui.Macros.nextInline()
Part.Gui.Macros.drawKnobGroup(true, Part.Parameter.Map.par_colors_track_meter_text_alpha_readout, false, "Alpha",
    label_w_meter_2)
Part.Cursor.destackCursor()
Part.Gui.Macros.nextLine()

Part.Cursor.stackCursor()
Part.Gui.Macros.drawKnobGroup(true, Part.Parameter.Map.par_colors_track_meter_text_tone_readout_clip, true, "Clip Tone",
    label_w_meter_2)
Part.Gui.Macros.nextInline()
Part.Gui.Macros.drawKnobGroup(true, Part.Parameter.Map.par_colors_track_meter_text_alpha_readout_clip, false,
    "Clip Alpha",
    label_w_meter_2)
Part.Cursor.destackCursor()
Part.Gui.Macros.nextLine()


-- ------------------------------
-- Folders

local header_w = 250

Part.Gui.Macros.placeCursorAtLastGroup(false, true, true)
Part.Gui.Macros.drawGroupBox("Folders", group_x, Part.Cursor.getCursorY(), 270, 165)
Part.Gui.Macros.lastGroup():setTint("folder")

-- Folder Track
Part.Gui.Macros.drawHeader("Folder Track", header_w)
Part.Gui.Macros.nextLine()

Part.Cursor.stackCursor()
Part.Gui.Macros.drawKnobGroup(true, Part.Parameter.Map.par_colors_track_folder_foldertrack_tone, true, "Tone", label_w)
Part.Gui.Macros.nextInline()
Part.Gui.Macros.drawKnobGroup(true, Part.Parameter.Map.par_colors_track_folder_foldertrack_tint, true, "Tint", label_w)
Part.Cursor.destackCursor()
Part.Gui.Macros.nextLine()

-- Folder Tree
Part.Gui.Macros.drawHeader("Folder Tree", header_w)
Part.Gui.Macros.nextLine()
Part.Control.Hint.Hint:new(nil, Part.Gui.Hint.Lookup.folder_tree, Part.Gui.Macros.getLastParameterLabel(), true)

Part.Cursor.stackCursor()
Part.Gui.Macros.drawKnobGroup(true, Part.Parameter.Map.par_colors_track_folder_foldertree_tone, true, "Tone", label_w)
Part.Gui.Macros.nextInline()
Part.Gui.Macros.drawKnobGroup(true, Part.Parameter.Map.par_colors_track_folder_foldertree_tint, true, "Tint", label_w)
Part.Cursor.destackCursor()

-- ===========================================================================
--      Tab : Transport
-- ===========================================================================

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

Part.Gui.Macros.drawGroupBox("Elements", group_x + 0, group_y, 185, 400)
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

-- menu button
Part.Cursor.incCursor(0, 10)
Part.Cursor.stackCursor()
Part.Gui.Macros.drawButtonToggleGroup(false, Part.Parameter.Map.par_trans_settings_theme_menu, 50, "Menu Button", "Show",
    80)
Part.Control.Hint.Hint:new(nil, Part.Gui.Hint.Lookup.menu_button, Part.Gui.Macros.getLastParameterLabel(), true)

Part.Cursor.destackCursor()
Part.Gui.Macros.nextLine()

-- bank buttons
Part.Cursor.stackCursor()
Part.Gui.Macros.drawSliderGroup(false, Part.Parameter.Map.par_trans_settings_theme_bank, false, 50, "Bank Buttons",
    60)
Part.Control.Hint.Hint:new(nil, Part.Gui.Hint.Lookup.bank_buttons, Part.Gui.Macros.getLastParameterLabel(), true)
Part.Gui.Macros.nextInline()
Part.Cursor.setCursorSize(20)
Part.Layout.Text.Text:new(nil, "", Part.Parameter.Map.par_trans_settings_theme_bank)
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

Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_trans_element_adj_status_size, false, slider_w_sizes,
    "Status",
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
Part.Gui.Macros.drawGroupBox("Time Elements", group_x, Part.Cursor.getCursorY(), 240, 125)
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

-- ===========================================================================
--      Tab : TCP : General
-- ===========================================================================

-- Settings
-- ------------------------------

Part.Tab.Entry.setRecentTab(Part.Gui.Tab.tab_tcp_general)
Part.Gui.Macros.resetCursor()

local group_x = 50
local group_y = Part.Cursor.getCursorY() + 20

local header_w = 255
local slider_w = 90
local label_w = 110

-- Spacing
-- ------------------------------

Part.Gui.Macros.drawGroupBox("Spacing", group_x, group_y, 275, 215)
Part.Gui.Macros.lastGroup():setTint("dimensions")

-- Button Spacing
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_gen_element_adj_spacing_x, false, slider_w,
    "Button Distance", label_w)
Part.Gui.Macros.nextLine()

-- Separator Size
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_gen_element_adj_separator, false, slider_w,
    "Button Separator",
    label_w, Part.Parameter.Map.par_tcp_gen_element_adj_separator_line[1], "Ico")
Part.Gui.Macros.nextLine()


-- Fader Distance
Part.Gui.Macros.drawHeader("Fader Distance", header_w)
Part.Gui.Macros.nextLine()
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_gen_element_adj_spacing_x_fader, false, slider_w,
    "Horizontal", label_w)
Part.Gui.Macros.nextLine()
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_gen_element_adj_spacing_y_fader, false, slider_w,
    "Vertical", label_w)
Part.Gui.Macros.nextLine()

-- Section Distance
Part.Gui.Macros.drawHeader("Section Distance", header_w)
Part.Gui.Macros.nextLine()
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_gen_element_adj_spacing_section_x, false, slider_w,
    "Horizontal", label_w)
Part.Gui.Macros.nextLine()
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_gen_element_adj_spacing_section_y, false, slider_w,
    "Vertical", label_w)

-- Inserts
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(false, true, true)
Part.Gui.Macros.drawGroupBox("Inserts", group_x, Part.Cursor.getCursorY(), 275, 55)
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_gen_insert_slot_width, false, slider_w, "Slot Size",
    label_w)

-- Highlights
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(true, false, true)
local group_x_2 = Part.Cursor.getCursorX()

Part.Gui.Macros.drawGroupBox("Highlights", group_x_2, group_y, 260, 85)
Part.Gui.Macros.lastGroup():setTint("colors")

-- Selection Marker
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_gen_highlight_selection, false, slider_w,
    "Selection Bar", label_w)
Part.Gui.Macros.nextLine()

-- Color Bar
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_gen_highlight_color, false, slider_w, "Color Bar",
    label_w)
Part.Gui.Macros.nextLine()

-- Folders
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(false, true, true)
Part.Gui.Macros.drawGroupBox("Folders", group_x_2, Part.Cursor.getCursorY(), 260, 140)
Part.Gui.Macros.lastGroup():setTint("folder")

Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_gen_folder_indent, false, slider_w, "Indentation",
    label_w)
Part.Gui.Macros.nextLine()
Part.Gui.Macros.drawHeader("Buttons", 230)
Part.Gui.Macros.nextLine()

-- Buttons
local selection = {
    { label = "Buttons", value = 1, width = 50 },
    { label = "+ Lines",    value = 2, width = 50 }
}

-- Position
Part.Cursor.stackCursor()
Part.Gui.Macros.drawButtonSelectionGroup(true, Part.Parameter.Map.par_tcp_gen_folder_icon_collapse, true, selection,
    "Collapse Toggle", label_w)

Part.Gui.Macros.nextLine()
Part.Gui.Macros.drawButtonToggleGroup(true, Part.Parameter.Map.par_tcp_gen_folder_icon_mode, 50, "Folder Mode", "Show",
    label_w)
Part.Gui.Macros.nextLine()




-- ===========================================================================
--      Tab : TCP : Track
-- ===========================================================================

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

-- Meter
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(true, false, true)
group_x = Part.Cursor.getCursorX()
Part.Gui.Macros.drawGroupBox("Meter", group_x, group_y, 405, 100)
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
Part.Gui.Macros.drawGroupBox("Faders", group_x, Part.Cursor.getCursorY(), 405, 155)
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
Part.Control.Hint.Hint:new(nil, Part.Gui.Hint.Lookup.tcp_fader_layout_inline, Part.Gui.Macros.getLastParameterLabel(2),
    false)
Part.Control.Hint.Hint:new(nil, Part.Gui.Hint.Lookup.tcp_fader_layout_separate, Part.Gui.Macros.getLastParameterLabel(1),
    false)
Part.Control.Hint.Hint:new(nil, Part.Gui.Hint.Lookup.tcp_fader_layout_separate_exploded,
    Part.Gui.Macros.getLastParameterLabel(), false)


-- Label
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(false, true, true)
group_y = Part.Cursor.getCursorY()
Part.Gui.Macros.drawGroupBox("Label", group_x, group_y, 195, 80)
Part.Gui.Macros.lastGroup():setTint("arrangement")

-- Label Size
Part.Cursor.stackCursor()
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_track_label_size, false, 115, "Size", 35)
Part.Control.Hint.Hint:new(nil, Part.Gui.Hint.Lookup.tcp_label_size, Part.Gui.Macros.getLastParameterLabel(), true)
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


-- ===========================================================================
--      Tab : TCP : ENVCP
-- ===========================================================================

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
Part.Control.Hint.Hint:new(nil, Part.Gui.Hint.Lookup.envcp_iconlane, Part.Gui.Macros.getLastParameterLabel(), true)
Part.Gui.Macros.nextLine()

-- Indentation
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_envcp_settings_indent, false, slider_size_w,
    "Indentation",
    90)
Part.Gui.Macros.nextLine()

Part.Gui.Macros.placeCursorAtLastGroup(true, false, true)
local group_x_elements = Part.Cursor.getCursorX()

-- Label
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(false, true, true)
Part.Gui.Macros.drawGroupBox("Label", group_x, Part.Cursor.getCursorY(), 265, 125)
Part.Gui.Macros.lastGroup():setTint("arrangement")

-- Label Size
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_envcp_label_size, false, slider_size_w, "Size",
    70)
Part.Control.Hint.Hint:new(nil, Part.Gui.Hint.Lookup.tcp_label_size, Part.Gui.Macros.getLastParameterLabel(), true)
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

Part.Gui.Macros.placeCursorAtLastGroup(false, true, true)
Part.Gui.Macros.drawGroupBox("Fader", group_x + group_x_fader_offset, Part.Cursor.getCursorY(), 295, 100)
Part.Gui.Macros.lastGroup():setTint("fader")

local selection = {
    { label = "Inline",    value = 1, width = 45 },
    { label = "Separate",  value = 2, width = 60 },
    { label = "Icon Lane", value = 3, width = 60 }
}

-- Placement
Part.Gui.Macros.drawButtonSelectionGroup(true, Part.Parameter.Map.par_tcp_envcp_value_mode, true, selection,
    "Placement", 70)
Part.Control.Hint.Hint:new(nil, Part.Gui.Hint.Lookup.envcp_fader_placement, Part.Gui.Macros.getLastParameterLabel(), true)
Part.Gui.Macros.nextLine()

selection = {
    { label = "Horizontal", value = 0, width = 65 },
    { label = "Vertical",   value = 1, width = 60 }
}

-- Orientation
Part.Gui.Macros.drawButtonSelectionGroup(true, Part.Parameter.Map.par_tcp_envcp_value_vertical, false, selection,
    "Orientation", 70)
Part.Gui.Macros.nextLine()

-- Size
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_envcp_value_size, false, slider_size_w, "Size",
    70, Part.Parameter.Map.par_tcp_envcp_value_scale[1])
Part.Control.Hint.Hint:new(nil, Part.Gui.Hint.Lookup.envcp_fader_size, Part.Gui.Macros.getLastParameterLabel(), true)
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

-- ===========================================================================
--      Tab : TCP : Master
-- ===========================================================================

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
    { label = "Env",  image = Part.Gui.Macros.icons.track.env,  separator = true,  index = 1 },
    { label = "Mute", image = Part.Gui.Macros.icons.track.mute, separator = false, index = 2 },
    { label = "Solo", image = Part.Gui.Macros.icons.track.solo, separator = true,  index = 3 },
    { label = "IO",   image = Part.Gui.Macros.icons.track.io,   separator = false, index = 4 },
    { label = "Mono", image = Part.Gui.Macros.icons.track.mono, separator = true,  index = 5 },
    { label = "FX",   image = Part.Gui.Macros.icons.track.fx,   separator = false, index = 6 },
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
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_master_insert_size, false, slider_size_w, "Size", 35,
    Part.Parameter.Map.par_tcp_master_insert_size_scale[1])
Part.Gui.Macros.nextLine()

-- Size
Part.Gui.Macros.drawButtonSelectionGroup(true, Part.Parameter.Map.par_tcp_master_insert_mode, true, selection, "Mode",
    35)
Part.Cursor.destackCursor()
Part.Gui.Macros.nextLine()


-- Meter
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(true, false, true)
local group_x = Part.Cursor.getCursorX()
Part.Gui.Macros.drawGroupBox("Meter", group_x, group_y, 375, 80)
Part.Gui.Macros.lastGroup():setTint("meter")


-- VU Text
Part.Cursor.stackCursor()
Part.Cursor.stackCursor()
Part.Gui.Macros.drawButtonToggleGroup(true, Part.Parameter.Map.par_tcp_master_meter_vu_db, 50, nil, "VU Text")
Part.Gui.Macros.nextInline()

-- Clip Text
Part.Gui.Macros.drawButtonToggleGroup(true, Part.Parameter.Map.par_tcp_master_meter_vu_readout, 60, nil, "Clip Text")
Part.Cursor.destackCursor()
Part.Gui.Macros.nextLine()

-- Volume Readout
Part.Gui.Macros.drawButtonToggleGroup(true, Part.Parameter.Map.par_tcp_master_meter_vol_readout, 40, "Vol Readout",
    "Show", 90)
Part.Cursor.destackCursor()

-- Meter Size
Part.Cursor.incCursor(170, 0)
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_master_meter_size, false, 100, "Size",
    55)
Part.Control.Hint.Hint:new(nil, Part.Gui.Hint.Lookup.tcp_master_size, Part.Gui.Macros.getLastParameterLabel(), true)
Part.Gui.Macros.nextLine()

-- Division
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_master_meter_channeldiv, false, 100, "VU Space", 55)


-- Faders
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(false, true, true)
Part.Gui.Macros.drawGroupBox("Faders", group_x, Part.Cursor.getCursorY(), 375, 155)
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
Part.Control.Hint.Hint:new(nil, Part.Gui.Hint.Lookup.tcp_fader_layout_inline, Part.Gui.Macros.getLastParameterLabel(2),
    false)
Part.Control.Hint.Hint:new(nil, Part.Gui.Hint.Lookup.tcp_fader_layout_separate, Part.Gui.Macros.getLastParameterLabel(1),
    false)
Part.Control.Hint.Hint:new(nil, Part.Gui.Hint.Lookup.tcp_fader_layout_separate_exploded,
    Part.Gui.Macros.getLastParameterLabel(), false)


-- ===========================================================================
--      Tab : MCP : General
-- ===========================================================================

-- ------------------------------
-- Settings

Part.Tab.Entry.setRecentTab(Part.Gui.Tab.tab_mcp_general)
Part.Gui.Macros.resetCursor()

local group_x = 60
local group_y = Part.Cursor.getCursorY() + 20

local header_w_column_b = 230
local slider_w = 120
local label_w = 80


-- Highlights
-- ------------------------------

Part.Gui.Macros.drawGroupBox("Highlights", group_x, group_y, 250, 84)
Part.Gui.Macros.lastGroup():setTint("colors")

-- Selection Marker
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_gen_highlight_selection, false, slider_w,
    "Selection Bar", label_w)
Part.Gui.Macros.nextLine()

-- Color Bar
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_gen_highlight_color, false, slider_w, "Color Bar",
    label_w)
Part.Gui.Macros.nextLine()

-- Folders
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(false, true, true)
Part.Gui.Macros.drawGroupBox("Folders", group_x, Part.Cursor.getCursorY(), 250, 140)
Part.Gui.Macros.lastGroup():setTint("folder")

-- Buttons
local selection = {
    { label = "Buttons", value = 1, width = 50 },
    { label = "+ Lines",    value = 2, width = 60 }
}

-- Position
Part.Cursor.stackCursor()
Part.Gui.Macros.drawButtonSelectionGroup(true, Part.Parameter.Map.par_mcp_gen_folder_icon_folder, true, selection,
    "Folder Lane", label_w)

Part.Gui.Macros.nextLine()

-- Indentation
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_gen_folder_indent, false, slider_w, "Indentation",
    label_w)
Part.Gui.Macros.nextLine()

-- Extra Padding
Part.Gui.Macros.drawHeader("Extra Padding", header_w_column_b)
Part.Control.Hint.Hint:new(nil, Part.Gui.Hint.Lookup.mcp_folder_padding, Part.Gui.Macros.getLastParameterLabel(), true)
Part.Gui.Macros.nextLine()

-- Folder Pad
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_gen_folder_pad_folder_parent, false, slider_w,
    "Folder Track",
    label_w)
Part.Gui.Macros.nextLine()

-- Last Pad
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_gen_folder_pad_folder_last, false, slider_w,
    "Last Track",
    label_w)
Part.Gui.Macros.nextLine()

-- Spacing
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(true, false, true)
group_x = Part.Cursor.getCursorX()
Part.Gui.Macros.drawGroupBox("Spacing", group_x, group_y, 260, 230)
Part.Gui.Macros.lastGroup():setTint("dimensions")

local spacing_header_w = 240
local spacing_slider_w = 75

-- Separator Size
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_gen_element_adj_separator, false, 85,
    "Button Separator",
    100, Part.Parameter.Map.par_mcp_gen_element_adj_separator_line[1], "Ico")
Part.Gui.Macros.nextLine()

-- Button Spacing
Part.Gui.Macros.drawHeader("Button Distance", spacing_header_w)
Part.Gui.Macros.nextLine()

-- Button Spacing X
Part.Cursor.stackCursor()
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_gen_element_adj_spacing_x, false, spacing_slider_w,
    "X", 15)
Part.Gui.Macros.nextInline()

-- Button Spacing Y
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_gen_element_adj_spacing_y, false, spacing_slider_w,
    "Y", 15)
Part.Cursor.destackCursor()
Part.Gui.Macros.nextLine()

-- Fader Spacing
Part.Gui.Macros.drawHeader("Fader Distance", spacing_header_w)
Part.Gui.Macros.nextLine()

-- fader Spacing X
Part.Cursor.stackCursor()
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_gen_element_adj_spacing_fader_x, false, spacing_slider_w,
    "X", 15)
Part.Gui.Macros.nextInline()

-- Fader Spacing Y
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_gen_element_adj_spacing_fader_y, false, spacing_slider_w,
    "Y", 15)
Part.Cursor.destackCursor()
Part.Gui.Macros.nextLine()

-- Fader Spacing
Part.Gui.Macros.drawHeader("Section Distance", spacing_header_w)
Part.Gui.Macros.nextLine()

-- fader Spacing X
Part.Cursor.stackCursor()
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_gen_element_adj_spacing_section_x, false,
    spacing_slider_w,
    "X", 15)
Part.Gui.Macros.nextInline()

-- Fader Spacing Y
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_gen_element_adj_spacing_section_y, false,
    spacing_slider_w,
    "Y", 15)
Part.Cursor.destackCursor()
Part.Gui.Macros.nextLine()

-- ===========================================================================
--      Tab : MCP : Track
-- ===========================================================================

-- Settings
-- ------------------------------

Part.Tab.Entry.setRecentTab(Part.Gui.Tab.tab_mcp_track)
Part.Gui.Macros.resetCursor()

local group_x = 7.5
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
Part.Control.Hint.Hint:new(nil, Part.Gui.Hint.Lookup.mcp_meter_position, Part.Gui.Macros.getLastParameterLabel(), true)
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
Part.Control.Hint.Hint:new(nil, Part.Gui.Hint.Lookup.mcp_meter_size, Part.Gui.Macros.getLastParameterLabel(), true)
Part.Gui.Macros.nextLine()

-- VU Spacing
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_track_meter_channeldiv, false, 85, "VU Space", 55)
Part.Cursor.destackCursor()

-- Expand
Part.Cursor.setCursorPos(column_b_x)
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_track_meter_expand, false, 85, "Expand", 75,
    Part.Parameter.Map.par_mcp_track_meter_expand_mode[1], "Fix")
Part.Control.Hint.Hint:new(nil, Part.Gui.Hint.Lookup.mcp_meter_expand, Part.Gui.Macros.getLastParameterLabel(), true)
Part.Gui.Macros.nextLine()

-- Expand Threshold
Part.Gui.Macros.drawKnobGroupWithDisplay(true, Part.Parameter.Map.par_mcp_track_meter_expand_threshold, false,
    "Expand Min Channel", 120, 2)
Part.Control.Hint.Hint:new(nil, Part.Gui.Hint.Lookup.mcp_meter_expand_threshold, Part.Gui.Macros.getLastParameterLabel(),
    true)
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
Part.Control.Hint.Hint:new(nil, Part.Gui.Hint.Lookup.mcp_faders_layout_pan_top, Part.Gui.Macros.getLastParameterLabel(2),
    false)
Part.Control.Hint.Hint:new(nil, Part.Gui.Hint.Lookup.mcp_faders_layout_strip, Part.Gui.Macros.getLastParameterLabel(1),
    false)
Part.Control.Hint.Hint:new(nil, Part.Gui.Hint.Lookup.mcp_faders_layout_bottom, Part.Gui.Macros.getLastParameterLabel(0),
    false)
Part.Gui.Macros.nextInline()

local matrix_rows = {
    { label = "Mono",   value = 0, width = 40, parameter = Part.Parameter.Map.par_mcp_track_fader_pan_mode_mono },
    { label = "Stereo", value = 1, width = 70, parameter = Part.Parameter.Map.par_mcp_track_fader_pan_mode_stereo },
    { label = "Dual",   value = 2, width = 80, parameter = Part.Parameter.Map.par_mcp_track_fader_pan_mode_dual }
}

Part.Gui.Macros.drawMcpPanConfiguration(matrix_rows)
Part.Control.Hint.Hint:new(nil, Part.Gui.Hint.Lookup.mcp_faders_panmode_knob, Part.Gui.Macros.getLastParameterLabel(2),
    false)
Part.Control.Hint.Hint:new(nil, Part.Gui.Hint.Lookup.mcp_faders_panmode_vertical,
    Part.Gui.Macros.getLastParameterLabel(1), false)
Part.Control.Hint.Hint:new(nil, Part.Gui.Hint.Lookup.mcp_faders_panmode_horizontal,
    Part.Gui.Macros.getLastParameterLabel(0), false)
Part.Gui.Macros.nextInline()


-- Always Show Width
Part.Cursor.incCursor(5, 0)
Part.Gui.Macros.drawButtonToggleGroup(true, Part.Parameter.Map.par_mcp_track_fader_wid_always, 120, nil,
    "Always Show Width")
Part.Gui.Macros.nextLine()

-- Width
Part.Cursor.stackCursor()
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_track_fader_pan_width, false, 65, "Width", 45)
Part.Control.Hint.Hint:new(nil, Part.Gui.Hint.Lookup.mcp_faders_width, Part.Gui.Macros.getLastParameterLabel(),
    true)
Part.Gui.Macros.nextLine()

-- Height
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_track_fader_pan_height, false, 65, "Height", 45,
    Part.Parameter.Map.par_mcp_track_fader_pan_height_scale[1])
Part.Control.Hint.Hint:new(nil, Part.Gui.Hint.Lookup.mcp_faders_height, Part.Gui.Macros.getLastParameterLabel(),
    true)
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
Part.Control.Hint.Hint:new(nil, Part.Gui.Hint.Lookup.mcp_extra_width, Part.Gui.Macros.getLastParameterLabel(),
    true)
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
    { label = "Top",     value = 1, width = 30 },
    { label = "Sidebar", value = 3, width = 50 },
    { label = "Embed",   value = 2, width = 50 },
}

-- Position
Part.Gui.Macros.drawButtonSelectionGroup(true, Part.Parameter.Map.par_mcp_track_insert_mode, true, selection,
    "Mode", label_w_insert)
Part.Control.Hint.Hint:new(nil, Part.Gui.Hint.Lookup.mcp_insert_mode, Part.Gui.Macros.getLastParameterLabel(), true)
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
Part.Control.Hint.Hint:new(nil, Part.Gui.Hint.Lookup.size_onembed, Part.Gui.Macros.getLastParameterLabel(), true)
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
    { label = "Solo",     image = Part.Gui.Macros.icons.track.solo,    separator = false, index = 11 },
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
Part.Control.Hint.Hint:new(nil, Part.Gui.Hint.Lookup.mcp_button_layout, Part.Gui.Macros.getLastParameterLabel(), true)
Part.Gui.Macros.nextLine()

-- Input Size
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_track_element_input_size, false, 65, "Input Size",
    60)
Part.Control.Hint.Hint:new(nil, Part.Gui.Hint.Lookup.mcp_input_size, Part.Gui.Macros.getLastParameterLabel(), true)
Part.Gui.Macros.nextLine()


-- ===========================================================================
--      Tab : MCP : Master
-- ===========================================================================

-- Settings
-- ------------------------------

Part.Tab.Entry.setRecentTab(Part.Gui.Tab.tab_mcp_master)
Part.Gui.Macros.resetCursor()

local group_x = 7.5
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
Part.Control.Hint.Hint:new(nil, Part.Gui.Hint.Lookup.mcp_meter_position, Part.Gui.Macros.getLastParameterLabel(), true)
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
Part.Control.Hint.Hint:new(nil, Part.Gui.Hint.Lookup.mcp_meter_size, Part.Gui.Macros.getLastParameterLabel(), true)

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
Part.Control.Hint.Hint:new(nil, Part.Gui.Hint.Lookup.mcp_faders_layout_pan_top, Part.Gui.Macros.getLastParameterLabel(2),
    false)
Part.Control.Hint.Hint:new(nil, Part.Gui.Hint.Lookup.mcp_faders_layout_strip, Part.Gui.Macros.getLastParameterLabel(1),
    false)
Part.Control.Hint.Hint:new(nil, Part.Gui.Hint.Lookup.mcp_faders_layout_bottom, Part.Gui.Macros.getLastParameterLabel(0),
    false)
Part.Gui.Macros.nextInline()

local matrix_rows = {
    { label = "Mono",   value = 0, width = 40, parameter = Part.Parameter.Map.par_mcp_master_fader_pan_mode_mono },
    { label = "Stereo", value = 1, width = 70, parameter = Part.Parameter.Map.par_mcp_master_fader_pan_mode_stereo },
    { label = "Dual",   value = 2, width = 80, parameter = Part.Parameter.Map.par_mcp_master_fader_pan_mode_dual }
}

Part.Gui.Macros.drawMcpPanConfiguration(matrix_rows)
Part.Control.Hint.Hint:new(nil, Part.Gui.Hint.Lookup.mcp_faders_panmode_knob, Part.Gui.Macros.getLastParameterLabel(2),
    false)
Part.Control.Hint.Hint:new(nil, Part.Gui.Hint.Lookup.mcp_faders_panmode_vertical,
    Part.Gui.Macros.getLastParameterLabel(1), false)
Part.Control.Hint.Hint:new(nil, Part.Gui.Hint.Lookup.mcp_faders_panmode_horizontal,
    Part.Gui.Macros.getLastParameterLabel(0), false)
Part.Gui.Macros.nextInline()


-- Always Show Width
Part.Cursor.incCursor(5, 0)
Part.Gui.Macros.drawButtonToggleGroup(true, Part.Parameter.Map.par_mcp_master_fader_wid_always, 120, nil,
    "Always Show Width")
Part.Gui.Macros.nextLine()

-- Width
Part.Cursor.stackCursor()
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_master_fader_pan_width, false, 65, "Width", 45)
Part.Control.Hint.Hint:new(nil, Part.Gui.Hint.Lookup.mcp_faders_width, Part.Gui.Macros.getLastParameterLabel(),
    true)
Part.Gui.Macros.nextLine()

-- Height
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_master_fader_pan_height, false, 65, "Height", 45,
    Part.Parameter.Map.par_mcp_master_fader_pan_height_scale[1])
Part.Control.Hint.Hint:new(nil, Part.Gui.Hint.Lookup.mcp_faders_height, Part.Gui.Macros.getLastParameterLabel(),
    true)
Part.Cursor.destackCursor()
Part.Gui.Macros.nextLine()


-- Settings
-- ------------------------------
Part.Gui.Macros.placeCursorAtLastGroup(false, true, true)
local group_y_inserts = Part.Cursor.getCursorY()
Part.Gui.Macros.drawGroupBox("Settings", group_x, Part.Cursor.getCursorY(), 200, 100)
Part.Gui.Macros.lastGroup():setTint("arrangement")

-- Extend Width
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_master_settings_extrapad, false, 75, "Width +", 75)
Part.Control.Hint.Hint:new(nil, Part.Gui.Hint.Lookup.mcp_extra_width, Part.Gui.Macros.getLastParameterLabel(),
    true)
Part.Gui.Macros.nextLine()

-- Menu Button Size
Part.Cursor.stackCursor()
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_master_settings_label_size, false, 75, "Menu Button", 75)
Part.Gui.Macros.nextLine()


-- Inserts
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(true, false, true)
Part.Gui.Macros.drawGroupBox("Inserts", Part.Cursor.getCursorX(), group_y_inserts, 245, 100)
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
    { label = "Solo", image = Part.Gui.Macros.icons.track.solo, separator = false, index = 6 },
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
Part.Control.Hint.Hint:new(nil, Part.Gui.Hint.Lookup.mcp_button_layout, Part.Gui.Macros.getLastParameterLabel(), true)
Part.Gui.Macros.nextLine()
