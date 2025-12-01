-- @version 1.2.3
-- @author Fleeesch
-- @description paRt Theme Adjuster
-- @noIndex

--[[
    The inclusion of WALTER parameters is happening here.
    It is mostly a 1:1 translation list for the parameters in the rtconfig.txt file,
    but sometimes there are exceptions that require a specific treatment.
]]--

local par = {}

-- ==========================================================================================
--                      Parameter Mapping
-- ==========================================================================================

--      Colors
-- -------------------------------------------

-- color adjustments
par.par_global_color_hue = Part.Parameter.Theme.ThemeParameter:new(nil, "hue", true)
par.par_global_color_saturation = Part.Parameter.Theme.ThemeParameter:new(nil, "saturation", true)
par.par_global_color_gamma = Part.Parameter.Theme.ThemeParameter:new(nil, "gamma", true)
par.par_global_color_highlights = Part.Parameter.Theme.ThemeParameter:new(nil, "highlights", true)
par.par_global_color_midtones = Part.Parameter.Theme.ThemeParameter:new(nil, "midtones", true)
par.par_global_color_shadows = Part.Parameter.Theme.ThemeParameter:new(nil, "shadows", true)
par.par_global_color_gamma:rescale(1400, 600)
par.par_global_color_highlights:rescale(-75, 75)
par.par_global_color_midtones:rescale(-75, 75)
par.par_global_color_shadows:rescale(-75, 75)
par.par_global_color_custom_overwrite = Part.Parameter.Theme.ThemeParameter:new(nil, "custom_color_mod", false)

-- track background
par.par_colors_track_track_bg_tone = { Part.Parameter.Group.ParameterGroup:new(nil, "par_colors_track_track_bg_tone") }
par.par_colors_track_track_bg_tint = { Part.Parameter.Group.ParameterGroup:new(nil, "par_colors_track_track_bg_tint") }
par.par_colors_track_track_bg_select_tone = { Part.Parameter.Group.ParameterGroup:new(nil, "par_colors_track_track_bg_select_tone") }
par.par_colors_track_track_bg_select_tint = { Part.Parameter.Group.ParameterGroup:new(nil, "par_colors_track_track_bg_select_tint") }

-- track label
par.par_colors_track_track_label_bg_tone = { Part.Parameter.Group.ParameterGroup:new(nil, "par_colors_track_track_label_bg_tone") }
par.par_colors_track_track_label_bg_tint = { Part.Parameter.Group.ParameterGroup:new(nil, "par_colors_track_track_label_bg_tint") }
par.par_colors_track_track_label_text_tone = { Part.Parameter.Group.ParameterGroup:new(nil, "par_colors_track_track_label_text_tone") }
par.par_colors_track_track_index_tone_tcp = { Part.Parameter.Group.ParameterGroup:new(nil, "par_colors_track_track_index_tone_tcp") }
par.par_colors_track_track_index_tone_mcp = { Part.Parameter.Group.ParameterGroup:new(nil, "par_colors_track_track_index_tone_mcp") }
par.par_colors_track_track_label_select_tone = { Part.Parameter.Group.ParameterGroup:new(nil, "par_colors_track_track_label_select_tone") }
par.par_colors_track_track_label_select_tint = { Part.Parameter.Group.ParameterGroup:new(nil, "par_colors_track_track_label_select_tint") }

-- envcp
par.par_colors_track_envcp_bg_tone = { Part.Parameter.Group.ParameterGroup:new(nil, "par_colors_track_envcp_bg_tone") }
par.par_colors_track_envcp_bg_tint = { Part.Parameter.Group.ParameterGroup:new(nil, "par_colors_track_envcp_bg_tint") }
par.par_colors_track_envcp_label_bg_Tone = { Part.Parameter.Group.ParameterGroup:new(nil, "par_colors_track_envcp_label_bg_Tone") }
par.par_colors_track_envcp_label_bg_tint = { Part.Parameter.Group.ParameterGroup:new(nil, "par_colors_track_envcp_label_bg_tint") }
par.par_colors_track_envcp_label_text_tone = { Part.Parameter.Group.ParameterGroup:new(nil, "par_colors_track_envcp_label_text_tone") }
par.par_colors_track_envcp_label_readout_tone = { Part.Parameter.Group.ParameterGroup:new(nil, "par_colors_track_envcp_label_readout_tone") }

-- folder
par.par_colors_track_folder_foldertrack_tone = { Part.Parameter.Group.ParameterGroup:new(nil, "par_colors_track_folder_foldertrack_tone") }
par.par_colors_track_folder_foldertrack_tint = { Part.Parameter.Group.ParameterGroup:new(nil, "par_colors_track_folder_foldertrack_tint") }
par.par_colors_track_folder_foldertree_tone = { Part.Parameter.Group.ParameterGroup:new(nil, "par_colors_track_folder_foldertree_tone") }
par.par_colors_track_folder_foldertree_tint = { Part.Parameter.Group.ParameterGroup:new(nil, "par_colors_track_folder_foldertree_tint") }

-- meter
par.par_colors_track_meter_text_tone_unlit = { Part.Parameter.Group.ParameterGroup:new(nil, "par_colors_track_meter_text_tone_unlit") }
par.par_colors_track_meter_text_tone_lit = { Part.Parameter.Group.ParameterGroup:new(nil, "par_colors_track_meter_text_tone_lit") }
par.par_colors_track_meter_text_tone_readout = { Part.Parameter.Group.ParameterGroup:new(nil, "par_colors_track_meter_text_tone_readout") }
par.par_colors_track_meter_text_tone_readout_clip = { Part.Parameter.Group.ParameterGroup:new(nil, "par_colors_track_meter_text_tone_readout_clip") }
par.par_colors_track_meter_text_shadow_lit = { Part.Parameter.Group.ParameterGroup:new(nil, "par_colors_track_meter_text_shadow_lit") }
par.par_colors_track_meter_text_shadow_unlit = { Part.Parameter.Group.ParameterGroup:new(nil, "par_colors_track_meter_text_shadow_unlit") }
par.par_colors_track_meter_text_alpha_tcp = { Part.Parameter.Group.ParameterGroup:new(nil, "par_colors_track_meter_text_alpha_tcp") }
par.par_colors_track_meter_text_alpha_mcp = { Part.Parameter.Group.ParameterGroup:new(nil, "par_colors_track_meter_text_alpha_mcp") }

-- colorbar
par.par_colors_track_track_colorbar_intensity = { Part.Parameter.Group.ParameterGroup:new(nil, "par_colors_track_track_colorbar_intensity") }

--      Transport
-- -------------------------------------------

-- settings
par.par_trans_settings_extrapad_x = { Part.Parameter.Group.ParameterGroup:new(nil, "par_trans_settings_extrapad_x") }
par.par_trans_settings_extrapad_y = { Part.Parameter.Group.ParameterGroup:new(nil, "par_trans_settings_extrapad_y") }

par.par_trans_settings_theme_menu = Part.Parameter.Theme.ThemeParameter:new(nil, "par_trans_settings_theme_menu")
par.par_trans_settings_theme_menu:storeInSettings()
par.par_trans_settings_theme_bank = Part.Parameter.Theme.ThemeParameter:new(nil, "par_trans_settings_theme_bank")
par.par_trans_settings_theme_bank:storeInSettings()

-- visibility
par.par_trans_element_vis = { Part.Parameter.Group.ParameterGroup:new(nil, "par_trans_element_vis") }
par.par_trans_element_separator = { Part.Parameter.Group.ParameterGroup:new(nil, "par_trans_element_separator") }

-- adjustments
par.par_trans_element_adj_selection_size = { Part.Parameter.Group.ParameterGroup:new(nil, "par_trans_element_adj_selection_size") }
par.par_trans_element_adj_selection_size_scale = { Part.Parameter.Group.ParameterGroup:new(nil, "par_trans_element_adj_selection_size_scale", nil, par.par_trans_element_adj_selection_size[3]) }
par.par_trans_element_adj_status_size = { Part.Parameter.Group.ParameterGroup:new(nil, "par_trans_element_adj_status_size") }
par.par_trans_element_adj_status_size_scale = { Part.Parameter.Group.ParameterGroup:new(nil, "par_trans_element_adj_status_size_scale", nil, par.par_trans_element_adj_status_size[3]) }
par.par_trans_element_adj_spacing_x = { Part.Parameter.Group.ParameterGroup:new(nil, "par_trans_element_adj_spacing_x") }
par.par_trans_element_adj_spacing_time_x = { Part.Parameter.Group.ParameterGroup:new(nil, "par_trans_element_adj_spacing_time_x") }
par.par_trans_element_adj_spacing_section_x = { Part.Parameter.Group.ParameterGroup:new(nil, "par_trans_element_adj_spacing_section_x") }
par.par_trans_element_adj_separator_size = { Part.Parameter.Group.ParameterGroup:new(nil, "par_trans_element_adj_separator_size") }

par.par_trans_element_adj_bpm_tap = { Part.Parameter.Group.ParameterGroup:new(nil, "par_trans_element_adj_bpm_tap") }

-- playrate
par.par_trans_playrate_mode = { Part.Parameter.Group.ParameterGroup:new(nil, "par_trans_playrate_mode") }
par.par_trans_playrate_size = { Part.Parameter.Group.ParameterGroup:new(nil, "par_trans_playrate_size") }


--      TCP
-- -------------------------------------------

-- spacing
par.par_tcp_gen_element_adj_spacing_x = { Part.Parameter.Group.ParameterGroup:new(nil, "par_tcp_gen_element_adj_spacing_x") }
par.par_tcp_gen_element_adj_spacing_y = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_tcp_gen_element_adj_spacing_y") }
par.par_tcp_gen_element_adj_spacing_x_fader = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_tcp_gen_element_adj_spacing_x_fader") }
par.par_tcp_gen_element_adj_spacing_y_fader = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_tcp_gen_element_adj_spacing_y_fader") }
par.par_tcp_gen_element_adj_spacing_section_x = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_tcp_gen_element_adj_spacing_section_x") }
par.par_tcp_gen_element_adj_spacing_section_y = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_tcp_gen_element_adj_spacing_section_y") }
par.par_tcp_gen_element_adj_separator = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_tcp_gen_element_adj_separator") }
par.par_tcp_gen_element_adj_separator_line = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_tcp_gen_element_adj_separator_line", nil, par.par_tcp_gen_element_adj_separator[3]) }

-- highlight
par.par_tcp_gen_highlight_selection = { Part.Parameter.Group.ParameterGroup:new(nil, "par_tcp_gen_highlight_selection") }
par.par_tcp_gen_highlight_color = { Part.Parameter.Group.ParameterGroup:new(nil, "par_tcp_gen_highlight_color") }

-- folder
par.par_tcp_gen_folder_indent = { Part.Parameter.Group.ParameterGroup:new(nil, "par_tcp_gen_folder_indent") }
par.par_tcp_gen_folder_icon_collapse = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_tcp_gen_folder_icon_collapse") }
par.par_tcp_gen_folder_icon_mode = { Part.Parameter.Group.ParameterGroup:new(nil, "par_tcp_gen_folder_icon_mode") }

-- inserts
par.par_tcp_gen_insert_slot_width = { Part.Parameter.Group.ParameterGroup:new(nil, "par_tcp_gen_insert_slot_width") }

-- track

-- element adjustments
par.par_tcp_track_element_adj_size_env = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_tcp_track_element_adj_size_env") }
par.par_tcp_track_element_adj_size_input = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_tcp_track_element_adj_size_input") }
par.par_tcp_track_element_adj_wrap_buttons = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_tcp_track_element_adj_wrap_buttons") }

-- element visibility
par.par_tcp_track_element_vis = { Part.Parameter.Group.ParameterGroup:new(nil, "par_tcp_track_element_vis") }
par.par_tcp_track_element_vis_mixer = { Part.Parameter.Group.ParameterGroup:new(nil, "par_tcp_track_element_vis_mixer") }
par.par_tcp_track_element_separator = { Part.Parameter.Group.ParameterGroup:new(nil, "par_tcp_track_element_separator") }

-- faders
par.par_tcp_track_fader_vol_vis = { Part.Parameter.Group.ParameterGroup:new(nil, "par_tcp_track_fader_vol_vis") }
par.par_tcp_track_fader_pan_vis = { Part.Parameter.Group.ParameterGroup:new(nil, "par_tcp_track_fader_pan_vis") }
par.par_tcp_track_fader_wid_vis = { Part.Parameter.Group.ParameterGroup:new(nil, "par_tcp_track_fader_wid_vis") }
par.par_tcp_track_fader_vol_vis_mixer = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_tcp_track_fader_vol_vis_mixer", nil, par.par_tcp_track_fader_vol_vis[3]) }
par.par_tcp_track_fader_pan_vis_mixer = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_tcp_track_fader_pan_vis_mixer", nil, par.par_tcp_track_fader_pan_vis[3]) }
par.par_tcp_track_fader_wid_vis_mixer = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_tcp_track_fader_wid_vis_mixer", nil, par.par_tcp_track_fader_wid_vis[3]) }
par.par_tcp_track_fader_vol_size = { Part.Parameter.Group.ParameterGroup:new(nil, "par_tcp_track_fader_vol_size", nil,
    par.par_tcp_track_fader_vol_vis[3]) }
par.par_tcp_track_fader_pan_size = { Part.Parameter.Group.ParameterGroup:new(nil, "par_tcp_track_fader_pan_size", nil,
    par.par_tcp_track_fader_pan_vis[3]) }
par.par_tcp_track_fader_wid_size = { Part.Parameter.Group.ParameterGroup:new(nil, "par_tcp_track_fader_wid_size", nil,
    par.par_tcp_track_fader_wid_vis[3]) }
par.par_tcp_track_fader_vol_size_scale = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_tcp_track_fader_vol_size_scale", nil, par.par_tcp_track_fader_vol_vis[3]) }
par.par_tcp_track_fader_pan_size_scale = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_tcp_track_fader_pan_size_scale", nil, par.par_tcp_track_fader_pan_vis[3]) }
par.par_tcp_track_fader_wid_size_scale = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_tcp_track_fader_wid_size_scale", nil, par.par_tcp_track_fader_wid_vis[3]) }
par.par_tcp_track_fader_placement = { Part.Parameter.Group.ParameterGroup:new(nil, "par_tcp_track_fader_placement") }

-- inserts
par.par_tcp_track_insert_mode = { Part.Parameter.Group.ParameterGroup:new(nil, "par_tcp_track_insert_mode") }
par.par_tcp_track_insert_size = { Part.Parameter.Group.ParameterGroup:new(nil, "par_tcp_track_insert_size") }
par.par_tcp_track_insert_size_scale = { Part.Parameter.Group.ParameterGroup:new(nil, "par_tcp_track_insert_size_scale",
    nil, par.par_tcp_track_insert_size[3]) }

-- meter
par.par_tcp_track_meter_mode = { Part.Parameter.Group.ParameterGroup:new(nil, "par_tcp_track_meter_mode") }
par.par_tcp_track_meter_vu_db = { Part.Parameter.Group.ParameterGroup:new(nil, "par_tcp_track_meter_vu_db") }
par.par_tcp_track_meter_vu_readout = { Part.Parameter.Group.ParameterGroup:new(nil, "par_tcp_track_meter_vu_readout") }
par.par_tcp_track_meter_size = { Part.Parameter.Group.ParameterGroup:new(nil, "par_tcp_track_meter_size") }
par.par_tcp_track_meter_size_scale = { Part.Parameter.Group.ParameterGroup:new(nil, "par_tcp_track_meter_size_scale",
    nil, par.par_tcp_track_meter_size[3]) }
par.par_tcp_track_meter_vol_readout = { Part.Parameter.Group.ParameterGroup:new(nil, "par_tcp_track_meter_vol_readout") }

par.par_tcp_track_meter_channeldiv = { Part.Parameter.Group.ParameterGroup:new(nil, "par_tcp_track_meter_channeldiv") }

-- label
par.par_tcp_track_label_size = { Part.Parameter.Group.ParameterGroup:new(nil, "par_tcp_track_label_size") }
par.par_tcp_track_label_index_vis = { Part.Parameter.Group.ParameterGroup:new(nil, "par_tcp_track_label_index_vis") }

-- envcp

par.par_tcp_envcp_element_vis = { Part.Parameter.Group.ParameterGroup:new(nil, "par_tcp_envcp_element_vis") }
par.par_tcp_envcp_element_separator = { Part.Parameter.Group.ParameterGroup:new(nil, "par_tcp_envcp_element_separator") }
par.par_tcp_envcp_element_adj_wrap_buttons = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_tcp_envcp_element_adj_wrap_buttons") }

par.par_tcp_envcp_settings_symbol = { Part.Parameter.Group.ParameterGroup:new(nil, "par_tcp_envcp_settings_symbol") }
par.par_tcp_envcp_settings_indent = { Part.Parameter.Group.ParameterGroup:new(nil, "par_tcp_envcp_settings_indent") }
par.par_tcp_envcp_settings_lane_display = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_tcp_envcp_settings_lane_display") }

par.par_tcp_envcp_label_size = { Part.Parameter.Group.ParameterGroup:new(nil, "par_tcp_envcp_label_size") }
par.par_tcp_envcp_label_readout_placement = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_tcp_envcp_label_readout_placement") }
par.par_tcp_envcp_label_readout_size = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_tcp_envcp_label_readout_size") }
par.par_tcp_envcp_label_readout_size_scale = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_tcp_envcp_label_readout_size_scale", nil, par.par_tcp_envcp_label_readout_size[3]) }

par.par_tcp_envcp_value_mode = { Part.Parameter.Group.ParameterGroup:new(nil, "par_tcp_envcp_value_mode") }
par.par_tcp_envcp_value_vertical = { Part.Parameter.Group.ParameterGroup:new(nil, "par_tcp_envcp_value_vertical") }
par.par_tcp_envcp_value_size = { Part.Parameter.Group.ParameterGroup:new(nil, "par_tcp_envcp_value_size") }
par.par_tcp_envcp_value_scale = { Part.Parameter.Group.ParameterGroup:new(nil, "par_tcp_envcp_value_scale", nil,
    par.par_tcp_envcp_value_size[3]) }

-- master

par.par_tcp_master_element_adj_size_env = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_tcp_master_element_adj_size_env") }
par.par_tcp_master_element_adj_size_fx = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_tcp_master_element_adj_size_fx") }
par.par_tcp_master_element_adj_wrap_buttons = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_tcp_master_element_adj_wrap_buttons") }

par.par_tcp_master_meter_mode = { Part.Parameter.Group.ParameterGroup:new(nil, "par_tcp_master_meter_mode") }
par.par_tcp_master_meter_vu_db = { Part.Parameter.Group.ParameterGroup:new(nil, "par_tcp_master_meter_vu_db") }
par.par_tcp_master_meter_vu_readout = { Part.Parameter.Group.ParameterGroup:new(nil, "par_tcp_master_meter_vu_readout") }
par.par_tcp_master_meter_size = { Part.Parameter.Group.ParameterGroup:new(nil, "par_tcp_master_meter_size") }
par.par_tcp_master_meter_size_scale = { Part.Parameter.Group.ParameterGroup:new(nil, "par_tcp_master_meter_size_scale") }
par.par_tcp_master_meter_vol_readout = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_tcp_master_meter_vol_readout") }

par.par_tcp_master_meter_channeldiv = { Part.Parameter.Group.ParameterGroup:new(nil, "par_tcp_master_meter_channeldiv") }

par.par_tcp_master_fader_vol_vis = { Part.Parameter.Group.ParameterGroup:new(nil, "par_tcp_master_fader_vol_vis") }
par.par_tcp_master_fader_pan_vis = { Part.Parameter.Group.ParameterGroup:new(nil, "par_tcp_master_fader_pan_vis") }
par.par_tcp_master_fader_wid_vis = { Part.Parameter.Group.ParameterGroup:new(nil, "par_tcp_master_fader_wid_vis") }
par.par_tcp_master_fader_vol_size = { Part.Parameter.Group.ParameterGroup:new(nil, "par_tcp_master_fader_vol_size", nil,
    par.par_tcp_master_fader_vol_vis[3]) }
par.par_tcp_master_fader_pan_size = { Part.Parameter.Group.ParameterGroup:new(nil, "par_tcp_master_fader_pan_size", nil,
    par.par_tcp_master_fader_pan_vis[3]) }
par.par_tcp_master_fader_wid_size = { Part.Parameter.Group.ParameterGroup:new(nil, "par_tcp_master_fader_wid_size", nil,
    par.par_tcp_master_fader_wid_vis[3]) }
par.par_tcp_master_fader_vol_size_scale = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_tcp_master_fader_vol_size_scale", nil, par.par_tcp_master_fader_vol_vis[3]) }
par.par_tcp_master_fader_pan_size_scale = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_tcp_master_fader_pan_size_scale", nil, par.par_tcp_master_fader_pan_vis[3]) }
par.par_tcp_master_fader_wid_size_scale = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_tcp_master_fader_wid_size_scale", nil, par.par_tcp_master_fader_wid_vis[3]) }
par.par_tcp_master_fader_placement = { Part.Parameter.Group.ParameterGroup:new(nil, "par_tcp_master_fader_placement") }

par.par_tcp_master_insert_size = { Part.Parameter.Group.ParameterGroup:new(nil, "par_tcp_master_insert_size") }
par.par_tcp_master_insert_size_scale = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_tcp_master_insert_size_scale") }
par.par_tcp_master_insert_mode = { Part.Parameter.Group.ParameterGroup:new(nil, "par_tcp_master_insert_mode") }

par.par_tcp_master_element_vis = { Part.Parameter.Group.ParameterGroup:new(nil, "par_tcp_master_element_vis") }
par.par_tcp_master_element_separator = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_tcp_master_element_separator") }




--      MCP
-- -------------------------------------------

-- highlights
par.par_mcp_gen_highlight_selection = { Part.Parameter.Group.ParameterGroup:new(nil, "par_mcp_gen_highlight_selection") }
par.par_mcp_gen_highlight_color = { Part.Parameter.Group.ParameterGroup:new(nil, "par_mcp_gen_highlight_color") }

-- spacing
par.par_mcp_gen_element_adj_spacing_x = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_mcp_gen_element_adj_spacing_x") }
par.par_mcp_gen_element_adj_spacing_y = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_mcp_gen_element_adj_spacing_y") }
par.par_mcp_gen_element_adj_spacing_fader_x = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_mcp_gen_element_adj_spacing_fader_x") }
par.par_mcp_gen_element_adj_spacing_fader_y = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_mcp_gen_element_adj_spacing_fader_y") }
par.par_mcp_gen_element_adj_spacing_section_x = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_mcp_gen_element_adj_spacing_section_x") }
par.par_mcp_gen_element_adj_spacing_section_y = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_mcp_gen_element_adj_spacing_section_y") }
par.par_mcp_gen_element_adj_separator = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_mcp_gen_element_adj_separator") }
par.par_mcp_gen_element_adj_separator_line = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_mcp_gen_element_adj_separator_line", nil, par.par_mcp_gen_element_adj_separator[3]) }

par.par_mcp_gen_folder_indent = { Part.Parameter.Group.ParameterGroup:new(nil, "par_mcp_gen_folder_indent") }
par.par_mcp_gen_folder_pad_folder_parent = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_mcp_gen_folder_pad_folder_parent") }
par.par_mcp_gen_folder_pad_folder_last = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_mcp_gen_folder_pad_folder_last") }
par.par_mcp_gen_folder_icon_folder = { Part.Parameter.Group.ParameterGroup:new(nil, "par_mcp_gen_folder_icon_folder") }
par.par_mcp_gen_folder_icon_last = { Part.Parameter.Group.ParameterGroup:new(nil, "par_mcp_gen_folder_icon_last") }


-- settings
par.par_mcp_track_settings_extrapad = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_mcp_track_settings_extrapad") }
par.par_mcp_track_settings_label_size = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_mcp_track_settings_label_size") }
par.par_mcp_track_settings_label_vertical = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_mcp_track_settings_label_vertical") }
par.par_mcp_track_settings_label_index = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_mcp_track_settings_label_index") }

-- inserts
par.par_mcp_track_insert_mode = { Part.Parameter.Group.ParameterGroup:new(nil, "par_mcp_track_insert_mode") }
par.par_mcp_track_insert_size = { Part.Parameter.Group.ParameterGroup:new(nil, "par_mcp_track_insert_size") }
par.par_mcp_track_insert_size_embed = { Part.Parameter.Group.ParameterGroup:new(nil, "par_mcp_track_insert_size_embed") }
par.par_mcp_track_insert_size_scale = { Part.Parameter.Group.ParameterGroup:new(nil, "par_mcp_track_insert_size_scale",
    nil, par.par_mcp_track_insert_size[3]) }
par.par_mcp_track_insert_pad = { Part.Parameter.Group.ParameterGroup:new(nil, "par_mcp_track_insert_pad") }

-- meter
par.par_mcp_track_meter_padding = { Part.Parameter.Group.ParameterGroup:new(nil, "par_mcp_track_meter_padding") }
par.par_mcp_track_meter_pos = { Part.Parameter.Group.ParameterGroup:new(nil, "par_mcp_track_meter_pos") }
par.par_mcp_track_meter_vol_readout = { Part.Parameter.Group.ParameterGroup:new(nil, "par_mcp_track_meter_vol_readout") }
par.par_mcp_track_meter_vu_db = { Part.Parameter.Group.ParameterGroup:new(nil, "par_mcp_track_meter_vu_db") }
par.par_mcp_track_meter_vu_readout = { Part.Parameter.Group.ParameterGroup:new(nil, "par_mcp_track_meter_vu_readout") }
par.par_mcp_track_meter_size = { Part.Parameter.Group.ParameterGroup:new(nil, "par_mcp_track_meter_size") }
par.par_mcp_track_meter_size_scale = { Part.Parameter.Group.ParameterGroup:new(nil, "par_mcp_track_meter_size_scale",
    nil, par.par_mcp_track_meter_size[3]) }
par.par_mcp_track_meter_expand = { Part.Parameter.Group.ParameterGroup:new(nil, "par_mcp_track_meter_expand") }
par.par_mcp_track_meter_expand_mode = { Part.Parameter.Group.ParameterGroup:new(nil, "par_mcp_track_meter_expand_mode") }
par.par_mcp_track_meter_expand_threshold = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_mcp_track_meter_expand_threshold") }
par.par_mcp_track_meter_channeldiv = { Part.Parameter.Group.ParameterGroup:new(nil, "par_mcp_track_meter_channeldiv") }

-- elements
par.par_mcp_track_element_vis = { Part.Parameter.Group.ParameterGroup:new(nil, "par_mcp_track_element_vis") }
par.par_mcp_track_element_separator = { Part.Parameter.Group.ParameterGroup:new(nil, "par_mcp_track_element_separator") }
par.par_mcp_track_element_width = { Part.Parameter.Group.ParameterGroup:new(nil, "par_mcp_track_element_width") }
par.par_mcp_track_element_input_size = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_mcp_track_element_input_size") }

-- faders
par.par_mcp_track_fader_layout = { Part.Parameter.Group.ParameterGroup:new(nil, "par_mcp_track_fader_layout") }
par.par_mcp_track_fader_pan_mode_mono = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_mcp_track_fader_pan_mode_mono") }
par.par_mcp_track_fader_pan_mode_stereo = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_mcp_track_fader_pan_mode_stereo", nil, par.par_mcp_track_fader_pan_mode_mono[3]) }
par.par_mcp_track_fader_pan_mode_dual = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_mcp_track_fader_pan_mode_dual", nil, par.par_mcp_track_fader_pan_mode_mono[3]) }
par.par_mcp_track_fader_pan_width = { Part.Parameter.Group.ParameterGroup:new(nil, "par_mcp_track_fader_pan_width") }
par.par_mcp_track_fader_pan_height = { Part.Parameter.Group.ParameterGroup:new(nil, "par_mcp_track_fader_pan_height") }
par.par_mcp_track_fader_pan_height_scale = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_mcp_track_fader_pan_height_scale", nil, par.par_mcp_track_fader_pan_height[3]) }
par.par_mcp_track_fader_wid_always = { Part.Parameter.Group.ParameterGroup:new(nil, "par_mcp_track_fader_wid_always") }

-- master

par.par_mcp_master_settings_extrapad = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_mcp_master_settings_extrapad") }
par.par_mcp_master_settings_label_size = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_mcp_master_settings_label_size") }

par.par_mcp_master_insert_mode = { Part.Parameter.Group.ParameterGroup:new(nil, "par_mcp_master_insert_mode") }
par.par_mcp_master_insert_size = { Part.Parameter.Group.ParameterGroup:new(nil, "par_mcp_master_insert_size") }
par.par_mcp_master_insert_size_scale = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_mcp_master_insert_size_scale", nil, par.par_mcp_master_insert_size[3]) }
par.par_mcp_master_insert_pad = { Part.Parameter.Group.ParameterGroup:new(nil, "par_mcp_master_insert_pad") }

par.par_mcp_master_meter_padding = { Part.Parameter.Group.ParameterGroup:new(nil, "par_mcp_master_meter_padding") }
par.par_mcp_master_meter_pos = { Part.Parameter.Group.ParameterGroup:new(nil, "par_mcp_master_meter_pos") }
par.par_mcp_master_meter_vol_readout = { Part.Parameter.Group.ParameterGroup:new(nil, "par_mcp_master_meter_vol_readout") }
par.par_mcp_master_meter_vu_db = { Part.Parameter.Group.ParameterGroup:new(nil, "par_mcp_master_meter_vu_db") }
par.par_mcp_master_meter_vu_readout = { Part.Parameter.Group.ParameterGroup:new(nil, "par_mcp_master_meter_vu_readout") }
par.par_mcp_master_meter_size = { Part.Parameter.Group.ParameterGroup:new(nil, "par_mcp_master_meter_size") }
par.par_mcp_master_meter_size_scale = { Part.Parameter.Group.ParameterGroup:new(nil, "par_mcp_master_meter_size_scale",
    nil, par.par_mcp_master_meter_size[3]) }

par.par_mcp_master_element_vis = { Part.Parameter.Group.ParameterGroup:new(nil, "par_mcp_master_element_vis") }
par.par_mcp_master_element_width = { Part.Parameter.Group.ParameterGroup:new(nil, "par_mcp_master_element_width") }
par.par_mcp_master_element_separator = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_mcp_master_element_separator") }

par.par_mcp_master_meter_channeldiv = { Part.Parameter.Group.ParameterGroup:new(nil, "par_mcp_master_meter_channeldiv") }
par.par_mcp_master_meter_channeldiv_rms = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_mcp_master_meter_channeldiv_rms") }

par.par_mcp_master_fader_layout = { Part.Parameter.Group.ParameterGroup:new(nil, "par_mcp_master_fader_layout") }
par.par_mcp_master_fader_pan_mode_mono = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_mcp_master_fader_pan_mode_mono") }
par.par_mcp_master_fader_pan_mode_stereo = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_mcp_master_fader_pan_mode_stereo", nil, par.par_mcp_master_fader_pan_mode_mono[3]) }
par.par_mcp_master_fader_pan_mode_dual = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_mcp_master_fader_pan_mode_dual", nil, par.par_mcp_master_fader_pan_mode_mono[3]) }
par.par_mcp_master_fader_pan_width = { Part.Parameter.Group.ParameterGroup:new(nil, "par_mcp_master_fader_pan_width") }
par.par_mcp_master_fader_pan_height = { Part.Parameter.Group.ParameterGroup:new(nil, "par_mcp_master_fader_pan_height") }
par.par_mcp_master_fader_pan_height_scale = { Part.Parameter.Group.ParameterGroup:new(nil,
    "par_mcp_master_fader_pan_height_scale", nil, par.par_mcp_master_fader_pan_height[3]) }
par.par_mcp_master_fader_wid_always = { Part.Parameter.Group.ParameterGroup:new(nil, "par_mcp_master_fader_wid_always") }

--      User
-- -------------------------------------------

-- range
par.par_user_range_0 = { Part.Parameter.Group.ParameterGroup:new(nil, "par_user_range_0") }
par.par_user_range_1 = { Part.Parameter.Group.ParameterGroup:new(nil, "par_user_range_1") }
par.par_user_range_2 = { Part.Parameter.Group.ParameterGroup:new(nil, "par_user_range_2") }
par.par_user_range_3 = { Part.Parameter.Group.ParameterGroup:new(nil, "par_user_range_3") }
par.par_user_range_4 = { Part.Parameter.Group.ParameterGroup:new(nil, "par_user_range_4") }
par.par_user_range_5 = { Part.Parameter.Group.ParameterGroup:new(nil, "par_user_range_5") }
par.par_user_range_6 = { Part.Parameter.Group.ParameterGroup:new(nil, "par_user_range_6") }
par.par_user_range_7 = { Part.Parameter.Group.ParameterGroup:new(nil, "par_user_range_7") }
par.par_user_range_8 = { Part.Parameter.Group.ParameterGroup:new(nil, "par_user_range_8") }
par.par_user_range_9 = { Part.Parameter.Group.ParameterGroup:new(nil, "par_user_range_9") }
par.par_user_range_10 = { Part.Parameter.Group.ParameterGroup:new(nil, "par_user_range_10") }
par.par_user_range_11 = { Part.Parameter.Group.ParameterGroup:new(nil, "par_user_range_11") }
par.par_user_range_12 = { Part.Parameter.Group.ParameterGroup:new(nil, "par_user_range_12") }
par.par_user_range_13 = { Part.Parameter.Group.ParameterGroup:new(nil, "par_user_range_13") }
par.par_user_range_14 = { Part.Parameter.Group.ParameterGroup:new(nil, "par_user_range_14") }
par.par_user_range_15 = { Part.Parameter.Group.ParameterGroup:new(nil, "par_user_range_15") }

-- selection
par.par_user_selection_0 = { Part.Parameter.Group.ParameterGroup:new(nil, "par_user_selection_0") }
par.par_user_selection_1 = { Part.Parameter.Group.ParameterGroup:new(nil, "par_user_selection_1") }
par.par_user_selection_2 = { Part.Parameter.Group.ParameterGroup:new(nil, "par_user_selection_2") }
par.par_user_selection_3 = { Part.Parameter.Group.ParameterGroup:new(nil, "par_user_selection_3") }
par.par_user_selection_4 = { Part.Parameter.Group.ParameterGroup:new(nil, "par_user_selection_4") }
par.par_user_selection_5 = { Part.Parameter.Group.ParameterGroup:new(nil, "par_user_selection_5") }
par.par_user_selection_6 = { Part.Parameter.Group.ParameterGroup:new(nil, "par_user_selection_6") }
par.par_user_selection_7 = { Part.Parameter.Group.ParameterGroup:new(nil, "par_user_selection_7") }

-- switches
par.par_user_switch_0 = { Part.Parameter.Group.ParameterGroup:new(nil, "par_user_switch_0") }
par.par_user_switch_1 = { Part.Parameter.Group.ParameterGroup:new(nil, "par_user_switch_1") }
par.par_user_switch_2 = { Part.Parameter.Group.ParameterGroup:new(nil, "par_user_switch_2") }
par.par_user_switch_3 = { Part.Parameter.Group.ParameterGroup:new(nil, "par_user_switch_3") }
par.par_user_switch_4 = { Part.Parameter.Group.ParameterGroup:new(nil, "par_user_switch_4") }
par.par_user_switch_5 = { Part.Parameter.Group.ParameterGroup:new(nil, "par_user_switch_5") }
par.par_user_switch_6 = { Part.Parameter.Group.ParameterGroup:new(nil, "par_user_switch_6") }
par.par_user_switch_7 = { Part.Parameter.Group.ParameterGroup:new(nil, "par_user_switch_7") }


return par
