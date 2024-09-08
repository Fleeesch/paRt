-- @version 1.1.8-pre.2
-- @author Fleeesch
-- @description paRt Theme Adjuster
-- @noIndex
local hint = {}

-- ====================================================================================
--              Hint Lookup
-- ====================================================================================

hint.HintMessages = {}

--      Universal
-- --------------------------------------

-- visibility matrix
hint.vismatrix_visbility = "Make an element visible."
hint.vismatrix_nomixer = "Hide an element when Mixer is visible."
hint.vismatrix_separator =
"Add extra space after a group of elements. \\n Requires at least one Element of the group to be visible."

-- fader configuration
hint.fader_size =
"Size of the the Adjustment Element. \\n Turning it all the way down will force the Element to become a Knob."


--      Colors
-- --------------------------------------

hint.folder_tree = "Adjust track tone and tint dynamically based on its folder level."


--      Transport
-- --------------------------------------

hint.menu_button = "Show a button to launch the Theme Adjuster from the transport section."
hint.bank_buttons = "Show buttons to switch between paRt banks in the transport section."

--      TCP
-- --------------------------------------

-- fader
hint.tcp_fader_layout_inline = "Arrange Faders next to the buttons."
hint.tcp_fader_layout_separate = "Arrange Faders on a separate line, next to each other."
hint.tcp_fader_layout_separate_exploded = "Arrange Faders on a separate line, stacked vertically."

-- hiding spot
hint.tcp_label_size =
"Adjusts the hiding position for the buttons. \\n The label itself is always extended to the last visible element."
hint.tcp_master_size =
"Adjusts the hiding position for the buttons. \\n The meter itself is always extended to the last visible element."

-- envcp
hint.envcp_iconlane =
"Add an artifical track lane section to envelopes. \\n Only activated when Track icons  are set or the  Fixed Track Lanes feature is used."
hint.envcp_fader_placement =
"Icon Lane  is automatically set to Inline when the Track Icon Lane setting is not active."
hint.envcp_fader_size =
"Bypassed when the Track Icon Lane  is active."

--      MCP
-- --------------------------------------

-- folder
hint.mcp_folder_buttons = "Folder buttons are only shown when the current project has a folder structure."
hint.mcp_folder_padding = "Add extra space for folder tracks and the last track of a folder."

-- meter
hint.mcp_meter_position =
"[Top|Position] \\n Places the Meter below the buttons. \\n [Bottom|Position] \\n Positions the meter next to the Volume Fader. \\n [No|Position] \\n Hides the meter."
hint.mcp_meter_size =
"[Top|Position] \\n Adjusts the height of the meter. \\n [Bottom|Position] \\n Extends the width when the meter."
hint.mcp_meter_expand =
'Increments the meter width by track channel count. \\n [Fix] \\n Extends the width only by a fixed amount when a given channel count is reached.'
hint.mcp_meter_expand_threshold = "The amound of track channels needed for the Expand setting to kick in."

-- faders layout
hint.mcp_faders_layout_pan_top = "Separate top section for Pan / Width"
hint.mcp_faders_layout_strip = "Vertical strip"
hint.mcp_faders_layout_bottom = "Pan / Width next to Volume Fader"

-- faders panmode
hint.mcp_faders_panmode_knob = "Knobs"
hint.mcp_faders_panmode_vertical = "Vertical Faders"
hint.mcp_faders_panmode_horizontal = "Horizontal Faders"

-- faders dimensions
hint.mcp_faders_width =
"Extends the width of the Pan Section if possible."
hint.mcp_faders_height = "Adjusts the height of the Pan Section if possible."

-- extra width
hint.mcp_extra_width =
"Adds additional space to the sides of the MCP."

-- inserts
hint.mcp_insert_mode =
"[Embed] \\n activate sidebar mode only when the track has embedded FX. \\n [Nothing] \\n Hides the Insert section from the MCP."
hint.size_onembed =
"[Static|Sidebar] \\n Increases the Sidebar Width when the track has embedded FX. \\n [Conditional|Sidebar] \\n Sets the base width when the Sidebar Mode is activated."

-- button layout
hint.mcp_button_layout =
"[Slim] \\n arranges the buttons vertically in a strip formation \\n [Wide] \\n spreads the buttons accross two columns."
hint.mcp_input_size = "Button Layout must be set to Slim."


return hint
