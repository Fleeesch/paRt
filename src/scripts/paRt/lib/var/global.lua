local globals = {}

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Globals
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

-- initial loading of parameters
globals.initial_load = false

-- global counter for time tracking
globals.ticks = 0

-- prevent stuff from happening during startup
globals.startup_delay = 8
globals.startup = false

-- fade-in time
globals.fade_in = 8

-- pending parameter save
globals.pending_save = 0
globals.pending_save_delay = 30

-- ext state section string
globals.ext_section = "Fleeesch - paRt Theme Adjuster"

-- default window title
globals.win_title = "paRt Theme Adjuster"


-- last used theme adjuster (for detecting theme changes)
globals.last_theme_file = reaper.GetLastColorThemeFile()

-- window default coordinates
globals.winpos_default_x = 50
globals.winpos_default_y = 50
globals.win_x = 0
globals.win_y = 0
globals.win_w = 640
globals.win_h = 540
globals.pad_x = 6
globals.pad_y = 6
globals.win_w_last = globals.win_w
globals.win_h_last = globals.win_h
globals.win_aratio = globals.win_w/globals.win_h
globals.win_x_offset = 0
globals.win_y_offset = 0
globals.win_x_offset_centered = 0
globals.win_y_offset_centered = 0

-- refresh theme once per draw when true
globals.refresh_theme = false
globals.refresh_theme_rate = 5
globals.refresh_theme_clock = 0
globals.refresh_theme_rate_threshold = 25

-- Bank Bar size
globals.bank_bar_size = 40

-- scaling corner traiangle
globals.bank = Part.Parameter.Parameter:new(nil, "Bank", 0, 0, 9, 1)
globals.bank_count = 8

-- scaling corner traiangle
globals.corner_triangle_size = 14

-- draw edge highlights under elements
globals.draw_edge_highlights = false

-- gui state
globals.gui_closed = false

-- image transparency
globals.img_alpha = 1
globals.img_header_alpha = 0.75

-- hint delay and fade-time
globals.hint_delay = 15
globals.hint_fade = 8

-- row shading thickness
globals.row_shading_expansion = 1

-- height of tabs
globals.tab_height = 24

-- default control segmentation
globals.label_control = {0.45, 0.55}
globals.label_control_button = {0.45, 0.4, 0.15}

-- global scale factor
gfx.ext_retina = 1
globals.scale = 1

-- main loop enabler
globals.keep_running = true

-- restart the theme when pressing "t"
globals.restart_shortcut = true

-- path to configuration files
globals.config_dir = ScriptPath .. "conf"

-- theme selection parameter (for load theme button feedback)
globals.par_theme_selected = Part.Parameter.Parameter:new(nil, "par_theme_selecteds", 0, 0, 3, true)

-- visible element update
globals.update_visible_elements = false

-- window drawing timeout
globals.drawing_timeout = 10
globals.drawing_timeout_counter = 0
globals.drawing_timeout_fadeout = 5
globals.drawing_timeout_fadeout_counter = 0

globals.aspect_ratio_ok = true

return globals