-- @version 1.2.2
-- @author Fleeesch
-- @description paRt Theme Adjuster
-- @noIndex
local hint = {}

-- ====================================================================================
--              Hint Lookup
-- ====================================================================================

hint.HintTypes = {
    normal = "normal",
    attention = "attention",
    warning = "warning",
    tip = "tip",
    highlight = "highlight"
}

hint.HintMessages = {}

--      Spacing
-- --------------------------------------

-- extra space
hint.extra_space = {
    { type = hint.HintTypes.normal, text = "Adjusts the amount of optional extra space between buttons." },
    { type = hint.HintTypes.tip,    text = "Extra space has to be activated individually per element in the visibility matrixes." }
}

-- bank toggle button
hint.bank_toggle = {
    { type = hint.HintTypes.highlight, text = "Use Bank System" },
    { type = hint.HintTypes.normal,    text = "Activating this Switch will make the Parameter use the Bank System." },
    { type = hint.HintTypes.normal,    text = "Each bank will store an individual Value for the Parameter." },
    { type = hint.HintTypes.tip,       text = "Activating the switch will not overwrite the previously set value. You can simply deactivate it again." }
}

-- spacing - buttons - x
hint.spacing_buttons_x = {
    { type = hint.HintTypes.normal,    text = "Increases the horizontal distance between buttons." },
    { type = hint.HintTypes.attention, text = "Some configurations might bypass this setting." },
}

-- spacing - buttons - y
hint.spacing_buttons_y = {
    { type = hint.HintTypes.normal,    text = "Increases the vertical distance between buttons." },
    { type = hint.HintTypes.attention, text = "Some configurations might bypass this setting." },
}

-- spacing - faders - x
hint.spacing_faders_x = {
    { type = hint.HintTypes.normal,    text = "Increases the horizontal distance between faders." },
    { type = hint.HintTypes.attention, text = "Some configurations might bypass this setting." },
}

-- spacing - faders - y
hint.spacing_faders_y = {
    { type = hint.HintTypes.normal,    text = "Increases the vertical distance between larger." },
    { type = hint.HintTypes.attention, text = "Some configurations might bypass this setting." },
}

-- spacing - section - x
hint.spacing_section_x = {
    { type = hint.HintTypes.normal,    text = "Increases the horizontal distance between larger sections." },
    { type = hint.HintTypes.attention, text = "Some configurations might bypass this setting." },
}

-- spacing - section - y
hint.spacing_section_y = {
    { type = hint.HintTypes.normal,    text = "Increases the vertical distance between larger sections." },
    { type = hint.HintTypes.attention, text = "Some configurations might bypass this setting." },
}

-- percentual scaling button
hint.size_percentual = {
    { type = hint.HintTypes.highlight, text = "Percentual Scaling" },
    { type = hint.HintTypes.normal,    text = "When turned on the size adjustment will change from an absolute size to a percentual one. A percentage of the remaining space will be used for the actual size." },
    { type = hint.HintTypes.attention, text = "When this setting is turned on, large sizes values might make it impossible to display the element. Try keeping the size small in this case." },
    { type = hint.HintTypes.attention, text = "Some configurations might bypass this setting." },
}

--      Buttons
-- --------------------------------------

-- large envelope button
hint.button_env_large = {
    { type = hint.HintTypes.normal, text = "Doubles the size of the envelope button." },
}



--      Highlights
-- --------------------------------------

-- colorbar size
hint.highlights_colorbar_size     =
{
    { type = hint.HintTypes.normal, text = "Adjusts the size of the tracks color bar." },
    { type = hint.HintTypes.normal, text = "The color bar displays the tracks custom color as a separate block." },
    { type = hint.HintTypes.tip,    text = "Setting the value to its minimal value will completely hide the color bar." },
}

-- selection bar size
hint.highlights_selectionbar_size =
{
    { type = hint.HintTypes.normal, text = "Adjusts the size of the tracks selection bar." },
    { type = hint.HintTypes.normal, text = "The selection bar highlights selected tracks." },
    { type = hint.HintTypes.tip,    text = "Setting the value to its minimal value will completely hide the selection bar." },
}



--      Visibility Matrix
-- --------------------------------------

-- visibility
hint.vismatrix_visbility = {
    { type = hint.HintTypes.normal, text = "Toggle the visibility of the element." },
}

-- hide when mixer is visible
hint.vismatrix_nomixer = {
    { type = hint.HintTypes.normal, text = "Hides the element when activated and the mixer is visible." },
}

-- add separator
hint.vismatrix_separator = {
    { type = hint.HintTypes.normal,    text = "Adds extra after the element if." },
    { type = hint.HintTypes.normal,    text = "The element must be visible." },
    { type = hint.HintTypes.attention, text = "Some settings may bypass this setting." },
}

-- size adjustment
hint.vismatrix_size = {
    { type = hint.HintTypes.normal, text = "Adjust the size of the element." },
}



--      Colors
-- --------------------------------------

-- theme files
hint.colors_theme_files =
{
    { type = hint.HintTypes.normal,    text = "Loads a paRt theme file with a different color profile." },
    { type = hint.HintTypes.tip,       text = "Separate theme files exist because of technical limitations and to reduce loading times." },
    { type = hint.HintTypes.attention, text = "The paRt Theme Adjuster needs to be active in order to synchronize user settings. It is recommended to use the Theme Adjuster to switch between paRt theme files." },
}

-- reaper colors
hint.colors_reaper =
{
    { type = hint.HintTypes.normal,    text = "Reaper's internal Color Adjustment Sliders." },
    { type = hint.HintTypes.attention, text = "These color adjustments will not be synchronized between paRt Theme files." },
}

-- colorbar intensity
hint.colors_tuning_colorbar_intensity =
{
    { type = hint.HintTypes.normal, text = "Adjusts the brightness and intensity of the track color bar." },
}


-- reaper colors to custom colors
hint.colors_reaper_apply_custom =
{
    { type = hint.HintTypes.normal, text = "Activating this setting will apply the color adjustment Values to custom color objects like Media Items, etc." }
}

-- track background tone
hint.colors_track_background_tone = {
    { type = hint.HintTypes.normal, text = "Brightness of the tracks background color." }
}

-- track background tone (selected)
hint.colors_track_background_tone_select = {
    { type = hint.HintTypes.normal, text = "Increased background brightness for selected tracks." }
}

-- track background tint
hint.colors_track_background_tint = {
    { type = hint.HintTypes.normal, text = "Adjusts the custom color intensity for track background." }
}

-- track background tint (selected)
hint.colors_track_background_tint_select = {
    { type = hint.HintTypes.normal, text = "Increased custom color intensity for selected tracks backgorund." }
}


-- track label tone
hint.colors_track_label_bg_tone = {
    { type = hint.HintTypes.normal, text = "Brightness of the tracks label background color." }
}

-- track label tone (selected)
hint.colors_track_label_bg_tone_select = {
    { type = hint.HintTypes.normal, text = "Increased label background brightness for selected tracks." }
}

-- track label tint
hint.colors_track_label_bg_tint = {
    { type = hint.HintTypes.normal, text = "Adjusts the custom color intensity for track label background." }
}

-- track label tint (selected)
hint.colors_track_label_bg_tint_select = {
    { type = hint.HintTypes.normal, text = "Increased custom color intensity for selected tracks label backgorund." }
}

-- track label text tone (selected)
hint.colors_track_label_text_tone = {
    { type = hint.HintTypes.normal, text = "Adjusts the brightness of the label text." }
}

-- index tone - tcp
hint.colors_track_index_tone_tcp = {
    { type = hint.HintTypes.normal, text = "Adjusts the brightness of the index number in the TCP." }
}

-- index tone - mcp
hint.colors_track_index_tone_mcp = {
    { type = hint.HintTypes.normal, text = "Adjusts the brightness of the index number in the MCP." }
}

-- envcp background tone
hint.colors_track_envcp_background_tone = {
    { type = hint.HintTypes.normal, text = "Adjusts the Brightness of the ENVCP background." }
}

-- envcp background tint
hint.colors_track_envcp_background_tint = {
    { type = hint.HintTypes.normal, text = "Adjusts the custom color intensity for the ENVCP background." },
    { type = hint.HintTypes.tip,    text = "The color is retrieved from the envelope's parent track custom color." }
}

-- envcp label tone
hint.colors_track_envcp_label_tone = {
    { type = hint.HintTypes.normal, text = "Adjusts the Brightness of the ENVCP label background." }
}

-- envcp label tint
hint.colors_track_envcp_label_tint = {
    { type = hint.HintTypes.normal, text = "Adjusts the custom color intensity for ENVCP label background." }
}


-- envcp label text tone
hint.colors_track_envcp_label_text_tone = {
    { type = hint.HintTypes.normal, text = "Adjusts the brightness of the ENVCP label text." },
}

-- envcp value text tone
hint.colors_track_envcp_label_readout_tone = {
    { type = hint.HintTypes.normal, text = "Adjusts the brightness of the ENVCP value output text." },
}

-- meter - unlit tone
hint.colors_meter_text_unlit_tone = {
    { type = hint.HintTypes.normal, text = "Tone of neutral meter text." },
}

-- meter - unlit alpha
hint.colors_meter_text_unlit_alpha = {
    { type = hint.HintTypes.normal, text = "Opacity of neutral meter text." },
}

-- meter - unlit shadow
hint.colors_meter_text_unlit_shadow = {
    { type = hint.HintTypes.normal, text = "Drop-shadow opacity of neutral meter text." },
}

-- meter - lit tone
hint.colors_meter_text_lit_tone = {
    { type = hint.HintTypes.normal, text = "Tone of highlighted meter text." },
}

-- meter - lit alpha
hint.colors_meter_text_lit_alpha = {
    { type = hint.HintTypes.normal, text = "Opacity of highlighted meter text." },
}

-- meter - lit shadow
hint.colors_meter_text_lit_shadow = {
    { type = hint.HintTypes.normal, text = "Drop-shadow opacity of highlighted meter text." },
}

-- track readout alpha
hint.colors_meter_text_track_alpha = {
    { type = hint.HintTypes.normal, text = "Opacity multiplier for all track readout elements." },
    { type = hint.HintTypes.tip,    text = "Alpha values for the master track are calibrated differrently. You can use this parameter to balance things out." },
}

-- master readout alpha
hint.colors_meter_text_master_alpha = {
    { type = hint.HintTypes.normal, text = "Opacity multiplier for all master track readout elements." },
    { type = hint.HintTypes.tip,    text = "Alpha values for the master track are calibrated differrently. You can use this parameter to balance things out." },
}

-- readout tone
hint.colors_meter_readout_tone = {
    { type = hint.HintTypes.normal, text = "Adjusts the brightness of the meter readout text." },
}

-- readout alpha
hint.colors_meter_readout_alpha = {
    { type = hint.HintTypes.normal, text = "Adjusts the opacity of the meter readout text." },
}

-- readout clip tone
hint.colors_meter_readout_clip_tone = {
    { type = hint.HintTypes.normal, text = "Adjusts the brightness of the meter readout text after peak clipping has happened." },
}

-- readout clip alpha
hint.colors_meter_readout_clip_alpha = {
    { type = hint.HintTypes.normal, text = "Adjusts the opacity of the meter readout text after peak clipping has happened." },
}


-- folder track tone
hint.colors_folder_track_tone = {
    { type = hint.HintTypes.normal, text = "Relative adjustment for the brightness of folder tracks." },
    { type = hint.HintTypes.normal, text = "The tone is left untouched when left in center position." },
}


-- folder track tint
hint.colors_folder_track_tint = {
    { type = hint.HintTypes.normal, text = "Relative adjustment for the saturation of folder tracks." },
    { type = hint.HintTypes.normal, text = "The tint is left untouched when left in center position." },
}

-- folder tree tone
hint.colors_folder_tree_tone = {
    { type = hint.HintTypes.normal,    text = "Changes the brightness of track backgrounds based on their folder depth." },
    { type = hint.HintTypes.normal,    text = "The brightness is left untouched when left in center position." },
    { type = hint.HintTypes.attention, text = "The total depth is based on the folder structure of visible tracks only." },
}

-- folder tree tint
hint.colors_folder_tree_tint = {
    { type = hint.HintTypes.normal,    text = "Changes the color intensity of track backgrounds based on their folder depth." },
    { type = hint.HintTypes.normal,    text = "The tint is left untouched when left in center position." },
    { type = hint.HintTypes.attention, text = "The total depth is based on the folder structure of visible tracks only." },
}

--      Transport
-- --------------------------------------

-- part menu button
hint.transport_menu_button = {
    { type = hint.HintTypes.normal, text = "Show a button in the transport section that opens the paRt Theme Adjuster." },
}

-- part bank buttons
hint.transport_bank_buttons = {
    { type = hint.HintTypes.normal, text = "Show buttons in the transport section for selecting paRt banks." },
}

-- transport width increase
hint.transport_width_plus = {
    { type = hint.HintTypes.normal, text = "Adds additional width to the transport section." },
    { type = hint.HintTypes.tip,    text = "This is mostly noticable when the transport section is in a floating window." },
}

-- transport height increase
hint.transport_height_plus = {
    { type = hint.HintTypes.normal, text = "Adds additional height to the transport section." },
}

-- transport tempo element spacing
hint.transport_spacing_tempo = {
    { type = hint.HintTypes.normal, text = "Increases the horizontal distance between elements within the tempo section." },
}

-- transport status size
hint.transport_size_status = {
    { type = hint.HintTypes.normal, text = "Adjusts the size of the status display." },
}

-- transport selection size
hint.transport_size_selection = {
    { type = hint.HintTypes.normal, text = "Adjusts the size of the selection area." },
}

-- transport tap button
hint.transport_tap_button = {
    { type = hint.HintTypes.normal, text = "Shows the Tap Tempo button in the tempo section." },
}

-- transport playrate knob
hint.transport_playrate_knob = {
    { type = hint.HintTypes.normal, text = "Displays the playrate adjustment as a knob." },
}

-- transport playrate fader
hint.transport_playrate_fader = {
    { type = hint.HintTypes.normal, text = "Displays the playrate adjustment as a horizontal fader." },
}

-- transport playrate fader size
hint.transport_playrate_fader_size = {
    { type = hint.HintTypes.normal, text = "Adjusts the size of the playrate fader." },
    { type = hint.HintTypes.tip,    text = "Requires the playrate adjustment set to be shown as a fader." },
}



--      TCP
-- --------------------------------------

-- tcp insert slot size
hint.tcp_general_insert_slot_size = {
    { type = hint.HintTypes.normal, text = "Adjusts the target width for fx & send slots." },
    { type = hint.HintTypes.normal, text = "Reaper takes care of the slot formatting based on the size of the fx block in the TCP." },
    { type = hint.HintTypes.tip,    text = "If you want the slots width to cover the full fx section, set this parameter to its maximum value." },
}

-- tcp folder indent
hint.tcp_general_folder_indent = {
    { type = hint.HintTypes.normal, text = "Adjusts the horizontal indentation for folder child tracks." },
}

-- tcp folder collapse buttons
hint.tcp_general_folder_collapse_buttons = {
    { type = hint.HintTypes.normal, text = "Toggles the folder collapse buttons." },
}

-- tcp folder collapse lines
hint.tcp_general_folder_collapse_lines = {
    { type = hint.HintTypes.normal, text = "Toggles the folder collapse buttons." },
    { type = hint.HintTypes.normal, text = "Shows additional lines highlighting the folder structure when activated." },
}

-- tcp folder mode
hint.tcp_general_folder_mode = {
    { type = hint.HintTypes.normal, text = "Shows an additional button to cycle between the tracks folder modes." },
}

-- tcp recinput size
hint.tcp_button_recinput_size = {
    { type = hint.HintTypes.normal, text = "Adjusts the size of the input selector." },
    { type = hint.HintTypes.normal, text = "When button wrapping is enabled, the input selector will be trimmed when it's running out of space." },
}

-- tcp button wrapping full
hint.tcp_button_wrap_full = {
    { type = hint.HintTypes.normal, text = "Activates button wrapping." },
    { type = hint.HintTypes.normal, text = "Buttons will be spread across multiple lines if there's not enough horizontal space." },
}

-- tcp button wrapping copmpact
hint.tcp_button_wrap_compact = {
    { type = hint.HintTypes.normal,    text = "Activates button wrapping." },
    { type = hint.HintTypes.normal,    text = "Buttons will be spread across multiple lines if there's not enough horizontal space." },
    { type = hint.HintTypes.highlight, text = "Extra spaces set in the visibility matrix will be removed starting with the second line." },
}

-- tcp button wrapping narrow
hint.tcp_button_wrap_narrow = {
    { type = hint.HintTypes.normal,    text = "Activates button wrapping." },
    { type = hint.HintTypes.normal,    text = "Buttons will be spread across multiple lines if there's not enough horizontal space." },
    { type = hint.HintTypes.highlight, text = "Extra spaces set in the visibility matrix will be removed starting with the second line." },
    { type = hint.HintTypes.highlight, text = "Button spacing will be reduced to the absolute minimum." },
}

-- tcp meter show
hint.tcp_meter_show = {
    { type = hint.HintTypes.normal, text = "Toggles the meter visibility." },
}

-- tcp meter volume readout
hint.tcp_meter_vol_readout = {
    { type = hint.HintTypes.normal,    text = "Shows a volume readout value label next to the meter." },
    { type = hint.HintTypes.attention, text = "Requires the meter to be visible." },
}

-- tcp meter text
hint.tcp_meter_text = {
    { type = hint.HintTypes.normal,    text = "Toggles dB scale visibility in the meter." },
    { type = hint.HintTypes.attention, text = "Requires the meter to be visible." },
}

-- tcp meter clip text
hint.tcp_meter_clip_text = {
    { type = hint.HintTypes.normal,    text = "Toggles peak clipping text visibility in the meter." },
    { type = hint.HintTypes.attention, text = "Requires the meter to be visible." },
}

-- tcp meter size
hint.tcp_meter_size = {
    { type = hint.HintTypes.normal, text = "Adjusts the size of the meter." },
}

-- tcp meter vu space
hint.tcp_meter_vu_space = {
    { type = hint.HintTypes.normal,    text = "Adjusts the distance between meter channels." },
    { type = hint.HintTypes.attention, text = "Reaper has a strong influence on the way how the distance is interpreted. Use this value preferably as a coarse adjustment." },
}


-- tcp fader visibility
hint.tcp_meter_vu_space = {
    { type = hint.HintTypes.normal,    text = "Adjusts the distance between meter channels." },
    { type = hint.HintTypes.attention, text = "Reaper has a strong influence on the way how the distance is interpreted. Use this value preferably as a coarse adjustment." },
}

-- tcp fader size
hint.tcp_fader_size_vol = {
    { type = hint.HintTypes.normal,    text = "Adjusts the size of the volume fader." },
    { type = hint.HintTypes.tip,       text = "Turning the size all the way down will force the fader to become a knob." },
    { type = hint.HintTypes.attention, text = "Vertical-Faders mode will ignore this adjustment and instead use the track height." },
    { type = hint.HintTypes.attention, text = "Stacked-Faders mode will use this size as its reference." },
}

-- tcp fader size
hint.tcp_fader_size_pan = {
    { type = hint.HintTypes.normal,    text = "Adjusts the size of the pan fader." },
    { type = hint.HintTypes.tip,       text = "Turning the size all the way down will force the fader to become a knob." },
    { type = hint.HintTypes.attention, text = "Vertical-Faders mode will ignore this adjustment and instead use the track height." },
    { type = hint.HintTypes.attention, text = "Stacked-Faders mode will ignore this setting and rely on the volume fader size instead." },
}

-- tcp fader size
hint.tcp_fader_size_wid = {
    { type = hint.HintTypes.normal,    text = "Adjusts the size of the width fader." },
    { type = hint.HintTypes.tip,       text = "Turning the size all the way down will force the fader to become a knob." },
    { type = hint.HintTypes.attention, text = "Vertical-Faders mode will ignore this adjustment and instead use the track height." },
    { type = hint.HintTypes.attention, text = "Stacked-Faders mode will ignore this setting and rely on the volume fader size instead." },
}

-- tcp fader layout inline
hint.tcp_fader_layout_inline = {
    { type = hint.HintTypes.highlight, text = "TCP - Inline Faders" },
    { type = hint.HintTypes.normal,    text = "Faders are displayed next to the buttons on the first line." },
    { type = hint.HintTypes.attention, text = "The faders will not be included in the optional button wrapping flow." },
}

-- tcp fader layout stacked
hint.tcp_fader_layout_stacked = {
    { type = hint.HintTypes.highlight, text = "TCP - Stacked Faders" },
    { type = hint.HintTypes.normal,    text = "Faders are displayed in a separate block, stacked vertically." },
    { type = hint.HintTypes.attention, text = "The width of the faders is adjusted by the Volume fader size and shared with all faders." },
}

-- tcp fader layout vertical
hint.tcp_fader_layout_vertical = {
    { type = hint.HintTypes.highlight, text = "TCP - Vertical Faders" },
    { type = hint.HintTypes.normal,    text = "Faders are displayed in a separate block, arranged horizontally." },
    { type = hint.HintTypes.normal,    text = "Fader height is hard-linked to the track height." },
    { type = hint.HintTypes.normal,    text = "The faders will automatically become knobs when the track height is below a certain threshold." },
}

-- tcp label size
hint.tcp_label_size = {
    { type = hint.HintTypes.normal, text = "Adjusts the size of the label." },
    { type = hint.HintTypes.normal, text = "This setting essentially shifts the element cutoff threshold to the right side. The higher the value, the sooner buttons and faders are hidden." },
    { type = hint.HintTypes.normal, text = "The label will always be stretched to the maximum available width when there's nothing else to show." },
}

-- tcp index - separate
hint.tcp_index_separate = {
    { type = hint.HintTypes.normal, text = "Toggles the index number visibility to be next to the name label." },
}

-- tcp index - in label
hint.tcp_index_in_label = {
    { type = hint.HintTypes.normal, text = "Toggles the track index number visibility to be within the name label." },
}

-- tcp inserts size
hint.tcp_inserts_size = {
    { type = hint.HintTypes.normal, text = "Adjusts the width of the inserts section." },
}

-- tcp inserts placement inline
hint.tcp_inserts_placement_inline = {
    { type = hint.HintTypes.normal, text = "Toggles the inserts section visibility in inline mode." },
    { type = hint.HintTypes.normal, text = "The inserts section will always be shown as a fixed section at the right side of the TCP." },
}

-- tcp inserts placement separate
hint.tcp_inserts_placement_separate = {
    { type = hint.HintTypes.normal, text = "Toggles the inserts section visibility in separate block mode." },
    { type = hint.HintTypes.normal, text = "The inserts section will be placed in the free space below the buttons and faders." },
    { type = hint.HintTypes.normal, text = "It will only be visible when the track height is extended." },
}

--      ENVCP
-- --------------------------------------

-- envcp show symbol
hint.envcp_show_symbol = {
    { type = hint.HintTypes.normal, text = "Shows a symbol next to each envelope lane with a little bit of indentation." },
}

-- envcp include track icon lane
hint.envcp_include_track_icon_lane = {
    { type = hint.HintTypes.normal,    text = "Adds an artifical track icon lane to the envelope." },
    { type = hint.HintTypes.attention, text = "Requires the track lanes or track icons to be visible in order to show up." },
}

-- envcp indentation
hint.envcp_indentation = {
    { type = hint.HintTypes.normal, text = "Adjusts a horizontal offset to the envelope lanes." },
}

-- envcp value placement separate
hint.envcp_value_placement_separate = {
    { type = hint.HintTypes.normal, text = "Toggles the parameter value visibility and places it next to the parameter label." },
}

-- envcp value placement next to label
hint.envcp_value_placement_in_label = {
    { type = hint.HintTypes.normal, text = "Toggles the parameter value visibility and places it within the parameter label." },
}

-- envcp value width
hint.envcp_value_width = {
    { type = hint.HintTypes.normal, text = "Adjusts the width reserved for the parmeter value display." },
}

-- envcp fader placement inline
hint.envcp_fader_placement_inline = {
    { type = hint.HintTypes.normal, text = "Toggles the visibility of the value fader and places it next to the buttons." },
}

-- envcp fader placement icon lane
hint.envcp_fader_placement_iconlane = {
    { type = hint.HintTypes.normal,    text = "Toggles the visibility of the value fader and places it in the artifical icon lane." },
    { type = hint.HintTypes.attention, text = "Requires the artificial icon lane to be enabled." },
    { type = hint.HintTypes.attention, text = "Without an icon lane the fader placement will fall back to the inline display." },
}

-- envcp fader orientation horizontal
hint.envcp_fader_orientation_horizontal = {
    { type = hint.HintTypes.normal, text = "Displays the value fader in a horizontal orientation." },
}

-- envcp fader orientation vertical
hint.envcp_fader_orientation_vertical = {
    { type = hint.HintTypes.normal, text = "Displays the value fader in a vertical orientation." },
}

-- envcp fader size
hint.envcp_fader_size = {
    { type = hint.HintTypes.normal,    text = "Adjusts the size of the value fader." },
    { type = hint.HintTypes.tip,       text = "Turning the value all the way down will force the fader to become a knob." },
    { type = hint.HintTypes.attention, text = "The adjustable size will be ignored during vertical orientation. The fader size will be determined by the track height in this mode." },
}

--      MCP
-- --------------------------------------

-- mcp folder indent
hint.mcp_general_folder_indent = {
    { type = hint.HintTypes.normal, text = "Adjusts the vertical indentation for folder child tracks." },
}

-- mcp folder start pad
hint.mcp_general_folder_pad_first = {
    { type = hint.HintTypes.normal, text = "Adds extra padding to the left side of folder tracks." },
}

-- mcp folder last pad
hint.mcp_general_folder_pad_last = {
    { type = hint.HintTypes.normal, text = "Adds extra padding to the last child track of a folder." },
}

-- mcp meter placement top
hint.mcp_meter_placement_top = {
    { type = hint.HintTypes.normal, text = "Toggles the meter visibility." },
    { type = hint.HintTypes.normal, text = "The meter is placed above the fader section." },
    { type = hint.HintTypes.normal, text = "Adjusting the meter size will increase its height while the width is locked to the MCP width." },
}

-- mcp meter placement bottom
hint.mcp_meter_placement_bottom = {
    { type = hint.HintTypes.normal, text = "Toggles the meter visibility." },
    { type = hint.HintTypes.normal, text = "The meter is placed next to the faders." },
    { type = hint.HintTypes.normal, text = "Adjusting the meter size will increase its width while the height is locked to the fader section dimensions." },
}

-- mcp meter side padding minimal
hint.mcp_meter_side_padding_minimal = {
    { type = hint.HintTypes.normal,    text = "Adds minimal padding to the edges of the meter." },
    { type = hint.HintTypes.normal,    text = "Additional side padding of the MCP will be ignored, the meter still stretches across the full width." },
    { type = hint.HintTypes.attention, text = "Has no effect when the meter placement is set to Bottom Mode." },
}

-- mcp meter side padding full
hint.mcp_meter_side_padding_full = {
    { type = hint.HintTypes.normal,    text = "Adds minimal padding to the edges of the meter." },
    { type = hint.HintTypes.normal,    text = "Additional side padding of the MCP will be respected and left as empty space." },
    { type = hint.HintTypes.attention, text = "Has no effect when the meter placement is set to Bottom Mode." },
}

-- mcp meter size
hint.mcp_meter_size = {
    { type = hint.HintTypes.normal, text = "Adjusts the Size of the meter." },
    { type = hint.HintTypes.normal, text = "When positioned above faders, the height will be adjusted." },
    { type = hint.HintTypes.normal, text = "When positioned next to faders, the width will be adjusted." },
}

-- mcp meter volume readout horizontal
hint.mcp_meter_volume_readout_horizontal = {
    { type = hint.HintTypes.normal, text = "Displays the volume fader dB value in a horizontal orientation." },
}

-- mcp meter volume readout vertical
hint.mcp_meter_volume_readout_vertical = {
    { type = hint.HintTypes.normal, text = "Displays the volume fader dB value in a vertical orientation." },
}

-- mcp meter channel expansion
hint.mcp_meter_channel_expansion = {
    { type = hint.HintTypes.normal,    text = "Expands the size of the meter as the channel count increases. Use the parameter to adjust the amount of expansion per channel pair." },
    { type = hint.HintTypes.attention, text = "Requires the meter to be positioned next to the faders." },
}

-- mcp meter channel expansion threshold
hint.mcp_meter_channel_expansion_threshold = {
    { type = hint.HintTypes.normal, text = "Set the amount of channels before the expansion kicks in." },
}

-- mcp meter channel expansion fixed
hint.mcp_meter_channel_expansion_fixed = {
    { type = hint.HintTypes.normal, text = "When activated, the dynamic expansion will be a static value, independent from the channel count." },
}

-- mcp layout fader top
hint.mcp_layout_fader_top = {
    { type = hint.HintTypes.highlight, text = "Split-Section Layout" },
    { type = hint.HintTypes.normal,    text = "Places the Volume fader at the bottom and the Pan and Width fader above it as a separate section." },
    { type = hint.HintTypes.attention, text = "This is the only layout that can implement the horizontal panning-faders." },
}

-- mcp layout strip
hint.mcp_layout_strip = {
    { type = hint.HintTypes.highlight, text = "Strip Layout" },
    { type = hint.HintTypes.normal,    text = "Aligns all fader elements vertically as a strip." },
    { type = hint.HintTypes.tip,       text = "Use this layout to achieve the smallest possible MCP width." },
    { type = hint.HintTypes.attention, text = "This layout cannot implement horizontal panning-faders." },
}

-- mcp layout block
hint.mcp_layout_block = {
    { type = hint.HintTypes.highlight, text = "Block Layout" },
    { type = hint.HintTypes.normal,    text = "Places all faders at the bottom. The Pan and Width faders are vertically stacked and placed next to the volume fader." },
    { type = hint.HintTypes.attention, text = "This layout cannot implement horizontal panning-faders." },
}

-- mcp panmode
hint.mcp_panmode = {
    { type = hint.HintTypes.normal, text = "Use this table to apply specific layouts to the Pan and Width faders depending on the tracks panmode." },
}

-- mcp panmode fader normal
hint.mcp_panmode_fader_normal = {
    { type = hint.HintTypes.normal, text = "Display Pan and Width as knobs." },
}

-- mcp panmode fader vertical
hint.mcp_panmode_fader_vertical = {
    { type = hint.HintTypes.normal,    text = "Display Pan and Width as vertical faders." },
    { type = hint.HintTypes.attention, text = "The faders will automatically be converted to knobs when there is not enough room." },
}

-- mcp panmode fader horizontal
hint.mcp_panmode_fader_horizontal = {
    { type = hint.HintTypes.normal,    text = "Display Pan and Width as a stacked pair of horizontal faders." },
    { type = hint.HintTypes.attention, text = "This is only possible in the Split-Section-Layout" },
}

-- mcp always show width
hint.mcp_always_show_width = {
    { type = hint.HintTypes.normal, text = "Forces Width to be always visible independent from the tracks current panmode setting." },
}

-- mcp pan section width
hint.mcp_pan_section_width = {
    { type = hint.HintTypes.normal,    text = "Adjusts the width the panning-section." },
    { type = hint.HintTypes.normal,    text = "This adjustment likely increases the width of the MCP." },
    { type = hint.HintTypes.attention, text = "This adjustment is only possible in the Split-Section-Layout" },
}

-- mcp pan section height
hint.mcp_pan_section_height = {
    { type = hint.HintTypes.normal,    text = "Adjusts the height the panning-section." },
    { type = hint.HintTypes.normal,    text = "This will limit the height of the Volume fader." },
    { type = hint.HintTypes.attention, text = "This adjustment is not possible in the Block Layout" },
}

-- mcp add padding
hint.mcp_add_padding = {
    { type = hint.HintTypes.normal,    text = "Adds empty space to the sides of the MCP tracks." },
    { type = hint.HintTypes.normal,    text = "This will increase the overall width of the MCP." },
    { type = hint.HintTypes.attention, text = "Certain elements require a specific setting to be enabled in order for them to recognize the empty space." },
    { type = hint.HintTypes.attention, text = "Some elements will simply ignore the empty space and fill it out anyways." },
}

-- mcp label size
hint.mcp_label_size = {
    { type = hint.HintTypes.normal, text = "Adjusts the vertical size of the track name label." },
}

-- mcp label orientation
hint.mcp_label_orientation_vertical = {
    { type = hint.HintTypes.normal, text = "Switches to label to a vertical orientation, rotating the text." },
    { type = hint.HintTypes.tip,    text = "This setting is recommended for thin channel strips." },
}

-- mcp label index in label
hint.mcp_label_index_in_label = {
    { type = hint.HintTypes.normal, text = "Toggles the visibility of the track index number." },
    { type = hint.HintTypes.normal, text = "The number will be placed inside the track name label." },
}

-- mcp label index separate
hint.mcp_label_index_separate = {
    { type = hint.HintTypes.normal, text = "Toggles the visibility of the track index number." },
    { type = hint.HintTypes.normal, text = "The number will be placed above the label block, below the fader section." },
}


-- mcp inserts placement top
hint.mcp_inserts_placement_top = {
    { type = hint.HintTypes.normal, text = "Toggles the visibility of the inserts section." },
    { type = hint.HintTypes.normal, text = "Places the inserts section at the top of the track." },
}

-- mcp inserts placement sidebar
hint.mcp_inserts_placement_side = {
    { type = hint.HintTypes.normal, text = "Toggles the visibility of the inserts section." },
    { type = hint.HintTypes.normal, text = "Places the inserts section at the side of the track." },
}

-- mcp inserts placement embed
hint.mcp_inserts_placement_embed = {
    { type = hint.HintTypes.normal, text = "Toggles the visibility of the inserts section." },
    { type = hint.HintTypes.normal, text = "Places the inserts section at the top of the track and dynamically switches to a sidebar layout when there's at least one embedded FX in the MCP." },
}

-- mcp inserts padding minimal
hint.mcp_inserts_padding_minimal = {
    { type = hint.HintTypes.normal,    text = "Adds a slight amount of padding to the edges of the inserts section." },
    { type = hint.HintTypes.attention, text = "The input-selection element will be affected by this setting on wider button layouts." },
}

-- mcp inserts padding full
hint.mcp_inserts_padding_full = {
    { type = hint.HintTypes.normal,    text = "Adds a slight amount of padding to the edges of the inserts section." },
    { type = hint.HintTypes.normal,    text = "Additional padding will be respected." },
    { type = hint.HintTypes.attention, text = "The input-selection element will be affected by this setting on wider button layouts." },
    { type = hint.HintTypes.attention, text = "Some settings and layouts will ignore this setting and fall back to the minimal padding." },
}

-- mcp inserts size
hint.mcp_inserts_size = {
    { type = hint.HintTypes.normal, text = "Adjusts the size of the inserts section." },
}

-- mcp inserts size on embed
hint.mcp_inserts_size_on_embed = {
    { type = hint.HintTypes.normal,    text = "Sets or increases the size of the inserts section for tracks containing embedded FX." },
    { type = hint.HintTypes.attention, text = "This will only affect tracks where the inserts section is positioned at the side." },
}

-- mcp button layout slim
hint.mcp_button_layout_slim = {
    { type = hint.HintTypes.highlight, text = "Slim Layout" },
    { type = hint.HintTypes.normal,    text = "Limited to 1 button per row." },
    { type = hint.HintTypes.tip,       text = "Use this layout if you want to make the MCP as slim as possible." },
    { type = hint.HintTypes.attention, text = "The order of the buttons is hard-coded." },
}

-- mcp button layout medium
hint.mcp_button_layout_medium = {
    { type = hint.HintTypes.highlight, text = "Medium Layout" },
    { type = hint.HintTypes.normal,    text = "Limited to 2 buttons per row." },
    { type = hint.HintTypes.attention, text = "The order of the buttons and their linebreaks are hard-coded." },
}

-- mcp button layout wide
hint.mcp_button_layout_wide = {
    { type = hint.HintTypes.highlight, text = "Wide Layout" },
    { type = hint.HintTypes.normal,    text = "Limited to 4 buttons per row." },
    { type = hint.HintTypes.attention, text = "The order of the buttons and their linebreaks are hard-coded." },
}

-- mcp button layout wide
hint.mcp_button_recinput_size = {
    { type = hint.HintTypes.normal,    text = "Adjusts the size of the Input Selector element." },
    { type = hint.HintTypes.attention, text = "This setting requires the slim layout ot be active." },
}

-- mcp master menu button
hint.mcp_master_menu_button = {
    { type = hint.HintTypes.normal, text = "Adjusts the height of the master track menu button in the mixer." },
}

--      Infobar
-- --------------------------------------

-- bank slot select
hint.bank_slot_select = {
    { type = hint.HintTypes.normal, text = "Sets the single active slot of the Bank System." },
    { type = hint.HintTypes.tip, text = "Use the [+] buttons to activate bank support for the respective parameter." },
    { type = hint.HintTypes.tip, text = "Bank slots can also be selected using optional buttons in the transport section or the custom scripts provided with paRt." },
}

-- bank copy mode
hint.bank_copy_mode = {
    { type = hint.HintTypes.highlight, text = "Bank Copy Mode" },
    { type = hint.HintTypes.normal, text = "Allows you to copy the settings of the currently selected bank to other banks, overwriting their data." },
    { type = hint.HintTypes.tip, text = "How to use:" },
    { type = hint.HintTypes.tip, text = "1. Activate copying mode" },
    { type = hint.HintTypes.tip, text = "2. Select target banks" },
    { type = hint.HintTypes.tip, text = "3. Select target banks" },
    { type = hint.HintTypes.tip, text = "4. Press Copy Bank button again to copy" },
    { type = hint.HintTypes.warning, text = "This action will irreversibly overwrite data." },
}

-- config slot select
hint.config_slot_select = {
    { type = hint.HintTypes.normal, text = "Selects the active configuration slot." },
    { type = hint.HintTypes.normal, text = "You can store several versions of the entire Theme Adjuster settings using the configuration slots." },
    { type = hint.HintTypes.tip, text = "Can be used for backups. Each configuration slot is storing its data in a separate file, located in the scripts folder." },
}

-- config slot save
hint.config_slot_save = {
    { type = hint.HintTypes.normal, text = "Saves all the Theme Adjuster settings to the current configuration slot." },
}

-- config slot load
hint.config_slot_load = {
    { type = hint.HintTypes.normal, text = "Loads all the Theme Adjuster settings from the current configuration slot." },
    { type = hint.HintTypes.attention, text = "Will only work if there's a saved configuration for the active slot available." },
}

-- config save to file
hint.config_save_to_file = {
    { type = hint.HintTypes.normal, text = "Saves all the Theme Adjuster settings to a file." },
    { type = hint.HintTypes.normal, text = "Allows you to pick the file using your OS provided file browser." },
    { type = hint.HintTypes.attention, text = "Requires the Rejs_ReaScriptAPI extension. If there are any issues you can fall back to the config slot system." },
}

-- config load from file
hint.config_load_from_file = {
    { type = hint.HintTypes.normal, text = "Loads all the Theme Adjuster settings from a file." },
    { type = hint.HintTypes.normal, text = "Allows you to pick the file using your OS provided file browser." },
    { type = hint.HintTypes.attention, text = "Requires the Rejs_ReaScriptAPI extension. If there are any issues you can fall back to the config slot system." },
}

-- config load default
hint.config_load_default = {
    { type = hint.HintTypes.normal, text = "Loads an optimized default configuration." },
    { type = hint.HintTypes.attention, text = "Requires you to press the button twice as a safety measure." },
    { type = hint.HintTypes.warning, text = "This action will irreversibly overwrite data." },
}

-- config hard reset
hint.config_hard_reset = {
    { type = hint.HintTypes.normal, text = "Resets all parameters using their hard-coded default values." },
    { type = hint.HintTypes.attention, text = "Requires you to press the button twice as a safety measure." },
    { type = hint.HintTypes.warning, text = "This action will irreversibly overwrite data." },
}

--      Custom
-- --------------------------------------

-- custom range
hint.custom_range = {
    { type = hint.HintTypes.normal, text = "A custom adjustment that can be used when modding the theme." },
}

-- custom button
hint.custom_button = {
    { type = hint.HintTypes.normal, text = "A custom button that can be used when modding the theme." },
}

-- custom selection
hint.custom_selection = {
    { type = hint.HintTypes.normal, text = "A custom multiple choice set that can be used when modding the theme." },
}


return hint
