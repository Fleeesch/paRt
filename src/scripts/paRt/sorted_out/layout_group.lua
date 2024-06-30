local layout = {}

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Layout : Group
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

layout.Group = Part.Layout.LayoutElement:new()

function layout.Group:new(o)
    o = o or Part.Layout.LayoutElement:new(o)
    setmetatable(o, self)
    self.__index = self

    -- transfer cursor dimensions
    Part.Cursor.applyCursorToTarget(o)

    -- rows
    o.rows = {}

    -- use row shading
    o.row_shading = false

    -- row shading visibility
    o.row_shading_depth = 1

    -- row shading offset
    o.row_shading_offset = 0

    -- row shading expansion
    o.row_shading_expand = 0

    -- row shading alternating
    o.row_shading_alternate = false

    -- row shading mask table
    o.row_shading_mask = nil

    -- padding
    o.pad = 8

    -- sidebar color tint
    o.sidebar = 6

    -- sync button parameter
    o.header_button_parameter = nil

    -- group label
    o.header_label = nil

    -- tint saturation of inner bg
    o.bg_inner_tint_factor = 0.08

    -- colors
    o.color_bg = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.group.bg)
    o.color_border = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.group.border)
    o.color_border_header = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.group.border_header)
    o.color_inner = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.group.bg_inner)
    o.color_shading_main = Part.Functions.deepCopy(o.color_bg)
    o.color_shading_alt = Part.Functions.deepCopy(o.color_bg)
    o.row_shading_factor_main = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.group.row_shading)
    o.row_shading_factor_alt = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.group.row_shading_alt)

    -- custom tint
    o.tint_color = nil

    -- color with custom tint mixed in
    o.color_tinted = {}
    o.color_inner_tinted = {}

    -- custom tint application flag
    o.color_is_tinted = false

    -- hint message
    o.hint = nil

    -- register in lists
    table.insert(Part.List.layout, o)
    table.insert(Part.List.layout_group, o)

    return o
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Layout : Group : Apply Row Shading
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function layout.Group:applyRowShading(depth, alternate, offset, expand, mask)
    -- activate row shading
    self.row_shading = true

    if depth ~= nil then
        self.row_shading_depth = depth
    end

    if alternate ~= nil then
        self.row_shading_alternate = alternate
    end

    if offset ~= nil then
        self.row_shading_offset = offset
    end

    if expand ~= nil then
        self.row_shading_expand = expand
    end

    if mask ~= nil then
        self.row_shading_mask = mask
    end
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Layout : Group : Add Row
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function layout.Group:addRow(x, y, w, h)
    -- insert row with specific dimensions
    table.insert(self.rows, { x, y, w, h })
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Layout : Group : Open
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function layout.Group:open(header)
    Part.Cursor.stackCursor()

    -- group top left corner
    self.dim_x = Part.Cursor.getCursorX()
    self.dim_y = Part.Cursor.getCursorY()

    -- create optional header label
    if header ~= nil then
        Part.Cursor.stackCursor()

        self.header_label = OutputText:new(nil, tostring(header))
        Part.Draw.Elements.lastElement():setColor(Part.Color.Lookup.color_palette.group.header_fg, Part.Color.Lookup.color_palette.group.header_bg, Part.Color.Lookup.color_palette.group.border_header)
        Part.Draw.Elements.lastElement():centerHorz(true)
        Part.Draw.Elements.lastElement():narrowShadow()
        Part.Draw.Elements.lastElement():setFontFlags("b")

        Part.Cursor.destackCursor()
        Part.Cursor.incCursor(0, Part.Cursor.getCursorH() + self.sidebar, 0, 0)
    end

    -- group internal padding
    Part.Cursor.incCursor(self.pad + self.sidebar, self.pad, 0, 0)

    Part.Cursor.stackCursor()
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Layout : Group : Close
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function layout.Group:close(inc_x, inc_y)
    -- optionally increment x with last elements width
    if inc_x ~= nil and inc_x then
        Part.Cursor.incCursor(Part.Cursor.getCursorW(), 0, 0, 0)
    end

    -- optionally increment y with last elements height
    if inc_y ~= nil and inc_y then
        Part.Cursor.incCursor(0, Part.Cursor.getCursorH(), 0, 0)
    end

    -- group padding
    Part.Cursor.incCursor(self.pad, self.pad, 0, 0)

    -- update width and height
    self.dim_w = Part.Cursor.getCursorX() - self.dim_x
    self.dim_h = Part.Cursor.getCursorY() - self.dim_y

    -- update header dimensions
    if self.header_label ~= nil then
        self.header_label.dim_x = self.dim_x
        self.header_label.dim_y = self.dim_y + Part.Functions.rescale(self.sidebar)
        self.header_label.dim_w = self.dim_w
    end

    -- hint on hover
    if self.hint ~= nil then
        Part.Cursor.stackCursor()

        Part.Cursor.setCursor(self.dim_x + Part.Draw.Graphics.border, self.dim_y + Part.Draw.Graphics.border, self.dim_w - Part.Draw.Graphics.border * 2,
            Part.Cursor.getCursorH() - Part.Draw.Graphics.border * 2 + self.sidebar)
        if self.header_sync_button ~= nil then
            Part.Cursor.setCursorSize(Part.Cursor.getCursorW() - 16, Part.Cursor.getCursorH())
        end

        local hint = Hint:new(nil, self.hint, self, true)
        hint:parameterHint(true)
        Part.Cursor.destackCursor()
    end

    -- add optional sync button
    if self.header_sync_button ~= nil then
        Part.Cursor.stackCursor()

        -- position at top right corner
        Part.Cursor.setCursor(self.dim_x + self.dim_w - 16, self.dim_y + self.sidebar, 16, Part.Cursor.getCursorH())

        -- bank button
        Button:new(nil, self.header_sync_button, true, "B", 1)
        Part.Draw.Elements.lastElement():triggerBankUpdate()
        Part.Draw.Elements.lastElement():setColor(Part.Color.Lookup.color_palette.button.sync_off_fg, Part.Color.Lookup.color_palette.button.sync_off_bg,
        Part.Color.Lookup.color_palette.button.sync_on_fg, Part.Color.Lookup.color_palette.button.sync_on_bg, Part.Color.Lookup.color_palette.button.sync_border)
        Part.Draw.Elements.lastElement():setFontFlags("b")

        Part.Cursor.destackCursor()
    end

    Part.Cursor.destackCursor()
    Part.Cursor.destackCursor()
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Layout : Group : Add Hint
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function layout.Group:addHint(hint)
    -- register sync button using its parameter
    self.hint = tostring(hint)
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Layout : Group : Add Sync Button
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function layout.Group:addSyncButton(parameter)
    -- register sync button using its parameter
    self.header_sync_button = parameter
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Layout : Group : Set Tint
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function layout.Group:setTint(tint)
    -- check if tint exists
    if Part.Color.Lookup.color_palette.group.tint ~= nil then
        -- get tint
        local tint_color = Part.Color.Lookup.color_palette.group.tint[tint]

        -- inrterpolate color values using the tints alpha value
        self.color_tinted[1] = Part.Functions.interpolate(self.color_bg[1], tint_color[1], tint_color[4])
        self.color_tinted[2] = Part.Functions.interpolate(self.color_bg[2], tint_color[2], tint_color[4])
        self.color_tinted[3] = Part.Functions.interpolate(self.color_bg[3], tint_color[3], tint_color[4])

        -- use the original color alpha value
        self.color_tinted[4] = self.color_bg[4]

        -- inner color
        self.color_inner_tinted[1] = Part.Functions.interpolate(self.color_inner[1], tint_color[1],
            tint_color[4] * self.bg_inner_tint_factor)
        self.color_inner_tinted[2] = Part.Functions.interpolate(self.color_inner[2], tint_color[2],
            tint_color[4] * self.bg_inner_tint_factor)
        self.color_inner_tinted[3] = Part.Functions.interpolate(self.color_inner[3], tint_color[3],
            tint_color[4] * self.bg_inner_tint_factor)
        self.color_inner_tinted[4] = self.color_inner[4]

        -- row shading main
        self.color_shading_main[1] = self.color_inner_tinted[1] * self.row_shading_factor_main
        self.color_shading_main[2] = self.color_inner_tinted[2] * self.row_shading_factor_main
        self.color_shading_main[3] = self.color_inner_tinted[3] * self.row_shading_factor_main

        -- row shading alt
        self.color_shading_alt[1] = self.color_inner_tinted[1] * self.row_shading_factor_alt
        self.color_shading_alt[2] = self.color_inner_tinted[2] * self.row_shading_factor_alt
        self.color_shading_alt[3] = self.color_inner_tinted[3] * self.row_shading_factor_alt

        -- mark color as tinted
        self.color_is_tinted = true
    end
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Layout : Group : Draw
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function layout.Group:draw()
    -- setup dimensions
    local x = Part.Functions.rescale(self.dim_x)
    local y = Part.Functions.rescale(self.dim_y)
    local w = Part.Functions.rescale(self.dim_w)
    local h = Part.Functions.rescale(self.dim_h)

    local bar = Part.Functions.rescale(self.sidebar)

    -- draw box shadow
    Part.Draw.Graphics.drawShadow(x, y, w, h)

    -- load background color
    local color_bg = self.color_bg
    local color_bg_inner = self.color_inner

    -- use tinted color if available
    if self.color_is_tinted then
        color_bg = self.color_tinted
        color_bg_inner = self.color_inner_tinted
    end

    -- draw background
    Part.Draw.Graphics.drawRectangle(x, y, w, h, color_bg_inner, self.color_border)

    -- draw sidebar tint
    local bar_y = y

    if self.header_label ~= nil then
        bar_y = bar_y + self.header_label.dim_h
    end

    Part.Draw.Graphics.drawRectangle(x, y, w, bar + Part.Draw.Graphics.border, color_bg, self.color_border_header)

    -- row shading enabled?
    if self.row_shading then
        -- go through rows

        local shading_idx = 0

        for key, val in pairs(self.rows) do
            -- skip row flag
            local skip_row = false

            -- shading mask available?
            if self.row_shading_mask then
                -- calculate mask index
                local mask_idx = key % #self.row_shading_mask

                if self.row_shading_mask[mask_idx] == 2 then
                    shading_idx = shading_idx + 1
                    skip_row = true
                end

                -- mask position set to skip this row?
                if self.row_shading_mask[mask_idx] == 0 then
                    -- mark row as skipped
                    skip_row = true
                end
            end

            -- row shall not be skipped=?
            if not skip_row then
                -- check if row line is even
                local row_alt = (shading_idx + self.row_shading_offset) % 2

                if not self.row_shading_alternate and self.row_shading_offset then
                    row_alt = 1
                end

                -- calculate row dimensions
                local row_x = Part.Functions.rescale(val[1] - self.row_shading_expand)
                local row_y = Part.Functions.rescale(val[2] - self.row_shading_expand)
                local row_w = Part.Functions.rescale(val[3] - val[1] + self.row_shading_expand * 2)
                local row_h = Part.Functions.rescale(val[4] - val[2] + self.row_shading_expand * 2)

                -- get row shading color
                local row_color = self.color_shading_main

                -- use alternative color of alternate shading has to be applied
                if row_alt == 1 then
                    row_color = self.color_shading_alt
                end

                -- create adusted row shading color
                local row_color_adj = { row_color[1], row_color[2], row_color[3], row_color[4] * self.row_shading_depth }

                -- draw shading
                Part.Draw.Graphics.drawRectangle(row_x, row_y, row_w, row_h, row_color_adj)
            end

            shading_idx = shading_idx + 1
        end
    end
end

return layout