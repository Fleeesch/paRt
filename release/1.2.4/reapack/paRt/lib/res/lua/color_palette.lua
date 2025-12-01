-- @version 1.2.4
-- @author Fleeesch
-- @description paRt Theme Adjuster
-- @noIndex


--[[
    This file stores the Theme Adjuster color schemes and some management tools.
    The base palette is used by the dark theme by default.
    The themes use the base palette as their basis and then overwrite the original entries
    with their own individual values.
]]--

local color = {}

-- ======================================================================
--                          Color Palettes
-- ======================================================================

-- ~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-
--          Base Palette
-- ~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-

-- global colors
color.color_base = {

    -- Sample
    -- ------------------
    sample = {
        shadow = { 40, 40, 40 },
        drop_shadow = { 0, 0, 0, 0.2 },
        border = { 0, 0, 0 },
        palette = {
            { 0,   255, 0 },
            { 0,   0,   255 },
            { 0,   255, 255 },
            { 0,   255 },
            { 255, 0,   0 },
        }
    },

    -- Background
    bg = { 45, 45, 45, 1 },

    -- Markers
    line = { 0, 0, 0, 0.75 },
    box = {
        fill = { 0, 0, 0, 0.15 },
        border = { 0, 0, 0, 0 },
    },

    --  Paths
    -- ------------------
    path = {
        icon = "",
        icon_table = "dark"
    },

    --  Main Colors
    -- ------------------
    color = {
        cyan = { 84, 185, 147 },
        blue = { 100, 167, 196 },
        red = { 181, 66, 66 },
        yellow = { 208, 171, 92 },
        violet = { 123, 94, 187 },
        gray = { 157, 157, 157 },
        green = { 108, 185, 84 },
    },

    --  Theme Hint
    -- ------------------
    theme_hint = {
        unpacked = { 100, 255, 150, 0.4 },
        modded = { 255, 150, 150, 0.4 }
    },

    --  Modulation
    -- ------------------
    mod = {
        lighten_hover = 0.1,
        lighten_click = 0.3,
        lighten_hint = { 1.05, 0.05 }
    },

    --  Buttons
    -- ------------------
    button = {
        off_bg = { 40, 40, 40, 1 },
        off_fg = { 190, 190, 190, 1 },
        on_fg = { 0, 0, 0, 1 },
        border = { 20, 20, 20, 1 },

        selection = {
            off_bg = { 50, 50, 50, 1 },
            off_fg = { 150, 150, 150, 1 },
            on_fg = { 0, 0, 0, 1 },
            border = { 20, 20, 20, 1 },
        },

        bank = {
            off_bg = { 50, 50, 50 },
            off_fg = { 125, 125, 125 },
            off_border = { 20, 20, 20 },
            on_fg = { 10, 10, 10 },
            on_border = { 20, 20, 20 },
        },

    },

    --  Blur Modulation
    -- ------------------
    blur = {
        mul = { 0.05, 0.05, 0.05, 1 },
        add = { 0.1, 0.1, 0.1, 0 },
        factor = 1
    },

    --  Infobar (Keyboard Shortcuts)
    -- ------------------------------
    infobar = {
        backdrop = { 60, 60, 60, 1 },
        bg = { 20, 20, 20, 1 },
        fg = { 100, 100, 100, 1 },
        label = {
            fg = { 150, 150, 150 },
            frame = { 90, 90, 90, 1 }
        }
    },

    --  Bank Bar
    -- ------------------
    bank_bar = {
        bg = { 60, 60, 60, 1 },
        border = { 20, 20, 20, 1 },

        button = {
            off_bg = { 30, 30, 30, 1 },
            off_fg = { 170, 170, 170, 1 },
            on_fg = { 0, 0, 0, 1 },
            border = { 20, 20, 20, 1 },
            submit_overlay = { 200, 100, 100, 0.25 },

            copy = {
                off_bg = { 70, 50, 50, 1 },
                off_fg = { 175, 175, 175, 1 },
                on_bg = { 200, 100, 100, 1 },
                on_fg = { 0, 0, 0, 1 },
                src_bg = { 40, 40, 40, 1 },
                src_fg = { 80, 80, 80, 1 },
            }
        }
    },

    --  Theme Error Message
    -- -----------------------
    theme_error = {
        bg = { 50, 50, 50, 1 },
        fg = { 200, 200, 200, 1 },
        fg_info = { 150, 150, 150, 1 },
    },

    --  Popup Message
    -- ------------------
    message = {
        bg = { 30, 50, 40, 1 },
        fg = { 200, 200, 200, 1 },
        error_bg = { 75, 40, 40, 1 },
        error_fg = { 225, 200, 200, 1 },
        border = { 0, 0, 0, 0.5 },
        shadow = { 0, 0, 0, 0.25 }
    },

    --  Hover Hint Message
    -- ---------------------
    hint = {
        stage_bg = { 45, 45, 45, 1 },
        bg = { 30, 30, 30, 0 },
        fg = { 200, 200, 200, 1 },
        highlight_fg = { 255, 255, 255, 1 },
        highlight_bg = { 255, 255, 255, 0 },
        tip_bg = { 30, 30, 75, 0 },
        tip_fg = { 160, 210, 230, 1 },
        attention_bg = { 255, 255, 255, 0 },
        attention_fg = { 225, 225, 150, 1 },
        warning_bg = { 50, 15, 15, 0 },
        warning_fg = { 225, 175, 175, 1 },
        controls_fg = { 255, 255, 255, 0.3 },
        controls_fg_desc = { 255, 255, 255, 0.4 }
    },

    --  Splash Message
    -- ---------------------
    splash = {
        bg = { 0.35, 0.35, 0.35, 0 },
        border = { 255, 255, 255, 0 },
        shadow = { 0, 0, 0, 1 },
        fg = { 200, 200, 200, 1 }
    },

    --  Radio Button
    -- ---------------------
    marker = {
        border = { 10, 10, 10 },
        bg_off = { 30, 30, 30 },
    },

    --  Parameter Set Shading
    -- --------------------------
    label = {
        bg = { 0, 0, 0, 0 },
        border = { 0, 0, 0, 0 }
    },

    --  Text Labels
    -- --------------------------
    text = {
        bg = { 0, 255, 0, 1 },
        fg = { 1, 255, 1 },
        border = { 0, 255, 0 },
        underline = { 0, 0, 0, 0.25 },

        parameter = {
            fg = { 200, 200, 200, 1 },
            bg = { 0, 0, 0, 0 },
            border = { 0, 0, 0, 0 }
        },

        monitor = {
            fg = { 180, 180, 180, 1 },
            bg = { 50, 50, 50, 1 },
            border = { 0, 0, 0, 0 }
        }

    },

    --  Table Content
    -- --------------------------
    table = {
        header_fg = { 200, 200, 200, 1 },
        entry_fg = { 175, 175, 175, 1 },
        empty_space = { 0, 0, 0, 0 },
        row_even = { 0, 0, 0, 0.15 },
        row_uneven = { 0, 0, 0, 0.1 },
        column_even = { 0, 0, 0, 0 },
        column_uneven = { 0, 0, 0, 0 },
    },

    --  Tab Selection
    -- --------------------------
    tab = {
        bg = { 40, 40, 40, 1 },
        bg_sub = { 65, 65, 65, 1 },
        off_bg = { 40, 40, 40, 1 },
        off_fg = { 125, 125, 125, 1 },
        on_bg = { 65, 65, 65, 1 },
        on_fg = { 200, 200, 200, 1 },
        sub = {
            off_bg = { 65, 65, 65, 1 },
            off_fg = { 140, 140, 140, 1 },
            on_fg = { 180, 180, 180, 1 },
        },
        shadow = { 0, 0, 0, 0.5 }
    },

    --  Element Groups
    -- --------------------------
    group = {
        bg = { 65, 65, 65, 1 },
        fg = { 150, 150, 150, 1 },
        border = { 0, 0, 0, 0 },

        header = {
            fg = { 125, 125, 125 },
            bg = { 30, 30, 30 },
            border = { 255, 255, 255, 0.25 }
        },
        section = {
            line = { 0, 0, 0, 0.15 }
        },
        inline_header = {
            fg = { 255, 255, 255, 0.4 },
            bg = { 0, 0, 0, 0.2 },
            underline = { 0, 0, 0, 0 }
        }
    },

    --  Slider
    -- --------------------------
    slider = {
        bg = { 30, 30, 30, 1 },
        border = { 20, 20, 20 },
        knob_border = { 10, 10, 10 },
        knob = { 180, 180, 180, 0.9 },
        gradient_knob = { 255, 255, 255, 0.5 },
        gradient_border = { 20, 20, 20 },
        slot_default = { 255, 255, 255, 0.4 },
        value_fill = { 84, 185, 147, 0.2 },
    },

    --  Knobs
    -- --------------------------
    knob = {
        bg = { 25, 25, 25, 1 },
        fg = { 200, 200, 200, 1 },
        border = { 0, 0, 0, 0.8 },
        default = { 255, 255, 255, 0.2 },
    },

    --  Gradients
    -- --------------------------
    gradient = {
        slider = {
            hue = { { 1, 0.2, 0.5, 1 }, { 0.9, 0.9, 0, 1 }, { 0, 1, 0.7, 1 }, { 0.5, 0, 1, 1 }, { 1, 0.2, 0.5, 1 } },
            saturation = { { 0.6, 0.6, 0.6, 1 }, { 0, 0.7, 0.5, 1 }, { 0, 1, 0.65, 1 } },
            gamma = { { 0.2, 0.2, 0.2, 1 }, { 0.4, 0.4, 0.4, 1 }, { 0.7, 0.7, 0.7, 1 } },
            highlights = { { 0.2, 0.2, 0.2, 1 }, { 0.4, 0.4, 0.4, 1 }, { 0.7, 0.7, 0.7, 1 } },
            midtones = { { 0.2, 0.2, 0.2, 1 }, { 0.4, 0.4, 0.4, 1 }, { 0.7, 0.7, 0.7, 1 } },
            shadows = { { 0.2, 0.2, 0.2, 1 }, { 0.4, 0.4, 0.4, 1 }, { 0.7, 0.7, 0.7, 1 } },
        }
    }

}

-- ~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-
--          Dark Palette
-- ~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-

color.color_dark = {
    -- Sample
    -- ------------------
    sample = {
        border = { 10, 10, 10 },
        shadow = { 10, 10, 10 },
        palette = {
            { 50,  50,  50,  1 },
            { 210, 210, 210, 1 },
            { 84,  185, 147 },
            { 100, 167, 196 },
            { 181, 66,  66 },
            { 208, 171, 92 },
        }
    }
}


-- ~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-
--          Dimmed Palette
-- ~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-

color.color_dimmed = {

    -- Sample
    -- ------------------

    sample = {
        border = { 50, 50, 50 },
        shadow = { 80, 80, 80 },
        palette = {
            { 225, 225, 225, 1 },
            { 100, 100, 100, 1 },
            { 131, 204, 177 },
            { 138, 192, 216 },
            { 222, 123, 123 },
            { 226, 195, 129 },
        }
    },

    -- Background
    bg = { 70, 70, 70 },

    -- Markers
    line = { 0, 0, 0, 0.75 },
    box = {
        fill = { 0, 0, 0, 0.15 },
        border = { 0, 0, 0, 0 },
    },

    --  Paths
    -- ------------------
    path = {
        icon = "",
        icon_table = "dimmed"
    },

    --  Main Colors
    -- ------------------
    color = {
        cyan = { 131, 204, 177 },
        blue = { 138, 192, 216 },
        red = { 222, 123, 123 },
        yellow = { 226, 195, 129 },
        violet = { 158, 137, 205 },
        gray = { 176, 176, 176 },
        green = { 158, 210, 141 },
    },

    --  Theme Hint
    -- ------------------
    theme_hint = {
        unpacked = { 125, 255, 150, 0.5 },
        modded = { 255, 150, 150, 0.5 }
    },

    --  Modulation
    -- ------------------
    mod = {
        lighten_hover = 0.1,
        lighten_click = 0.3,
    },

    --  Buttons
    -- ------------------
    button = {
        off_bg = { 60, 60, 60 },
        off_fg = { 210, 210, 210, 1 },
        on_fg = { 0, 0, 0, 1 },
        border = { 40, 40, 40 },

        selection = {
            off_bg = { 70, 70, 70 },
            off_fg = { 185, 185, 185 },
            on_fg = { 20, 20, 20, 1 },
            border = { 40, 40, 40 }
        },

        bank = {
            off_bg = { 80, 80, 80 },
            off_fg = { 150, 150, 150 },
            off_border = { 30, 30, 30 },
            on_fg = { 20, 20, 20 },
            on_border = { 30, 30, 30 },
        },

    },

    --  Infobar (Keyboard Shortcuts)
    -- ------------------------------
    infobar = {
        backdrop = { 75, 75, 75, 1 },
        bg = { 50, 50, 50 },
        fg = { 150, 150, 150, 1 }
    },

    --  Bank Bar
    -- ------------------
    bank_bar = {
        bg = { 255, 0, 0 },
        border = { 0, 0, 0, 0 },

        button = {
            off_bg = { 50, 50, 50 },
            off_fg = { 190, 190, 190 },
            on_fg = { 0, 0, 0 },
            border = { 30, 30, 30 },
            submit_overlay = { 200, 100, 100, 0.25 },

            copy = {
                off_bg = { 70, 50, 50 },
                off_fg = { 180, 180, 180 },
                on_bg = { 200, 100, 100 },
                on_fg = { 0, 0, 0 },
                src_bg = { 80, 80, 80 },
                src_fg = { 150, 150, 150 },
            }
        }
    },

    --  Theme Error Message
    -- -----------------------
    theme_error = {
        bg = { 50, 50, 50 },
        fg = { 175, 175, 175 },
        box = { 25, 25, 25 },
        border = { 255, 255, 255, 0.2 },
    },

    --  Popup Message
    -- ------------------
    message = {
        bg = { 100, 120, 110 },
        fg = { 240, 240, 240 },
        error_bg = { 120, 90, 90, },
        error_fg = { 250, 240, 240 },
        border = { 0, 0, 0, 0.5 },
        shadow = { 0, 0, 0, 0.25 }
    },

    --  Hover Hint Message
    -- ---------------------
    hint = {
        stage_bg = { 70, 70, 70 },
        bg = { 75, 75, 75, 1 },
        fg = { 200, 200, 200, 1 },
        text_highlight = { 255, 255, 255, 1 },
        shadow = { 0, 0, 0, 0.1 },
        highlight_fg = { 255, 255, 255, 1 },
        highlight_bg = { 0, 0, 0, 0.5 },
        hover = { 0.3, 0.3, 0.3, 0 },
        symbol = { 131, 204, 177 },
        controls_fg = { 255, 255, 255, 0.3 },
        controls_fg_desc = { 255, 255, 255, 0.4 }
    },

    --  Radio Button
    -- ---------------------
    marker = {
        border = { 20, 20, 20 },
        bg_off = { 40, 40, 40 }
    },

    --  Parameter Set Shading
    -- --------------------------
    label = {
        bg = { 0, 0, 0, 0 },
        border = { 0, 0, 0, 0 }
    },

    --  Text Labels
    -- --------------------------
    text = {
        bg = { 0, 255, 0, 1 },
        fg = { 1, 255, 1 },
        border = { 0, 255, 0 },
        underline = { 0, 0, 0, 0.25 },

        parameter = {
            fg = { 230, 230, 230 },
            bg = { 0, 0, 0, 0 },
            border = { 0, 0, 0, 0 }
        },

        monitor = {
            fg = { 180, 180, 180, 1 },
            bg = { 50, 50, 50, 1 },
            border = { 0, 0, 0, 0 }
        }

    },

    --  Table Content
    -- --------------------------
    table = {
        header_fg = { 180, 180, 180 },
        entry_fg = { 200, 200, 200 },
        empty_space = { 0, 0, 0, 0 },
        row_even = { 0, 0, 0, 0.15 },
        row_uneven = { 0, 0, 0, 0.1 },
        column_even = { 0, 0, 0, 0 },
        column_uneven = { 0, 0, 0, 0 },
    },

    --  Tab Selection
    -- --------------------------
    tab = {
        bg = { 70, 70, 70 },
        bg_sub = { 95, 95, 95 },
        off_bg = { 70, 70, 70 },
        off_fg = { 150, 150, 150 },
        on_bg = { 95, 95, 95 },
        on_fg = { 240, 240, 240 },
        sub = {
            off_bg = { 95, 95, 95 },
            off_fg = { 190, 190, 190 },
            on_fg = { 255, 255, 255 },
        },
        shadow = { 0, 0, 0, 0.2 }
    },

    --  Element Groups
    -- --------------------------
    group = {
        bg = { 95, 95, 95, 1 },
        fg = { 150, 150, 150, 1 },

        header = {
            fg = { 150, 150, 150 },
            bg = { 50, 50, 50 },
        },
        section = {
            line = { 0, 0, 0, 0.2 }
        },
        inline_header = {
            fg = { 255, 255, 255, 0.4 },
            bg = { 0, 0, 0, 0.2 },
            underline = { 0, 0, 0, 0 }
        }
    },

    --  Slider
    -- --------------------------
    slider = {
        bg = { 60, 60, 60, 1 },
        border = { 30, 30, 30 },
        knob_border = { 30, 30, 30 },
        knob = { 200, 200, 200, 0.8 },
        gradient_border = { 30, 30, 30 },
        slot_default = { 255, 255, 255, 0.5 },
        value_fill = { 84, 185, 147, 0.3 },
    },

    --  Knobs
    -- --------------------------
    knob = {
        bg = { 60, 60, 60, 1 },
        fg = { 200, 200, 200, 1 },
        border = { 0, 0, 0, 0.5 },
        default = { 255, 255, 255, 0.2 },
    },


}

-- ~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-
--          Light Palette
-- -------------------------------------------

color.color_light = {

    -- Sample
    -- ------------------

    sample = {
        border = { 75, 75, 75 },
        shadow = { 230, 230, 230 },
        palette = {
            { 255, 255, 255 },
            { 75,  75,  75 },
            { 138, 231, 196 },
            { 149, 195, 215 },
            { 231, 136, 136 },
            { 241, 208, 138 },
        }
    },

    -- Background
    bg = { 200, 200, 200 },

    -- Markers
    line = { 0, 0, 0, 0.5 },
    box = {
        fill = { 0, 0, 0, 0.1 },
        border = { 0, 0, 0, 0 },
    },

    --  Paths
    -- ------------------
    path = {
        icon = "",
        icon_table = "light"
    },

    --  Main Colors
    -- ------------------
    color = {
        cyan = { 138, 231, 196 },
        blue = { 149, 195, 215 },
        red = { 231, 136, 136 },
        yellow = { 241, 208, 138 },
        violet = { 177, 160, 215 },
        gray = { 185, 185, 185 },
        green = { 173, 216, 160 },
    },

    --  Theme Hint
    -- ------------------
    theme_hint = {
        unpacked = { 5, 75, 20, 0.5 },
        modded = { 150, 25, 25, 0.5 }
    },

    --  Modulation
    -- ------------------
    mod = {
        lighten_hover = 0.05,
        lighten_click = 0.15,
    },

    --  Buttons
    -- ------------------
    button = {
        off_bg = { 150, 150, 150 },
        off_fg = { 255, 255, 255 },
        on_fg = { 0, 0, 0, 0.9 },
        border = { 100, 100, 100 },

        selection = {
            off_bg = { 160, 160, 160 },
            off_fg = { 245, 245, 245 },
            on_fg = { 0, 0, 0, 0.9 },
            border = { 110, 110, 110 },
        },

        bank = {
            off_bg = { 150, 150, 150 },
            off_fg = { 225, 225, 225 },
            off_border = { 100, 100, 100 },
            on_fg = { 75, 75, 75 },
            on_border = { 75, 75, 75 },
        },

    },

    --  Infobar (Keyboard Shortcuts)
    -- ------------------------------
    infobar = {
        backdrop = { 180, 180, 180 },
        bg = { 120, 120, 120 },
        fg = { 210, 210, 210 },
        label = {
            fg = { 70, 70, 70 },
            frame = { 140, 140, 140 }
        }
    },

    --  Bank Bar
    -- ------------------
    bank_bar = {
        bg = { 200, 200, 200 },
        border = { 0, 0, 0, 0 },

        button = {
            off_bg = { 135, 135, 135 },
            off_fg = { 245, 245, 245 },
            on_fg = { 0, 0, 0 },
            border = { 100, 100, 100 },
            submit_overlay = { 200, 100, 100, 0.25 },

            copy = {
                off_bg = { 130, 100, 100 },
                off_fg = { 200, 200, 200 },
                on_bg = { 250, 125, 125 },
                on_fg = { 0, 0, 0 },
                src_bg = { 150, 150, 150 },
                src_fg = { 210, 210, 210 },
            }
        }
    },

    --  Theme Error Message
    -- -----------------------
    theme_error = {
        bg = { 50, 50, 50, 1 },
        fg = { 175, 175, 175, 1 },
        box = { 25, 25, 25, 1 },
        border = { 255, 255, 255, 0.2 },
    },

    --  Popup Message
    -- ------------------
    message = {
        bg = { 200, 230, 200 },
        fg = { 0, 0, 0 },
        error_bg = { 225, 150, 150 },
        error_fg = { 0, 0, 0 },
        border = { 50, 50, 50 },
        shadow = { 0, 0, 0, 0.25 }
    },

    --  Hover Hint Message
    -- ---------------------
    hint = {
        stage_bg = { 200, 200, 200 },
        bg = { 255, 255, 255, 1 },
        fg = { 50, 50, 50 },
        highlight_fg = { 50, 50, 50 },
        highlight_bg = { 255, 255, 255, 0 },
        tip_bg = { 149, 195, 215, 0.35 },
        tip_fg = { 0, 0, 0, 0.7 },
        attention_bg = { 241, 208, 138, 0.35 },
        attention_fg = { 0, 0, 0, 0.7 },
        warning_bg = { 231, 136, 136, 0.35 },
        warning_fg = { 0, 0, 0, 0.7 },
        controls_fg = { 0, 0, 0, 0.3 },
        controls_fg_desc = { 0, 0, 0, 0.4 }
    },


    --  Radio Button
    -- ---------------------
    marker = {
        border = { 50, 50, 50 },
        bg_off = { 120, 120, 120, 1 },
    },

    --  Parameter Set Shading
    -- --------------------------
    label = {
        bg = { 0, 0, 0, 0 },
        border = { 0, 0, 0, 0 }
    },

    --  Text Labels
    -- --------------------------
    text = {
        bg = { 0, 0, 0, 1 },
        fg = { 0, 0, 0, 1 },
        border = { 0, 0, 0, 0.5 },

        parameter = {
            fg = { 0, 0, 0, 0.8 },
            bg = { 0, 0, 0, 0 },
            border = { 0, 0, 0, 0 }
        },

        monitor = {
            fg = { 255, 255, 255 },
            bg = { 150, 150, 150 },
            border = { 0, 0, 0, 0 }
        }

    },

    --  Table Content
    -- --------------------------
    table = {
        header_fg = { 50, 50, 50 },
        entry_fg = { 0, 0, 0 },
        empty_space = { 0, 0, 0, 0 },
        row_even = { 0, 0, 0, 0.1 },
        row_uneven = { 0, 0, 0, 0.05 },
        column_even = { 0, 0, 0, 0 },
        column_uneven = { 0, 0, 0, 0 },
    },

    --  Tab Selection
    -- --------------------------
    tab = {
        bg = { 230, 230, 230 },
        bg_sub = { 200, 200, 200 },
        off_bg = { 230, 230, 230 },
        off_fg = { 125, 125, 125 },
        on_bg = { 200, 200, 200 },
        on_fg = { 0, 0, 0 },
        sub = {
            off_bg = { 200, 200, 200 },
            off_fg = { 80, 80, 80 },
            on_fg = { 0, 0, 0 },
        },
        shadow = { 0, 0, 0, 0.2 }
    },

    --  Element Groups
    -- --------------------------
    group = {
        bg = { 180, 180, 180 },
        fg = { 80, 80, 80, 1 },
        border = { 0, 0, 0, 0 },

        header = {
            fg = { 225, 225, 225 },
            bg = { 125, 125, 125 },
            border = { 255, 255, 255, 0.25 }
        },
        inline_header = {
            fg = { 0, 0, 0, 0.4 },
            bg = { 0, 0, 0, 0.05 },
        },
        section = {
            line = { 0, 0, 0, 0.15 }
        },

    },

    --  Slider
    -- --------------------------
    slider = {
        bg = { 150, 150, 150, 1 },
        border = { 75, 75, 75 },
        knob_border = { 75, 75, 75 },
        knob = { 220, 220, 220 },
        gradient_border = { 75, 75, 75 },
        slot_default = { 255, 255, 255, 0.5 },
        value_fill = { 138, 231, 196 },
    },

    --  Knobs
    -- --------------------------
    knob = {
        bg = { 150, 150, 150 },
        fg = { 255, 255, 255 },
        border = { 0, 0, 0, 0.4 },
        default = { 255, 255, 255, 0.2 },
    },

}



--  Method : Use Dark Color Palette
-- -------------------------------------------

function color.useDarkPalette()
    color.color_palette = color.color_dark
    color.updateImageSet()
end

--  Method : Use Dark Windows Color Palette
-- -------------------------------------------

function color.useDimmedPalette()
    color.color_palette = color.color_dimmed
    color.updateImageSet()
end

--  Method : Use Light Color Palette
-- -------------------------------------------

function color.useLightPalette()
    color.color_palette = color.color_light
    color.updateImageSet()
end

--  Method : Update Image Set
-- -------------------------------------------

function color.updateImageSet()
    color.image_set = color.color_palette.path.icon
    color.image_set_table = color.color_palette.path.icon_table
end

--  Palette Merge
-- -------------------------------------------

-- merge palettes
Part.Functions.deepMerge(color.color_base, color.color_dark)
Part.Functions.deepMerge(color.color_base, color.color_dimmed)
Part.Functions.deepMerge(color.color_base, color.color_light)

-- choose dark by default
color.useDarkPalette()

return color
