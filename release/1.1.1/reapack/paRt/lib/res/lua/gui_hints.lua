-- @version 1.1.1
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
hint.vismatrix_visbility = "Show Element"
hint.vismatrix_nomixer = "Hide Element when Mixer is visible"
hint.vismatrix_separator =
"Add extra space after a group of Elements. \\n Requires at least one Element of the group to be visible."

-- fader configuration
hint.fader_size =
"Size of the the Adjustment Element. \\n Turning it all the way down will force the Element to become a Knob."


--      Colors
-- --------------------------------------

hint.folder_tree = "Adjust track tone and tint dynamically based on its folder|level"


--      Transport
-- --------------------------------------

hint.menu_button = "Show a button to launch the Theme Adjuster from the transport section"
hint.bank_buttons = "Show buttons to switch between paRt banks in the transport section"

--      TCP
-- --------------------------------------

-- fader
hint.tcp_fader_layout_inline = "Arrange Faders next to the buttons"
hint.tcp_fader_layout_separate = "Arrange Faders on a separate line, next to each other"
hint.tcp_fader_layout_separate_exploded = "Arrange Faders on a separate line, stacked vertically"

-- hiding spot
hint.tcp_label_size =
"Adjusts the hiding position for the buttons. \\n The label itself is always extended to the last visible element."
hint.tcp_master_size =
"Adjusts the hiding position for the buttons. \\n The meter itself is always extended to the last visible element."

-- envcp
hint.envcp_iconlane =
"Add an artifical track lane section to envelopes. \\n Only activated when Track icons  are set or the  Fixed Track Lanes feature is used."
hint.envcp_fader_placement =
"Icon Lane  is automatically reverted to Inline when the Track Icon Lane setting is not active"
hint.envcp_fader_size =
"Bypassed when the Track Icon Lane  is active"

--      MCP
-- --------------------------------------

-- folder
hint.mcp_folder_buttons = "Folder buttons are only shown when the current project has a folder structure"
hint.mcp_folder_padding = "Add extra space for folder tracks and the last track of a folder"

-- meter
hint.mcp_meter_position =
"Top Position  places the Meter below the buttons. \\n Bottom Position positions the meter next to the Volume Fader. \\n Choosing no position will hide the meter."
hint.mcp_meter_size =
"Adjusts the height when the Meter is in top position. \\n Extends the width when the Meter is in bottom position."
hint.mcp_meter_expand =
'Increments the meter width by track channel count. \\n Activating "Fix" will extend the width only by a fixed amount when a given channel count is reached.'
hint.mcp_meter_expand_threshold = "The amound of track channels needed for the Expand setting to kick in"

-- faders layout
hint.mcp_faders_layout_pan_top = "Place the Pan and Width adjustment in a separate section above the Volume fader"
hint.mcp_faders_layout_strip = "Arrange the Pan, Width and Volume adjustments vertically as a strip"
hint.mcp_faders_layout_bottom = "Place the Pan and Width adjustments as faders next to the Volume fader"

-- faders panmode
hint.mcp_faders_panmode_knob = "Knobs"
hint.mcp_faders_panmode_vertical = "Vertical Faders"
hint.mcp_faders_panmode_horizontal = "Horizontal Faders"

-- faders dimensions
hint.mcp_faders_width =
"Extends the width of the Pan Section when the Fader Layout is set to use a separate Pan Section."
hint.mcp_faders_height = "Ignored when the Pan and Width adjustments are placed next to the Volume fader."

-- extra width
hint.mcp_extra_width =
"Adds additional space to the sides of the MCP"

-- inserts
hint.mcp_insert_mode =
"Embed will activate sidebar mode only when the track has embedded FX. \\n Selecting nothing will hide the Insert section from the MCP."
hint.size_onembed =
"Increases the Sidebar Width when the track has embedded FX. \\n Sets the base width when the Sidebar Mode is triggered conditionally."

-- button layout
hint.mcp_button_layout =
"Slim arranges the buttons vertically in a strip formation. \\n Wide spreads the buttons accross two columns."
hint.mcp_input_size = "Only effective when Button Layout is set to Slim"


return hint
