-- @version 1.1.4
-- @author Fleeesch
-- @description paRt Theme Adjuster
-- @noIndex


local color = {}

-- ======================================================================
--                          Color Palettes
-- ======================================================================

-- ~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-
--          Base Palette
-- ~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-

-- global colors
color.color_base = {

    -- Background
    bg = { 70, 70, 70, 1 },

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

    --  Modulation
    -- ------------------
    mod = {
        lighten_hover = 0.1,
        lighten_click = 0.3,
    },

    --  Buttons
    -- ------------------
    button = {
        off_bg = { 25, 25, 25, 1 },
        off_fg = { 130, 130, 130, 1 },
        on_fg = { 0, 0, 0, 1 },
        border = { 0, 0, 0, 0.4 },

        selection = {
            off_bg = { 40, 40, 40, 1 },
            off_fg = { 150, 150, 150, 1 },
            on_fg = { 0, 0, 0, 1 },
            border = { 0, 0, 0, 0.4 }
        },

        bank = {
            off_bg = { 0, 0, 0, 0.25 },
            off_fg = { 255, 255, 255, 0.3 },
            off_border = { 0, 0, 0, 0.5 },
            on_fg = { 0, 0, 0, 0.8 },
            on_border = { 0, 0, 0, 0.5 },
        },

    },

    --  Blur Modulation
    -- ------------------
    blur = {
        mul = { 0.25, 0.25, 0.25, 1 },
        add = { 0.2, 0.2, 0.2, 0 },
        factor = 1
    },

    --  Infobar (Keyboard Shortcuts)
    -- ------------------------------
    infobar = {
        bg = { 25, 25, 25, 1 },
        fg = { 125, 125, 125, 1 }
    },

    --  Bank Bar
    -- ------------------
    bank_bar = {
        bg = { 60, 60, 60, 1 },
        border = { 0, 0, 0, 0 },

        button = {
            off_bg = { 30, 30, 30, 1 },
            off_fg = { 150, 150, 150, 1 },
            on_fg = { 0, 0, 0, 1 },
            border = { 0, 0, 0, 0.5 },
            submit_overlay = { 200, 100, 100, 0.25 },

            copy = {
                off_bg = { 70, 50, 50, 1 },
                off_fg = { 150, 150, 150, 1 },
                on_bg = { 200, 100, 100, 1 },
                on_fg = { 0, 0, 0, 1 },
                src_bg = { 100, 100, 100, 1 },
                src_fg = { 150, 150, 150, 1 },
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
        bg = { 30, 30, 30, 1 },
        fg = { 200, 200, 200, 1 },
        text_highlight = { 255, 255, 255, 1 },
        shadow = { 0, 0, 0, 0.1 },
        highlight_fg = { 255, 255, 255, 1 },
        highlight_bg = { 0, 0, 0, 0.5 },
        hover = { 0.3, 0.3, 0.3, 0 },
        symbol = { 84, 185, 147 }
    },

    --  Splash Message
    -- ---------------------
    splash = {
        bg = { 0.25, 0.25, 0.25, 1 },
        border = { 255, 255, 255, 0.25 },
        shadow = { 0, 0, 0, 1 },
        fg = { 200, 200, 200, 1 }
    },

    --  Radio Button
    -- ---------------------
    marker = {
        border = { 0, 0, 0, 0.75 },
        bg_off = { 50, 50, 50, 1 },
    },

    --  Parameter Set Shading
    -- --------------------------
    label = {
        bg = { 0,0,0, 0.1 },
        border = { 0, 0, 0, 0 }
    },

    --  Text Labels
    -- --------------------------
    text = {
        bg = { 0, 0, 0, 1 },
        fg = { 0.8, 0.8, 0.8, 1 },
        border = { 0, 0, 0, 0.5 },

        parameter = {
            fg = { 150, 150, 150, 1 },
            bg = { 0, 0, 0, 0 },
            border = { 0, 0, 0, 0 }
        },

        monitor = {
            fg = { 150, 150, 150, 1 },
            bg = { 50, 50, 50, 1 },
            border = { 0, 0, 0, 0 }
        }

    },

    --  Table Content
    -- --------------------------
    table = {
        header_fg = { 200, 200, 200, 1 },
        entry_fg = { 150, 150, 150, 1 },
        empty_space = { 0, 0, 0, 0.1 },
        row_even = { 0, 0, 0, 0.1 },
        row_uneven = { 0, 0, 0, 0.1},
        column_even = { 0, 0, 0, 0.1 },
        column_uneven = { 0, 0, 0, 0.1 },
    },

    --  Tab Selection
    -- --------------------------
    tab = {
        off_bg = { 50, 50, 50, 1 },
        off_fg = { 125, 125, 125, 1 },
        on_bg = { 70, 70, 70, 1 },
        on_fg = { 200, 200, 200, 1 },
        sub = {
            off_bg = { 70, 70, 70, 1 },
            off_fg = { 180, 180, 180, 1 },
            on_fg = { 225, 225, 225, 1 },
        },
        shadow = { 0, 0, 0, 0.25 }
    },

    --  Element Groups
    -- --------------------------
    group = {
        bg = { 60, 60, 60, 1 },
        fg = { 150, 150, 150, 1 },
        border = { 0, 0, 0, 0.5 },

        header = {
            fg = { 255, 1, 1, 0.5 },
            bg = { 0, 0, 0, 0 },
            border = { 255, 255, 255, 0.25 }
        },
        inline_header = {
            fg = { 255, 255, 255, 0.4 },
            bg = { 0, 0, 0, 0.15 },
        },
        tint = {
            arrangement = { 255, 0, 0, 0.025 },
            settings = { 0, 255, 0, 0.025 },
            fader = { 0, 0, 255, 0.025 },
            inserts = { 255, 0, 255, 0.025 },
            folder = { 255, 255, 0, 0.025 },
            meter = { 0, 255, 255, 0.025 },
            colors = { 255, 125, 0, 0.025 },
            conditions = { 125, 255, 0, 0.025 },
            dimensions = { 125, 0, 255, 0.025 }
        }
    },

    --  Slider
    -- --------------------------
    slider = {
        bg = { 25, 25, 25, 1 },
        border = { 0, 0, 0, 0.5 },
        knob_border = { 0, 0, 0, 0.75 },
        knob = { 150, 150, 150, 1 },
        gradient_border = { 0, 0, 0, 0.5 },
        slot_default = { 255, 255, 255, 0.5 }
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
            gamma = { { 0.7, 0.7, 0.7, 1 }, { 0.4, 0.4, 0.4, 1 }, { 0.2, 0.2, 0.2, 1 } },
            highlights = { { 0.2, 0.2, 0.2, 1 }, { 0.4, 0.4, 0.4, 1 }, { 0.7, 0.7, 0.7, 1 } },
            midtones = { { 0.2, 0.2, 0.2, 1 }, { 0.4, 0.4, 0.4, 1 }, { 0.7, 0.7, 0.7, 1 } },
            shadows = { { 0.2, 0.2, 0.2, 1 }, { 0.4, 0.4, 0.4, 1 }, { 0.7, 0.7, 0.7, 1 } },
        }
    }

}

-- ~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-
--          Dark Palette
-- ~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-

color.color_dark = {}


-- ~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-
--          Dimmed Palette
-- ~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-

color.color_dimmed = {

    -- Background
    bg = { 100, 100, 100, 1 },

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

    --  Modulation
    -- ------------------
    mod = {
        lighten_hover = 0.1,
        lighten_click = 0.3,
    },

    --  Buttons
    -- ------------------
    button = {
        off_bg = { 75, 75, 75, 1 },
        off_fg = { 210, 210, 210, 1 },
        on_fg = { 0, 0, 0, 1 },
        border = { 0, 0, 0, 0.3 },

        selection = {
            off_bg = { 95, 95, 95, 1 },
            off_fg = { 190, 190, 190, 1 },
            on_fg = { 20, 20, 20, 1 },
            border = { 0, 0, 0, 0.3 }
        },

        bank = {
            off_bg = { 0, 0, 0, 0.1 },
            off_fg = { 255, 255, 255, 0.5 },
            off_border = { 0, 0, 0, 0.25 },
            on_fg = { 0, 0, 0, 0.8 },
            on_border = { 0, 0, 0, 0.5 },
        },

    },

    --  Blur Modulation
    -- ------------------
    blur = {
        mul = { 0.25, 0.25, 0.25, 1 },
        add = { 0.2, 0.2, 0.2, 0 },
        factor = 1
    },

    --  Infobar (Keyboard Shortcuts)
    -- ------------------------------
    infobar = {
        bg = { 80, 80, 80, 1 },
        fg = { 150,150,150, 1 }
    },

    --  Bank Bar
    -- ------------------
    bank_bar = {
        bg = { 90, 90, 90, 1 },
        border = { 0, 0, 0, 0 },

        button = {
            off_bg = { 70, 70, 70, 1 },
            off_fg = { 180, 180, 180, 1 },
            on_fg = { 0, 0, 0, 1 },
            border = { 0, 0, 0, 0.4 },
            submit_overlay = { 200, 100, 100, 0.25 },

            copy = {
                off_bg = { 70, 50, 50, 1 },
                off_fg = { 150, 150, 150, 1 },
                on_bg = { 200, 100, 100, 1 },
                on_fg = { 0, 0, 0, 1 },
                src_bg = { 100, 100, 100, 1 },
                src_fg = { 150, 150, 150, 1 },
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
        bg = { 100, 120, 110, 1 },
        fg = { 240, 240, 240, 1 },
        error_bg = { 120, 90, 90, 1 },
        error_fg = { 250, 240, 240, 1 },
        border = { 0, 0, 0, 0.5 },
        shadow = { 0, 0, 0, 0.25 }
    },

    --  Hover Hint Message
    -- ---------------------
    hint = {
        bg = { 60, 60, 60, 1 },
        fg = { 200, 200, 200, 1 },
        text_highlight = { 255, 255, 255, 1 },
        shadow = { 0, 0, 0, 0.1 },
        highlight_fg = { 255, 255, 255, 1 },
        highlight_bg = { 0, 0, 0, 0.5 },
        hover = { 0.3, 0.3, 0.3, 0 },
        symbol = { 131, 204, 177 },
    },

    --  Splash Message
    -- ---------------------
    splash = {
        bg = { 0.25, 0.25, 0.25, 1 },
        border = { 255, 255, 255, 0.25 },
        shadow = { 0, 0, 0, 1 },
        fg = { 200, 200, 200, 1 }
    },

    --  Radio Button
    -- ---------------------
    marker = {
        border = { 0, 0, 0, 0.6 },
        bg_off = { 80, 80, 80, 1 },
    },

    --  Parameter Set Shading
    -- --------------------------
    label = {
        bg = { 0, 0, 0, 0.125 },
        border = { 0, 0, 0, 0 }
    },

    --  Text Labels
    -- --------------------------
    text = {
        bg = { 0, 0, 0, 1 },
        fg = { 0.8, 0.8, 0.8, 1 },
        border = { 0, 0, 0, 0.5 },

        parameter = {
            fg = { 210, 210, 210, 1 },
            bg = { 0, 0, 0, 0 },
            border = { 0, 0, 0, 0 }
        },

        monitor = {
            fg = { 200, 200, 200, 1 },
            bg = { 90, 90, 90, 1 },
            border = { 0, 0, 0, 0 }
        }

    },

    --  Table Content
    -- --------------------------
    table = {
        header_fg = { 200, 200, 200, 1 },
        entry_fg = { 200, 200, 200, 1 },
        empty_space = { 0,0,0, 0.04 },
        row_even = { 0, 0, 0, 0.075 },
        row_uneven = { 0, 0, 0, 0.1 },
        column_even = { 0, 0, 0, 0.075 },
        column_uneven = { 0, 0, 0, 0.075 },
    },

    --  Tab Selection
    -- --------------------------
    tab = {
        off_bg = { 70, 70, 70, 1 },
        off_fg = { 170, 170, 170, 1 },
        on_bg = { 100, 100, 100, 1 },
        on_fg = { 0, 0, 0, 1 },
        sub = {
            off_bg = { 100, 100, 100, 1 },
            off_fg = { 40, 40, 40, 1 },
            on_fg = { 0, 0, 0, 1 },
        },
        shadow = { 0, 0, 0, 0.1 }
    },

    --  Element Groups
    -- --------------------------
    group = {
        bg = { 90, 90, 90, 1 },
        fg = { 210, 210, 210, 1 },
        border = { 0, 0, 0, 0.3 },
        header = {
            fg = { 255, 1, 1, 0.25 },
            bg = { 0, 0, 0, 0 },
            border = { 255, 255, 255, 0.25 }
        },
        inline_header = {
            fg = { 0, 0, 0, 0.4 },
            bg = { 255, 255, 255, 0.1 },
        },
        tint = {
            arrangement = { 255, 0, 0, 0.025 },
            settings = { 0, 255, 0, 0.025 },
            fader = { 0, 0, 255, 0.025 },
            inserts = { 255, 0, 255, 0.025 },
            folder = { 255, 255, 0, 0.025 },
            meter = { 0, 255, 255, 0.025 },
            colors = { 255, 125, 0, 0.025 },
            conditions = { 125, 255, 0, 0.025 },
            dimensions = { 125, 0, 255, 0.025 }
        }
    },

    --  Slider
    -- --------------------------
    slider = {
        bg = { 60, 60, 60, 1 },
        border = { 0, 0, 0, 0.3 },
        knob_border = { 0, 0, 0, 0.75 },
        knob = { 170, 170, 170, 1 },
        gradient_border = { 0, 0, 0, 0.5 },
        slot_default = { 255, 255, 255, 0.5 }
    },

    --  Knobs
    -- --------------------------
    knob = {
        bg = { 60, 60, 60, 1 },
        fg = { 200, 200, 200, 1 },
        border = { 0, 0, 0, 0.5 },
        default = { 255, 255, 255, 0.2 },
    },

    --  Gradients
    -- --------------------------
    gradient = {
        slider = {
            hue = { { 1, 0.2, 0.5, 1 }, { 0.9, 0.9, 0, 1 }, { 0, 1, 0.7, 1 }, { 0.5, 0, 1, 1 }, { 1, 0.2, 0.5, 1 } },
            saturation = { { 0.7, 0.7, 0.7, 1 }, { 0.1, 0.75, 0.55, 1 }, { 0.2, 1, 0.8, 1 } },
            gamma = { { 0.6, 0.6, 0.6, 1 }, { 0.5, 0.5, 0.5, 1 }, { 0.4, 0.4, 0.4, 1 } },
            highlights = { { 0.3, 0.3, 0.3, 1 }, { 0.5, 0.5, 0.5, 1 }, { 0.8, 0.8, 0.8, 1 } },
            midtones = { { 0.3, 0.3, 0.3, 1 }, { 0.5, 0.5, 0.5, 1 }, { 0.8, 0.8, 0.8, 1 } },
            shadows = { { 0.3, 0.3, 0.3, 1 }, { 0.5, 0.5, 0.5, 1 }, { 0.8, 0.8, 0.8, 1 } },
        }
    }


}

-- ~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-
--          Light Palette
-- -------------------------------------------

color.color_light = {

    -- Background
    bg = { 221, 221, 221 },

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

    --  Modulation
    -- ------------------
    mod = {
        lighten_hover = 0.1,
        lighten_click = 0.3,
    },

    --  Buttons
    -- ------------------
    button = {
        off_bg = { 150, 150, 150 },
        off_fg = { 255, 255, 255 },
        on_fg = { 0, 0, 0, 0.9 },
        border = { 0, 0, 0, 0.3 },

        selection = {
            off_bg = { 150, 150, 150 },
            off_fg = { 225, 225, 225 },
            on_fg = { 0, 0, 0, 0.9 },
            border = { 0, 0, 0, 0.3 }
        },

        bank = {
            off_bg = { 0, 0, 0, 0.2 },
            off_fg = { 255, 255, 255, 0.8 },
            off_border = { 0, 0, 0, 0.1 },
            on_fg = { 0, 0, 0, 0.7 },
            on_border = { 0, 0, 0, 0.4 },
        },

    },

    --  Infobar (Keyboard Shortcuts)
    -- ------------------------------
    infobar = {
        bg = { 230, 230, 230 },
        fg = { 140, 140, 140 }
    },

    --  Bank Bar
    -- ------------------
    bank_bar = {
        bg = { 190, 190, 190 },
        border = { 0, 0, 0, 0 },

        button = {
            off_bg = { 150, 150, 150 },
            off_fg = { 255, 255, 255 },
            on_fg = { 0, 0, 0, 0.9 },
            border = { 0, 0, 0, 0.3 },
            submit_overlay = { 200, 100, 100, 0.25 },

            copy = {
                off_bg = { 130, 100, 100, 1 },
                off_fg = { 170, 170, 170, 1 },
                on_bg = { 200, 100, 100, 1 },
                on_fg = { 0, 0, 0, 1 },
                src_bg = { 125, 125, 125, 1 },
                src_fg = { 185, 185, 185, 1 },
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
        bg = { 200, 220, 210 },
        fg = { 0, 0, 0 },
        error_bg = { 225, 150, 150 },
        error_fg = { 0, 0, 0 },
        border = { 0, 0, 0, 0.4 },
        shadow = { 0, 0, 0, 0.1 }
    },

    --  Hover Hint Message
    -- ---------------------
    hint = {
        bg = { 255, 255, 255, 1 },
        fg = { 0, 0, 0, 1 },
        text_highlight = { 75, 75, 75, 1 },
        shadow = { 0, 0, 0, 0.25 },
        highlight_fg = { 255, 255, 255, 1 },
        highlight_bg = { 0, 0, 0, 0.5 },
        hover = { 0.3, 0.3, 0.3, 0 },
        symbol = { 98, 181, 156 },
    },

    --  Splash Message
    -- ---------------------
    splash = {
        bg = { 0.25, 0.25, 0.25, 1 },
        border = { 255, 255, 255, 0.25 },
        shadow = { 0, 0, 0, 1 },
        fg = { 200, 200, 200, 1 }
    },

    --  Radio Button
    -- ---------------------
    marker = {
        border = { 0, 0, 0, 0.5 },
        bg_off = { 120, 120, 120, 1 },
    },

    --  Parameter Set Shading
    -- --------------------------
    label = {
        bg = { 255, 255, 255, 0.2 },
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
        header_fg = { 0, 0, 0 },
        entry_fg = { 0, 0, 0, 0.8 },
        empty_space = { 255, 255, 255, 0.05 },
        row_even = { 255, 255, 255, 0.2 },
        row_uneven = { 255, 255, 255, 0.2 },
        column_even = { 255, 255, 255, 0.2 },
        column_uneven = { 255, 255, 255, 0.2 },
    },

    --  Tab Selection
    -- --------------------------
    tab = {
        off_bg = { 200, 200, 200 },
        off_fg = { 100, 100, 100 },
        on_bg = { 221, 221, 221 },
        on_fg = { 0, 0, 0 },
        sub = {
            off_bg = { 221, 221, 221 },
            off_fg = { 0, 0, 0, 0.5 },
            on_fg = { 0, 0, 0 },
        },
        shadow = { 0, 0, 0, 0.1 }
    },

    --  Element Groups
    -- --------------------------
    group = {
        bg = { 200, 200, 200, 1 },
        fg = { 80, 80, 80, 1 },
        border = { 0, 0, 0, 0.2 },

        header = {
            fg = { 255, 1, 1, 0.5 },
            bg = { 0, 0, 0, 0 },
            border = { 255, 255, 255, 0.25 }
        },
        inline_header = {
            fg = { 0, 0, 0, 0.4 },
            bg = { 0, 0, 0, 0.05 },
        },
        tint = {
            arrangement = { 255, 0, 0, 0.025 },
            settings = { 0, 255, 0, 0.025 },
            fader = { 0, 0, 255, 0.025 },
            inserts = { 255, 0, 255, 0.025 },
            folder = { 255, 255, 0, 0.025 },
            meter = { 0, 255, 255, 0.025 },
            colors = { 255, 125, 0, 0.025 },
            conditions = { 125, 255, 0, 0.025 },
            dimensions = { 125, 0, 255, 0.025 }
        }
    },

    --  Slider
    -- --------------------------
    slider = {
        bg = { 150, 150, 150, 1 },
        border = { 0, 0, 0, 0.3 },
        knob_border = { 0, 0, 0, 0.4 },
        knob = { 220, 220, 220 },
        gradient_border = { 0, 0, 0, 0.5 },
        slot_default = { 255, 255, 255, 0.5 }
    },

    --  Knobs
    -- --------------------------
    knob = {
        bg = { 150, 150, 150 },
        fg = { 255, 255, 255 },
        border = { 0, 0, 0, 0.4 },
        default = { 255, 255, 255, 0.2 },
    },

    --  Gradients
    -- --------------------------
    gradient = {
        slider = {
            hue = { { 1, 0.2, 0.5, 1 }, { 0.9, 0.9, 0, 1 }, { 0, 1, 0.7, 1 }, { 0.5, 0, 1, 1 }, { 1, 0.2, 0.5, 1 } },
            saturation = { { 0.7, 0.7, 0.7, 1 }, { 0.1, 0.8, 0.6, 1 }, { 0.5, 1, 0.85, 1 } },
            gamma = { { 1, 1, 1, 1 }, { 0.8, 0.8, 0.8, 1 }, { 0.6, 0.6, 0.6, 1 } },
            highlights = { { 0.6, 0.6, 0.6, 1 }, { 0.8, 0.8, 0.8, 1 }, { 1, 1, 1, 1 } },
            midtones = { { 0.6, 0.6, 0.6, 1 }, { 0.8, 0.8, 0.8, 1 }, { 1, 1, 1, 1 } },
            shadows = { { 0.6, 0.6, 0.6, 1 }, { 0.8, 0.8, 0.8, 1 }, { 1, 1, 1, 1 } },
        }
    }

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
