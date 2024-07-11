-- @version 1.0.4
-- @author Fleeesch
-- @description paRt Theme Adjuster
-- @noIndex



local layout = { BankBar = {}, Group = {}, Label = {}, Text = {}, Image = {} }

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
    o.button_size = 24

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
    Part.Cursor.incCursor(0, 7)

    -- set button dimensions
    Part.Cursor.setCursorSize(self.button_size, self.button_size)
    Part.Cursor.setCursorPadding(self.padding, self.padding)

    -- go through banks
    for idx, bank in pairs(self.handler.bank_slot) do
        -- bank is not a global bank?
        if not bank:isGlobal() then
            -- create bank button
            Part.Control.Bank.Select.ButtonBankSelect:new(nil, self.handler, bank.label, bank)

            Part.Draw.Elements.lastElement():setFontFlags("b")

            -- increment cursor
            Part.Cursor.incCursor(Part.Cursor.getCursorW(), 0)

            -- register bank button
            table.insert(self.bank_buttons, Part.Draw.Elements.lastElement())
        end
    end

    -- copy button
    Part.Control.Bank.Copy.ButtonBankCopy:new(nil, self.handler, "Copy Bank")

    Part.Cursor.incCursor(Part.Cursor.getCursorW() + 10, 0)

    -- save and load are only drawn when the JS_Extension is installed
    Part.Cursor.setCursorSize(40, self.button_size)

    if Part.Global.js_extension_available then
        Part.Control.Bank.Save.ButtonBankSave:new(nil, self.handler, "Save")
    end

    Part.Cursor.incCursor(Part.Cursor.getCursorW(), 0)

    if Part.Global.js_extension_available then
    Part.Control.Bank.Load.ButtonBankLoad:new(nil, self.handler, "Load")
    end

    Part.Cursor.incCursor(Part.Cursor.getCursorW() + 10, 0)

    -- reset values button
    Part.Control.Bank.Reset.ButtonBankReset:new(nil, self.handler, "Default Config")

    Part.Cursor.incCursor(Part.Cursor.getCursorW(), 0)

    -- reset values button
    Part.Control.Bank.HardReset.ButtonBankResetHard:new(nil, self.handler, "Hard Reset")
end

--  Bank Bar : Draw
-- -------------------------------------------

function layout.BankBar.BankBar:draw()
    -- prepare dimensions
    local x = Part.Functions.rescale(self.dim_x)
    local y = Part.Functions.rescale(self.dim_y + Part.Global.win_y_offset)
    local w = gfx.w
    local h = gfx.h - y

    -- draw background, rest of drawing is handled by individual elements
    Part.Draw.Graphics.drawRectangle(x, y, w, h, self.color_bg, self.color_border)
end

--  Bank Bar : Tab Check
-- -------------------------------------------

function layout.BankBar.BankBar:tabCheck()
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

    o.header_text = header_text

    -- color values
    o.color_bg = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.group.bg)
    o.color_fg = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.group.fg)
    o.color_border = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.group.border)
    o.color_header_bg = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.group.header.bg)
    o.color_header_fg = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.group.header.fg)
    o.color_header_border = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.group.header.border)
    o.color_bg_tinted = Part.Functions.deepCopy(o.color_bg)

    -- register image in list
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

-- Layout : Group : Set Tint
-- -------------------------------------------

function layout.Group.Group:setTint(tint)
    -- check if tint exists
    if Part.Color.Lookup.color_palette.group.tint ~= nil then
        -- get tint
        local tint_color = Part.Color.Lookup.color_palette.group.tint[tint]

        -- inrterpolate color values using the tints alpha value
        self.color_bg_tinted[1] = Part.Functions.interpolate(self.color_bg[1], tint_color[1], tint_color[4])
        self.color_bg_tinted[2] = Part.Functions.interpolate(self.color_bg[2], tint_color[2], tint_color[4])
        self.color_bg_tinted[3] = Part.Functions.interpolate(self.color_bg[3], tint_color[3], tint_color[4])

        -- use the original color alpha value
        self.color_bg_tinted[4] = self.color_bg[4]

        -- mark color as tinted
        self.color_is_tinted = true
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

    local pad_x = Part.Functions.rescale(10)
    local pad_y = Part.Functions.rescale(4)

    Part.Draw.Graphics.drawRectangle(x, y, w, h, self.color_bg_tinted, self.color_border)

    if self.header_text ~= nil then
        gfx.x = x + pad_x
        gfx.y = y + pad_y

        local line_h = Part.Functions.rescale(16)
        local pad_line = Part.Functions.rescale(20)

        Part.Color.setColor(self.color_fg, true)
        Part.Draw.Graphics.setFont(16)
        gfx.drawstr(self.header_text, 1, gfx.x + w - pad_x * 2, gfx.y + line_h)

        Part.Draw.Graphics.drawRectangle(x + pad_line, gfx.y + line_h, w - pad_line * 2, Part.Draw.Graphics.border,
            self.color_header_border)
    end
end

-- ==========================================================================================
--                      Layout : Label
-- ==========================================================================================


-- Output : Text
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

    o.expand_w = 1
    o.expand_h = 1

    -- register in lists
    table.insert(Part.List.layout, o)
    table.insert(Part.List.layout_label, o)

    return o
end

-- Output : Text : Stretch
-- -------------------------------------------

function layout.Label.Label:stretch(x, y)
    if x ~= nil then self.dim_w = x - self.dim_x end
    if y ~= nil then self.dim_h = y - self.dim_y end
end

-- Output : Text : Table Row
-- -------------------------------------------

function layout.Label.Label:tableRow(uneven)
    if uneven ~= nil and uneven ~= 0 then
        self:setColor(Part.Color.Lookup.color_palette.table.row_uneven)
    else
        self:setColor(Part.Color.Lookup.color_palette.table.row_even)
    end
end

-- Output : Text : Table Column
-- -------------------------------------------

function layout.Label.Label:tableColumn(uneven)
    if uneven ~= nil and uneven ~= 0 then
        self:setColor(Part.Color.Lookup.color_palette.table.column_uneven)
    else
        self:setColor(Part.Color.Lookup.color_palette.table.column_even)
    end
end

-- Output : Text : Table Empty Space
-- -------------------------------------------

function layout.Label.Label:tableEmptySpace()
    self:setColor(Part.Color.Lookup.color_palette.table.empty_space)
end

-- Output : Text : Set Color
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

-- Output : Text : Draw
-- -------------------------------------------

function layout.Label.Label:draw()
    -- initialize dimensions
    local x = Part.Functions.rescale(self.dim_x - self.expand_w, self.autocenter_position)
    local y = Part.Functions.rescale(self.dim_y - self.expand_h, false, self.autocenter_position)
    local w = Part.Functions.rescale(self.dim_w + self.expand_w * 2)
    local h = Part.Functions.rescale(self.dim_h + self.expand_h * 2)


    -- background color available?
    if self.color_bg ~= nil then
        Part.Draw.Graphics.drawRectangle(x, y, w, h, self.color_bg, self.color_border)
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

    -- lookup table (for dynamic output text)
    o.lookup = nil

    -- custom expansion (for dealing with clipping)
    o.expand_w = 0
    o.expand_h = 0

    -- color values
    o.color_font = Part.Color.Lookup.color_palette.text.fg
    o.color_bg = Part.Color.Lookup.color_palette.text.bg
    o.color_border = Part.Color.Lookup.color_palette.text.border

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
    self:setColors(Part.Color.Lookup.color_palette.label.divider, Part.Color.Lookup.color_palette.label.divider_bg, nil)
    --self:setFontFlags("b")

    -- register itself as divider
    self.is_divider = true
end

-- Output : Text : Set Color
-- -------------------------------------------

function layout.Text.Text:setColor(fg, bg, border)
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

    -- draw
    Part.Draw.Graphics.setFont(16, self.font_flags)

    gfx.drawstr(text, self:getFlags(), x + w - p_x * 2, y + h - p_y * 2)
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

        -- Part.Functions.rescale( dimensions
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

return layout
