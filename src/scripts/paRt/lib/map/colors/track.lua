-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--      Tab : Colors : Track / Envelope / Meter
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

-- Settings
-- ------------------------------

Part.Tab.Entry.setRecentTab(Part.Gui.Tab.tab_colors_tracks)
Part.Gui.Macros.resetCursor()

local group_x = 20
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

Part.Gui.Macros.drawKnobGroup(true, Part.Parameter.Map.par_colors_track_track_label_text_tone, false, "Text Tone",
    label_w)
Part.Gui.Macros.nextLine()

-- Track Index
Part.Gui.Macros.drawHeader("Track Index", header_w)
Part.Gui.Macros.nextLine()

Part.Gui.Macros.drawKnobGroup(true, Part.Parameter.Map.par_colors_track_track_index_tone_tcp, false, "TCP", label_w)
Part.Gui.Macros.nextInline()
Part.Gui.Macros.drawKnobGroup(true, Part.Parameter.Map.par_colors_track_track_index_tone_mcp, false, "MCP", label_w)

-- Envelopes
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(false, true, true)

Part.Gui.Macros.drawGroupBox("Envelopes", group_x, Part.Cursor.getCursorY(), 270, 146)
Part.Gui.Macros.lastGroup():setTint("colors")

-- Background
Part.Gui.Macros.drawHeader("Background", header_w)
Part.Cursor.incCursor(0, Part.Gui.Macros.line_h)

Part.Cursor.stackCursor()
Part.Gui.Macros.drawKnobGroup(true, Part.Parameter.Map.par_colors_track_envcp_bg_tone, false, "Tone", label_w)
Part.Gui.Macros.nextInline()
Part.Gui.Macros.drawKnobGroup(true, Part.Parameter.Map.par_colors_track_envcp_bg_tint, false, "Tint", label_w)
Part.Cursor.destackCursor()
Part.Gui.Macros.nextLine()

-- Label
Part.Gui.Macros.drawHeader("Label", header_w)
Part.Gui.Macros.nextLine()

Part.Cursor.stackCursor()
Part.Gui.Macros.drawKnobGroup(true, Part.Parameter.Map.par_colors_track_envcp_label_bg_Tone, false, "Tone", label_w)
Part.Gui.Macros.nextInline()
Part.Gui.Macros.drawKnobGroup(true, Part.Parameter.Map.par_colors_track_envcp_label_bg_tint, false, "Tint", label_w)
Part.Cursor.destackCursor()
Part.Gui.Macros.nextLine()

Part.Gui.Macros.drawKnobGroup(true, Part.Parameter.Map.par_colors_track_envcp_label_text_tone, false, "Text Tone",
    label_w)
Part.Gui.Macros.nextInline()
Part.Gui.Macros.drawKnobGroup(true, Part.Parameter.Map.par_colors_track_envcp_label_readout_tone, false, "Value Tone",
    label_w)

-- Meter Text
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(true, false, true)
group_x = Part.Cursor.getCursorX()
Part.Gui.Macros.drawGroupBox("Meter Text", group_x, group_y, 330, 234)
Part.Gui.Macros.lastGroup():setTint("meter")

local label_w_meter_2 = 80
local label_w_meter_3 = 55
local header_w = 310

-- Unlit
Part.Gui.Macros.drawHeader("Unlit", header_w)
Part.Gui.Macros.nextLine()

Part.Cursor.stackCursor()
Part.Gui.Macros.drawKnobGroup(true, Part.Parameter.Map.par_colors_track_meter_text_tone_unlit, false, "Tone",
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
Part.Gui.Macros.drawKnobGroup(true, Part.Parameter.Map.par_colors_track_meter_text_tone_lit, false, "Tone",
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
Part.Gui.Macros.drawHeader("Transparency", header_w)
Part.Gui.Macros.nextLine()

Part.Cursor.stackCursor()
Part.Gui.Macros.drawKnobGroup(true, Part.Parameter.Map.par_colors_track_meter_text_alpha_top, false, "Top",
    label_w_meter_2)
Part.Gui.Macros.nextInline()
Part.Gui.Macros.drawKnobGroup(true, Part.Parameter.Map.par_colors_track_meter_text_alpha_bottom, false, "Bottom",
    label_w_meter_2)
Part.Cursor.destackCursor()
Part.Gui.Macros.nextLine()

-- Readout
Part.Gui.Macros.drawHeader("Readout", header_w)
Part.Gui.Macros.nextLine()

Part.Cursor.stackCursor()
Part.Gui.Macros.drawKnobGroup(true, Part.Parameter.Map.par_colors_track_meter_text_tone_readout, false, "Tone",
    label_w_meter_2)
Part.Gui.Macros.nextInline()
Part.Gui.Macros.drawKnobGroup(true, Part.Parameter.Map.par_colors_track_meter_text_alpha_readout, false, "Alpha",
    label_w_meter_2)
Part.Cursor.destackCursor()
Part.Gui.Macros.nextLine()

Part.Cursor.stackCursor()
Part.Gui.Macros.drawKnobGroup(true, Part.Parameter.Map.par_colors_track_meter_text_tone_readout_clip, false, "Clip Tone",
    label_w_meter_2)
Part.Gui.Macros.nextInline()
Part.Gui.Macros.drawKnobGroup(true, Part.Parameter.Map.par_colors_track_meter_text_tint_readout_clip, false, "Clip Tint",
    label_w_meter_2)
Part.Cursor.destackCursor()
Part.Gui.Macros.nextLine()


-- ------------------------------
-- Folders

Part.Gui.Macros.placeCursorAtLastGroup(false, true, true)
Part.Gui.Macros.drawGroupBox("Folders", group_x, Part.Cursor.getCursorY(), 270, 165)
Part.Gui.Macros.lastGroup():setTint("folder")

header_w = 250

-- Folder Track
Part.Gui.Macros.drawHeader("Folder Track", header_w)
Part.Gui.Macros.nextLine()

Part.Cursor.stackCursor()
Part.Gui.Macros.drawKnobGroup(true, Part.Parameter.Map.par_colors_track_folder_foldertrack_tone, false, "Tone", label_w)
Part.Gui.Macros.nextInline()
Part.Gui.Macros.drawKnobGroup(true, Part.Parameter.Map.par_colors_track_folder_foldertrack_tint, false, "Tint", label_w)
Part.Cursor.destackCursor()
Part.Gui.Macros.nextLine()

-- Folder Tree
Part.Gui.Macros.drawHeader("Folder Tree", header_w)
Part.Gui.Macros.nextLine()

Part.Cursor.stackCursor()
Part.Gui.Macros.drawKnobGroup(true, Part.Parameter.Map.par_colors_track_folder_foldertree_tone, false, "Tone", label_w)
Part.Gui.Macros.nextInline()
Part.Gui.Macros.drawKnobGroup(true, Part.Parameter.Map.par_colors_track_folder_foldertree_tint, false, "Tint", label_w)
Part.Cursor.destackCursor()
