-- @version 1.2.3
-- @author Fleeesch
-- @description paRt Theme Adjuster
-- @noIndex

--[[
    Those are all the hint messages displayed in the Theme Adjuster when you hover over objects.
]]

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

--      Placeholders
-- --------------------------------------

-- storage
hint.line_stored_per_theme_file = { type = hint.HintTypes.attention, text = "Parameter will be stored exclusively per Theme File." }

-- bypass
hint.line_bypass_possible = { type = hint.HintTypes.attention, text = "Some configurations may bypass this setting." }
hint.line_bypass_center = { type = hint.HintTypes.attention, text = "This feature will be bypassed when the parameter is centered." }

-- button wrapping
hint.line_button_wrap_toggle = { type = hint.HintTypes.normal, text = "Activates button wrapping." }
hint.line_button_wrap_description = { type = hint.HintTypes.normal, text = "Buttons will flow across multiple lines if horizontal space is insufficient." }
hint.line_button_wrap_tight = { type = hint.HintTypes.normal, text = "Toggleable extra spacing is removed starting from the second line." }
hint.line_button_wrap_extratight = { type = hint.HintTypes.normal, text = "Button spacing is reduced to the absolute minimum." }

-- meter visible
hint.line_meter_must_be_visible = { type = hint.HintTypes.attention, text = "Requires the meter to be visible." }

-- fader
hint.line_fader_knob = { type = hint.HintTypes.tip, text = "Setting to minimum forces the fader to become a knob." }
hint.line_fader_vertical = { type = hint.HintTypes.attention, text = "Vertical-Faders mode ignores this adjustment and uses track height instead." }
hint.line_fader_stacked = { type = hint.HintTypes.attention, text = "Stacked-Faders mode ignores this setting and uses the volume fader size instead." }

-- warnings
hint.line_warning_overwrite = { type = hint.HintTypes.warning, text = "This will irreversibly overwrite data." }

-- requirements
hint.line_requirement_rejs = { type = hint.HintTypes.attention, text = "Requires Rejs_ReaScriptAPI. If issues occur, fallback to the configuration slots." }

--      Spacing
-- --------------------------------------

-- extra space
hint.extra_space = {
    { type = hint.HintTypes.normal, text = "Adjusts optional extra space." },
    { type = hint.HintTypes.tip,    text = "Extra space has to be enabled per element in its visibility matrix." }
}

-- bank toggle button
hint.bank_toggle = {
    { type = hint.HintTypes.highlight, text = "Use Bank System" },
    { type = hint.HintTypes.normal, text = "Enables the bank system for this parameter." },
    { type = hint.HintTypes.normal, text = "Each bank stores its own value for the parameter." },
    { type = hint.HintTypes.tip, text = "Enabling the switch won’t overwrite the existing value. You can disable it again at any time." }
}

-- spacing - buttons - x
hint.spacing_buttons_x = {
    { type = hint.HintTypes.normal, text = "Increases horizontal space between buttons." },
    hint.line_bypass_possible
}

-- spacing - buttons - y
hint.spacing_buttons_y = {
    { type = hint.HintTypes.normal, text = "Increases the vertical space between buttons." },
    hint.line_bypass_possible
}

-- spacing - faders - x
hint.spacing_faders_x = {
    { type = hint.HintTypes.normal, text = "Increases the horizontal space between faders." },
    hint.line_bypass_possible
}

-- spacing - faders - y
hint.spacing_faders_y = {
    { type = hint.HintTypes.normal, text = "Increases the vertical space between faders." },
    hint.line_bypass_possible
}

-- spacing - section - x
hint.spacing_section_x = {
    { type = hint.HintTypes.normal, text = "Increases the horizontal space between sections." },
    hint.line_bypass_possible
}

-- spacing - section - y
hint.spacing_section_y = {
    { type = hint.HintTypes.normal, text = "Increases the vertical space between sections." },
    hint.line_bypass_possible
}

-- percentual scaling button
hint.size_percentual = {
    { type = hint.HintTypes.highlight, text = "Percentual Scaling" },
    { type = hint.HintTypes.normal,    text = "Switches size adjustment from an absolute value to a percentage of the remaining space." },
    { type = hint.HintTypes.attention, text = "When enabled, large percentage values may prevent the element from being displayed." },
    hint.line_bypass_possible
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
hint.highlights_colorbar_size = {
    { type = hint.HintTypes.normal, text = "Adjusts the size of the track's color bar." },
    { type = hint.HintTypes.normal, text = "The color bar shows the track's custom color as a separate block." },
    { type = hint.HintTypes.tip,    text = "Setting it to the minimum value will hide the color bar completely." },
}

-- selection bar size
hint.highlights_selectionbar_size = {
    { type = hint.HintTypes.normal, text = "Adjusts the size of the track's selection bar." },
    { type = hint.HintTypes.normal, text = "The selection bar highlights selected tracks." },
    { type = hint.HintTypes.tip,    text = "Setting it to the minimum value will hide the selection bar completely." },
}


--      Visibility Matrix
-- --------------------------------------

-- visibility
hint.vismatrix_visbility = {
    { type = hint.HintTypes.normal, text = "Toggles the element's visibility." },
}

-- hide when mixer is visible
hint.vismatrix_nomixer = {
    { type = hint.HintTypes.normal, text = "Hides the element when enabled and the mixer is visible." },
}

-- add separator
hint.vismatrix_separator = {
    { type = hint.HintTypes.normal, text = "Adds extra spacing after the element." },
    { type = hint.HintTypes.normal, text = "The element must be visible." },
    hint.line_bypass_possible
}

-- size adjustment
hint.vismatrix_size = {
    { type = hint.HintTypes.normal, text = "Adjusts the size of the element." },
}


--      Colors
-- --------------------------------------

-- theme files
hint.colors_theme_files = {
    { type = hint.HintTypes.normal,    text = "Loads a paRt theme file that provides a different color profile." },
    { type = hint.HintTypes.attention, text = "The paRt Theme Adjuster must be active to sync user settings. It is recommended to use the Theme Adjuster when switching paRt theme files." },
}

-- reaper colors
hint.colors_reaper = {
    { type = hint.HintTypes.normal, text = "Reaper's internal color adjustment sliders." },
    hint.line_stored_per_theme_file,
}

-- reaper colors to custom colors
hint.colors_reaper_apply_custom = {
    { type = hint.HintTypes.normal, text = "Applies Reaper's internal color adjustment values to custom color objects, such as media items." },
}

-- colorbar intensity
hint.colors_tuning_colorbar_intensity = {
    { type = hint.HintTypes.normal, text = "Adjusts the brightness and intensity of the track color bar." },
}

-- track background tone
hint.colors_track_background_tone = {
    { type = hint.HintTypes.normal, text = "Brightness of the track background color." },
}

-- track background tone (selected)
hint.colors_track_background_tone_select = {
    { type = hint.HintTypes.normal, text = "Increased background brightness for selected tracks." },
}

-- track background tint
hint.colors_track_background_tint = {
    { type = hint.HintTypes.normal, text = "Adjusts the custom color intensity of the track background." },
}

-- track background tint (selected)
hint.colors_track_background_tint_select = {
    { type = hint.HintTypes.normal, text = "Increased custom color intensity for selected track backgrounds." },
}

-- track label tone
hint.colors_track_label_bg_tone = {
    { type = hint.HintTypes.normal, text = "Brightness of the track label background color." },
}

-- track label tone (selected)
hint.colors_track_label_bg_tone_select = {
    { type = hint.HintTypes.normal, text = "Increased label background brightness for selected tracks." },
}

-- track label tint
hint.colors_track_label_bg_tint = {
    { type = hint.HintTypes.normal, text = "Adjusts the custom color intensity of the track label background." },
}

-- track label tint (selected)
hint.colors_track_label_bg_tint_select = {
    { type = hint.HintTypes.normal, text = "Increased custom color intensity for selected track label backgrounds." },
}

-- track label text tone
hint.colors_track_label_text_tone = {
    { type = hint.HintTypes.normal, text = "Adjusts the brightness of the label text." },
}

-- index tone - TCP
hint.colors_track_index_tone_tcp = {
    { type = hint.HintTypes.normal, text = "Adjusts the brightness of the track index number in the TCP." },
}

-- index tone - MCP
hint.colors_track_index_tone_mcp = {
    { type = hint.HintTypes.normal, text = "Adjusts the brightness of the track index number in the MCP." },
}

-- ENVCP background tone
hint.colors_track_envcp_background_tone = {
    { type = hint.HintTypes.normal, text = "Adjusts the brightness of the ENVCP background." },
}

-- ENVCP background tint
hint.colors_track_envcp_background_tint = {
    { type = hint.HintTypes.normal, text = "Adjusts the custom color intensity of the ENVCP background." },
    { type = hint.HintTypes.tip,    text = "The color is taken from the envelope's parent track custom color." },
}

-- ENVCP label tone
hint.colors_track_envcp_label_tone = {
    { type = hint.HintTypes.normal, text = "Adjusts the brightness of the ENVCP label background." },
}

-- ENVCP label tint
hint.colors_track_envcp_label_tint = {
    { type = hint.HintTypes.normal, text = "Adjusts the custom color intensity of the ENVCP label background." },
}

-- ENVCP label text tone
hint.colors_track_envcp_label_text_tone = {
    { type = hint.HintTypes.normal, text = "Adjusts the brightness of the ENVCP label text." },
}

-- ENVCP value text tone
hint.colors_track_envcp_label_readout_tone = {
    { type = hint.HintTypes.normal, text = "Adjusts the brightness of the ENVCP value display text." },
}

-- meter - unlit tone
hint.colors_meter_text_unlit_tone = {
    { type = hint.HintTypes.normal, text = "Tone of neutral meter text." },
}

-- meter - unlit shadow
hint.colors_meter_text_unlit_shadow = {
    { type = hint.HintTypes.normal, text = "Drop-shadow opacity of neutral meter text." },
}

-- meter - lit tone
hint.colors_meter_text_lit_tone = {
    { type = hint.HintTypes.normal, text = "Tone of highlighted meter text." },
}

-- meter - lit shadow
hint.colors_meter_text_lit_shadow = {
    { type = hint.HintTypes.normal, text = "Drop-shadow opacity of highlighted meter text." },
}

-- readout tone
hint.colors_meter_readout_tone = {
    { type = hint.HintTypes.normal, text = "Adjusts the brightness of the meter readout text." },
}
-- readout clip tone
hint.colors_meter_readout_clip_tone = {
    { type = hint.HintTypes.normal, text = "Adjusts the brightness of the meter readout text after peak clipping." },
}

-- meter TCP alpha
hint.colors_meter_alpha_tcp = {
    { type = hint.HintTypes.normal, text = "Adjusts the opacity of the meter text overlay in TCP tracks." },
}

-- meter MCP alpha
hint.colors_meter_alpha_mcp = {
    { type = hint.HintTypes.normal, text = "Adjusts the opacity of the meter text overlay in MCP tracks." },
}

-- folder track tone
hint.colors_folder_track_tone = {
    { type = hint.HintTypes.normal, text = "Relative adjustment for the background brightness of folder tracks." },
    hint.line_bypass_center
}

-- folder track tint
hint.colors_folder_track_tint = {
    { type = hint.HintTypes.normal, text = "Relative adjustment for the background saturation of folder tracks." },
    hint.line_bypass_center
}

-- folder tree tone
hint.colors_folder_tree_tone = {
    { type = hint.HintTypes.normal,    text = "Changes the brightness of track backgrounds based on folder depth." },
    { type = hint.HintTypes.attention, text = "Total depth is calculated from visible tracks only." },
    hint.line_bypass_center
}

-- folder tree tint
hint.colors_folder_tree_tint = {
    { type = hint.HintTypes.normal,    text = "Changes the color intensity of track backgrounds based on folder depth." },
    { type = hint.HintTypes.attention, text = "Total depth is calculated from visible tracks only." },
    hint.line_bypass_center
}

--      Transport
-- --------------------------------------

-- part menu button
hint.transport_menu_button = {
    { type = hint.HintTypes.normal, text = "Shows a button in the transport section that opens the paRt Theme Adjuster." },
}

-- part bank buttons
hint.transport_bank_buttons = {
    { type = hint.HintTypes.normal, text = "Shows buttons in the transport section for selecting paRt banks." },
}

-- transport width increase
hint.transport_width_plus = {
    { type = hint.HintTypes.normal, text = "Adds extra width to the transport section." },
    { type = hint.HintTypes.tip,    text = "Most noticeable when the transport section is a floating window." },
}

-- transport height increase
hint.transport_height_plus = {
    { type = hint.HintTypes.normal, text = "Adds extra height to the transport section." },
}

-- transport tempo element spacing
hint.transport_spacing_tempo = {
    { type = hint.HintTypes.normal, text = "Increases horizontal spacing between elements in the tempo section." },
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
    { type = hint.HintTypes.tip,    text = "Only applies when the playrate is set to be displayed as a fader." },
}



--      TCP
-- --------------------------------------

-- TCP insert slot size
hint.tcp_general_insert_slot_size = {
    { type = hint.HintTypes.normal, text = "Adjusts the target width for FX, send and parameter slots." },
    { type = hint.HintTypes.normal, text = "REAPER formats the slots based on the size of the FX block in the TCP." },
    { type = hint.HintTypes.tip,    text = "To cover the full FX section, set this parameter to its maximum value." },
}

-- TCP folder indent
hint.tcp_general_folder_indent = {
    { type = hint.HintTypes.normal, text = "Adjusts the horizontal indentation for folder child tracks." },
}

-- TCP folder collapse buttons
hint.tcp_general_folder_collapse_buttons = {
    { type = hint.HintTypes.normal, text = "Toggles the folder collapse buttons." },
}

-- TCP folder collapse lines
hint.tcp_general_folder_collapse_lines = {
    { type = hint.HintTypes.normal, text = "Toggles the folder collapse buttons." },
    { type = hint.HintTypes.normal, text = "Shows lines highlighting the folder structure when activated." },
}

-- TCP folder mode
hint.tcp_general_folder_mode = {
    { type = hint.HintTypes.normal, text = "Shows a button to cycle through track folder modes." },
}

-- TCP rec input size
hint.tcp_button_recinput_size = {
    { type = hint.HintTypes.normal, text = "Adjusts the size of the input selector." },
    { type = hint.HintTypes.normal, text = "When button wrapping is enabled, the input selector will be trimmed if space is limited." },
}

-- TCP button wrapping full
hint.tcp_button_wrap_full = {
    hint.line_button_wrap_toggle,
    hint.line_button_wrap_description,
}

-- TCP button wrapping compact
hint.tcp_button_wrap_compact = {
    hint.line_button_wrap_toggle,
    hint.line_button_wrap_description,
    hint.line_button_wrap_tight,
}

-- TCP button wrapping narrow
hint.tcp_button_wrap_narrow = {
    hint.line_button_wrap_toggle,
    hint.line_button_wrap_description,
    hint.line_button_wrap_tight,
    hint.line_button_wrap_extratight
}

-- TCP meter show
hint.tcp_meter_show = {
    { type = hint.HintTypes.normal, text = "Toggles meter visibility." },
}

-- TCP meter volume readout
hint.tcp_meter_vol_readout = {
    { type = hint.HintTypes.normal, text = "Shows a volume level readout label next to the meter." },
    hint.line_meter_must_be_visible
}

-- TCP meter text
hint.tcp_meter_text = {
    { type = hint.HintTypes.normal, text = "Toggles dB scale visibility in the meter." },
    hint.line_meter_must_be_visible
}

-- TCP meter clip text
hint.tcp_meter_clip_text = {
    { type = hint.HintTypes.normal, text = "Toggles peak text visibility in the meter." },
    hint.line_meter_must_be_visible
}

-- TCP meter size
hint.tcp_meter_size = {
    { type = hint.HintTypes.normal, text = "Adjusts the size of the meter." },
}

-- TCP meter VU space
hint.tcp_meter_vu_space = {
    { type = hint.HintTypes.normal,    text = "Adjusts the space between meter channels." },
    { type = hint.HintTypes.attention, text = "REAPER strongly affects how the distance is interpreted. Use this as a coarse adjustment." },
}

-- TCP fader size - volume
hint.tcp_fader_size_vol = {
    { type = hint.HintTypes.normal,    text = "Adjusts the size of the volume fader." },
    hint.line_fader_knob,
    hint.line_fader_vertical,
    { type = hint.HintTypes.attention, text = "Stacked-Faders mode uses this size as reference." },
}

-- TCP fader size - pan
hint.tcp_fader_size_pan = {
    { type = hint.HintTypes.normal, text = "Adjusts the size of the pan fader." },
    hint.line_fader_knob,
    hint.line_fader_vertical,
    hint.line_fader_stacked
}

-- TCP fader size - width
hint.tcp_fader_size_wid = {
    { type = hint.HintTypes.normal, text = "Adjusts the size of the width fader." },
    hint.line_fader_knob,
    hint.line_fader_vertical,
    hint.line_fader_stacked
}

-- TCP fader layout inline
hint.tcp_fader_layout_inline = {
    { type = hint.HintTypes.highlight, text = "TCP - Inline Faders" },
    { type = hint.HintTypes.normal,    text = "Faders are shown next to buttons on the first line." },
    { type = hint.HintTypes.attention, text = "Faders are excluded from button wrapping." },
}

-- TCP fader layout stacked
hint.tcp_fader_layout_stacked = {
    { type = hint.HintTypes.highlight, text = "TCP - Stacked Faders" },
    { type = hint.HintTypes.normal,    text = "Faders are displayed in a separate vertical block." },
    { type = hint.HintTypes.attention, text = "Fader width is set by the volume fader size and shared across all faders." },
}

-- TCP fader layout vertical
hint.tcp_fader_layout_vertical = {
    { type = hint.HintTypes.highlight, text = "TCP - Vertical Faders" },
    { type = hint.HintTypes.normal,    text = "Faders are displayed in a separate horizontal block." },
    { type = hint.HintTypes.normal,    text = "Fader height is linked to track height." },
    { type = hint.HintTypes.normal,    text = "Faders automatically become knobs if track height is too small." },
}

-- TCP label size
hint.tcp_label_size = {
    { type = hint.HintTypes.normal, text = "Adjusts the size of the label by drawing an invisible line that triggers hiding and button wrapping." },
    { type = hint.HintTypes.tip,    text = "The label is always trying to use as much width as possible, you have to play around with this setting and the TCP width to figure out the optimal value." },
}

-- TCP index - separate
hint.tcp_index_separate = {
    { type = hint.HintTypes.normal, text = "Shows the index number next to the name label." },
}

-- TCP index - in label
hint.tcp_index_in_label = {
    { type = hint.HintTypes.normal, text = "Shows the index number inside the name label." },
}

-- TCP inserts size
hint.tcp_inserts_size = {
    { type = hint.HintTypes.normal, text = "Adjusts the width of the inserts section." },
}

-- TCP inserts placement - inline
hint.tcp_inserts_placement_inline = {
    { type = hint.HintTypes.normal, text = "Shows the inserts section inline on the right side of the TCP." },
}

-- TCP inserts placement - separate
hint.tcp_inserts_placement_separate = {
    { type = hint.HintTypes.normal, text = "Shows the inserts section in a separate block." },
    { type = hint.HintTypes.normal, text = "The section is placed below buttons and faders." },
    { type = hint.HintTypes.normal, text = "It is visible only when track height is extended." },
}
--      ENVCP
-- --------------------------------------

-- ENVCP show symbol
hint.envcp_show_symbol = {
    { type = hint.HintTypes.normal, text = "Shows a symbol next to each envelope lane with slight indentation." },
}

-- ENVCP include track icon lane
hint.envcp_include_track_icon_lane = {
    { type = hint.HintTypes.normal,    text = "Adds an artificial track icon lane to the envelope." },
    { type = hint.HintTypes.attention, text = "Requires track lanes or track icons to be visible." },
}

-- ENVCP indentation
hint.envcp_indentation = {
    { type = hint.HintTypes.normal, text = "Adjusts horizontal offset for the envelope lanes." },
}

-- ENVCP value placement - separate
hint.envcp_value_placement_separate = {
    { type = hint.HintTypes.normal, text = "Shows the parameter value next to the parameter label." },
}

-- ENVCP value placement - in label
hint.envcp_value_placement_in_label = {
    { type = hint.HintTypes.normal, text = "Shows the parameter value within the parameter label." },
}

-- ENVCP value width
hint.envcp_value_width = {
    { type = hint.HintTypes.normal, text = "Adjusts the width reserved for the parameter value display." },
}

-- ENVCP fader placement - inline
hint.envcp_fader_placement_inline = {
    { type = hint.HintTypes.normal, text = "Shows the value fader next to the buttons." },
}

-- ENVCP fader placement - icon lane
hint.envcp_fader_placement_iconlane = {
    { type = hint.HintTypes.normal,    text = "Shows the value fader in the artificial icon lane." },
    { type = hint.HintTypes.attention, text = "Requires the artificial icon lane to be enabled." },
    { type = hint.HintTypes.attention, text = "Without an icon lane, the fader falls back to inline placement." },
}

-- ENVCP fader orientation - horizontal
hint.envcp_fader_orientation_horizontal = {
    { type = hint.HintTypes.normal, text = "Displays the value fader horizontally." },
}

-- ENVCP fader orientation - vertical
hint.envcp_fader_orientation_vertical = {
    { type = hint.HintTypes.normal, text = "Displays the value fader vertically." },
}

-- ENVCP fader size
hint.envcp_fader_size = {
    { type = hint.HintTypes.normal,    text = "Adjusts the size of the value fader." },
    { type = hint.HintTypes.tip,       text = "Setting this to minimum forces the fader to become a knob." },
    { type = hint.HintTypes.attention, text = "Size is ignored in vertical orientation. the fader height follows track height in this mode." },
}


--      MCP
-- --------------------------------------

-- MCP folder indent
hint.mcp_general_folder_indent = {
    { type = hint.HintTypes.normal, text = "Adjusts the vertical indentation for folder child tracks." },
}

-- MCP folder start pad
hint.mcp_general_folder_pad_first = {
    { type = hint.HintTypes.normal, text = "Adds extra padding to the left side of folder tracks." },
}

-- MCP folder last pad
hint.mcp_general_folder_pad_last = {
    { type = hint.HintTypes.normal, text = "Adds extra padding to the last child track of a folder." },
}

-- MCP meter placement top
hint.mcp_meter_placement_top = {
    { type = hint.HintTypes.normal, text = "Toggles meter visibility." },
    { type = hint.HintTypes.normal, text = "The meter is placed above the fader section." },
    { type = hint.HintTypes.normal, text = "Adjusting the meter size changes its height; width is locked to the MCP width." },
}

-- MCP meter placement bottom
hint.mcp_meter_placement_bottom = {
    { type = hint.HintTypes.normal, text = "Toggles meter visibility." },
    { type = hint.HintTypes.normal, text = "The meter is placed next to the faders." },
    { type = hint.HintTypes.normal, text = "Adjusting the meter size changes its width; height is locked to the fader section." },
}

-- MCP meter side padding minimal
hint.mcp_meter_side_padding_minimal = {
    { type = hint.HintTypes.normal,    text = "Adds minimal padding to the meter edges." },
    { type = hint.HintTypes.normal,    text = "Ignores additional padding whitespace." },
    { type = hint.HintTypes.attention, text = "Has no effect when the meter is placed at the bottom." },
}

-- MCP meter side padding full
hint.mcp_meter_side_padding_full = {
    { type = hint.HintTypes.normal,    text = "Adds padding to the meter edges." },
    { type = hint.HintTypes.normal,    text = "Includes additional padding whitespace." },
    { type = hint.HintTypes.attention, text = "Has no effect when the meter is placed at the bottom." },
}

-- MCP meter size
hint.mcp_meter_size = {
    { type = hint.HintTypes.normal, text = "Adjusts the size of the meter." },
    { type = hint.HintTypes.normal, text = "Depending on the placement this either affects its width or its height." },
}

-- MCP meter volume readout horizontal
hint.mcp_meter_volume_readout_horizontal = {
    { type = hint.HintTypes.normal, text = "Displays the volume fader dB value in a horizontal orientation." },
}

-- MCP meter volume readout vertical
hint.mcp_meter_volume_readout_vertical = {
    { type = hint.HintTypes.normal, text = "Displays the volume fader dB value in a vertical orientation." },
}

-- MCP meter channel expansion
hint.mcp_meter_channel_expansion = {
    { type = hint.HintTypes.normal,    text = "Expands the meter size as the track channel count increases." },
    { type = hint.HintTypes.attention, text = "Requires the meter to be positioned next to the faders." },
}

-- MCP meter channel expansion threshold
hint.mcp_meter_channel_expansion_threshold = {
    { type = hint.HintTypes.normal, text = "Sets the channel count at which automatic expansion begins." },
}

-- MCP meter channel expansion fixed
hint.mcp_meter_channel_expansion_fixed = {
    { type = hint.HintTypes.normal, text = "When enabled, expansion is applied only once withe a fixed level after the channel count threshold has been reached." },
}

-- MCP layout fader top
hint.mcp_layout_fader_top = {
    { type = hint.HintTypes.highlight, text = "Split-Section Layout" },
    { type = hint.HintTypes.normal,    text = "Volume fader at bottom; Pan and Width faders above as a separate section." },
    { type = hint.HintTypes.attention, text = "Only layout supporting horizontal panning-faders." },
}

-- MCP layout strip
hint.mcp_layout_strip = {
    { type = hint.HintTypes.highlight, text = "Strip Layout" },
    { type = hint.HintTypes.normal,    text = "Aligns all fader elements vertically as a strip." },
    { type = hint.HintTypes.tip,       text = "Use for the smallest possible MCP width." },
    { type = hint.HintTypes.attention, text = "Cannot implement horizontal panning-faders." },
}

-- MCP layout block
hint.mcp_layout_block = {
    { type = hint.HintTypes.highlight, text = "Block Layout" },
    { type = hint.HintTypes.normal,    text = "All faders at bottom; Pan and Width stacked vertically next to volume fader." },
    { type = hint.HintTypes.attention, text = "Cannot implement horizontal panning-faders." },
}

-- MCP panmode
hint.mcp_panmode = {
    { type = hint.HintTypes.normal, text = "Apply specific layouts to Pan and Width faders depending on the track panmode." },
}

-- MCP panmode fader normal
hint.mcp_panmode_fader_normal = {
    { type = hint.HintTypes.normal, text = "Display Pan and Width as knobs." },
}

-- MCP panmode fader vertical
hint.mcp_panmode_fader_vertical = {
    { type = hint.HintTypes.normal, text = "Display Pan and Width as vertical faders." },
    { type = hint.HintTypes.attention, text = "Faders convert to knobs if there isn’t enough space." },
}

-- MCP panmode fader horizontal
hint.mcp_panmode_fader_horizontal = {
    { type = hint.HintTypes.normal,    text = "Display Pan and Width as a stacked pair of horizontal faders." },
    { type = hint.HintTypes.attention, text = "Only possible in Split-Section Layout." },
}

-- MCP always show width
hint.mcp_always_show_width = {
    { type = hint.HintTypes.normal, text = "Forces Width to always be visible, ignoring track panmode." },
}

-- MCP pan section width
hint.mcp_pan_section_width = {
    { type = hint.HintTypes.normal,    text = "Adjusts the width of the panning section." },
    { type = hint.HintTypes.normal,    text = "Likely increases the overall MCP width." },
    { type = hint.HintTypes.attention, text = "Only available in Split-Section Layout." },
}

-- MCP pan section height
hint.mcp_pan_section_height = {
    { type = hint.HintTypes.normal,    text = "Adjusts the height of the panning section." },
    { type = hint.HintTypes.normal,    text = "Limits the height of the Volume fader." },
    { type = hint.HintTypes.attention, text = "Not available in Block Layout." },
}

-- MCP add padding
hint.mcp_add_padding = {
    { type = hint.HintTypes.normal, text = "Adds empty space to the sides of MCP tracks." },
    { type = hint.HintTypes.normal, text = "Increases the overall MCP width." },
}

-- MCP label size
hint.mcp_label_size = {
    { type = hint.HintTypes.normal, text = "Adjusts the vertical size of the track name label." },
}

-- MCP label orientation vertical
hint.mcp_label_orientation_vertical = {
    { type = hint.HintTypes.normal, text = "Rotates the label text for a vertical orientation." },
    { type = hint.HintTypes.tip,    text = "Recommended for narrow channel strips." },
}

-- MCP label index in label
hint.mcp_label_index_in_label = {
    { type = hint.HintTypes.normal, text = "Shows the track index number inside the name label." },
}

-- MCP label index separate
hint.mcp_label_index_separate = {
    { type = hint.HintTypes.normal, text = "Shows the track index number above the label block, below the fader section." },
}

-- MCP inserts placement top
hint.mcp_inserts_placement_top = {
    { type = hint.HintTypes.normal, text = "Shows the inserts section at the top of the track." },
}

-- MCP inserts placement sidebar
hint.mcp_inserts_placement_side = {
    { type = hint.HintTypes.normal, text = "Shows the inserts section at the side of the track." },
}

-- MCP inserts placement embed
hint.mcp_inserts_placement_embed = {
    { type = hint.HintTypes.normal, text = "Shows the inserts section at the top, switching to sidebar when embedded FX exist." },
}

-- MCP inserts padding minimal
hint.mcp_inserts_padding_minimal = {
    { type = hint.HintTypes.normal,    text = "Adds minimal padding to the edges of the inserts section." },
    { type = hint.HintTypes.normal,    text = "Ignores additional padding whitespace." },
}

-- MCP inserts padding full
hint.mcp_inserts_padding_full = {
    { type = hint.HintTypes.normal,    text = "Adds padding to the edges of the inserts section." },
    { type = hint.HintTypes.normal,    text = "Includes additional padding whitespace." },
    { type = hint.HintTypes.attention, text = "Some layouts ignore this setting and fall back to minimal padding." },
}

-- MCP inserts size
hint.mcp_inserts_size = {
    { type = hint.HintTypes.normal, text = "Adjusts the size of the inserts section." },
}

-- MCP inserts size on embed
hint.mcp_inserts_size_on_embed = {
    { type = hint.HintTypes.normal,    text = "Adjusts size of inserts for tracks with embedded FX." },
    { type = hint.HintTypes.attention, text = "Only affects tracks with the inserts section at the side." },
}

-- MCP button layout slim
hint.mcp_button_layout_slim = {
    { type = hint.HintTypes.highlight, text = "Slim Layout" },
    { type = hint.HintTypes.normal,    text = "1 button per row." },
    { type = hint.HintTypes.tip,       text = "Use this lyaout in order to archieve the narrowest MCP width." },
    { type = hint.HintTypes.attention, text = "Button order is hard-coded." },
}

-- MCP button layout medium
hint.mcp_button_layout_medium = {
    { type = hint.HintTypes.highlight, text = "Medium Layout" },
    { type = hint.HintTypes.normal,    text = "2 buttons per row." },
    { type = hint.HintTypes.attention, text = "Button order and line breaks are hard-coded." },
}

-- MCP button layout wide
hint.mcp_button_layout_wide = {
    { type = hint.HintTypes.highlight, text = "Wide Layout" },
    { type = hint.HintTypes.normal,    text = "4 buttons per row." },
    { type = hint.HintTypes.attention, text = "Button order and line breaks are hard-coded." },
}

-- MCP button recinput size
hint.mcp_button_recinput_size = {
    { type = hint.HintTypes.normal,    text = "Adjusts the size of the Input Selector." },
    { type = hint.HintTypes.attention, text = "Requires Slim Layout to be active." },
}

-- MCP master menu button
hint.mcp_master_menu_button = {
    { type = hint.HintTypes.normal, text = "Adjusts the height of the master track menu button." },
}

--      Infobar
-- --------------------------------------

-- bank slot select
hint.bank_slot_select = {
    { type = hint.HintTypes.normal, text = "Sets the active slot in the Bank System." },
    { type = hint.HintTypes.tip,    text = "Use the [+] buttons to enable bank support for the respective parameter." },
    { type = hint.HintTypes.tip,    text = "Bank slots can also be selected via Theme Adjuster, optional transport buttons or custom paRt scripts." },
}

-- bank copy mode
hint.bank_copy_mode = {
    { type = hint.HintTypes.highlight, text = "Bank Copy Mode" },
    { type = hint.HintTypes.normal,    text = "Copies the settings of the currently selected bank to other banks, overwriting their data." },
    { type = hint.HintTypes.tip,       text = "How to use:" },
    { type = hint.HintTypes.tip,       text = "1. Activate copy mode" },
    { type = hint.HintTypes.tip,       text = "2. Select target banks" },
    { type = hint.HintTypes.tip,       text = "3. Press the Copy Bank button to confirm" },
    { type = hint.HintTypes.warning,   text = "This will irreversibly overwrite data." },
}

-- config slot select
hint.config_slot_select = {
    { type = hint.HintTypes.normal, text = "Selects the active configuration slot." },
    { type = hint.HintTypes.normal, text = "Each configuration slot can store a complete configuration of the Theme Adjuster." },
}

-- config slot save
hint.config_slot_save = {
    { type = hint.HintTypes.normal, text = "Saves all Theme Adjuster settings to the current configuration slot." },
}

hint.config_slot_load = {
    { type = hint.HintTypes.normal,    text = "Loads all Theme Adjuster settings from the current configuration slot." },
    { type = hint.HintTypes.attention, text = "If the slot is empty, the Theme Adjuster will fall back to a pre-defined default configuration." },
}

-- config save to file
hint.config_save_to_file = {
    { type = hint.HintTypes.normal,    text = "Saves all Theme Adjuster settings to a file." },
    { type = hint.HintTypes.normal,    text = "The file can be selected via your OS file browser." },
    hint.line_requirement_rejs
}

-- config load from file
hint.config_load_from_file = {
    { type = hint.HintTypes.normal,    text = "Loads all Theme Adjuster settings from a file." },
    { type = hint.HintTypes.normal,    text = "The file can be selected via your OS file browser." },
    hint.line_requirement_rejs
}

-- config load default
hint.config_load_default = {
    { type = hint.HintTypes.normal,    text = "Loads an optimized default configuration." },
    { type = hint.HintTypes.attention, text = "Requires pressing the button twice as a safety measure." },
    { type = hint.HintTypes.warning,   text = "This will irreversibly overwrite data." },
}

-- config hard reset
hint.config_hard_reset = {
    { type = hint.HintTypes.normal,    text = "Resets all parameters to their hard-coded default values." },
    { type = hint.HintTypes.attention, text = "Requires pressing the button twice as a safety measure." },
    { type = hint.HintTypes.warning,   text = "This will irreversibly overwrite data." },
}

--      Custom
-- --------------------------------------

-- custom range
hint.custom_range = {
    { type = hint.HintTypes.normal, text = "A custom adjustment reserved for theme modding." },
}

-- custom button
hint.custom_button = {
    { type = hint.HintTypes.normal, text = "A custom button for reserved theme modding." },
}

-- custom selection
hint.custom_selection = {
    { type = hint.HintTypes.normal, text = "A custom multiple-choice set reserved for theme modding." },
}

return hint
