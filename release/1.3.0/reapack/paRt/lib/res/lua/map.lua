-- @version 1.2.7
-- @author Fleeesch
-- @description paRt Theme Adjuster
-- @noIndex

--[[
    The layouting of (mostly) interactive elements in the Theme Adjuster.
    Anything than can be clicked with a button will be defined right here,
    plus some eye candy like section backgrounds and whatnot.
    Makes heavy use of map_macros.lua in order to keep things readable.
]]

-- ===========================================================================
--      Spritesheet
-- ===========================================================================

Part.Layout.icon_spritesheet = Part.Layout.Spritesheet:new(nil, "lib/res/icon/themeadj_sprites.png",
    "lib.res.icon.themeadj_sprites")

-- ===========================================================================
--      Tab Header Bar
-- ===========================================================================

Part.Gui.Tab = {}

Part.Cursor.stackCursor()

Part.Cursor.setCursor(0, 0, Part.Global.win_w, Part.Global.tab_height, 0, 0)

-- Tab Bar
Part.Gui.Tab.tab_top = Part.Tab.Group.TabGroup:new(nil, "Top Menu")

-- Tab Sub-Entries
Part.Gui.Tab.tab_colors = Part.Tab.Entry.TabEntry:new(nil, Part.Gui.Tab.tab_top, "Colors")
Part.Gui.Tab.tab_transport = Part.Tab.Entry.TabEntry:new(nil, Part.Gui.Tab.tab_top, "Transport")
Part.Gui.Tab.tab_tcp = Part.Tab.Entry.TabEntry:new(nil, Part.Gui.Tab.tab_top, "TCP")
Part.Gui.Tab.tab_mcp = Part.Tab.Entry.TabEntry:new(nil, Part.Gui.Tab.tab_top, "MCP")
Part.Gui.Tab.tab_custom = Part.Tab.Entry.TabEntry:new(nil, Part.Gui.Tab.tab_top, "Custom")

Part.Cursor.incCursor(0, Part.Cursor.getCursorH())

-- Colors
Part.Gui.Tab.tab_colors_sub = Part.Tab.Group.TabGroup:new(nil, "Global", Part.Gui.Tab.tab_colors, 1)
Part.Gui.Tab.tab_colors_themes = Part.Tab.EntrySub.TabEntrySub:new(nil, Part.Gui.Tab.tab_colors_sub, "Color Palettes")
Part.Gui.Tab.tab_colors_a = Part.Tab.EntrySub.TabEntrySub:new(nil, Part.Gui.Tab.tab_colors_sub, "Adjustments A")
Part.Gui.Tab.tab_colors_b = Part.Tab.EntrySub.TabEntrySub:new(nil, Part.Gui.Tab.tab_colors_sub, "Adjustments B")

-- Transport
Part.Gui.Tab.tab_transport_sub = Part.Tab.Group.TabGroup:new(nil, "Transport", Part.Gui.Tab.tab_transport, 1) -- placeholder

-- Tcp
Part.Gui.Tab.tab_tcp_sub = Part.Tab.Group.TabGroup:new(nil, "TCP", Part.Gui.Tab.tab_tcp, 1)
Part.Gui.Tab.tab_tcp_general = Part.Tab.EntrySub.TabEntrySub:new(nil, Part.Gui.Tab.tab_tcp_sub, "General")
Part.Gui.Tab.tab_tcp_track_a = Part.Tab.EntrySub.TabEntrySub:new(nil, Part.Gui.Tab.tab_tcp_sub, "Track A")
Part.Gui.Tab.tab_tcp_track_b = Part.Tab.EntrySub.TabEntrySub:new(nil, Part.Gui.Tab.tab_tcp_sub, "Track B")
Part.Gui.Tab.tab_tcp_master = Part.Tab.EntrySub.TabEntrySub:new(nil, Part.Gui.Tab.tab_tcp_sub, "Master")
Part.Gui.Tab.tab_tcp_envcp = Part.Tab.EntrySub.TabEntrySub:new(nil, Part.Gui.Tab.tab_tcp_sub, "Envelope")

-- Mcp
Part.Gui.Tab.tab_mcp_sub = Part.Tab.Group.TabGroup:new(nil, "MCP", Part.Gui.Tab.tab_mcp, 1)
Part.Gui.Tab.tab_mcp_general = Part.Tab.EntrySub.TabEntrySub:new(nil, Part.Gui.Tab.tab_mcp_sub, "General")
Part.Gui.Tab.tab_mcp_track_a = Part.Tab.EntrySub.TabEntrySub:new(nil, Part.Gui.Tab.tab_mcp_sub, "Track A")
Part.Gui.Tab.tab_mcp_track_b = Part.Tab.EntrySub.TabEntrySub:new(nil, Part.Gui.Tab.tab_mcp_sub, "Track B")
Part.Gui.Tab.tab_mcp_master = Part.Tab.EntrySub.TabEntrySub:new(nil, Part.Gui.Tab.tab_mcp_sub, "Master")

-- Custom
Part.Gui.Tab.tab_custom_sub = Part.Tab.Group.TabGroup:new(nil, "Custom", Part.Gui.Tab.tab_custom, 1) -- placeholder

-- Bank Bar
Part.Cursor.setCursorSize(Part.Global.win_w, Part.Global.bank_bar_size)
Part.Cursor.setCursorPos(70, Part.Global.win_h - Part.Cursor.getCursorH())
Part.Cursor.stackCursor()
Part.Gui.BankBar = Part.Layout.BankBar.BankBar:new(nil, Part.Bank.Handler)
Part.Cursor.destackCursor()

-- config bar
Part.Cursor.setCursorPos(420, Part.Global.win_h - Part.Cursor.getCursorH())
Part.Gui.ConfigBar = Part.Layout.ConfigBar.ConfigBar:new(nil, Part.Config.Handler)

-- bank symbol
Part.Cursor.setCursorSize(20, 20)
Part.Cursor.setCursorPos(10, 520)
local sprite = Part.Layout.Sprite.Sprite:new(nil, Part.Layout.icon_spritesheet, "bank_l")
sprite:setCenterBehaviour(false, false, true)

-- ===========================================================================
--      Message Handler
-- ===========================================================================

Part.Cursor.incCursor(0, -10)
Part.Cursor.setCursorPos(0, Part.Cursor.getCursorY())
Part.Cursor.setCursorSize(Part.Global.win_w - 10, Part.Cursor.getCursorH())

Part.Gui.MessageHandler = Part.Message.Handler.MessageHandler:new()

Part.Cursor.destackCursor()


-- ===========================================================================
--      Tab : Colors : Themes / Adjustments
-- ===========================================================================

-- Settings
-- ------------------------------

Part.Tab.Entry.setRecentTab(Part.Gui.Tab.tab_colors_themes)
Part.Gui.Macros.resetCursor()

-- Universal Values
-- ------------------------------

-- temporary group storage
local group

-- initial starting position
local group_x = Part.Cursor.getCursorX()
local group_y = Part.Cursor.getCursorY()
local group_w = 280
local group_w_wide = 565

-- fixed sizes
local label_w = 100
local slider_w = 130
local button_w_full = 132
local button_w = 90
local button_w_2 = 63
local button_w_3 = 40
local section_w = 250

-- temporary button and slider storage
local button
local slider

-- line for extending group backgrounds
local bottom_y = 495

-- Themes
-- ------------------------------

-- theme files
Part.Gui.Macros.drawGroupBox("Theme Files", group_x, group_y, group_w_wide, 100)

-- theme file list
local theme_list = {
    { label = "Dark",   function_call = "loadDarkTheme",   palette = "color_dark" },
    { label = "Dimmed", function_call = "loadDimmedTheme", palette = "color_dimmed" },
    { label = "Light",  function_call = "loadLightTheme",  palette = "color_light" }
}

-- button dimensions
Part.Cursor.setCursorSize(160, nil)

-- draw theme file buttons
for idx, theme in pairs(theme_list) do
    -- button
    Part.Cursor.stackCursor()
    Part.Control.Button.Button:new(nil, Part.Global.par_theme_selected, false, theme.label, idx - 1)
    Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.colors_theme_files, Part.Draw.Elements.lastElement(), true)

    Part.Draw.Elements.lastElement():bindAction(theme.function_call)
    Part.Gui.Macros.nextLine()
    Part.Layout.Function.Function:new(nil, Part.Draw.Graphics.drawThemePaletteSample, theme.palette, Part.Cursor.getCursorW())

    Part.Cursor.destackCursor()
    Part.Cursor.incCursor(Part.Cursor.getCursorW() + 10, 0)
end


-- Color Adjustments
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(false, true)
group_y = Part.Cursor.getCursorY() + Part.Gui.Macros.pad_group
group = Part.Gui.Macros.drawGroupBox("Color Adjustments", group_x, group_y, group_w_wide, 295)

-- apply-to-all button
Part.Cursor.setCursorSize(210, 22)
Part.Control.Button.Button:new(nil, Part.Parameter.Map.par_global_color_custom_overwrite, true, "Apply Adjustments to Custom Colors", 1)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.colors_reaper_apply_custom, Part.Draw.Elements.lastElement(), true)
Part.Cursor.incCursor(0, 40, 0, 0)

-- color slider list
local color_adj_list = {
    { separator = false, label = "Hue",        parameter = Part.Parameter.Map.par_global_color_hue,        thumb_opcaity = 1, gradient = Part.Color.Lookup.color_palette.gradient.slider.hue },
    { separator = true,  label = "Saturation", parameter = Part.Parameter.Map.par_global_color_saturation, thumb_opcaity = 1, gradient = Part.Color.Lookup.color_palette.gradient.slider.saturation },
    { separator = true,  label = "Gamma",      parameter = Part.Parameter.Map.par_global_color_gamma,      thumb_opcaity = 1, gradient = Part.Color.Lookup.color_palette.gradient.slider.gamma },
    { separator = false, label = "Highlights", parameter = Part.Parameter.Map.par_global_color_highlights, thumb_opcaity = 1, gradient = Part.Color.Lookup.color_palette.gradient.slider.highlights },
    { separator = false, label = "Midtones",   parameter = Part.Parameter.Map.par_global_color_midtones,   thumb_opcaity = 1, gradient = Part.Color.Lookup.color_palette.gradient.slider.midtones },
    { separator = false, label = "Shadows",    parameter = Part.Parameter.Map.par_global_color_shadows,    thumb_opcaity = 1, gradient = Part.Color.Lookup.color_palette.gradient.slider.shadows }
}


-- draw sliders
for _, color_adj in pairs(color_adj_list) do
    -- slider size
    Part.Cursor.setCursorSize(600, Part.Gui.Macros.slider_h + 10)

    Part.Cursor.stackCursor()
    Part.Gui.Macros.openLabel()

    -- store starting point of box
    local pad_x = Part.Gui.Macros.parameter_frame_pad_x
    local pad_y = Part.Gui.Macros.parameter_frame_pad_y
    local frame_x = Part.Cursor.getCursorX()
    local frame_y = Part.Cursor.getCursorY()
    local frame_h = 16

    -- label
    Part.Gui.Macros.drawParameterLabel(color_adj.label, label_w)

    Part.Cursor.setCursorSize(430, Part.Gui.Macros.slider_h)
    Part.Cursor.stackCursor()
    Part.Cursor.incCursor(0, Part.Gui.Macros.slider_offset, 0, 0)

    -- slider
    Part.Control.Slider.Slider:new(nil, color_adj.parameter)
    Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.colors_reaper, Part.Draw.Elements.lastElement(), true)

    -- box width
    local frame_w = Part.Cursor.getCursorX() - frame_x + Part.Cursor.getCursorW()

    -- slider attributes
    Part.Draw.Elements.lastElement():colorFinder(color_adj.thumb_opcaity, color_adj.gradient)
    Part.Draw.Elements.lastElement():noValueFill()

    -- close label
    Part.Cursor.destackCursor()
    Part.Gui.Macros.closeLabel()

    -- box
    Part.Layout.Box.Box:new(nil, true, true, frame_x - pad_x, frame_y - pad_y, frame_w + pad_x * 2, frame_h + pad_y * 2)

    -- increment position
    Part.Cursor.destackCursor()
    Part.Cursor.incCursor(0, Part.Cursor.getCursorH())

    -- additional separator
    if color_adj.separator then
        --Part.Cursor.incCursor(0, 10, 0, 0)
    end
end

-- stretch group
group:stretchToPosition(nil, bottom_y)



-- ===========================================================================
--      Tab : Colors : A
-- ===========================================================================

-- Settings
-- ------------------------------

Part.Tab.Entry.setRecentTab(Part.Gui.Tab.tab_colors_a)
Part.Gui.Macros.resetCursor()

local group_x = Part.Cursor.getCursorX()
local group_y = Part.Cursor.getCursorY()


-- Track Background
-- ------------------------------

group = Part.Gui.Macros.drawGroupBox("Track Background", group_x + 0, group_y, group_w, 120)
-- background tone
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_colors_track_track_bg_tone, false, slider_w, "Tone", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.colors_track_background_tone, slider, true)
Part.Gui.Macros.nextLine()

-- background tone (selected)
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_colors_track_track_bg_select_tone, false, slider_w, "Selected Tone", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.colors_track_background_tone_select, slider, true)
Part.Gui.Macros.nextLine()

-- background tint
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_colors_track_track_bg_tint, false, slider_w, "Tint", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.colors_track_background_tint, slider, true)
Part.Gui.Macros.nextLine()

-- background tint (selected)
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_colors_track_track_bg_select_tint, false, slider_w, "Selected Tint", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.colors_track_background_tint_select, slider, true)
Part.Gui.Macros.nextLine()

-- Track Label
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(false, true, true)
group = Part.Gui.Macros.drawGroupBox("Track Label", group_x + 0, Part.Cursor.getCursorY(), group_w, 200)

-- label tone
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_colors_track_track_label_bg_tone, false, slider_w, "Tone", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.colors_track_label_bg_tone, slider, true)
Part.Gui.Macros.nextLine()

-- label tone (selected)
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_colors_track_track_label_select_tone, false, slider_w, "Selected Tone", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.colors_track_label_bg_tone_select, slider, true)
Part.Gui.Macros.nextLine()

-- label tint
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_colors_track_track_label_bg_tint, false, slider_w, "Tint", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.colors_track_label_bg_tint, slider, true)
Part.Gui.Macros.nextLine()

-- label tint (selected)
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_colors_track_track_label_select_tint, false, slider_w, "Selected Tint", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.colors_track_label_bg_tint_select, slider, true)
Part.Gui.Macros.nextLine()

Part.Gui.Macros.nextSection(section_w)

-- label text tone
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_colors_track_track_label_text_tone, false, slider_w, "Text Tone", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.colors_track_label_text_tone, slider, true)
Part.Gui.Macros.nextLine()

-- index tone (TCP)
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_colors_track_track_index_tone_tcp, false, slider_w, "TCP Index Tone", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.colors_track_index_tone_tcp, slider, true)
Part.Gui.Macros.nextLine()

-- index tone (MCP)
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_colors_track_track_index_tone_mcp, false, slider_w, "MCP Index Tone", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.colors_track_index_tone_mcp, slider, true)
Part.Gui.Macros.nextLine()


-- stretch group
group:stretchToPosition(nil, bottom_y)



-- Envelopes Background
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(true, false, true)
group_x = Part.Cursor.getCursorX()
group = Part.Gui.Macros.drawGroupBox("Envelope Background", group_x, group_y, group_w, 70)

-- background tone
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_colors_track_envcp_bg_tone, false, slider_w, "Tone", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.colors_track_envcp_background_tone, slider, true)
Part.Gui.Macros.nextLine()

-- background tint
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_colors_track_envcp_bg_tint, false, slider_w, "Tint", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.colors_track_envcp_background_tint, slider, true)
Part.Gui.Macros.nextLine()

-- Envelopes Label
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(false, true, true)
group = Part.Gui.Macros.drawGroupBox("Envelope Label", group_x, Part.Cursor.getCursorY(), group_w, 120)

-- label background tone
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_colors_track_envcp_label_bg_Tone, false, slider_w, "Tone", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.colors_track_envcp_label_tone, slider, true)
Part.Gui.Macros.nextLine()

-- label background tint
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_colors_track_envcp_label_bg_tint, false, slider_w, "Tint", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.colors_track_envcp_label_tint, slider, true)
Part.Gui.Macros.nextLine()

Part.Gui.Macros.nextSection(section_w)


-- label text tone
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_colors_track_envcp_label_text_tone, false, slider_w, "Text Tone", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.colors_track_envcp_label_text_tone, slider, true)
Part.Gui.Macros.nextLine()

-- label value tone
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_colors_track_envcp_label_readout_tone, false, slider_w, "Value Tone", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.colors_track_envcp_label_readout_tone, slider, true)
Part.Gui.Macros.nextLine()


-- stretch group
group:stretchToPosition(nil, bottom_y)

-- ===========================================================================
--      Tab : Colors : B
-- ===========================================================================

-- Settings
-- ------------------------------

Part.Tab.Entry.setRecentTab(Part.Gui.Tab.tab_colors_b)
Part.Gui.Macros.resetCursor()

local group_x = Part.Cursor.getCursorX()
local group_y = Part.Cursor.getCursorY()


-- Tracks
-- ------------------------------

group = Part.Gui.Macros.drawGroupBox("Highlights", group_x + 0, group_y, group_w, 100)

-- Colorbar
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_colors_track_track_colorbar_intensity, false, slider_w, "Colorbar Intensity", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.colors_tuning_colorbar_intensity, slider, true)
Part.Gui.Macros.nextLine()

Part.Gui.Macros.nextSection(section_w)

-- Selection Frame Tint
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_colors_track_track_selectionframe_tint, false, slider_w, "Sel. Frame Tint", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.colors_tuning_selectionframe_tint, slider, true)
Part.Gui.Macros.nextLine()

-- Selection Frame Tone
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_colors_track_track_selectionframe_tone, false, slider_w, "Sel. Frame Tone", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.colors_tuning_selectionframe_tone, slider, true)
Part.Gui.Macros.nextLine()

-- ------------------------------
-- Folders

Part.Gui.Macros.placeCursorAtLastGroup(false, true, true)
group = Part.Gui.Macros.drawGroupBox("Folders", group_x, Part.Cursor.getCursorY(), group_w, 180)

-- Folder Track
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_colors_track_folder_foldertrack_tone, false, slider_w, "Folder Track Tone", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.colors_folder_track_tone, slider, true)
Part.Gui.Macros.nextLine()

slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_colors_track_folder_foldertrack_tint, false, slider_w, "Folder Track Tint", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.colors_folder_track_tint, slider, true)
Part.Gui.Macros.nextLine()
Part.Gui.Macros.nextSection(section_w)

-- folder tree tone
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_colors_track_folder_foldertree_tone, false, slider_w, "Folder Tree Tone", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.colors_folder_tree_tone, slider, true)
Part.Gui.Macros.nextLine()

-- folder tree tint
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_colors_track_folder_foldertree_tint, false, slider_w, "Folder Tree Tint", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.colors_folder_tree_tint, slider, true)
Part.Gui.Macros.nextLine()

-- stretch group
group:stretchToPosition(nil, bottom_y)


-- Meter Text
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(true, false, true)
group_x = Part.Cursor.getCursorX()
group = Part.Gui.Macros.drawGroupBox("Meter Text", group_x, group_y, group_w, 315)


-- unlit tone
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_colors_track_meter_text_tone_unlit, false, slider_w, "Unlit Tone", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.colors_meter_text_unlit_tone, slider, true)
Part.Gui.Macros.nextLine()

-- unlit shadow
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_colors_track_meter_text_shadow_unlit, false, slider_w, "Unlit Shadow", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.colors_meter_text_unlit_shadow, slider, true)
Part.Gui.Macros.nextLine()
Part.Gui.Macros.nextSection(section_w)

-- lit tone
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_colors_track_meter_text_tone_lit, false, slider_w, "Lit Tone", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.colors_meter_text_lit_tone, slider, true)
Part.Gui.Macros.nextLine()

-- lit shadow
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_colors_track_meter_text_shadow_lit, false, slider_w, "Lit Shadow", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.colors_meter_text_lit_shadow, slider, true)
Part.Gui.Macros.nextLine()
Part.Gui.Macros.nextSection(section_w)

-- readout tone
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_colors_track_meter_text_tone_readout, false, slider_w, "Readout Tone", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.colors_meter_readout_tone, slider, true)
Part.Gui.Macros.nextLine()

-- readout clip tone
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_colors_track_meter_text_tone_readout_clip, false, slider_w, "Clip Tone", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.colors_meter_readout_clip_tone, slider, true)
Part.Gui.Macros.nextLine()
Part.Gui.Macros.nextSection(section_w)

-- tcp alpha
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_colors_track_meter_text_alpha_tcp, false, slider_w, "TCP Alpha", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.colors_meter_alpha_mcp, slider, true)
Part.Gui.Macros.nextLine()

-- mcp alpha
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_colors_track_meter_text_alpha_mcp, false, slider_w, "MCP Alpha", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.colors_meter_alpha_mcp, slider, true)
Part.Gui.Macros.nextLine()

-- stretch group
group:stretchToPosition(nil, bottom_y)



-- ===========================================================================
--      Tab : Transport
-- ===========================================================================

-- Settings
-- ------------------------------

Part.Tab.Entry.setRecentTab(Part.Gui.Tab.tab_transport)
Part.Gui.Macros.resetCursor()

local group_x = Part.Cursor.getCursorX()
local group_y = Part.Cursor.getCursorY()


-- Dimensions
-- ------------------------------

Part.Gui.Macros.drawGroupBox("Dimensions", group_x, group_y, group_w, 150)

-- transport width +
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_trans_settings_extrapad_x, false, slider_w, "Width +", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.transport_width_plus, slider, true)
Part.Gui.Macros.nextLine()

-- transport height +
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_trans_settings_extrapad_y, false, slider_w, "Height +",
    label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.transport_height_plus, slider, true)

Part.Gui.Macros.nextLine()
Part.Gui.Macros.nextSection(section_w)

-- button distance
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_trans_element_adj_spacing_x, false, slider_w, "Button Spacing", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.spacing_buttons_x, slider, true)
Part.Gui.Macros.nextLine()

-- tempo distance
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_trans_element_adj_spacing_time_x, false, slider_w, "Tempo Spacing", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.transport_spacing_tempo, slider, true)
Part.Gui.Macros.nextLine()

-- section spacing
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_trans_element_adj_spacing_section_x, false, slider_w, "Section Spacing", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.spacing_section_x, slider, true)
Part.Gui.Macros.nextLine()

-- Tempo Elements
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(false, true, true)
Part.Gui.Macros.drawGroupBox("Tempo Elements", group_x, Part.Cursor.getCursorY(), group_w, 122)

-- tap tempo
button = Part.Gui.Macros.drawButtonToggleGroup(true, Part.Parameter.Map.par_trans_element_adj_bpm_tap, button_w_full, "Tap Tempo Button", "Show in Tempo Section", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.transport_tap_button, button, true)
Part.Gui.Macros.nextLine()

-- timebase
button = Part.Gui.Macros.drawButtonToggleGroup(true, Part.Parameter.Map.par_trans_element_adj_timebase, button_w_full, "Timebase Button", "Show in Tempo Section", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.transport_timebase_button, button, true)
Part.Gui.Macros.nextLine()
Part.Gui.Macros.nextSection(section_w)

local selection = {
    { label = "Knob",  value = 1, width = button_w_2 },
    { label = "Fader", value = 2, width = button_w_2 },
}

-- playrate display mode
button = Part.Gui.Macros.drawButtonSelectionGroup(true, Part.Parameter.Map.par_trans_playrate_mode, true, selection, "Rate Display", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.transport_playrate_knob, button[1], true)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.transport_playrate_fader, button[2], true)
Part.Gui.Macros.nextLine()

-- playrate fader size
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_trans_playrate_size, false, slider_w, "Rate Fader Size", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.transport_playrate_fader_size, slider, true)

-- Status / Selection
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(false, true, true)
group = Part.Gui.Macros.drawGroupBox("Status / Selection", group_x, Part.Cursor.getCursorY(), group_w, 230)

-- status size
slider, button = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_trans_element_adj_status_size, false, slider_w, "Status", label_w, Part.Parameter.Map.par_trans_element_adj_status_size_scale[1])
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.transport_size_status, slider, true)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.size_percentual, button, true)
Part.Gui.Macros.nextLine()

-- selection size
slider, button = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_trans_element_adj_selection_size, false, slider_w, "Selection", label_w, Part.Parameter.Map.par_trans_element_adj_selection_size_scale[1])
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.transport_size_selection, slider, true)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.size_percentual, button, true)

-- stretch group
group:stretchToPosition(nil, bottom_y)

-- Buttons
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(true, false, true)
group_x = Part.Cursor.getCursorX()
group = Part.Gui.Macros.drawGroupBox("Buttons", group_x, group_y, group_w, 500)

-- visibility matrix
local visibility_data = {
    { label = "Rewind",     image = Part.Gui.Macros.icons.transport.rewind,     separator = true,  index = 1 },
    { label = "Forward",    image = Part.Gui.Macros.icons.transport.forward,    separator = true,  index = 2 },
    { label = "Stop",       image = Part.Gui.Macros.icons.transport.stop,       separator = true,  index = 3 },
    { label = "Pause",      image = Part.Gui.Macros.icons.transport.pause,      separator = true,  index = 4 },
    { label = "Play",       image = Part.Gui.Macros.icons.transport.play,       separator = true,  index = 5 },
    { label = "Record",     image = Part.Gui.Macros.icons.transport.record,     separator = true,  index = 6 },
    { label = "Repeat",     image = Part.Gui.Macros.icons.transport.loop,       separator = true,  index = 7 },
    { label = "Automation", image = Part.Gui.Macros.icons.transport.automation, separator = false, index = 8 },
    { label = "Bpm",        image = Part.Gui.Macros.icons.transport.bpm,        separator = false, index = 9 },
    { label = "Status",     image = Part.Gui.Macros.icons.transport.status,     separator = false, index = 10 },
    { label = "Selection",  image = Part.Gui.Macros.icons.transport.selection,  separator = false, index = 11 }
}

local matrix_data = {
    label_width = 70
}



Part.Gui.Macros.drawVisibilityMatrix(matrix_data, visibility_data, Part.Parameter.Map.par_trans_element_vis, nil, Part.Parameter.Map.par_trans_element_separator)

-- separator size
Part.Cursor.incCursor(0, 1)
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_trans_element_adj_separator_size, false, slider_w, "Extra Space", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.extra_space, slider, true)
Part.Gui.Macros.nextLine()
Part.Gui.Macros.nextSection(section_w)

-- bank button count
Part.Cursor.stackCursor()
slider = Part.Gui.Macros.drawSliderGroup(false, Part.Parameter.Map.par_trans_settings_theme_bank, false, slider_w, "Bank Buttons", label_w, nil, nil, true)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.transport_bank_buttons, slider, true)
Part.Gui.Macros.nextLine()

-- menu button
button = Part.Gui.Macros.drawButtonToggleGroup(false, Part.Parameter.Map.par_trans_settings_theme_menu, button_w_full, "Theme Adjuster Button", "Show In Transport", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.transport_menu_button, button, true)

-- stretch group
group:stretchToPosition(nil, bottom_y)

-- ===========================================================================
--      Tab : TCP : General
-- ===========================================================================

-- Settings
-- ------------------------------

Part.Tab.Entry.setRecentTab(Part.Gui.Tab.tab_tcp_general)
Part.Gui.Macros.resetCursor()

local group_x = Part.Cursor.getCursorX()
local group_y = Part.Cursor.getCursorY()

-- Spacing
-- ------------------------------

group = Part.Gui.Macros.drawGroupBox("Spacing", group_x, group_y, group_w, 500)

-- Separator Size
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_gen_element_adj_separator, false, slider_w, "Extra Space", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.extra_space, slider, true)

Part.Gui.Macros.nextLine()
Part.Gui.Macros.nextSection(section_w)

-- Button Spacing X
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_gen_element_adj_spacing_x, false, slider_w, "Button Spacing X", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.spacing_buttons_x, slider, true)
Part.Gui.Macros.nextLine()

-- Button Spacing Y
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_gen_element_adj_spacing_y, false, slider_w, "Button Spacing Y", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.spacing_buttons_y, slider, true)

Part.Gui.Macros.nextLine()
Part.Gui.Macros.nextSection(section_w)

-- Fader Spacing X
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_gen_element_adj_spacing_x_fader, false, slider_w, "Fader Spacing X", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.spacing_faders_x, slider, true)
Part.Gui.Macros.nextLine()

-- Fader Spacing Y
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_gen_element_adj_spacing_y_fader, false, slider_w, "Fader Spacing Y", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.spacing_faders_y, slider, true)

Part.Gui.Macros.nextLine()
Part.Gui.Macros.nextSection(section_w)

-- Section Spacing X
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_gen_element_adj_spacing_section_x, false, slider_w, "Section Spacing X", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.spacing_section_x, slider, true)
Part.Gui.Macros.nextLine()

-- Section Spacing Y
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_gen_element_adj_spacing_section_y, false, slider_w, "Section Spacing Y", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.spacing_section_y, slider, true)

-- stretch group
group:stretchToPosition(nil, bottom_y)


-- Highlights
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(true, false, true)
local group_x = Part.Cursor.getCursorX()
Part.Gui.Macros.drawGroupBox("Highlights", group_x, group_y, group_w, 100)

-- Selection Marker
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_gen_highlight_selection, false, slider_w, "Selection Bar", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.highlights_selectionbar_size, slider, true)
Part.Gui.Macros.nextLine()

-- Color Bar
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_gen_highlight_color, false, slider_w, "Color Bar", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.highlights_colorbar_size, slider, true)
Part.Gui.Macros.nextLine()

-- Selection Frame
button = Part.Gui.Macros.drawButtonToggleGroup(true, Part.Parameter.Map.par_tcp_gen_highlight_selectionframe, button_w_2, "Selection Frame", "Show", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.colors_tuning_selectionframe_activation, button, true)
Part.Gui.Macros.nextLine()


-- Folders
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(false, true, true)
group = Part.Gui.Macros.drawGroupBox("Folders", group_x, Part.Cursor.getCursorY(), group_w, 100)

-- folder indentation
local slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_gen_folder_indent, false, slider_w, "Indentation", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.tcp_general_folder_indent, slider, true)
Part.Gui.Macros.nextLine()

-- Buttons
local selection = {
    { label = "Buttons", value = 1, width = button_w_2 },
    { label = "+ Lines", value = 2, width = button_w_2 }
}

-- collapse button selection
Part.Cursor.stackCursor()
button = Part.Gui.Macros.drawButtonSelectionGroup(true, Part.Parameter.Map.par_tcp_gen_folder_icon_collapse, true, selection, "Collapse Toggle", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.tcp_general_folder_collapse_buttons, button[1], true)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.tcp_general_folder_collapse_lines, button[2], true)
Part.Gui.Macros.nextLine()

-- folder mode button
button = Part.Gui.Macros.drawButtonToggleGroup(true, Part.Parameter.Map.par_tcp_gen_folder_icon_mode, button_w_2, "Folder Mode Toggle", "Show", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.tcp_general_folder_mode, button, true)
Part.Gui.Macros.nextLine()

-- Inserts
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(false, true, true)
group = Part.Gui.Macros.drawGroupBox("Inserts", group_x, Part.Cursor.getCursorY(), group_w, 55)

slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_gen_insert_slot_width, false, slider_w, "Slot Size", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.tcp_general_insert_slot_size, slider, true)



-- stretch group
group:stretchToPosition(nil, bottom_y)


-- ===========================================================================
--      Tab : TCP : Track A
-- ===========================================================================

-- Settings
-- ------------------------------

Part.Tab.Entry.setRecentTab(Part.Gui.Tab.tab_tcp_track_a)
Part.Gui.Macros.resetCursor()

local group_x = Part.Cursor.getCursorX()
local group_y = Part.Cursor.getCursorY()


-- Inserts
-- ------------------------------

Part.Gui.Macros.drawGroupBox("Inserts", group_x, group_y, group_w, 70)

selection = {
    { label = "Inline",   value = 1, width = button_w_2 },
    { label = "Separate", value = 2, width = button_w_2 }
}

-- inserts display mode
Part.Cursor.stackCursor()
slider, button = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_track_insert_size, false, slider_w, "Inserts Width", label_w, Part.Parameter.Map.par_tcp_track_insert_size_scale[1])
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.tcp_index_separate, slider, true)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.size_percentual, button, true)
Part.Gui.Macros.nextLine()

-- inserts size
button = Part.Gui.Macros.drawButtonSelectionGroup(true, Part.Parameter.Map.par_tcp_track_insert_mode, true, selection, "Inserts Placement", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.tcp_inserts_placement_inline, button[1], true)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.tcp_inserts_placement_separate, button[2], true)
Part.Cursor.destackCursor()
Part.Gui.Macros.nextLine()

-- Label
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(false, true, true)
group = Part.Gui.Macros.drawGroupBox("Label", group_x, Part.Cursor.getCursorY(), group_w, 110)

-- Label Size
Part.Cursor.stackCursor()
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_track_label_size, false, slider_w, "Label Width", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.tcp_label_size, slider, true)

Part.Gui.Macros.nextLine()

-- Track Index
local selection = {
    { label = "Separate", value = 1, width = button_w_2 },
    { label = "In Label", value = 2, width = button_w_2 }
}

button = Part.Gui.Macros.drawButtonSelectionGroup(true, Part.Parameter.Map.par_tcp_track_label_index_vis, true, selection, "Index Placement", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.tcp_index_separate, button[1], true)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.tcp_index_in_label, button[2], true)
Part.Gui.Macros.nextLine()

-- Info Box
button = Part.Gui.Macros.drawButtonToggleGroup(true, Part.Parameter.Map.par_tcp_track_label_infobox, button_w_full, "Info Box", "Show in Label", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.tcp_info_box, button, true)

-- stretch group
group:stretchToPosition(nil, bottom_y)


-- Elements
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(true, false, true)
group_x = Part.Cursor.getCursorX()
group = Part.Gui.Macros.drawGroupBox("Buttons", group_x, group_y, group_w, 500)

local visibility_data = {
    { label = "Solo",        image = Part.Gui.Macros.icons.track.solo,    separator = true,  index = 4 },
    { label = "Mute",        image = Part.Gui.Macros.icons.track.mute,    separator = true,  index = 5 },
    { label = "Rec Arm",     image = Part.Gui.Macros.icons.track.recarm,  separator = true,  index = 2 },
    { label = "Monitor",     image = Part.Gui.Macros.icons.track.recmon,  separator = true,  index = 3 },
    { label = "Env",         image = Part.Gui.Macros.icons.track.env,     separator = true,  index = 1 },
    { label = "Phase",       image = Part.Gui.Macros.icons.track.phase,   separator = true,  index = 6 },
    { label = "IO",          image = Part.Gui.Macros.icons.track.io,      separator = true,  index = 7 },
    { label = "FX",          image = Part.Gui.Macros.icons.track.fx,      separator = true,  index = 8 },
    { label = "In FX",       image = Part.Gui.Macros.icons.track.infx,    separator = true,  index = 9 },
    { label = "Record Mode", image = Part.Gui.Macros.icons.track.recmode, separator = true,  index = 10 },
    { label = "Input",       image = Part.Gui.Macros.icons.track.input,   separator = false, index = 11 },
}

local matrix_data = {
    label_width = 70
}

-- Visibility Matrix
Part.Gui.Macros.drawVisibilityMatrix(matrix_data, visibility_data, Part.Parameter.Map.par_tcp_track_element_vis, Part.Parameter.Map.par_tcp_track_element_vis_mixer, Part.Parameter.Map.par_tcp_track_element_separator)
Part.Cursor.incCursor(0, 4)

-- Button Wrapping
local selection = {
    { label = "L", value = 1, width = button_w_3 },
    { label = "M", value = 2, width = button_w_3 },
    { label = "S", value = 3, width = button_w_3 }
}


button = Part.Gui.Macros.drawButtonSelectionGroup(true, Part.Parameter.Map.par_tcp_track_element_adj_wrap_buttons, true, selection, "Button Wrapping", label_w)
Part.Gui.Macros.nextLine()
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.tcp_button_wrap_full, button[1], true)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.tcp_button_wrap_compact, button[2], true)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.tcp_button_wrap_narrow, button[3], true)

-- Envelope Button Size
button = Part.Gui.Macros.drawButtonToggleGroup(true, Part.Parameter.Map.par_tcp_track_element_adj_size_env, button_w_2, "Envelope Button", "Large", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.button_env_large, button, true)
Part.Gui.Macros.nextLine()

-- Rec Input Size
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_track_element_adj_size_input, false, slider_w, "RecInput Width", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.tcp_button_recinput_size, slider, true)
Part.Gui.Macros.nextLine()


-- stretch group
group:stretchToPosition(nil, bottom_y)

-- ===========================================================================
--      Tab : TCP : Track B
-- ===========================================================================

-- Settings
-- ------------------------------

Part.Tab.Entry.setRecentTab(Part.Gui.Tab.tab_tcp_track_b)
Part.Gui.Macros.resetCursor()

local group_x = Part.Cursor.getCursorX()
local group_y = Part.Cursor.getCursorY()


-- Meter
-- ------------------------------

group = Part.Gui.Macros.drawGroupBox("Meter", group_x, group_y, group_w, 114)

-- Visibility
local selection = {
    { label = "Show",        value = 1, width = button_w_3 },
    { label = "+ Collapsed", value = 2, width = button_w }
}

button = Part.Gui.Macros.drawButtonSelectionGroup(true, Part.Parameter.Map.par_tcp_track_meter_mode, true, selection, "Show in TCP", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.tcp_meter_show, button[1], true)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.tcp_meter_show_collapsed, button[2], true)
Part.Gui.Macros.nextLine()

-- Meter Size
slider, button = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_track_meter_size, false, slider_w, "Meter Width",
    label_w, Part.Parameter.Map.par_tcp_track_meter_size_scale[1])
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.tcp_meter_size, slider, true)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.size_percentual, button, true)
Part.Gui.Macros.nextLine()
Part.Gui.Macros.nextSection(section_w)

-- Volume Readout
button = Part.Gui.Macros.drawButtonToggleGroup(true, Part.Parameter.Map.par_tcp_track_meter_vol_readout, button_w_full, "Volume Readout", "Next to Meter", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.tcp_meter_vol_readout, button, true)
Part.Gui.Macros.nextLine()

-- VU Text
button = Part.Gui.Macros.drawButtonToggleGroup(true, Part.Parameter.Map.par_tcp_track_meter_vu_db, button_w_full, "VU Text", "Show in Meter", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.tcp_meter_text, button, true)
Part.Gui.Macros.nextLine()

-- Clip Text
button = Part.Gui.Macros.drawButtonToggleGroup(true, Part.Parameter.Map.par_tcp_track_meter_vu_readout, button_w_full, "Clip Text", "Show in Meter", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.tcp_meter_clip_text, button, true)
Part.Gui.Macros.nextLine()
Part.Gui.Macros.nextSection(section_w)

-- Meter VU Space
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_track_meter_channeldiv, false, slider_w, "Channel Spacing", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.tcp_meter_vu_space, slider, true)
Part.Gui.Macros.nextLine()

-- Gain Reduction Pad
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_track_meter_gaindiv, false, slider_w, "Gain Red. Spacing", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.tcp_meter_gainreduction_space, slider, true)
Part.Gui.Macros.nextLine()

-- Gain Reduction Width
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_track_meter_gainwid, false, slider_w, "Gain Red. Width", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.tcp_meter_gainreduction_width, slider, true)
Part.Gui.Macros.nextLine()


-- stretch group
group:stretchToPosition(nil, bottom_y)

-- Faders
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(true, false, true)
group = Part.Gui.Macros.drawGroupBox("Faders", Part.Cursor.getCursorX(), group_y, group_w, 155)

-- Fader Layout
Part.Cursor.incCursor(0, 4, 0, 0)
Part.Gui.Macros.drawTcpFaderLayoutConfiguration(Part.Parameter.Map.par_tcp_track_fader_placement)
Part.Gui.Macros.nextLine()

Part.Cursor.incCursor(0, 4, 0, 0)
Part.Gui.Macros.nextSection(section_w)
Part.Cursor.incCursor(0, 4, 0, 0)

-- Fader Configuration
local fader_data = {
    { label = "Vol",   par_vis = Part.Parameter.Map.par_tcp_track_fader_vol_vis, par_vis_mixer = Part.Parameter.Map.par_tcp_track_fader_vol_vis_mixer, par_size = Part.Parameter.Map.par_tcp_track_fader_vol_size, par_size_scale = Part.Parameter.Map.par_tcp_track_fader_vol_size_scale, size_hint = Part.Hint.Lookup.tcp_fader_size_vol },
    { label = "Pan",   par_vis = Part.Parameter.Map.par_tcp_track_fader_pan_vis, par_vis_mixer = Part.Parameter.Map.par_tcp_track_fader_pan_vis_mixer, par_size = Part.Parameter.Map.par_tcp_track_fader_pan_size, par_size_scale = Part.Parameter.Map.par_tcp_track_fader_pan_size_scale, size_hint = Part.Hint.Lookup.tcp_fader_size_pan },
    { label = "Width", par_vis = Part.Parameter.Map.par_tcp_track_fader_wid_vis, par_vis_mixer = Part.Parameter.Map.par_tcp_track_fader_wid_vis_mixer, par_size = Part.Parameter.Map.par_tcp_track_fader_wid_size, par_size_scale = Part.Parameter.Map.par_tcp_track_fader_wid_size_scale, size_hint = Part.Hint.Lookup.tcp_fader_size_wid }
}

Part.Gui.Macros.drawTcpFaderConfiguration(fader_data)

-- stretch group
group:stretchToPosition(nil, bottom_y)

-- ===========================================================================
--      Tab : TCP : Master
-- ===========================================================================

-- Settings
-- ------------------------------

Part.Tab.Entry.setRecentTab(Part.Gui.Tab.tab_tcp_master)
Part.Gui.Macros.resetCursor()

local group_x = Part.Cursor.getCursorX()
local group_y = Part.Cursor.getCursorY()

-- Meter
-- ------------------------------

Part.Gui.Macros.drawGroupBox("Meter", group_x, group_y, group_w, 220)

-- Visibility
button = Part.Gui.Macros.drawButtonToggleGroup(true, Part.Parameter.Map.par_tcp_master_meter_mode, button_w_full, "Visibility", "Show Meter in Master", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.tcp_meter_show, button, true)
Part.Gui.Macros.nextLine()

-- Meter Size
slider, button = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_master_meter_size, false, slider_w, "Meter Width", label_w, Part.Parameter.Map.par_tcp_master_meter_size_scale[1])
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.tcp_meter_size, slider, true)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.size_percentual, button, true)
Part.Gui.Macros.nextLine()
Part.Gui.Macros.nextSection(section_w)

-- Volume Readout
button = Part.Gui.Macros.drawButtonToggleGroup(true, Part.Parameter.Map.par_tcp_master_meter_vol_readout, button_w_full, "Volume Readout", "Next to Meter", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.tcp_meter_vol_readout, button, true)
Part.Gui.Macros.nextLine()

-- VU Text
button = Part.Gui.Macros.drawButtonToggleGroup(true, Part.Parameter.Map.par_tcp_master_meter_vu_db, button_w_full, "VU Text", "Show in Meter", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.tcp_meter_text, button, true)
Part.Gui.Macros.nextLine()

-- Clip Text
button = Part.Gui.Macros.drawButtonToggleGroup(true, Part.Parameter.Map.par_tcp_master_meter_vu_readout, button_w_full, "Clip Text", "Show in Meter", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.tcp_meter_clip_text, button, true)
Part.Gui.Macros.nextLine()
Part.Gui.Macros.nextSection(section_w)

-- Meter VU Space
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_master_meter_channeldiv, false, slider_w, "Channel Spacing", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.tcp_meter_vu_space, slider, true)
Part.Gui.Macros.nextLine()

-- Gain Reduction Pad
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_master_meter_gaindiv, false, slider_w, "Gain Red. Spacing", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.tcp_meter_gainreduction_space, slider, true)
Part.Gui.Macros.nextLine()

-- Gain Reduction Width
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_master_meter_gainwid, false, slider_w, "Gain Red. Width", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.tcp_meter_gainreduction_width, slider, true)



-- Inserts
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(false, true, true)
group = Part.Gui.Macros.drawGroupBox("Inserts", group_x, Part.Cursor.getCursorY(), group_w, 70)

-- Inserts Size
Part.Cursor.stackCursor()
slider, button = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_master_insert_size, false, slider_w, "Inserts Width", label_w, Part.Parameter.Map.par_tcp_master_insert_size_scale[1])
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.tcp_inserts_size, slider, true)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.size_percentual, button, true)
Part.Gui.Macros.nextLine()

-- Display Mode
local selection = {
    { label = "Inline",   value = 1, width = button_w_2 },
    { label = "Separate", value = 2, width = button_w_2 }
}
button = Part.Gui.Macros.drawButtonSelectionGroup(true, Part.Parameter.Map.par_tcp_master_insert_mode, true, selection, "Inserts Placement", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.tcp_inserts_placement_inline, button[1], true)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.tcp_inserts_placement_separate, button[2], true)

Part.Cursor.destackCursor()
Part.Gui.Macros.nextLine()


group:stretchToPosition(nil, bottom_y)

-- Faders
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(true, false, true)
group_x = Part.Cursor.getCursorX()

group = Part.Gui.Macros.drawGroupBox("Faders", group_x, group_y, group_w, 160)

-- Fader Layout
Part.Cursor.incCursor(0, 4, 0, 0)
Part.Gui.Macros.drawTcpFaderLayoutConfiguration(Part.Parameter.Map.par_tcp_master_fader_placement)
Part.Gui.Macros.nextLine()

Part.Cursor.incCursor(0, 4, 0, 0)
Part.Gui.Macros.nextSection(section_w)
Part.Cursor.incCursor(0, 4, 0, 0)

-- Fader Configuration
local fader_data = {
    { label = "Vol",   par_vis = Part.Parameter.Map.par_tcp_master_fader_vol_vis, par_vis_mixer = Part.Parameter.Map.par_tcp_master_fader_vol_vis_mixer, par_size = Part.Parameter.Map.par_tcp_master_fader_vol_size, par_size_scale = Part.Parameter.Map.par_tcp_master_fader_vol_size_scale, size_hint = Part.Hint.Lookup.tcp_fader_size_vol },
    { label = "Pan",   par_vis = Part.Parameter.Map.par_tcp_master_fader_pan_vis, par_vis_mixer = Part.Parameter.Map.par_tcp_master_fader_pan_vis_mixer, par_size = Part.Parameter.Map.par_tcp_master_fader_pan_size, par_size_scale = Part.Parameter.Map.par_tcp_master_fader_pan_size_scale, size_hint = Part.Hint.Lookup.tcp_fader_size_pan },
    { label = "Width", par_vis = Part.Parameter.Map.par_tcp_master_fader_wid_vis, par_vis_mixer = Part.Parameter.Map.par_tcp_master_fader_wid_vis_mixer, par_size = Part.Parameter.Map.par_tcp_master_fader_wid_size, par_size_scale = Part.Parameter.Map.par_tcp_master_fader_wid_size_scale, size_hint = Part.Hint.Lookup.tcp_fader_size_wid }
}

Part.Gui.Macros.drawTcpFaderConfiguration(fader_data)


-- Buttons
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(false, true, true)
group = Part.Gui.Macros.drawGroupBox("Buttons", group_x, Part.Cursor.getCursorY(), group_w, 266)

local visibility_data = {
    { label = "Solo", image = Part.Gui.Macros.icons.track.solo, separator = true,  index = 2 },
    { label = "Mute", image = Part.Gui.Macros.icons.track.mute, separator = true,  index = 3 },
    { label = "Env",  image = Part.Gui.Macros.icons.track.env,  separator = true,  index = 1 },
    { label = "Mono", image = Part.Gui.Macros.icons.track.mono, separator = true,  index = 4 },
    { label = "IO",   image = Part.Gui.Macros.icons.track.io,   separator = true,  index = 5 },
    { label = "FX",   image = Part.Gui.Macros.icons.track.fx,   separator = false, index = 6 },
}

local matrix_data = {
    label_width = 70
}

-- Visibility Matrix
Part.Gui.Macros.drawVisibilityMatrix(matrix_data, visibility_data, Part.Parameter.Map.par_tcp_master_element_vis, nil, Part.Parameter.Map.par_tcp_master_element_separator)
Part.Cursor.incCursor(0, 4)


-- Button Wrapping
local selection = {
    { label = "L", value = 1, width = button_w_3 },
    { label = "M", value = 2, width = button_w_3 },
    { label = "S", value = 3, width = button_w_3 }
}

button = Part.Gui.Macros.drawButtonSelectionGroup(true, Part.Parameter.Map.par_tcp_master_element_adj_wrap_buttons, true, selection, "Button Wrapping", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.tcp_button_wrap_full, button[1], true)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.tcp_button_wrap_compact, button[2], true)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.tcp_button_wrap_narrow, button[3], true)
Part.Gui.Macros.nextLine()

-- Envelope Button Size
button = Part.Gui.Macros.drawButtonToggleGroup(true, Part.Parameter.Map.par_tcp_master_element_adj_size_env, button_w_2, "Envelope Button", "Large", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.button_env_large, button, true)
Part.Gui.Macros.nextLine()

-- stretch group
group:stretchToPosition(nil, bottom_y)

-- ===========================================================================
--      Tab : TCP : ENVCP
-- ===========================================================================

-- ------------------------------
-- Settings

Part.Tab.Entry.setRecentTab(Part.Gui.Tab.tab_tcp_envcp)
Part.Gui.Macros.resetCursor()

local group_x = Part.Cursor.getCursorX()
local group_y = Part.Cursor.getCursorY()

-- Settings
-- ------------------------------

group = Part.Gui.Macros.drawGroupBox("Format", group_x, group_y, group_w, 100)

-- Show Envelope Symbol
button = Part.Gui.Macros.drawButtonToggleGroup(true, Part.Parameter.Map.par_tcp_envcp_settings_symbol, button_w_2, "Dot Symbol", "Show", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.envcp_show_symbol, button, true)
Part.Gui.Macros.nextLine()

-- Include Track Icon Lane
button = Part.Gui.Macros.drawButtonToggleGroup(true, Part.Parameter.Map.par_tcp_envcp_settings_lane_display, button_w_2, "Artifical Lane", "Show", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.envcp_include_track_icon_lane, button, true)
Part.Gui.Macros.nextLine()

-- Indentation
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_envcp_settings_indent, false, slider_w, "Indentation", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.envcp_indentation, slider, true)
Part.Gui.Macros.nextLine()

-- Fader
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(false, true, true)
Part.Gui.Macros.drawGroupBox("Fader", group_x, Part.Cursor.getCursorY(), group_w, 100)

-- Fader Placement
local selection = {
    { label = "Inline",    value = 1, width = button_w_2 },
    { label = "Icon Lane", value = 3, width = button_w_2 }
}

button = Part.Gui.Macros.drawButtonSelectionGroup(true, Part.Parameter.Map.par_tcp_envcp_value_mode, true, selection, "Placement", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.envcp_fader_placement_inline, button[1], true)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.envcp_fader_placement_iconlane, button[2], true)
Part.Gui.Macros.nextLine()

-- Fader Orientation
selection = {
    { label = "Horizontal", value = 0, width = button_w_2 },
    { label = "Vertical",   value = 1, width = button_w_2 }
}

button = Part.Gui.Macros.drawButtonSelectionGroup(true, Part.Parameter.Map.par_tcp_envcp_value_vertical, false, selection, "Orientation", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.envcp_fader_orientation_horizontal, button[1], true)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.envcp_fader_orientation_vertical, button[2], true)
Part.Gui.Macros.nextLine()

-- Fader Size
slider, button = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_envcp_value_size, false, slider_w, "Fader Size", label_w, Part.Parameter.Map.par_tcp_envcp_value_scale[1])
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.envcp_fader_size, slider, true)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.size_percentual, button, true)
Part.Gui.Macros.nextLine()


-- Label
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(false, true, true)
group = Part.Gui.Macros.drawGroupBox("Label", group_x, Part.Cursor.getCursorY(), group_w, 290)

-- Label Size
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_envcp_label_size, false, slider_w, "Label Width", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.tcp_label_size, slider, true)
Part.Gui.Macros.nextLine()
Part.Gui.Macros.nextSection(section_w)

-- Value Display Placement
local selection = {
    { label = "Separate", value = 2, width = button_w_2 },
    { label = "In Label", value = 1, width = button_w_2 },
}

button = Part.Gui.Macros.drawButtonSelectionGroup(true, Part.Parameter.Map.par_tcp_envcp_label_readout_placement, true, selection, "Value Display", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.envcp_value_placement_separate, button[1], true)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.envcp_value_placement_in_label, button[2], true)
Part.Gui.Macros.nextLine()

-- Size
slider, button = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_tcp_envcp_label_readout_size, false, slider_w, "Value Width", label_w, Part.Parameter.Map.par_tcp_envcp_label_readout_size_scale[1])
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.envcp_value_width, slider, true)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.size_percentual, button, true)
Part.Gui.Macros.nextLine()

-- stretch group
group:stretchToPosition(nil, bottom_y)


-- Buttons
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(true, false, true)
group_x = Part.Cursor.getCursorX()
group = Part.Gui.Macros.drawGroupBox("Buttons", group_x, group_y, group_w, 230)

local visibility_data = {
    { label = "Arm",    image = Part.Gui.Macros.icons.envcp.arm,    separator = true,  index = 1 },
    { label = "Bypass", image = Part.Gui.Macros.icons.envcp.bypass, separator = true,  index = 2 },
    { label = "Hide",   image = Part.Gui.Macros.icons.envcp.hide,   separator = true,  index = 3 },
    { label = "Mod",    image = Part.Gui.Macros.icons.envcp.mod,    separator = true,  index = 4 },
    { label = "Learn",  image = Part.Gui.Macros.icons.envcp.learn,  separator = false, index = 5 }
}

local matrix_data = {
    label_width = 50
}

-- Visibility Matrix
Part.Gui.Macros.drawVisibilityMatrix(matrix_data, visibility_data, Part.Parameter.Map.par_tcp_envcp_element_vis, nil, Part.Parameter.Map.par_tcp_envcp_element_separator)
Part.Cursor.incCursor(0, 4)


-- Button Wrapping
local selection = {
    { label = "L", value = 1, width = button_w_3 },
    { label = "M", value = 2, width = button_w_3 },
    { label = "S", value = 3, width = button_w_3 }
}

button = Part.Gui.Macros.drawButtonSelectionGroup(true, Part.Parameter.Map.par_tcp_envcp_element_adj_wrap_buttons, true, selection, "Button Wrapping", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.tcp_button_wrap_full, button[1], true)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.tcp_button_wrap_compact, button[2], true)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.tcp_button_wrap_narrow, button[3], true)
Part.Gui.Macros.nextLine()

-- stretch group
group:stretchToPosition(nil, bottom_y)



-- ===========================================================================
--      Tab : MCP : General
-- ===========================================================================

-- ------------------------------
-- Settings

Part.Tab.Entry.setRecentTab(Part.Gui.Tab.tab_mcp_general)
Part.Gui.Macros.resetCursor()

local group_x = Part.Cursor.getCursorX()
local group_y = Part.Cursor.getCursorY()

-- Spacing
-- ------------------------------

group = Part.Gui.Macros.drawGroupBox("Spacing", group_x, group_y, group_w, 205)

-- Separator Size
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_gen_element_adj_separator, false, slider_w, "Extra Space", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.extra_space, slider, true)
Part.Gui.Macros.nextLine()
Part.Gui.Macros.nextSection(section_w)

-- Button Spacing X
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_gen_element_adj_spacing_x, false, slider_w, "Button Spacing X", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.spacing_buttons_x, slider, true)
Part.Gui.Macros.nextLine()

-- Button Spacing Y
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_gen_element_adj_spacing_y, false, slider_w, "Button Spacing Y", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.spacing_buttons_y, slider, true)

Part.Gui.Macros.nextLine()
Part.Gui.Macros.nextSection(section_w)

-- Fader Spacing X
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_gen_element_adj_spacing_fader_x, false, slider_w, "Fader Spacing X", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.spacing_faders_x, slider, true)
Part.Gui.Macros.nextLine()

-- Fader Spacing Y
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_gen_element_adj_spacing_fader_y, false, slider_w, "Fader Spacing Y", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.spacing_faders_y, slider, true)

Part.Gui.Macros.nextLine()
Part.Gui.Macros.nextSection(section_w)

-- Section Spacing X
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_gen_element_adj_spacing_section_x, false, slider_w, "Section Spacing X", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.spacing_section_x, slider, true)
Part.Gui.Macros.nextLine()

-- Section Spacing Y
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_gen_element_adj_spacing_section_y, false, slider_w, "Section Spacing Y", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.spacing_section_y, slider, true)

-- stretch group
group:stretchToPosition(nil, bottom_y)


-- Highlights
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(true, false, true)
group_x = Part.Cursor.getCursorX()
Part.Gui.Macros.drawGroupBox("Highlights", group_x, group_y, group_w, 100)

-- Selection Marker
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_gen_highlight_selection, false, slider_w, "Selection Bar", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.highlights_selectionbar_size, slider, true)
Part.Gui.Macros.nextLine()

-- Color Bar
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_gen_highlight_color, false, slider_w, "Color Bar", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.highlights_colorbar_size, slider, true)
Part.Gui.Macros.nextLine()

-- Selection Frame
button = Part.Gui.Macros.drawButtonToggleGroup(true, Part.Parameter.Map.par_mcp_gen_highlight_selectionframe, button_w_2, "Selection Frame", "Show", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.colors_tuning_selectionframe_activation, button, true)
Part.Gui.Macros.nextLine()

-- Folders
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(false, true, true)
group = Part.Gui.Macros.drawGroupBox("Folders", group_x, Part.Cursor.getCursorY(), group_w, 140)

-- Indentation
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_gen_folder_indent, false, slider_w, "Indentation", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.mcp_general_folder_indent, slider, true)
Part.Gui.Macros.nextLine()

-- Buttons
local selection = {
    { label = "Buttons", value = 1, width = button_w_2 },
    { label = "+ Lines", value = 2, width = button_w_2 }
}

-- Position
Part.Cursor.stackCursor()
button = Part.Gui.Macros.drawButtonSelectionGroup(true, Part.Parameter.Map.par_mcp_gen_folder_icon_folder, true, selection, "Folder Lane", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.tcp_general_folder_collapse_buttons, button[1], true)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.tcp_general_folder_collapse_lines, button[2], true)
Part.Gui.Macros.nextLine()

-- Folder Start Pad
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_gen_folder_pad_folder_parent, false, slider_w, "Folder Padding", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.mcp_general_folder_pad_first, slider, true)
Part.Gui.Macros.nextLine()

-- Folder Last Pad
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_gen_folder_pad_folder_last, false, slider_w, "Last Track Padding", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.mcp_general_folder_pad_last, slider, true)
Part.Gui.Macros.nextLine()

-- stretch group
group:stretchToPosition(nil, bottom_y)


-- ===========================================================================
--      Tab : MCP : Track A
-- ===========================================================================

-- Settings
-- ------------------------------

Part.Tab.Entry.setRecentTab(Part.Gui.Tab.tab_mcp_track_a)
Part.Gui.Macros.resetCursor()

local group_x = Part.Cursor.getCursorX()
local group_y = Part.Cursor.getCursorY()


-- Settings
-- ------------------------------

Part.Gui.Macros.drawGroupBox("Settings", group_x, Part.Cursor.getCursorY(), group_w, 130)

-- Extend Width
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_track_settings_extrapad, false, slider_w, "Side Padding", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.mcp_add_padding, slider, true)
Part.Gui.Macros.nextLine()
Part.Gui.Macros.nextSection(section_w)

-- Size
Part.Cursor.stackCursor()
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_track_settings_label_size, false, slider_w, "Label Height", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.mcp_add_padding, slider, true)
Part.Gui.Macros.nextLine()

-- Vertical
button = Part.Gui.Macros.drawButtonToggleGroup(true, Part.Parameter.Map.par_mcp_track_settings_label_vertical, button_w_2, "Orientation", "Vertical", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.mcp_label_orientation_vertical, button, true)
Part.Gui.Macros.nextLine()

-- Index Placement
selection = {
    { label = "Separate", value = 2, width = button_w_2 },
    { label = "In Label", value = 1, width = button_w_2 },
}

button = Part.Gui.Macros.drawButtonSelectionGroup(true, Part.Parameter.Map.par_mcp_track_settings_label_index, true, selection, "Index Placement", label_w)

Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.mcp_label_index_separate, button[1], true)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.mcp_label_index_in_label, button[2], true)

Part.Cursor.destackCursor()
Part.Gui.Macros.nextLine()


-- Inserts
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(false, true, true)
group = Part.Gui.Macros.drawGroupBox("Inserts", group_x, Part.Cursor.getCursorY(), group_w, 120)

-- Position
selection = {
    { label = "Top",   value = 1, width = button_w_3 },
    { label = "Side",  value = 3, width = button_w_3 },
    { label = "Embed", value = 2, width = button_w_3 },
}

button = Part.Gui.Macros.drawButtonSelectionGroup(true, Part.Parameter.Map.par_mcp_track_insert_mode, true, selection, "Placement", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.mcp_inserts_placement_top, button[1], true)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.mcp_inserts_placement_side, button[2], true)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.mcp_inserts_placement_embed, button[3], true)
Part.Gui.Macros.nextLine()


-- Side Padding
selection = {
    { label = "Minimal", value = 1, width = button_w_2 },
    { label = "Full",    value = 2, width = button_w_2 }
}

button = Part.Gui.Macros.drawButtonSelectionGroup(true, Part.Parameter.Map.par_mcp_track_insert_pad, true, selection, "Padding", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.mcp_inserts_padding_minimal, button[1], true)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.mcp_inserts_padding_full, button[2], true)
Part.Gui.Macros.nextLine()

-- Size
slider, button = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_track_insert_size, false, slider_w, "Size", label_w, Part.Parameter.Map.par_mcp_track_insert_size_scale[1])
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.mcp_inserts_size, slider, true)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.size_percentual, button, true)
Part.Gui.Macros.nextLine()

-- Size on Embed
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_track_insert_size_embed, false, slider_w, "Embed Size +", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.mcp_inserts_size_on_embed, slider, true)
Part.Gui.Macros.nextLine()

-- stretch group
group:stretchToPosition(nil, bottom_y)



-- Buttons
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(true, false, true)
group_x = Part.Cursor.getCursorX()
group = Part.Gui.Macros.drawGroupBox("Buttons", group_x, group_y, group_w, 372)

local visibility_data = {
    { label = "Input",       image = Part.Gui.Macros.icons.track.input,   separator = true,  index = 1 },
    { label = "Record Mode", image = Part.Gui.Macros.icons.track.recmode, separator = true,  index = 2 },
    { label = "In FX",       image = Part.Gui.Macros.icons.track.infx,    separator = true,  index = 3 },
    { label = "FX",          image = Part.Gui.Macros.icons.track.fx,      separator = true,  index = 4 },
    { label = "IO",          image = Part.Gui.Macros.icons.track.io,      separator = true,  index = 5 },
    { label = "Phase",       image = Part.Gui.Macros.icons.track.phase,   separator = true,  index = 6 },
    { label = "Mute",        image = Part.Gui.Macros.icons.track.mute,    separator = true,  index = 7 },
    { label = "Solo",        image = Part.Gui.Macros.icons.track.solo,    separator = true,  index = 8 },
    { label = "Rec Arm",     image = Part.Gui.Macros.icons.track.recarm,  separator = true,  index = 9 },
    { label = "Monitoring",  image = Part.Gui.Macros.icons.track.recmon,  separator = true,  index = 10 },
    { label = "Env",         image = Part.Gui.Macros.icons.track.env,     separator = false, index = 11 },
}

local matrix_data = {
    label_width = 90
}


-- Visibility Matrix
Part.Gui.Macros.drawVisibilityMatrix(matrix_data, visibility_data, Part.Parameter.Map.par_mcp_track_element_vis, nil, Part.Parameter.Map.par_mcp_track_element_separator)
Part.Cursor.incCursor(0, 4)

-- Layout
local selection = {
    { label = "S", value = 0, width = button_w_3 },
    { label = "M", value = 1, width = button_w_3 },
    { label = "W", value = 2, width = button_w_3 }
}

button = Part.Gui.Macros.drawButtonSelectionGroup(true, Part.Parameter.Map.par_mcp_track_element_width, false, selection, "Button Layout", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.mcp_button_layout_slim, button[1], true)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.mcp_button_layout_medium, button[2], true)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.mcp_button_layout_wide, button[3], true)
Part.Gui.Macros.nextLine()

-- Input Size
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_track_element_input_size, false, slider_w, "Input Size", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.mcp_button_recinput_size, slider, true)
Part.Gui.Macros.nextLine()

-- stretch group
group:stretchToPosition(nil, bottom_y)


-- ===========================================================================
--      Tab : MCP : Track B
-- ===========================================================================

-- Settings
-- ------------------------------

Part.Tab.Entry.setRecentTab(Part.Gui.Tab.tab_mcp_track_b)
Part.Gui.Macros.resetCursor()

local group_x = Part.Cursor.getCursorX()
local group_y = Part.Cursor.getCursorY()

-- Meter
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(false, true, true)
group = Part.Gui.Macros.drawGroupBox("Meter", group_x, group_y, group_w, 240)


local selection = {
    { label = "Top",    value = 1, width = button_w_2 },
    { label = "Bottom", value = 2, width = button_w_2 }
}

-- Position
button = Part.Gui.Macros.drawButtonSelectionGroup(true, Part.Parameter.Map.par_mcp_track_meter_pos, true, selection, "Placement", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.mcp_meter_placement_top, button[1], true)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.mcp_meter_placement_bottom, button[2], true)
Part.Gui.Macros.nextLine()

-- Side Padding
selection = {
    { label = "Minimal", value = 1, width = button_w_2 },
    { label = "Full",    value = 2, width = button_w_2 }
}

button = Part.Gui.Macros.drawButtonSelectionGroup(true, Part.Parameter.Map.par_mcp_track_meter_padding, true, selection, "Side Padding", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.mcp_meter_side_padding_minimal, button[1], true)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.mcp_meter_side_padding_full, button[2], true)
Part.Gui.Macros.nextLine()

-- Size
Part.Cursor.stackCursor()
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_track_meter_size, false, slider_w, "Size", label_w, Part.Parameter.Map.par_mcp_track_meter_size_scale[1])
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.mcp_meter_size, slider, true)
Part.Gui.Macros.nextLine()
Part.Gui.Macros.nextSection(section_w)

-- Volume Readout
selection = {
    { label = "Horizontal", value = 1, width = button_w_2 },
    { label = "Vertical",   value = 2, width = button_w_2 },
}

button = Part.Gui.Macros.drawButtonSelectionGroup(true, Part.Parameter.Map.par_mcp_track_meter_vol_readout, true, selection, "Volume Readout", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.mcp_meter_volume_readout_horizontal, button[1], true)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.mcp_meter_volume_readout_vertical, button[2], true)
Part.Gui.Macros.nextLine()

-- VU Text
button = Part.Gui.Macros.drawButtonToggleGroup(true, Part.Parameter.Map.par_mcp_track_meter_vu_db, button_w_full, "VU Text", "Show in Meter", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.tcp_meter_text, button, true)
Part.Gui.Macros.nextLine()

-- Clip Text
button = Part.Gui.Macros.drawButtonToggleGroup(true, Part.Parameter.Map.par_mcp_track_meter_vu_readout, button_w_full, "Clip Text", "Show in Meter", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.tcp_meter_clip_text, button, true)
Part.Gui.Macros.nextLine()
Part.Gui.Macros.nextSection(section_w)

-- VU Spacing
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_track_meter_channeldiv, false, slider_w, "Channel Spacing", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.tcp_meter_vu_space, slider, true)
Part.Gui.Macros.nextLine()

-- Gain Reduction Pad
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_track_meter_gaindiv, false, slider_w, "Gain R. Spacing", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.tcp_meter_gainreduction_space, slider, true)
Part.Gui.Macros.nextLine()

-- Gain Reduction Width
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_track_meter_gainwid, false, slider_w, "Gain R. Width", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.tcp_meter_gainreduction_width, slider, true)
Part.Gui.Macros.nextLine()
Part.Gui.Macros.nextSection(section_w)

-- Dynamic Size
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_track_meter_expand, false, slider_w, "Dynamic Size", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.mcp_meter_channel_expansion, slider, true)
Part.Gui.Macros.nextLine()

-- Expand Threshold
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_track_meter_expand_threshold, false, slider_w, "Threshold", label_w, nil, nil, true, true, 1, 2)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.mcp_meter_channel_expansion_threshold, slider, true)
Part.Gui.Macros.nextLine()

-- Fixed Expansion
button = Part.Gui.Macros.drawButtonToggleGroup(true, Part.Parameter.Map.par_mcp_track_meter_expand_mode, button_w_full, "Behaviour", "Expand only once", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.mcp_meter_channel_expansion_fixed, button, true)
Part.Gui.Macros.nextLine()

-- stretch group
group:stretchToPosition(nil, bottom_y)

-- Faders
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(true, false, true)
group_x = Part.Cursor.getCursorX()
group = Part.Gui.Macros.drawGroupBox("Faders", group_x, group_y, group_w, 220)

-- Fader Layout
Part.Gui.Macros.drawMcpLayoutConfiguration(Part.Parameter.Map.par_mcp_track_fader_layout)
Part.Gui.Macros.nextLine()
Part.Gui.Macros.nextSection(section_w)

-- Pan Fader Layout
local matrix_rows = {
    { label = "Pan Mode Mono",   value = 0, width = 40, parameter = Part.Parameter.Map.par_mcp_track_fader_pan_mode_mono },
    { label = "Pan Mode Stereo", value = 1, width = 70, parameter = Part.Parameter.Map.par_mcp_track_fader_pan_mode_stereo },
    { label = "Pan Mode Dual",   value = 2, width = 80, parameter = Part.Parameter.Map.par_mcp_track_fader_pan_mode_dual }
}
Part.Gui.Macros.drawMcpPanConfiguration(matrix_rows)
Part.Cursor.incCursor(0, 4, 0, 0)

-- Width
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_track_fader_pan_width, false, slider_w, "Pan Width", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.mcp_pan_section_width, slider,
    true)
Part.Gui.Macros.nextLine()

-- Height
slider, button = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_track_fader_pan_height, false, slider_w, "Pan Height", label_w, Part.Parameter.Map.par_mcp_track_fader_pan_height_scale[1])
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.mcp_pan_section_height, slider, true)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.size_percentual, button, true)
Part.Gui.Macros.nextLine()

-- Always Show Width
button = Part.Gui.Macros.drawButtonToggleGroup(true, Part.Parameter.Map.par_mcp_track_fader_wid_always, button_w_full, "Width", "Always Visible", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.mcp_always_show_width, button, true)
Part.Gui.Macros.nextLine()

-- stretch group
group:stretchToPosition(nil, bottom_y)

-- ===========================================================================
--      Tab : MCP : Master
-- ===========================================================================

-- Settings
-- ------------------------------

Part.Tab.Entry.setRecentTab(Part.Gui.Tab.tab_mcp_master)
Part.Gui.Macros.resetCursor()

local group_x = Part.Cursor.getCursorX()
local group_y = Part.Cursor.getCursorY()

-- Meter
-- ------------------------------

Part.Gui.Macros.drawGroupBox("Meter", group_x, group_y, group_w, 200)
local selection = {
    { label = "Top",    value = 1, width = button_w_2 },
    { label = "Bottom", value = 2, width = button_w_2 }
}

-- Position
button = Part.Gui.Macros.drawButtonSelectionGroup(true, Part.Parameter.Map.par_mcp_master_meter_pos, true, selection, "Placement", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.mcp_meter_placement_top, button[1], true)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.mcp_meter_placement_bottom, button[2], true)
Part.Gui.Macros.nextLine()

-- Side Padding
selection = {
    { label = "Minimal", value = 1, width = button_w_2 },
    { label = "Full",    value = 2, width = button_w_2 }
}

button = Part.Gui.Macros.drawButtonSelectionGroup(true, Part.Parameter.Map.par_mcp_master_meter_padding, true, selection, "Side Padding", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.mcp_meter_side_padding_minimal, button[1], true)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.mcp_meter_side_padding_full, button[2], true)
Part.Gui.Macros.nextLine()

-- Size
Part.Cursor.stackCursor()
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_master_meter_size, false, slider_w, "Size", label_w,
    Part.Parameter.Map.par_mcp_master_meter_size_scale[1])
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.mcp_meter_size, slider, true)
Part.Gui.Macros.nextLine()
Part.Gui.Macros.nextSection(section_w)

-- Volume Readout
selection = {
    { label = "Horizontal", value = 1, width = button_w_2 },
    { label = "Vertical",   value = 2, width = button_w_2 },
}

button = Part.Gui.Macros.drawButtonSelectionGroup(true, Part.Parameter.Map.par_mcp_master_meter_vol_readout, true, selection, "Volume Readout", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.mcp_meter_volume_readout_horizontal, button[1], true)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.mcp_meter_volume_readout_vertical, button[2], true)
Part.Gui.Macros.nextLine()

-- VU Text
button = Part.Gui.Macros.drawButtonToggleGroup(true, Part.Parameter.Map.par_mcp_master_meter_vu_db, button_w_full, "VU Text", "Show in Meter", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.tcp_meter_text, button, true)
Part.Gui.Macros.nextLine()

-- Clip Text
button = Part.Gui.Macros.drawButtonToggleGroup(true, Part.Parameter.Map.par_mcp_master_meter_vu_readout, button_w_full, "Clip Text", "Show in Meter", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.tcp_meter_clip_text, button, true)
Part.Gui.Macros.nextLine()
Part.Gui.Macros.nextSection(section_w)

-- VU Spacing
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_master_meter_channeldiv, false, slider_w, "Channel Spacing", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.tcp_meter_vu_space, slider, true)
Part.Gui.Macros.nextLine()


-- Inserts
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(false, true, true)
group = Part.Gui.Macros.drawGroupBox("Inserts", group_x, Part.Cursor.getCursorY(), group_w, 100)

-- Position
selection = {
    { label = "Top",  value = 1, width = button_w_2 },
    { label = "Side", value = 2, width = button_w_2 },
}

button = Part.Gui.Macros.drawButtonSelectionGroup(true, Part.Parameter.Map.par_mcp_master_insert_mode, true, selection, "Placement", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.mcp_inserts_placement_top, button[1], true)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.mcp_inserts_placement_side, button[2], true)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.mcp_inserts_placement_embed, button[3], true)
Part.Gui.Macros.nextLine()


-- Side Padding
selection = {
    { label = "Minimal", value = 1, width = button_w_2 },
    { label = "Full",    value = 2, width = button_w_2 }
}

button = Part.Gui.Macros.drawButtonSelectionGroup(true, Part.Parameter.Map.par_mcp_master_insert_pad, true, selection, "Padding", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.mcp_inserts_padding_minimal, button[1], true)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.mcp_inserts_padding_full, button[2], true)
Part.Gui.Macros.nextLine()

-- Size
slider, button = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_master_insert_size, false, slider_w, "Size", label_w,
    Part.Parameter.Map.par_mcp_master_insert_size_scale[1])
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.mcp_inserts_size, slider, true)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.size_percentual, button, true)
Part.Gui.Macros.nextLine()

-- Settings
-- ------------------------------
Part.Gui.Macros.placeCursorAtLastGroup(false, true, true)

group = Part.Gui.Macros.drawGroupBox("Settings", group_x, Part.Cursor.getCursorY(), group_w, 80)

-- Extend Width
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_master_settings_extrapad, false, slider_w, "Side Padding", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.mcp_add_padding, slider, true)
Part.Gui.Macros.nextLine()

-- Menu Button Size
Part.Cursor.stackCursor()
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_master_settings_label_size, false, slider_w, "Menu Button Size", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.mcp_master_menu_button, slider, true)
Part.Gui.Macros.nextLine()

-- stretch group
group:stretchToPosition(nil, bottom_y)


-- Faders
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(true, false, true)
group_x = Part.Cursor.getCursorX()
group = Part.Gui.Macros.drawGroupBox("Faders", group_x, group_y, group_w, 220)

-- Fader Layout
Part.Gui.Macros.drawMcpLayoutConfiguration(Part.Parameter.Map.par_mcp_master_fader_layout)
Part.Gui.Macros.nextLine()
Part.Gui.Macros.nextSection(section_w)

-- Pan Fader Layout
local matrix_rows = {
    { label = "Pan Mode Mono",   value = 0, width = 40, parameter = Part.Parameter.Map.par_mcp_master_fader_pan_mode_mono },
    { label = "Pan Mode Stereo", value = 1, width = 70, parameter = Part.Parameter.Map.par_mcp_master_fader_pan_mode_stereo },
    { label = "Pan Mode Dual",   value = 2, width = 80, parameter = Part.Parameter.Map.par_mcp_master_fader_pan_mode_dual }
}
Part.Gui.Macros.drawMcpPanConfiguration(matrix_rows)
Part.Cursor.incCursor(0, 4, 0, 0)

-- Width
slider = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_master_fader_pan_width, false, slider_w,
    "Pan Width", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.mcp_pan_section_width, slider,
    true)
Part.Gui.Macros.nextLine()

-- Height
slider, button = Part.Gui.Macros.drawSliderGroup(true, Part.Parameter.Map.par_mcp_master_fader_pan_height, false,
    slider_w, "Pan Height", label_w,
    Part.Parameter.Map.par_mcp_master_fader_pan_height_scale[1])
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.mcp_pan_section_height, slider, true)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.size_percentual, button, true)
Part.Gui.Macros.nextLine()

-- Always Show Width
button = Part.Gui.Macros.drawButtonToggleGroup(true, Part.Parameter.Map.par_mcp_master_fader_wid_always, button_w_full, "Width", "Always Visible", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.mcp_always_show_width, button, true)
Part.Gui.Macros.nextLine()


-- Buttons
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(false, true, true)
group = Part.Gui.Macros.drawGroupBox("Buttons", group_x, Part.Cursor.getCursorY(), group_w, 240)

local visibility_data = {
    { label = "FX",   image = Part.Gui.Macros.icons.track.fx,   separator = true,  index = 1 },
    { label = "IO",   image = Part.Gui.Macros.icons.track.io,   separator = true,  index = 2 },
    { label = "Mono", image = Part.Gui.Macros.icons.track.mono, separator = true,  index = 3 },
    { label = "Mute", image = Part.Gui.Macros.icons.track.mute, separator = true,  index = 4 },
    { label = "Solo", image = Part.Gui.Macros.icons.track.solo, separator = true,  index = 5 },
    { label = "Env",  image = Part.Gui.Macros.icons.track.env,  separator = false, index = 6 },
}

local matrix_data = {
    label_width = 55
}


-- Visibility Matrix
Part.Gui.Macros.drawVisibilityMatrix(matrix_data, visibility_data, Part.Parameter.Map.par_mcp_master_element_vis, nil, Part.Parameter.Map.par_mcp_master_element_separator)
Part.Cursor.incCursor(0, 4)

-- Layout
local selection = {
    { label = "S", value = 0, width = button_w_3 },
    { label = "M", value = 1, width = button_w_3 },
    { label = "W", value = 2, width = button_w_3 }
}

button = Part.Gui.Macros.drawButtonSelectionGroup(true, Part.Parameter.Map.par_mcp_master_element_width, false, selection, "Button Layout", label_w)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.mcp_button_layout_slim, button[1], true)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.mcp_button_layout_medium, button[2], true)
Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.mcp_button_layout_wide, button[3], true)
Part.Gui.Macros.nextLine()



-- stretch group
group:stretchToPosition(nil, bottom_y)


-- ===========================================================================
--      Tab : Custom
-- ===========================================================================

-- ------------------------------
-- Settings

Part.Tab.Entry.setRecentTab(Part.Gui.Tab.tab_custom)
Part.Gui.Macros.resetCursor()

local group_x = Part.Cursor.getCursorX()
local group_y = Part.Cursor.getCursorY()

-- distancer between rows
local custom_spacer = 10

-- Range Adjustments
-- ------------------------------

group = Part.Gui.Macros.drawGroupBox("Range Adjustments", group_x, group_y, group_w, 420)

local custom_parmaeter_settings = Part.Parameter.CustomParameterSettings

-- definition
local parameters = {
    { par = Part.Parameter.Map.par_user_range_0,  bank = true },
    { par = Part.Parameter.Map.par_user_range_1,  bank = true },
    { par = Part.Parameter.Map.par_user_range_2,  bank = true },
    { par = Part.Parameter.Map.par_user_range_3,  bank = true },
    { par = Part.Parameter.Map.par_user_range_4,  bank = true },
    { par = Part.Parameter.Map.par_user_range_5,  bank = true },
    { par = Part.Parameter.Map.par_user_range_6,  bank = true },
    { par = Part.Parameter.Map.par_user_range_7,  bank = true },
    { par = Part.Parameter.Map.par_user_range_8,  bank = true },
    { par = Part.Parameter.Map.par_user_range_9,  bank = true },
    { par = Part.Parameter.Map.par_user_range_10, bank = true },
    { par = Part.Parameter.Map.par_user_range_11, bank = true },
    { par = Part.Parameter.Map.par_user_range_12, bank = true },
    { par = Part.Parameter.Map.par_user_range_13, bank = true },
    { par = Part.Parameter.Map.par_user_range_14, bank = true },
    { par = Part.Parameter.Map.par_user_range_15, bank = true },
}

-- parameters
for idx, parameter in pairs(parameters) do
    local hint_msg = Part.Functions.deepCopy(Part.Hint.Lookup.custom_range)
    local parameter_name = "par_user_range_" .. tostring(idx - 1)
    table.insert(hint_msg, { type = Part.Hint.Lookup.HintTypes.tip, text = "WALTER Address:" })
    table.insert(hint_msg, { type = Part.Hint.Lookup.HintTypes.tip, text = parameter_name })

    -- info if there's no bank and sync support
    if not parameter.bank then
        table.insert(hint_msg, Part.Hint.Lookup.line_stored_per_theme_file)
    end

    -- get label name
    local label_name = parameter_name

    if custom_parmaeter_settings["adjustments"] ~= nil then
        if custom_parmaeter_settings.adjustments[idx] ~= nil then
            label_name = custom_parmaeter_settings.adjustments[idx]
        end
    end

    -- slider
    slider = Part.Gui.Macros.drawSliderGroup(parameter.bank, parameter.par, false, slider_w, label_name, label_w)

    -- hint
    Part.Control.Hint.Hint:new(nil, hint_msg, slider, true)

    -- next line
    Part.Gui.Macros.nextLine()

    -- divider
    if idx % 4 == 0 then
        Part.Cursor.incCursor(0, custom_spacer, 0, 0)
    end
end

-- stretch group
group:stretchToPosition(nil, bottom_y)


-- Multiple Choice Buttons
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(true, false, true)
group_x = Part.Cursor.getCursorX()
Part.Gui.Macros.drawGroupBox("Multiple-Choice", group_x, group_y, group_w, 220)

-- definition
local parameters = {
    { par = Part.Parameter.Map.par_user_selection_0, bank = true },
    { par = Part.Parameter.Map.par_user_selection_1, bank = true },
    { par = Part.Parameter.Map.par_user_selection_2, bank = true },
    { par = Part.Parameter.Map.par_user_selection_3, bank = true },
    { par = Part.Parameter.Map.par_user_selection_4, bank = true },
    { par = Part.Parameter.Map.par_user_selection_5, bank = true },
    { par = Part.Parameter.Map.par_user_selection_6, bank = true },
    { par = Part.Parameter.Map.par_user_selection_7, bank = true },
}

-- parameters
for idx, parameter in pairs(parameters) do
    local hint_msg = Part.Functions.deepCopy(Part.Hint.Lookup.custom_selection)
    local parameter_name = "par_user_selection_" .. tostring(idx - 1)
    table.insert(hint_msg, { type = Part.Hint.Lookup.HintTypes.tip, text = "WALTER Address:" })
    table.insert(hint_msg, { type = Part.Hint.Lookup.HintTypes.tip, text = parameter_name })


    -- values
    local selection = {
        { label = "A", value = 0, width = 16 },
        { label = "B", value = 1, width = 16 },
        { label = "C", value = 2, width = 16 },
        { label = "D", value = 3, width = 16 },
        { label = "E", value = 4, width = 16 },
        { label = "F", value = 5, width = 16 },
    }

    -- get label name
    local label_name = parameter_name

    if custom_parmaeter_settings["choices"] ~= nil then
        if custom_parmaeter_settings.choices[idx] ~= nil then
            label_name = custom_parmaeter_settings.choices[idx]
        end
    end

    -- button
    button = Part.Gui.Macros.drawButtonSelectionGroup(parameter.bank, parameter.par, false, selection, label_name, label_w)

    -- hint
    for button_idx, button_entry in pairs(button) do
        local button_hint_msg = Part.Functions.deepCopy(hint_msg)
        table.insert(button_hint_msg,
            { type = Part.Hint.Lookup.HintTypes.tip, text = "Target Value: " .. tostring(button_idx - 1) })

        -- info if there's no bank and sync support
        if not parameter.bank then
            table.insert(button_hint_msg, Part.Hint.Lookup.line_stored_per_theme_file)
        end

        Part.Control.Hint.Hint:new(nil, button_hint_msg, button_entry, true)
    end

    -- next line
    Part.Gui.Macros.nextLine()

    -- divider
    if idx % 4 == 0 then
        Part.Cursor.incCursor(0, custom_spacer, 0, 0)
    end
end



-- Toggle Buttons
-- ------------------------------

Part.Gui.Macros.placeCursorAtLastGroup(false, true, true)
group_y = Part.Cursor.getCursorY()
group = Part.Gui.Macros.drawGroupBox("Toggle Buttons", group_x, group_y, group_w, 220)

-- definition
local parameters = {
    { par = Part.Parameter.Map.par_user_switch_0, bank = true },
    { par = Part.Parameter.Map.par_user_switch_1, bank = true },
    { par = Part.Parameter.Map.par_user_switch_2, bank = true },
    { par = Part.Parameter.Map.par_user_switch_3, bank = true },
    { par = Part.Parameter.Map.par_user_switch_4, bank = true },
    { par = Part.Parameter.Map.par_user_switch_5, bank = true },
    { par = Part.Parameter.Map.par_user_switch_6, bank = true },
    { par = Part.Parameter.Map.par_user_switch_7, bank = true },
}

-- parameters
for idx, parameter in pairs(parameters) do
    local hint_msg = Part.Functions.deepCopy(Part.Hint.Lookup.custom_button)
    local parameter_name = "par_user_switch_" .. tostring(idx - 1)
    table.insert(hint_msg, { type = Part.Hint.Lookup.HintTypes.tip, text = "WALTER Address:" })
    table.insert(hint_msg, { type = Part.Hint.Lookup.HintTypes.tip, text = parameter_name })

    -- info if there's no bank and sync support
    if not parameter.bank then
        table.insert(hint_msg, Part.Hint.Lookup.line_stored_per_theme_file)
    end

    -- get label name
    local label_name = parameter_name

    if custom_parmaeter_settings["buttons"] ~= nil then
        if custom_parmaeter_settings.buttons[idx] ~= nil then
            label_name = custom_parmaeter_settings.buttons[idx]
        end
    end


    -- button
    button = Part.Gui.Macros.drawButtonToggleGroup(parameter.bank, parameter.par, 40, label_name, "On", label_w)

    -- hint
    Part.Control.Hint.Hint:new(nil, hint_msg, button, true)

    -- next line
    Part.Gui.Macros.nextLine()

    -- divider
    if idx % 4 == 0 then
        Part.Cursor.incCursor(0, custom_spacer, 0, 0)
    end
end

-- stretch group
group:stretchToPosition(nil, bottom_y)
