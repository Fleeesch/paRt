-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--      Tab : TCP : General
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

-- Settings
-- ------------------------------

Part.Tab.Entry.setRecentTab(Part.Gui.Tab.tab_tcp_general)
Part.Gui.Macros.resetCursor()

local group_x = 55
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
Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_gen_element_adj_separator, false, slider_w, "Button Separator",
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

-- Highlights
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(true,false,true)
group_x = Part.Cursor.getCursorX()

Part.Gui.Macros.drawGroupBox("Highlights", group_x, group_y , 250, 85)
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

Part.Gui.Macros.placeCursorAtLastGroup(false,true,true)

Part.Gui.Macros.drawGroupBox("Folders", group_x , Part.Cursor.getCursorY(), 250, 125)
Part.Gui.Macros.lastGroup():setTint("folder")

Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_gen_folder_indent, false, slider_w, "Indentation",
    label_w)
Part.Gui.Macros.nextLine()
Part.Gui.Macros.drawHeader("Buttons", 230)
Part.Gui.Macros.nextLine()
Part.Gui.Macros.drawButtonToggleGroup(true, Part.Parameter.Map.par_tcp_gen_folder_icon_collapse, 50, "Collapse Toggle", "Show",
    label_w)
Part.Gui.Macros.nextLine()
Part.Gui.Macros.drawButtonToggleGroup(true, Part.Parameter.Map.par_tcp_gen_folder_icon_mode, 50, "Folder Mode", "Show",
    label_w)

