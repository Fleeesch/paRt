-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--      Tab : Colors : Themes / Adjustments
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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

Part.Gui.Macros.drawGroupBox("paRt Theme", group_x + 90, group_y, 120, 100)

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

Part.Gui.Macros.drawGroupBox("Drawing Adjustments", group_x, group_y, 300, 210)
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
