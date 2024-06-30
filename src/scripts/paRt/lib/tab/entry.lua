local tab = {}

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Set recent Tab
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- recently created tab, used for mapping controls

tab.recent_tab = nil

function tab.setRecentTab(tab_entry)
    tab.recent_tab = tab_entry
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Get recent Tab
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function tab.getRecentTab()
    return tab.recent_tab
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Tab Entry
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

TabEntry = {
    dim_x = 0,
    dim_y = 0,
    dim_w = 100,
    dim_h = 20,
    draw_x = 0,
    draw_y = 0,
    draw_w = 0,
    draw_h = 0,
    draw_shadow = 0
}

function TabEntry:new(o, tab_group, title)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    if tab_group == nil then
        return o
    end

    -- group the tab belongs to to
    o.tab_group = tab_group

    -- title of the tab
    o.title = title

    -- register entry to group
    o.tab_group:addEntry(o)

    -- active state
    o.state = false

    -- string flags
    o.flags = 1

    -- colors
    o.color_bg_off = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.tab.off_bg)
    o.color_fg_off = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.tab.off_fg)
    o.color_bg_on = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.tab.on_bg)
    o.color_fg_on = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.tab.on_fg)
    o.color_bg_sub_off = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.tab.sub.off_bg)
    o.color_fg_sub_off = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.tab.sub.off_fg)
    o.color_bg_sub_on = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.tab.sub.off_bg)
    o.color_fg_sub_on = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.tab.sub.on_fg)
    o.color_shadow = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.tab.shadow)

    -- register to list
    table.insert(Part.List.tab_entry, o)

    return o
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Tab : Entry : Is active
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function TabEntry:active()
    -- tab group is a tab in itself?
    if self.tab_group.tab ~= nil then
        -- check if tab group and this tab itself is active
        return self.tab_group:tabCheck() and self.state
    end

    -- return state
    return self.state
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Tab : Entry : Prepare
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function TabEntry:prepare()
    self.draw_x = Part.Functions.rescale(self.dim_x)
    self.draw_y = Part.Functions.rescale(self.dim_y)
    self.draw_w = Part.Functions.rescale(self.dim_w)
    self.draw_h = Part.Functions.rescale(self.dim_h)
    self.draw_shadow = Part.Functions.rescale(10)
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Tab : Entry : Draw
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function TabEntry:draw()
    -- calculate dimensions
    local x = self.draw_x
    local y = self.draw_y
    local w = self.draw_w
    local h = self.draw_h
    local shadow = self.draw_shadow

    -- colors
    local color_bg, color_fg

    if self.state then
        color_bg = self.color_bg_on
        color_fg = self.color_fg_on
    else
        color_bg = self.color_bg_off
        color_fg = self.color_fg_off
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

    -- side shadows gradients
    if self.state then
        local grad_l = { { 0, 0, 0, 0 }, self.color_shadow }
        local grad_r = { self.color_shadow, { 0, 0, 0, 0 } }
        Part.Draw.Graphics.drawGradient(x - shadow, y, shadow, h, 0, grad_l)
        Part.Draw.Graphics.drawGradient(x + w, y, shadow, h, 0, grad_r)
    end

    -- background
    Part.Draw.Graphics.drawRectangle(x, y, w, h, color_bg)

    -- text
    Part.Cursor.setCursorPos(x, y)
    Part.Color.setColor(color_fg, true)
    Part.Draw.Graphics.setFont(22)
    gfx.drawstr(self.title, self.flags, x + w, y + h)
end

return tab
