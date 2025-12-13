-- @version 1.2.6
-- @author Fleeesch
-- @description paRt Theme Adjuster
-- @noIndex

--[[
    Global variables, but stored in a LUA table in this case.
    
    There are a lot things that be adjusted here to change and break things.    
]]

local var = { globals = {}, list = {} }

--  OS detection
-- -------------------------------------------

var.globals.os_windows = false
var.globals.os_macos = false
var.globals.os_linux = false



-- windows
if reaper.GetOS():match("^Win") ~= nil then
    var.globals.os_windows = true
else
    -- mac os font size reduction
    local os_mac = { "OSX32", "OSX64", "macOS-arm64" }

    for _, entry in ipairs(os_mac) do
        local current_os = string.lower(reaper.GetOS())
        if string.find(current_os, string.lower(entry)) then
            var.globals.os_macos = true
            break
        end
    end

    -- linux if nothing else matches
    var.globals.os_linux = true
end

--  Globals
-- -------------------------------------------

-- theme lookup list
var.globals.themes = { "dark", "dimmed", "light" }

-- theme flags
var.globals.theme_is_unpacked = false
var.globals.theme_is_modded = false
var.globals.theme_is_part = false

-- paRt provided zoom levels
var.globals.zoom_levels = { 1, 1.25, 1.5, 1.75, 2, 2.25, 2.5 }

-- initial loading of parameters
var.globals.initial_load = false

-- global counter for time tracking
var.globals.ticks = 0

-- prevent stuff from happening during startup
var.globals.startup_delay = 8
var.globals.startup = false

-- fade-in time
var.globals.fade_in = 8

-- pending parameter save
var.globals.pending_save = 0
var.globals.pending_save_delay = 30

-- ext state section string
var.globals.ext_section = "Fleeesch - paRt Theme Adjuster"

-- default window title
var.globals.win_title = "paRt Theme Adjuster"

-- availability of the js_extension
var.js_extension_available = false

-- last used theme adjuster (for detecting theme changes)
var.globals.last_theme_file = reaper.GetLastColorThemeFile()

-- window default coordinates
var.globals.winpos_default_x = 50
var.globals.winpos_default_y = 50
var.globals.win_x = 0
var.globals.win_y = 0
var.globals.win_w = 780
var.globals.win_h = 545
var.globals.hint_x = 575
var.globals.hint_y = 45
var.globals.hint_w = 200
var.globals.hint_h = 450
var.globals.pad_x = 6
var.globals.pad_y = 6
var.globals.win_w_last = var.globals.win_w
var.globals.win_h_last = var.globals.win_h
var.globals.win_aratio = var.globals.win_w / var.globals.win_h
var.globals.win_x_offset = 0
var.globals.win_y_offset = 0
var.globals.win_x_offset_centered = 0
var.globals.win_y_offset_centered = 0

-- refresh theme once per draw when true
var.globals.refresh_theme = false
var.globals.refresh_theme_rate = 5
var.globals.refresh_theme_clock = 0
var.globals.refresh_theme_rate_threshold = 25
var.globals.parameter_buffer_time = 5

-- Bank Bar size
var.globals.bank_bar_size = 30

-- scaling corner traiangle
var.globals.bank = Part.Parameter.Parameter:new(nil, "Bank", 0, 0, 9, 1)
var.globals.bank_count = 8

-- infobar height
var.globals.infobar_h = 14

-- draw edge highlights under elements
var.globals.draw_edge_highlights = false

-- gui state
var.globals.gui_closed = false

-- image transparency
var.globals.img_alpha = 1
var.globals.img_header_alpha = 0.75

-- hint delay and fade-time
var.globals.hint_delay = 15
var.globals.hint_fade = 8

-- height of tabs
var.globals.tab_height = 20

-- global scale factor
gfx.ext_retina = 1
var.globals.scale = 1

-- main loop enabler
var.globals.keep_running = true

-- restart the theme when pressing "t"
var.globals.restart_shortcut = true

-- path to configuration files
var.globals.config_dir = ScriptPath .. "conf"
var.globals.config_custom_parameter_settings_file = "custom_parameters.lua"
var.globals.config_custom_parameter_settings_file_fallback = "custom_parameters.lua.def"
var.globals.config_user_path = "user"

-- theme selection parameter (for load theme button feedback)
var.globals.par_theme_selected = Part.Parameter.Parameter:new(nil, "par_theme_selected", 0, 0, 3, true)

-- visible element update
var.globals.update_visible_elements = false

-- aspect ratio check
var.globals.aspect_ratio_ok = true


--  Lists
-- -------------------------------------------

-- elements
var.list.visible_elements = {}
var.list.visible_layout = {}
var.list.visible_layout_spacer = {}
var.list.visible_layout_image = {}
var.list.visible_layout_text = {}
var.list.visible_layout_redraw = {}
var.list.visible_control = {}
var.list.visible_control_hint = {}
var.list.visible_editor_area = {}


-- routines
var.list.routine = {}

-- bank elements
var.list.bank_parameter_set = {}
var.list.bank_slot = {}

-- control eelements
var.list.control = {}
var.list.control_hint = {}
var.list.control_button_bank = {}
var.list.control_button_bank_select = {}
var.list.control_button_config_select = {}
var.list.control_button = {}
var.list.control_marker = {}
var.list.control_sliders = {}
var.list.control_knobs = {}

-- layout
var.list.layout = {}
var.list.layout_label = {}
var.list.layout_redraw = {}
var.list.layout_text = {}
var.list.layout_group = {}
var.list.layout_image = {}

-- message
var.list.message = {}

-- parameters
var.list.parameter = {}
var.list.parameter_group = {}
var.list.reaper_parameter = {}
var.list.banked_parameter = {}
var.list.theme_parameter = {}
var.list.theme_parameter_buffer = {}

-- tab elements
var.list.tab_entry = {}
var.list.tab_group = {}

var.list.part_light_theme = false
var.list.last_theme_file = ""

-- pending actions (triggerd at the end of draw)
var.list.pending_action = {}


return var
