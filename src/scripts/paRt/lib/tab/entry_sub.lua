local tab = {}

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Tab Entry Sub
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

TabEntrySub = TabEntry:new()

function TabEntrySub:new(o, tab_group, title)
    o = o or TabEntry:new(o, tab_group, title)
    setmetatable(o, self)
    self.__index = self


    return o
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Tab : Entry Sub : Prepare
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function TabEntrySub:prepare()
    self.draw_x = Part.Functions.rescale(self.dim_x)
    self.draw_y = Part.Functions.rescale(self.dim_y)
    self.draw_w = Part.Functions.rescale(self.dim_w)
    self.draw_h = Part.Functions.rescale(self.dim_h)

    Part.Draw.Graphics.setFont(18)
    local str_w, str_h = gfx.measurestr(self.title)
    self.draw_circle_x = math.floor(self.draw_x + self.draw_w / 2 - str_w / 2 - Part.Functions.rescale(10))
    self.draw_circle_y = math.floor(self.draw_y + str_h / 2) + Part.Functions.rescale(2)
    self.draw_circle_r = math.floor(Part.Functions.rescale(4))
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Tab : Entry Sub : Draw
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function TabEntrySub:draw()
    -- calculate dimensions
    local x = self.draw_x
    local y = self.draw_y
    local w = self.draw_w
    local h = self.draw_h

    local color_bg, color_fg

    if self.state then
        color_bg = self.color_bg_sub_on
        color_fg = self.color_fg_sub_on
    else
        color_bg = self.color_bg_sub_off
        color_fg = self.color_fg_sub_off
    end

    -- hover
    if Part.Gui.Mouse.hoverCheck(self) and Part.Gui.Mouse.Drag.isOff() then
        color_bg = Part.Color.lightenColor(color_bg, 0.1)
        color_fg = Part.Color.lightenColor(color_fg, 0.1)

        -- activation
        if Part.Gui.Mouse.leftClick() then
            self.tab_group:setActiveEntry(self)
        end
    end


    -- background
    Part.Draw.Graphics.drawRectangle(x, y, w, h, color_bg)

    -- font
    Part.Color.setColor(color_fg,true)
    Part.Draw.Graphics.setFont(18)
    y = y + Part.Functions.rescale(2)
    Part.Cursor.setCursorPos(x, y)
    gfx.drawstr(self.title, self.flags, x + w, y + h)

    -- bullet
    gfx.circle(self.draw_circle_x, self.draw_circle_y, self.draw_circle_r, true, true)

    -- bullet fill
    if not self.state then
        Part.Color.setColor(color_bg,true)
        local r = self.draw_circle_r - Part.Draw.Graphics.border
        gfx.circle(self.draw_circle_x, self.draw_circle_y, r, true, true)
    end
end

return tab