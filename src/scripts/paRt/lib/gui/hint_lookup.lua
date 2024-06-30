local gui = {}

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Hint Lookup
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

gui.HintMessages = {}

-- color
gui.HintMessages.color_schemes = "Switch between different [paRt|color|schemes]"
gui.HintMessages.color_adjust =
"[Reaper's] integrated color adjustments. \\n These settings are [excluded] from [banking] and saved individually for every theme file instead."

gui.HintMessages.color_folders_singlefolder = "Color variation for tracks that are folders."
gui.HintMessages.color_folders_colorize = "Colorize folders dynamically based on their depth."

gui.HintMessages.element_spacing = "[Distance] between the individual [elements]."
gui.HintMessages.element_separator =
"[Additional|distance] between elements, set in the [visibility|matrix]. \\n The visibility of a [separator|line] can be changed using the [Line|knob]."

gui.HintMessages.element_visibility = "[Visibility] of the element."
gui.HintMessages.element_extrapad =
"[Additional|distance] between element groups. \\n The extra space is only applied if a group has [at|least] [one|visible] [element]."

gui.HintMessages.element_mixer = "[Hides] the element if the [Mixer] [is] [visible]."

gui.HintMessages.tcp_folder_buttons =
"The [Collapse|Button] toggle between folder collapse states. \\n The [State|Button] changes the folder state of a track."

gui.HintMessages.tcp_indent = "Indentation based on folder depth. \\n [Limit] uses a globally fixed indentation that is divided accross all folder levels."

gui.HintMessages.tcp_indent_shadow = "Optional [highlighting] of the current folder level."

gui.HintMessages.tcp_meter_size = "Horzontal size of the meter. \\n [Scale] will synchronize the meter size with the [TCP|width]."

gui.HintMessages.tcp_track_label_size =
"Size of the TCP name label. \\n [Scale] will synchronize the label size with the [TCP|width]."
gui.HintMessages.tcp_track_button_large =
"Large variations of various buttons. \\n The [FX|Bypass] button is only visible within the large FX button."

gui.HintMessages.tcp_track_fader_pos =
"Position of the [fader|elements] relative to the TCP buttons. \\n [2nd|Row] will show the faders on TCP height expansion."

gui.HintMessages.tcp_track_fader_size =
"Width of the TCP [fader|elements]. \\n The [dot] toggles the [visibility] of the element. \\n Setting the [size] [to] [0] will display the elements as [knobs]. \\n [Scale] will synchronize the size of the elements with the [TCP|width]."

gui.HintMessages.tcp_insert_mode =
"[Inline] will display the Insert box next to the buttons. \\n [2nd|Row] displays inserts on TCP height expansion. \\n [Embedded|FX] are only shown when the TCP height is expanded, adapting to free space."

gui.HintMessages.tcp_insert_inline_size =
"Width of the Insert block when Mode is set to [Inline]. \\n [Scale] will synchronize the Insert size with the [TCP|width]."

gui.HintMessages.envcp_label_size =
"Size of the ENVCP name label. \\n [Scale] will synchronize the label size with the [ENVCP|width]."

gui.HintMessages.envcp_value_pos =
"Position of the [value|fader] relative to the ENVCP buttons. \\n [2nd|Row] will show the fader on ENVCP height expansion."

gui.HintMessages.mcp_settings_multirow =
"Display mixer tracks across multiple rows. \\n [Compact] will always use maximum displayable Rows."

gui.HintMessages.mcp_settings_folder_features = "Bypass all folder features, limiting folder display to the TCP."

gui.HintMessages.mcp_settings_folder_icons =
"[Folder] displays a clickable icon on folder tracks for toggling the visibility of its children. \\n [Last] displays an icon in the last track of a folder."

gui.HintMessages.mcp_settings_folder_stack =
"[Stack] displays the folder hierarchy [vertically] [stacked]. \\n [Tone] Changes the folder graphics brightness according to the [folder] [level] of the track."

gui.HintMessages.mcp_settings_folder_width =
"Extend the width of folder tracks and their closing tracks. \\n [Tone] changes the brightness of the extended section."

gui.HintMessages.mcp_settings_insert_padding =
"Adds padding to the insert block. \\n [Minimal] will only insert a very small amount of padding, still keeping the insert block at maximum width. \\n [Full] includes every additional padding."

gui.HintMessages.mcp_settings_insert_elements =
"Visibility of the individual insert element types. \\n [Group] will combine the element type with the FX section. \\n [Hiding all] elements will completely disable the insert block."

gui.HintMessages.mcp_track_insert_size =
"Height of the [Insert] [block]. \\n [Scale] will synchronize the size of the insert block with the [MCP] [height]. \\n If the insert block is [prioritized] or the layout is set to [Sidebar] the height settings will be ignored."

gui.HintMessages.mcp_track_meter_size =
"Size of the [Meter]. \\n [VU|Text] will toggle the visibility of the [Meter] [text]. \\n If the meter is [prioritized] or a [layout] [won't] [permit] meter adjustments the height setting will be ignored."

gui.HintMessages.mcp_track_meter_expansion =
"Expand the meter size with track channel count. \\n [Thres] sets the [channel] [count] that will be used as the starting point for the expansion. \\n If [layout] settings [won't] [allow] meter customization the automatic [expansion] [is] [bypassed]."

gui.HintMessages.mcp_track_width_condition =
"Always show width knob, else show width knob only on tracks with [alternative] [Pan-Modes]."

gui.HintMessages.mcp_track_fader_size =
"[Size] of the [fader] [section]. \\n [Weight] adjusts the [distribution] when [multiple] [faders] are visible. \\n [Knobs] won't be affected by this setting."

gui.HintMessages.mcp_track_fader_mode =
"Appearance of the individual fader elements. \\n Depending on the [layout] preferences these settings might get [overwritten] in order to ensure usability."

gui.HintMessages.mcp_track_fader_mode_knob =
"Knob"

gui.HintMessages.mcp_track_fader_mode_vert =
"Vertical Fader. \\n Will revert to [Knob] when layout restrictions require it."

gui.HintMessages.mcp_track_fader_mode_horz =
"Horzontal Fader. \\n Will revert to [vertical|Fader] if there's not enough room."

gui.HintMessages.mcp_track_arrange_layout =
"The base [layout] for [element] [arrangement]. \\n Depending on the layout certain settings will be [overwritten] in order to maintain usability."

gui.HintMessages.mcp_track_arrange_priority =
"[Prioritizes] exactly [one] [element]. \\n The prioritized element will compensate for remaining space after all elements have been placed. \\n Individual height [settings] of prioritized elements will be [ignored]."

return gui