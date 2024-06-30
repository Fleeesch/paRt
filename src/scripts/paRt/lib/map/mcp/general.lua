-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--      Tab : MCP : General
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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
Part.Gui.Macros.drawGroupBox("Folders", group_x, Part.Cursor.getCursorY(), 250, 145)
Part.Gui.Macros.lastGroup():setTint("folder")

-- Buttons
Part.Gui.Macros.drawButtonToggleGroup(true, Part.Parameter.Map.par_mcp_gen_folder_icon_folder, 50, "Buttons",
    "Show",
    label_w)
Part.Gui.Macros.nextLine()

-- Indentation
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_gen_folder_indent, false, slider_w, "Indentation",
    label_w)
Part.Gui.Macros.nextLine()

-- Extra Padding
Part.Gui.Macros.drawHeader("Extra Padding", header_w_column_b)
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
Part.Gui.Macros.drawGroupBox("Spacing", group_x, group_y, 260, 235)
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