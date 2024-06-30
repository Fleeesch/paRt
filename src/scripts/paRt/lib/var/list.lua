local list = {}

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Lists
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

-- elements
list.visible_elements = {}
list.visible_layout = {}
list.visible_layout_spacer = {}
list.visible_layout_image = {}
list.visible_layout_text = {}
list.visible_layout_redraw = {}
list.visible_control = {}
list.visible_control_hint = {}
list.visible_editor_area = {}


-- editor area
list.editor_area = {}

-- routines
list.routine = {}

-- bank elements
list.bank_parameter_set = {}
list.bank_slot = {}

-- control eelements    
list.control = {}
list.control_hint = {}
list.control_button_bank = {}
list.control_button_bank_select = {}
list.control_button = {}
list.control_marker = {}
list.control_reorder_set = {}
list.control_reorder = {}
list.control_sliders = {}
list.control_knobs = {}

-- layout
list.layout = {}
list.layout_label = {}
list.layout_redraw = {}
list.layout_text = {}
list.layout_group = {}
list.layout_image = {}

-- message
list.message = {}

-- parameters
list.parameter = {}
list.parameter_group = {}
list.reaper_parameter = {}
list.banked_parameter = {}
list.theme_parameter = {}
list.theme_parameter_buffer = {}

-- tab elements
list.tab_entry = {}
list.tab_group = {}

list.part_light_theme = false
list.last_theme_file = ""

-- pending actions (triggerd at the end of draw)
list.pending_action = {}


return list