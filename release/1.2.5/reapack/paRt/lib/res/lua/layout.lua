-- @version 1.2.2
-- @author Fleeesch
-- @description paRt Theme Adjuster
-- @noIndex

--[[
    Non-interactive Graphical elements that are handled in a pseudo-OOP style.
]] --

local layout = { BankBar = {}, ConfigBar = {}, Group = {}, Label = {}, Text = {}, Image = {}, Spritesheet = {}, Sprite = {}, Line = {}, Box = {}, Function = {} }

-- ==========================================================================================
--                      Layout : Generic
-- ==========================================================================================


-- Layout
-- -------------------------------------------

layout.LayoutElement = {
    dim_x = 0,
    dim_y = 0,
    dim_w = 100,
    dim_h = 20,
    value = 0
}

function layout.LayoutElement:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    -- optionally store tab
    o.tab = Part.Tab.Entry.getRecentTab() or nil

    o.autocenter_position = true

    -- set as recently created element
    Part.Draw.Elements.setLastElement(o)

    return o
end

-- Layout : Draw
-- -------------------------------------------

function layout.LayoutElement:draw()

end

-- Layout : Tab Check
-- -------------------------------------------

function layout.LayoutElement:tabCheck()
    if self.tab == nil or self.tab:active() then
        -- tab is active
        return true
    end
    -- tab is inactive
    return false
end

-- ==========================================================================================
--                      Layout : Bank Bar
-- ==========================================================================================


--  Bank Bar
-- -------------------------------------------

layout.BankBar.BankBar = layout.LayoutElement:new()

function layout.BankBar.BankBar:new(o, handler)
    o = o or layout.LayoutElement:new(o)
    setmetatable(o, self)
    self.__index = self

    Part.Cursor.applyCursorToTarget(o)

    -- regsiter bank handler
    o.handler = handler or Part.Bank.Handler

    -- default colors
    o.color_bg = Part.Color.Lookup.color_palette.bank_bar.bg
    o.color_fg = Part.Color.Lookup.color_palette.bank_bar.fg
    o.color_border = Part.Color.Lookup.color_palette.bank_bar.border

    -- button size
    o.button_w = 20
    o.button_h = 16

    -- padding
    o.padding = 5

    -- button list
    o.bank_buttons = {}

    -- copy mode activity
    o.copy_mode = false

    -- copy source index
    o.copy_src_idx = -1

    -- setup buttons
    o:setupButtons()

    -- register in lookup list
    table.insert(Part.List.layout, o)

    return o
end

--  Bank Bar : Copy Mode
-- -------------------------------------------

function layout.BankBar.BankBar:copyMode()
    -- inform that copy marking is active
    return self.copy_mode
end

--  Bank Bar : Set Copy Mode
-- -------------------------------------------

function layout.BankBar.BankBar:setCopyMode(on)
    -- update copy mode
    self.copy_mode = on

    -- grab source bank index during activation
    if on then
        self.copy_src_idx = self.handler.bank_selected:getIndex()
    end
end

--  Bank Bar : Setup Buttons
-- -------------------------------------------

function layout.BankBar.BankBar:setupButtons()
    -- set cursor dimensions
    Part.Cursor.setCursorPos(self.dim_x + 5, self.dim_y)
    Part.Cursor.setCursorSize(80, Part.Cursor.getCursorH())

    -- increment cursor
    Part.Cursor.incCursor(0, 6)

    -- set button dimensions
    Part.Cursor.setCursorSize(self.button_w, self.button_h)
    Part.Cursor.setCursorPadding(self.padding, self.padding)

    -- go through banks

    local button_x = Part.Cursor.getCursorX()
    local button_x_end = Part.Cursor.getCursorX()
    local button_y = Part.Cursor.getCursorY()

    for idx, bank in pairs(self.handler.bank_slot) do
        -- bank is not a global bank?
        if not bank:isGlobal() then
            -- create bank button
            local button = Part.Control.Config.SelectBank.ButtonBankSelect:new(nil, self.handler, bank.label, bank)
            Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.bank_slot_select, button, true)

            Part.Draw.Elements.lastElement():setFontFlags("b")

            -- increment cursor
            Part.Cursor.incCursor(Part.Cursor.getCursorW(), 0)

            -- register bank button
            table.insert(self.bank_buttons, Part.Draw.Elements.lastElement())

        end
    end


    Part.Cursor.incCursor(5, 0)

    -- copy button
    Part.Cursor.setCursorSize(self.button_w)
    local button = Part.Control.Config.Copy.ButtonBankCopy:new(nil, self.handler, "Copy")
    Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.bank_copy_mode, button, true)
end

--  Bank Bar : Tab Check
-- -------------------------------------------

function layout.BankBar.BankBar:tabCheck()
    return true
end

-- ==========================================================================================
--                      Layout : Config Bar
-- ==========================================================================================

--  Config Bar
-- -------------------------------------------

layout.ConfigBar.ConfigBar = layout.LayoutElement:new()

function layout.ConfigBar.ConfigBar:new(o, handler)
    o = o or layout.LayoutElement:new(o)
    setmetatable(o, self)
    self.__index = self

    Part.Cursor.applyCursorToTarget(o)

    -- regsiter bank handler
    o.handler = handler or Part.Bank.Handler

    -- default colors
    o.color_bg = Part.Color.Lookup.color_palette.bank_bar.bg
    o.color_fg = Part.Color.Lookup.color_palette.bank_bar.fg
    o.color_border = Part.Color.Lookup.color_palette.bank_bar.border

    -- button size
    o.button_w = 20
    o.button_h = 16

    -- padding
    o.padding = 5

    -- button list
    o.config_buttons = {}

    -- setup buttons
    o:setupButtons()

    -- register in lookup list
    table.insert(Part.List.layout, o)

    return o
end

--  Config Bar : Setup Buttons
-- -------------------------------------------

function layout.ConfigBar.ConfigBar:setupButtons()
    local button

    -- set cursor dimensions
    Part.Cursor.setCursorPos(self.dim_x + 5, self.dim_y)
    Part.Cursor.setCursorSize(80, Part.Cursor.getCursorH())

    -- increment cursor
    Part.Cursor.incCursor(0, 7)

    -- store source positions
    local source_x = Part.Cursor.getCursorX()
    local source_y = Part.Cursor.getCursorY()

    -- set button dimensions
    Part.Cursor.setCursorSize(self.button_w, self.button_h)
    Part.Cursor.setCursorPadding(self.padding, self.padding)

    -- iterate slots
    local button_x = Part.Cursor.getCursorX()
    local button_y = Part.Cursor.getCursorY()
    local button_x_end = Part.Cursor.getCursorX()

    for i = 0, 7 do
        -- create config button
        local button = Part.Control.Config.SelectConfig.ButtonConfigSelect:new(nil, self.handler, tostring(i + 1), i)
        Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.config_slot_select, button, true)

        Part.Draw.Elements.lastElement():setFontFlags("b")

        -- increment cursor
        Part.Cursor.incCursor(Part.Cursor.getCursorW(), 0)

        -- register bank button
        table.insert(self.config_buttons, Part.Draw.Elements.lastElement())

        -- if (i + 1) % 4 == 0 then
        --     button_x_end = Part.Cursor.getCursorX()
        --     Part.Cursor.setCursorPos(button_x, Part.Cursor.getCursorY())
        --     Part.Cursor.incCursor(0, Part.Cursor.getCursorH())
        -- end
    end

    -- offset position
    Part.Cursor.incCursor(5, 0)

    -- load to file using browser
    Part.Cursor.setCursorSize(35, self.button_h)
    button = Part.Control.Config.Load.ButtonConfigLoad:new(nil, self.handler, "Load")
    Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.config_slot_load, button, true)
    Part.Draw.Elements.lastElement():useSelectedConfig()
    Part.Cursor.incCursor(Part.Cursor.getCursorW(), 0)

    -- save from file using browser
    button = Part.Control.Config.Save.ButtonConfigSave:new(nil, self.handler, "Save")
    Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.config_slot_save, button, true)
    Part.Draw.Elements.lastElement():useSelectedConfig()
    Part.Cursor.incCursor(Part.Cursor.getCursorW(), 0)

    --  optional file handling (requires extension)
    -- =============================================

    -- Part.Cursor.setCursorPos(source_x + pos_file_handling_x, source_y)
    -- Part.Cursor.setCursorSize(60, self.button_h)
    -- Part.Cursor.stackCursor()

    -- -- load file
    -- if Part.Global.js_extension_available then
    --     button = Part.Control.Config.Load.ButtonConfigLoad:new(nil, self.handler, "Load File")
    --     Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.config_load_from_file, button, true)
    --     Part.Cursor.incCursor(0, Part.Cursor.getCursorH())
    -- end
    -- -- save file
    -- if Part.Global.js_extension_available then
    --     button = Part.Control.Config.Save.ButtonConfigSave:new(nil, self.handler, "Save File")
    --     Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.config_save_to_file, button, true)
    -- end

    -- Part.Cursor.destackCursor()
    -- Part.Cursor.incCursor(Part.Cursor.getCursorW(), 0)

    -- reset values button
    Part.Cursor.incCursor(5, 0)
    Part.Cursor.setCursorSize(40, nil)

    -- reset values button
    button = Part.Control.Config.HardReset.ButtonConfigResetHard:new(nil, self.handler, "Reset")
    Part.Control.Hint.Hint:new(nil, Part.Hint.Lookup.config_hard_reset, button, true)
end

--  Config Bar : Tab Check
-- -------------------------------------------

function layout.ConfigBar.ConfigBar:tabCheck()
    return true
end

-- ==========================================================================================
--                      Layout : Group
-- ==========================================================================================


-- Group
-- -------------------------------------------

layout.Group.Group = layout.LayoutElement:new()

function layout.Group.Group:new(o, header_text)
    o = o or layout.LayoutElement:new(o)
    setmetatable(o, self)
    self.__index = self

    -- transfer cursor dimensions
    Part.Cursor.applyCursorToTarget(o)

    -- header settings
    o.header_text = header_text
    o.limit_header_width = true
    o.header_width = 200
    o.header_pad = 4

    -- color values
    o.color_bg = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.group.bg)
    o.color_fg = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.group.fg)
    o.color_border = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.group.border)
    o.color_header_bg = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.group.header.bg)
    o.color_header_fg = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.group.header.fg)
    o.color_header_border = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.group.header.border)
    o.color_bg_tinted = Part.Functions.deepCopy(o.color_bg)

    -- register in list
    table.insert(Part.List.layout, o)

    return o
end

-- Group : Set Color
-- -------------------------------------------

function layout.Group.Group:setColor(fg, bg, border)
    -- foreground
    if type(fg) == "table" or fg == nil then
        self.color_font = fg
    end

    -- background
    if type(bg) == "table" or bg == nil then
        self.color_bg = bg
    end

    -- border
    if type(border) == "table" or border == nil then
        self.color_border = border
    end
end

-- Layout : Group : Stretch
-- -------------------------------------------

function layout.Group.Group:stretchToPosition(target_x, target_y)
    -- stretch width
    if target_x ~= nil then
        self.dim_w = target_x - self.dim_x
    end

    -- stretch height
    if target_y ~= nil then
        self.dim_h = target_y - self.dim_y
    end
end

-- Group : Draw
-- -------------------------------------------

function layout.Group.Group:draw()
    -- prepare dimensions
    local x = Part.Functions.rescale(self.dim_x, true)
    local y = Part.Functions.rescale(self.dim_y, false, true)
    local w = Part.Functions.rescale(self.dim_w)
    local h = Part.Functions.rescale(self.dim_h)

    local pad_x = self.header_pad
    local pad_y = self.header_pad
    local pad_x_text = Part.Functions.rescale(10)
    local pad_y_text = Part.Functions.rescale(2)
    local line_h = Part.Functions.rescale(18)
    local header_w = math.floor(w / 2)


    Part.Draw.Graphics.drawRectangle(x, y, w, h, self.color_bg_tinted, self.color_border)

    if self.header_text ~= nil then
        gfx.x = x + pad_x + pad_x_text
        gfx.y = y + pad_y + pad_y_text

        Part.Draw.Graphics.setFont(13, "b")

        -- make sure background is covering text
        local string_w = gfx.measurestr(self.header_text)

        -- original width calculation using half the width
        --local bg_w = math.max(string_w + pad_x_text * 2, header_w)

        -- width
        local bg_w = math.max(string_w + pad_x_text * 2, Part.Functions.rescale(150))

        -- draw background
        Part.Draw.Graphics.drawRectangle(x + pad_x, y + pad_y, bg_w, line_h, self.color_header_bg)

        -- draw text
        Part.Color.setColor(self.color_header_fg, true)
        gfx.drawstr(self.header_text, 0, gfx.x + w - pad_x * 2, gfx.y + line_h)
    end
end

-- ==========================================================================================
--                      Layout : Line
-- ==========================================================================================

-- Line
-- -------------------------------------------

layout.Line.Line = layout.LayoutElement:new()

function layout.Line.Line:new(o, start_x, start_y, vertical, length)
    o = o or layout.LayoutElement:new(o)
    setmetatable(o, self)
    self.__index = self

    -- transfer cursor dimensions
    Part.Cursor.applyCursorToTarget(o)

    -- coordinates
    o.start_x = start_x
    o.start_y = start_y
    o.vertical = vertical
    o.length = length

    -- scaling of thickness
    o.scaling_factor = 2

    -- color values
    o.color_fg = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.line)

    -- register in list
    table.insert(Part.List.layout, o)

    return o
end

-- Group : Scale
-- -------------------------------------------

function layout.Line.Line:scale(factor)
    self.scaling_factor = factor
end

-- Group : Set Color
-- -------------------------------------------

function layout.Line.Line:setColor(color)
    self.color_fg = color
end

-- Group : Draw
-- -------------------------------------------

function layout.Line.Line:draw()
    -- prepare dimensions
    local x = Part.Functions.rescale(self.start_x, true)
    local y = Part.Functions.rescale(self.start_y, false, true)
    local length = Part.Functions.rescale(self.length)

    -- target size
    local w
    local h

    -- thickness
    local thickness = math.ceil(Part.Draw.Graphics.border * self.scaling_factor)
    local thickness_offset = math.floor(thickness * 0.5)

    -- direction
    if self.vertical then
        x = x - thickness_offset
        w = thickness
        h = y + length
    else
        y = y - thickness_offset
        w = length
        h = thickness
    end

    -- draw line
    Part.Draw.Graphics.drawRectangle(x, y, w, h, self.color_fg, nil)
end

-- ==========================================================================================
--                      Layout : Box
-- ==========================================================================================

-- Box
-- -------------------------------------------

layout.Box.Box = layout.LayoutElement:new()

function layout.Box.Box:new(o, fill, border, start_x, start_y, width, height)
    o = o or layout.LayoutElement:new(o)
    setmetatable(o, self)
    self.__index = self

    -- transfer cursor dimensions
    Part.Cursor.applyCursorToTarget(o)

    o.fill = fill or false
    o.border = border or true

    -- coordinates
    o.start_x = start_x
    o.start_y = start_y
    o.width = width
    o.height = height

    -- color values default to nil
    o.color_fill = nil
    o.color_border = nil

    -- set colors depending on filling mode
    if fill then
        o.color_fill = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.box.fill)
    end

    if border then
        o.color_border = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.box.border)
    end

    -- register in list
    table.insert(Part.List.layout, o)

    return o
end

-- Group : Set Color
-- -------------------------------------------

function layout.Box.Box:setColor(input_fill, input_border)
    -- fill
    if self.fill and input_fill ~= nil then
        self.color_fill = input_fill
    end

    -- border
    if self.border and input_border ~= nil then
        self.color_fg = input_border
    end
end

-- Group : Draw
-- -------------------------------------------

function layout.Box.Box:draw()
    -- prepare dimensions
    local start_x = Part.Functions.rescale(self.start_x, true)
    local start_y = Part.Functions.rescale(self.start_y, false, true)
    local width = Part.Functions.rescale(self.width)
    local height = Part.Functions.rescale(self.height)

    -- draw box
    Part.Draw.Graphics.drawRectangle(start_x, start_y, width, height, self.color_fill, self.color_border)
end

-- ==========================================================================================
--                      Layout : Label
-- ==========================================================================================


-- Output : Label
-- -------------------------------------------
layout.Label.Label = layout.LayoutElement:new()

function layout.Label.Label:new(o)
    o = o or layout.LayoutElement:new(o)
    setmetatable(o, self)
    self.__index = self

    -- get cursor values
    Part.Cursor.applyCursorToTarget(o)

    -- color values
    o.color_bg = Part.Color.Lookup.color_palette.label.bg
    o.color_border = Part.Color.Lookup.color_palette.label.border

    -- optional underline
    o.use_table_underline = false
    o.use_table_underline_thickness = 2

    o.expand_w = 1
    o.expand_h = 1

    -- register in lists
    table.insert(Part.List.layout, o)
    table.insert(Part.List.layout_label, o)

    return o
end

-- Output : Label : Stretch
-- -------------------------------------------

function layout.Label.Label:stretch(x, y)
    if x ~= nil then self.dim_w = x - self.dim_x end
    if y ~= nil then self.dim_h = y - self.dim_y end
end

-- Output : Label : Table Row
-- -------------------------------------------

function layout.Label.Label:tableRow(uneven)
    if uneven ~= nil and uneven ~= 0 then
        self:setColor(Part.Color.Lookup.color_palette.table.row_uneven)
    else
        self:setColor(Part.Color.Lookup.color_palette.table.row_even)
    end
end

-- Output : Label : Underline
-- -------------------------------------------

function layout.Label.Label:tableUnderline(thickness)
    thickness = thickness or 2
    self.use_table_underline = true
    self.use_table_underline_thickness = thickness
end

-- Output : Label : Table Column
-- -------------------------------------------

function layout.Label.Label:tableColumn(uneven)
    if uneven ~= nil and uneven ~= 0 then
        self:setColor(Part.Color.Lookup.color_palette.table.column_uneven)
    else
        self:setColor(Part.Color.Lookup.color_palette.table.column_even)
    end
end

-- Output : Label : Table Empty Space
-- -------------------------------------------

function layout.Label.Label:tableEmptySpace()
    self:setColor(Part.Color.Lookup.color_palette.table.empty_space)
end

-- Output : Label : Set Color
-- -------------------------------------------

function layout.Label.Label:setColor(bg, border)
    -- background
    if type(bg) == "table" or bg == nil then
        self.color_bg = bg
    end

    -- border
    if type(border) == "table" or border == nil then
        self.color_border = border
    end
end

-- Output : Label : Draw
-- -------------------------------------------

function layout.Label.Label:draw()
    -- initialize dimensions
    local x = Part.Functions.rescale(self.dim_x - self.expand_w, self.autocenter_position)
    local y = Part.Functions.rescale(self.dim_y - self.expand_h, false, self.autocenter_position)
    local w = Part.Functions.rescale(self.dim_w + self.expand_w * 2)
    local h = Part.Functions.rescale(self.dim_h + self.expand_h * 2)
    local border = Part.Functions.rescale(self.use_table_underline_thickness)

    -- color required
    if self.color_bg ~= nil then
        if not self.use_table_underline then
            -- conventional background
            Part.Draw.Graphics.drawRectangle(x, y, w, h, self.color_bg, self.color_border)
        else
            -- underline for tables
            Part.Draw.Graphics.drawRectangle(x, y + h + math.floor(border * 0.5), w, border, self.color_bg,
                self.color_border)
        end
    end
end

-- ==========================================================================================
--                      Layout : Text
-- ==========================================================================================

-- Output : Text
-- -------------------------------------------
layout.Text.Text = layout.LayoutElement:new()

function layout.Text.Text:new(o, text_blank, parameter)
    o = o or layout.LayoutElement:new(o)
    setmetatable(o, self)
    self.__index = self

    -- padding
    self.pad_x = 2
    self.pad_y = 1

    -- get cursor values
    Part.Cursor.applyCursorToTarget(o)

    -- label text
    o.text_blank = text_blank

    -- linked parameter (replacing text_blank)
    o.parameter = parameter
    o.parameter_multiplier = 1

    -- flags for display formatting
    o.flags = 0

    -- optional underline
    o.draw_underline = false

    -- lookup table (for dynamic output text)
    o.lookup = nil

    -- custom expansion (for dealing with clipping)
    o.expand_w = 0
    o.expand_h = 0

    -- color values
    o.color_font = Part.Color.Lookup.color_palette.text.fg
    o.color_bg = Part.Color.Lookup.color_palette.text.bg
    o.color_border = Part.Color.Lookup.color_palette.text.border
    o.color_underline = Part.Color.Lookup.color_palette.text.underline

    -- is a divider (sub-heading)
    o.is_divider = false

    -- font flags
    self.font_flags = ""

    -- formatting flags
    o.flags = {
        center_horz = 0,
        center_vert = 0,
        right_just = 0,
        bottom_just = 0,
        ignore_right_bottom = 0
    }

    -- register in lists
    table.insert(Part.List.layout, o)
    table.insert(Part.List.layout_text, o)

    return o
end

--  Output : Text : Set Font Flags
-- -------------------------------------------

function layout.Text.Text:setFontFlags(flags)
    self.font_flags = flags
end

-- Output : Text : Expand
-- -------------------------------------------

function layout.Text.Text:expand(expand_w, expand_h)
    -- horizontal expansion
    if expand_w ~= nil then
        self.expand_w = expand_w
    end

    -- vertical expansion
    if expand_h ~= nil then
        self.expand_h = expand_h
    end
end

-- Output : Text : Parameter Label
-- -------------------------------------------

function layout.Text.Text:parameterLabel()
    self:justRight()
    self:centerVert()
    self:setColor(Part.Color.Lookup.color_palette.text.parameter.fg, Part.Color.Lookup.color_palette.text.parameter.bg,
        nil)
end

-- Output : Text : Info Label
-- -------------------------------------------

function layout.Text.Text:infoLabel()
    self:centerHorz()
    self:centerVert()
    self:setColor(Part.Color.Lookup.color_palette.text.info_fg, Part.Color.Lookup.color_palette.text.info_bg,
        nil)
end

-- Output : Text : Table Header
-- -------------------------------------------

function layout.Text.Text:tableHeader(colspan)
    self:centerHorz()
    self:expand(20)

    self:setColor(Part.Color.Lookup.table.header_fg, nil, nil)

    if colspan ~= nil and colspan > 1 then
        self.colspan = colspan
    end
end

-- Output : Text : Table Entry
-- -------------------------------------------

function layout.Text.Text:tableEntry(just_right)
    if just_right ~= nil and just_right then
        self:justRight()
    end

    self:setColor(Part.Color.Lookup.color_palette.table.entry_fg, nil, nil)
end

-- Output : Text : Parameter Monitor
-- -------------------------------------------

function layout.Text.Text:parameterMonitor(multiplier)
    self:setColor(Part.Color.Lookup.color_palette.text.monitor.fg, Part.Color.Lookup.color_palette.text.monitor.bg,
        Part.Color.Lookup.color_palette.text.monitor.border)

    self.parameter_multiplier = multiplier or 1

    self:centerHorz()
    self:centerVert()

    table.insert(Part.List.layout_redraw, self)
end

-- Output : Text : Divider
-- -------------------------------------------

function layout.Text.Text:divider(keep_width)
    local keep_width = keep_width or false

    -- divider settings
    self.ignore_cols = not keep_width

    self:centerHorz()
    self:centerVert()
    self:setColor(Part.Color.Lookup.color_palette.label.divider, Part.Color.Lookup.color_palette.label.divider_bg, nil)


    -- register itself as divider
    self.is_divider = true
end

-- Output : Text : Underline
-- -------------------------------------------

function layout.Text.Text:underline()
    self.draw_underline = true
end

-- Output : Text : Set Color
-- -------------------------------------------

function layout.Text.Text:setColor(fg, bg, border, underline)
    -- foreground
    if type(fg) == "table" or fg == nil then
        self.color_font = fg
    end

    -- background
    if type(bg) == "table" or bg == nil then
        self.color_bg = bg
    end

    -- border
    if type(border) == "table" or border == nil then
        self.color_border = border
    end

    -- underline
    if type(underline) == "table" or underline == nil then
        self.color_underline = underline
    end
end

-- Output : Text : Get Flags
-- -------------------------------------------

function layout.Text.Text:getFlags()
    -- return value
    local rtn = 0

    -- construct flag number
    for i, v in pairs(self.flags) do
        rtn = rtn + v
    end

    -- return flags
    return rtn
end

-- Output : Text : Center Horizontally
-- -------------------------------------------

function layout.Text.Text:centerHorz(on)
    if on == nil or on then
        self.flags["center_horz"] = 1
    else
        self.flags["center_horz"] = 0
    end
end

-- Output : Text : Center Vertically
-- -------------------------------------------

function layout.Text.Text:centerVert(on)
    if on == nil or on then
        self.flags["center_vert"] = 4
    else
        self.flags["center_vert"] = 0
    end
end

-- Output : Text : Justify Right
-- -------------------------------------------

function layout.Text.Text:justRight(on)
    if on == nil or on then
        self.flags["just_right"] = 2
    else
        self.flags["just_right"] = 0
    end
end

-- Output : Text : Justify Bottom
-- -------------------------------------------

function layout.Text.Text:justBottom(on)
    if on == nil or on then
        self.flags["just_bottom"] = 8
    else
        self.flags["just_bottom"] = 0
    end
end

-- Output : Text : Ignore Right Bottom
-- -------------------------------------------

function layout.Text.Text:ignoreRightBottom(on)
    if on == nil or on then
        self.flags["ignore_right_bottom"] = 256
    else
        self.flags["ignore_right_bottom"] = 0
    end
end

-- Output : Text : Set Lookup Table
-- -------------------------------------------

function layout.Text.Text:setLookupTable(lookup)
    -- convert lookup table values to string
    for i, v in pairs(lookup) do
        lookup[i] = tostring(v)
    end

    -- store lookup values
    self.lookup = lookup
end

-- Output : Text : Draw
-- -------------------------------------------

function layout.Text.Text:draw()
    -- initialize dimensions
    local x = Part.Functions.rescale(self.dim_x - self.expand_w, self.autocenter_position)
    local y = Part.Functions.rescale(self.dim_y - self.expand_h, false, self.autocenter_position)
    local w = Part.Functions.rescale(self.dim_w + self.expand_w * 2)
    local h = Part.Functions.rescale(self.dim_h + self.expand_h * 2)

    -- font y position
    local y_f = Part.Functions.rescale(self.dim_y - 2 - -self.expand_h, false, self.autocenter_position)

    -- padding
    local p_x = Part.Functions.rescale(self.pad_x)
    local p_y = Part.Functions.rescale(self.pad_y)

    -- background color available?
    if self.color_bg ~= nil then
        Part.Draw.Graphics.drawRectangle(x, y, w, h, self.color_bg, self.color_border)
    end

    -- font color
    Part.Color.setColor(self.color_font, true)

    -- custom font position
    Part.Cursor.setCursorPos(x + p_x, y_f + p_y)

    -- output text
    local text = self.text_blank

    -- direct parameter value
    if self.parameter ~= nil then
        text = tostring(self.parameter:getValue() * self.parameter_multiplier)
    end

    -- lookup table
    if self.lookup ~= nil then
        -- calculate index based on value
        local idx = math.floor(self.parameter:getValue() - self.parameter.value_min) + 1

        -- cap index
        idx = math.min(idx, #self.lookup)

        -- pick text from lookup
        text = self.lookup[idx]
    end

    -- draw text
    Part.Draw.Graphics.setFont(13, self.font_flags)

    gfx.drawstr(text, self:getFlags(), x + w - p_x * 2, y + h - p_y * 2)

    -- optional underline
    if self.draw_underline then
        local line_h = Part.Functions.rescale(16)
        local pad_line = Part.Functions.rescale(20)
        Part.Draw.Graphics.drawRectangle(x, y + line_h, w, Part.Draw.Graphics.border,
            self.color_underline)
    end
end

-- ==========================================================================================
--                      Layout : Image
-- ==========================================================================================


-- Image
-- -------------------------------------------

layout.Image.Image = layout.LayoutElement:new()

-- lookup table, used for detecting duplicates
layout.Image.image_lookup = {}

function layout.Image.Image:new(o, file, hdpi, scale, alpha)
    o = o or layout.LayoutElement:new(o)
    setmetatable(o, self)
    self.__index = self

    -- file path
    o.file = file

    -- scaling
    o.scale = scale or 1

    -- transparency
    o.alpha = alpha or 1

    -- [!] don't use hdpi assets (works, image count is way too high)
    --o.use_hdpi_assets = hdpi or false
    o.use_hdpi_assets = false

    -- hdpi levels
    o.levels = { 100, 125, 150, 175, 200, 225, 250 }

    -- image handle is current image index
    o.handle = Part.Draw.Sprites.getNextFreeImageSlot()

    -- use existing handle or initially load image
    if layout.Image.image_lookup[file] ~= nil then
        o.handle = layout.Image.image_lookup[file].handle
    else
        o:load()
    end

    -- justification
    o.justHorz = 0
    o.justVert = 0

    -- transfer cursor dimensions
    Part.Cursor.applyCursorToTarget(o)

    -- register image in list
    table.insert(Part.List.layout, o)

    -- store image in lookup table
    layout.Image.image_lookup[file] = o

    return o
end

-- Image : Justify
-- -------------------------------------------

-- left
function layout.Image.Image:justLeft()
    self.justHorz = -1
end

-- right
function layout.Image.Image:justRight()
    self.justHorz = 1
end

-- top
function layout.Image.Image:justTop()
    self.justVert = -1
end

-- bottom
function layout.Image.Image:justBottom()
    self.justVert = 1
end

-- Image : Load
-- -------------------------------------------

function layout.Image.Image:load()
    -- use hdpi assets?
    if self.use_hdpi_assets then
        -- go through levels
        for i = 0, #self.levels - 1 do
            -- construct filename from base filename and zoom level
            local filename = self.file .. ".png"

            -- load image
            if i == 0 then
                gfx.loadimg(self.handle + i, ScriptPath .. filename)
            else
                -- Find the position of the last slash
                local last_slash_Pos = self.file:match(".*()/")
                local before_last_folder = self.file:sub(1, last_slash_Pos - 1)
                local file = self.file:sub(last_slash_Pos + 1)
                local path = before_last_folder .. "/" .. self.levels[i + 1] .. "/" .. file .. ".png"
                gfx.loadimg(self.handle + i, ScriptPath .. path)
            end

            -- increment image index
            Part.Draw.Sprites.getNextFreeImageSlot()
        end
    else
        -- load image
        gfx.loadimg(self.handle, ScriptPath .. self.file .. ".png")

        -- increment image index
        Part.Draw.Sprites.getNextFreeImageSlot()
    end
end

-- Image : Draw
-- -------------------------------------------

function layout.Image.Image:draw()
    -- prepare dimensions
    local x = Part.Functions.rescale(self.dim_x, true)
    local y = Part.Functions.rescale(self.dim_y, false, true)
    local w = Part.Functions.rescale(self.dim_w)
    local h = Part.Functions.rescale(self.dim_h)

    -- set transparency
    Part.Color.setColor({ 0, 0, 0, self.alpha })

    -- use hdpi assets?
    if self.use_hdpi_assets then
        -- image handle offset
        local handle_plus = 0

        -- go through levels
        for key, val in pairs(self.levels) do
            -- level is matching scale?
            if Part.Global.scale * 100 >= val then
                -- increment handle offset
                handle_plus = key - 1
            end
        end

        -- set drawing cursor
        Part.Cursor.setCursor(x, y, w, h)

        -- get image dimensions
        local img_w, img_h = gfx.getimgdim(self.handle + handle_plus)

        -- justify left
        if self.justHorz == 0 then
            gfx.x = gfx.x + (w - img_w) / 2
        end

        -- justify right
        if self.justHorz > 0 then
            gfx.x = gfx.x + (w - img_w)
        end

        -- justify top
        if self.justVert == 0 then
            gfx.y = gfx.y + (h - img_h) / 2
        end

        -- justify bottom
        if self.justVert > 0 then
            gfx.y = gfx.y + (h - img_h)
        end

        -- draw image
        gfx.blit(self.handle + handle_plus, 1, 0)

        -- reset cursor
        Part.Cursor.setCursor(x, y, w, h)

        -- don't use hdpi assets?
    else
        Part.Cursor.setCursor(x, y, w, h)

        -- calculate image size
        local size = Part.Global.scale / 2

        -- get image dimensions
        local img_w, img_h = gfx.getimgdim(self.handle)

        -- rescaling
        img_w = img_w * size
        img_h = img_h * size

        -- justify left
        if self.justHorz == 0 then
            gfx.x = gfx.x + (w - img_w) / 2
        end

        -- justify right
        if self.justHorz > 0 then
            gfx.x = gfx.x + (w - img_w)
        end

        -- justify top
        if self.justVert == 0 then
            gfx.y = gfx.y + (h - img_h) / 2
        end

        -- justify bottom
        if self.justVert > 0 then
            gfx.y = gfx.y + (h - img_h)
        end

        -- draw image
        gfx.blit(self.handle, size, 0)

        -- reset cursor
        Part.Cursor.setCursor(x, y, w, h)
    end
end

-- ==========================================================================================
--                      Layout : Spritesheet
-- ==========================================================================================

-- Spritesheet
-- -------------------------------------------

layout.sprites = 0

function layout.Spritesheet:new(o, file_image, file_lookup)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    -- file path
    o.file_image = file_image
    o.file_lookup = file_lookup

    o.lookup_data = require(file_lookup)

    o.handle = Part.Draw.Sprites.getNextFreeImageSlot()
    gfx.loadimg(o.handle, ScriptPath .. o.file_image)

    return o
end

-- Spritesheet : Load
-- -------------------------------------------

function layout.Spritesheet:getSprite(theme, dpi, name)
    if self.lookup_data[theme][dpi][name] ~= nil then
        local x = self.lookup_data[theme][dpi][name].x
        local y = self.lookup_data[theme][dpi][name].y
        local w = self.lookup_data[theme][dpi][name].width
        local h = self.lookup_data[theme][dpi][name].height

        return x, y, w, h
    end

    return nil
end

-- Spritesheet : Draw Sprite
-- -------------------------------------------

function layout.Spritesheet:drawSprite(name, src_x, src_y, src_w, src_h, just_horz, just_vert, scaling)
    local current_theme = Part.Global.themes[Part.Global.par_theme_selected:getValue() + 1]
    local current_dpi = Part.Global.scale * 100

    scaling = scaling or 1

    local sheet_x, sheet_y, sheet_w, sheet_h = self:getSprite(current_theme, current_dpi, name)

    Part.Cursor.setCursorPos(src_x, src_y)

    -- justify left
    if just_horz == 0 then
        gfx.x = gfx.x + (src_w - sheet_w) / 2
    end

    -- justify right
    if just_horz > 0 then
        gfx.x = gfx.x + (src_w - sheet_w)
    end

    -- justify top
    if just_vert == 0 then
        gfx.y = gfx.y + (src_h - sheet_h) / 2
    end

    -- justify bottom
    if just_vert > 0 then
        gfx.y = gfx.y + (src_h - sheet_h)
    end


    if sheet_x ~= nil then
        gfx.blit(self.handle, 1, 0, sheet_x, sheet_y, sheet_w, sheet_h, gfx.x, gfx.y, sheet_w * scaling, sheet_h * scaling, 0, 0)
    end
end

-- ==========================================================================================
--                      Layout : Sprite
-- ==========================================================================================

-- Sprite
-- -------------------------------------------

layout.Sprite.Sprite = layout.LayoutElement:new()

function layout.Sprite.Sprite:new(o, spritesheet, name, alpha, draw_to_buffer)
    o = o or layout.LayoutElement:new(o)
    setmetatable(o, self)
    self.__index = self

    o.spritesheet = spritesheet
    o.name = name

    o.alpha = alpha or 1

    -- can be excluded from buffer -> requires manual drawing call
    o.draw_to_buffer = draw_to_buffer or true

    -- justification
    o.justHorz = 0
    o.justVert = 0

    -- center on resize
    o.center_x = true
    o.center_y = true

    -- stick sprite to bottom edge
    o.stick_to_bottom = false

    -- optional scaling
    o.scale_factor = 1

    -- transfer cursor dimensions
    Part.Cursor.applyCursorToTarget(o)

    -- register sprite in list
    if o.draw_to_buffer then
        table.insert(Part.List.layout, o)
    end

    return o
end

-- Sprite : Set Center Behaviour
-- -------------------------------------------

function layout.Sprite.Sprite:setCenterBehaviour(center_x, center_y, stick_to_bottom)
    if center_x ~= nil then
        self.center_x = center_x
    end
    if center_y ~= nil then
        self.center_y = center_y
    end
    if stick_to_bottom ~= nil then
        self.stick_to_bottom = stick_to_bottom
    end
end

-- Sprite : Scale
-- -------------------------------------------

function layout.Sprite.Sprite:setScaleFactor(factor)
    self.scale_factor = factor or 1
end

-- Sprite : Justify
-- -------------------------------------------

-- left
function layout.Sprite.Sprite:justLeft()
    self.justHorz = -1
end

-- right
function layout.Sprite.Sprite:justRight()
    self.justHorz = 1
end

-- top
function layout.Sprite.Sprite:justTop()
    self.justVert = -1
end

-- bottom
function layout.Sprite.Sprite:justBottom()
    self.justVert = 1
end

-- Sprite : Draw
-- -------------------------------------------

function layout.Sprite.Sprite:draw()
    -- optionally stick to bottom
    local bottom_offset = 0
    if self.stick_to_bottom then
        bottom_offset = Part.Global.win_y_offset
    end

    -- prepare dimensions
    local x = Part.Functions.rescale(self.dim_x, self.center_x)
    local y = Part.Functions.rescale(self.dim_y + bottom_offset, false, self.center_y)
    local w = Part.Functions.rescale(self.dim_w)
    local h = Part.Functions.rescale(self.dim_h)

    gfx.a = self.alpha

    -- draw sprite
    self.spritesheet:drawSprite(self.name, x, y, w, h, self.justHorz, self.justVert, self.scale_factor)
end

-- ==========================================================================================
--                      Layout : Function
-- ==========================================================================================

-- Function
-- -------------------------------------------

layout.Function.Function = layout.LayoutElement:new()

function layout.Function.Function:new(o, function_address, ...)
    o = o or layout.LayoutElement:new(o)
    setmetatable(o, self)
    self.__index = self

    -- store address of target function
    o.function_address = function_address
    o.function_args = { ... } or {}

    -- transfer cursor dimensions
    Part.Cursor.applyCursorToTarget(o)

    -- register sprite in list
    table.insert(Part.List.layout, o)

    return o
end

-- Function : Draw
-- -------------------------------------------

function layout.Function.Function:draw()
    -- prepare dimensions
    local x = Part.Functions.rescale(self.dim_x, true)
    local y = Part.Functions.rescale(self.dim_y, false, true)
    local w = Part.Functions.rescale(self.dim_w)
    local h = Part.Functions.rescale(self.dim_h)

    -- update cursor position before function call
    Part.Cursor.stackCursor()
    Part.Cursor.setCursor(x, y, w, h, 0, 0)

    -- call function
    local f = self.function_address
    if f then
        f(table.unpack(self.function_args))
    end
    Part.Cursor.destackCursor()
end

return layout
