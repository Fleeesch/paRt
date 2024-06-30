local control = {}

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Hint
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
control.Hint = Part.Control.Control:new()

function control.Hint:new(o, text, linked_element, use_cursor)
    o = o or Part.Control.Control:new(o, nil, true)

    setmetatable(o, self)
    self.__index = self

    -- hint message
    o.text = text

    -- functions
    o.functions = {}

    -- linked element
    o.linked_element = linked_element or Part.Draw.Elements.lastElement()

    -- use cursor positions for hover detection
    o.use_cursor = use_cursor or false

    Part.Cursor.applyCursorToTarget(o)

    -- delay before hint hover is recognized
    o.show_delay = Part.Global.hint_delay

    -- fade-in time for hint
    o.show_time = o.show_delay + Part.Global.hint_fade

    -- show hint when counter exceeds delay
    o.show_counter = 0

    -- text flags
    o.flags = 0

    -- extra padding
    o.pad = 4

    -- show hint flag
    o.show_hint = false

    -- fade factor
    o.display_factor = 0

    -- optional symbol
    o.draw_symbol = false

    o.symbol_rotation = 1.5708

    -- default colors
    o.color_bg = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.hint.bg)
    o.color_fg = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.hint.fg)
    o.color_border = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.hint.border)
    o.color_shadow = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.hint.shadow)
    o.color_hover = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.hint.hover)
    o.color_symbol = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.color.cyan)

    o.use_alt_color = false

    -- add to lists
    table.insert(Part.List.control, o)
    table.insert(Part.List.control_hint, o)

    return o
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Hint : Add Padding
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Hint:setPadding(pad)
    self.pad = math.max(pad, 0)
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Hint : Prameter Hint
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Hint:parameterHint()
    self:setPadding(0)
    self.draw_symbol = true
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Hint : Calculate Display factor
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Hint:displayFactor()
    return (self.show_counter - self.show_delay) / (self.show_time - self.show_delay)
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Prepare
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Hint:prepare()
    self.draw_x = Part.Functions.rescale(self.dim_x, true)
    self.draw_y = Part.Functions.rescale(self.dim_y, false, true)
    self.draw_w = Part.Functions.rescale(self.dim_w)
    self.draw_h = Part.Functions.rescale(self.dim_h)
    self.draw_p = Part.Functions.rescale(self.pad)

    self.draw_link_x = Part.Functions.rescale(self.linked_element.dim_x, true)
    self.draw_link_y = Part.Functions.rescale(self.linked_element.dim_y, false, true)
    self.draw_link_w = Part.Functions.rescale(self.linked_element.dim_w)
    self.draw_link_h = Part.Functions.rescale(self.linked_element.dim_h)

    self.draw_symbol_size = Part.Functions.rescale(Part.Draw.Sprites.hint_corner_size)
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Control : Hint : Draw
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function control.Hint:draw()
    -- get dimensions
    local link_x = self.draw_link_x
    local link_y = self.draw_link_y
    local link_w = self.draw_link_w
    local link_h = self.draw_link_h

    local x, y, w, h


    if self.use_cursor then
        x = self.draw_x
        y = self.draw_y
        w = self.draw_w
        h = self.draw_h
    else
        x = link_x
        y = link_y
        w = link_w
        h = link_h
    end


    -- hover state
    local hover = false

    -- hover active?
    if Part.Gui.Mouse.hoverCheck(nil, x, y, w, h) then
        if Part.Gui.Mouse.Drag.isOff() then
            hover = true


            -- increment counter
            if self.show_counter < self.show_time then
                self.show_counter = self.show_counter + 1

                if self.show_counter >= self.show_delay then
                    Part.Gui.Hint.hint_message:setSource(self)
                end
            end
        end

        -- no hovering?
    else
        -- decrement or reset counter
        if self.show_counter >= self.show_delay then
            self.show_counter = self.show_counter - 1
        else
            self.show_counter = 0
        end

        -- clear as active hint
        if Part.Gui.Hint.hint_message.source == self then
            Part.Gui.Hint.hint_message:clear()
        end
    end

    -- symbol
    if self.draw_symbol then
        gfx.a = 1
        gfx.x = x + w - self.draw_symbol_size
        gfx.y = y

        gfx.blit(Part.Draw.Sprites.cornerHint(), 1, self.symbol_rotation)
    end

    -- custom overlay drawing
    if hover then
        local p = self.draw_p
        local f = Part.Functions.cap((self.show_counter / self.show_delay) - 0.01 * 1.01, 0, 1)
        local r = self.color_hover[1] * f + 1
        local g = self.color_hover[2] * f + 1
        local b = self.color_hover[3] * f + 1
        gfx.muladdrect(link_x - p, link_y - p, link_w + p * 2, link_h + p * 2, r, g, b, 1, 0, 0, 0, 0)
    end
end

return control
