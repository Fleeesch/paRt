-- @version 
-- @author Fleeesch
-- @description paRt Theme Adjuster
-- @noIndex
local tab = { Entry = {}, EntrySub = {}, Group = {} }

-- =======================================================================
--                      Tab : Entry
-- =======================================================================


--  Method : Set recent Tab
-- -------------------------------------------
-- recently created tab, used for mapping controls

tab.Entry.recent_tab = nil

function tab.Entry.setRecentTab(tab_entry)
    tab.Entry.recent_tab = tab_entry
end

--  Method : Get recent Tab
-- -------------------------------------------

function tab.Entry.getRecentTab()
    return tab.Entry.recent_tab
end

--  Tab : Entry
-- -------------------------------------------

tab.Entry.TabEntry = {
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

function tab.Entry.TabEntry:new(o, tab_group, title)
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

--  Tab : Entry : Is active
-- -------------------------------------------

function tab.Entry.TabEntry:active()
    -- tab group is a tab in itself?
    if self.tab_group.tab ~= nil then
        -- check if tab group and this tab itself is active
        return self.tab_group:tabCheck() and self.state
    end

    -- return state
    return self.state
end

--  Tab : Entry : Prepare
-- -------------------------------------------

function tab.Entry.TabEntry:prepare()
    self.draw_x = Part.Functions.rescale(self.dim_x)
    self.draw_y = Part.Functions.rescale(self.dim_y)
    self.draw_w = Part.Functions.rescale(self.dim_w)
    self.draw_h = Part.Functions.rescale(self.dim_h)
    self.draw_shadow = Part.Functions.rescale(10)
end

--  Tab : Entry : Draw
-- -------------------------------------------

function tab.Entry.TabEntry:draw()
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

-- =======================================================================
--                      Tab : Sub Entry
-- =======================================================================


--  Tab : Entry Sub
-- -------------------------------------------

tab.EntrySub.TabEntrySub = tab.Entry.TabEntry:new()

function tab.EntrySub.TabEntrySub:new(o, tab_group, title)
    o = o or tab.Entry.TabEntry:new(o, tab_group, title)
    setmetatable(o, self)
    self.__index = self


    return o
end

--  Tab : Entry Sub : Prepare
-- -------------------------------------------

function tab.EntrySub.TabEntrySub:prepare()
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

--  Tab : Entry Sub : Draw
-- -------------------------------------------

function tab.EntrySub.TabEntrySub:draw()
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
    Part.Color.setColor(color_fg, true)
    Part.Draw.Graphics.setFont(18)
    y = y + Part.Functions.rescale(2)
    Part.Cursor.setCursorPos(x, y)
    gfx.drawstr(self.title, self.flags, x + w, y + h)

    -- bullet
    gfx.circle(self.draw_circle_x, self.draw_circle_y, self.draw_circle_r, true, true)

    -- bullet fill
    if not self.state then
        Part.Color.setColor(color_bg, true)
        local r = self.draw_circle_r - Part.Draw.Graphics.border
        gfx.circle(self.draw_circle_x, self.draw_circle_y, r, true, true)
    end
end

-- =======================================================================
--                      Tab : Group
-- =======================================================================

tab.Group.active_tab_changed = false


--  Method : Update Tap Entries
-- -------------------------------------------

function tab.Group.updateTabEntries()
    if tab.Group.active_tab_changed then
        Part.Draw.Buffer.clearCompleteBuffer()
        tab.Group.active_tab_changed = false
    end

    for idx, group in pairs(Part.List.tab_group) do
        for idx2, entry in pairs(group.entries) do
            entry.state = entry == group.active_entry
        end
    end
end

--  Method : Restore Tabs
-- -------------------------------------------
function tab.Group.restoreTabs()
    -- go through tab groups
    for key, val in pairs(Part.List.tab_group) do
        -- restore tabs of group
        val:restoreTab()
    end

    Part.Draw.Elements.filterVisibleElements()
end

-- Tab : Group
-- -------------------------------------------

tab.Group.TabGroup = {}

function tab.Group.TabGroup:new(o, name, tab, level)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    -- tab representing this tab group
    o.tab = tab

    -- name of group
    o.name = name

    -- ext key for storing the active tab
    o.ext_key = "Tab: " .. name .. ": last Tab"

    -- entries of group
    o.entries = {}

    -- active entry
    o.active_entry = nil

    -- tab entry set to be active
    o.pending_active_entry = nil

    -- style of group
    o.style = 0

    -- level of group
    o.level = math.abs(level or 0)

    o.color_bg = Part.Color.Lookup.color_palette.tab.bg
    o.color_border = Part.Color.Lookup.color_palette.tab.border

    if o.level == 1 then
        o.color_bg = Part.Color.Lookup.color_palette.tab.bg_sub
    end

    -- window size tracking
    o.last_win_w = -1
    o.last_win_h = -1

    -- apply cursor to dimensions of element
    Part.Cursor.applyCursorToTarget(o)

    -- register to lookup list
    table.insert(Part.List.tab_group, o)

    return o
end

-- Tab : Calculate Dimensions
-- -------------------------------------------

function tab.Group.TabGroup:calculateDimensions()
    -- calculate tab width
    local segment = math.floor(self.dim_w / (#self.entries))

    -- get missing pixels, resulting from rounding
    local missing_pixels = self.dim_w - (#self.entries * segment)

    -- do two drawing runs; run 1 = inactive tabs, run 2 = active tab
    for x = 1, 2, 1 do
        -- get tab x position form dimensions
        local tab_x = self.dim_x

        -- go through entries
        for i, v in pairs(self.entries) do
            -- assume drawing won't happen
            local draw = false

            -- first run
            if x == 1 then
                -- entry isn't active? draw it
                if v ~= self.active_entry then
                    draw = true
                end

                -- second run
            else
                -- entry is active? draw it
                if v == self.active_entry then
                    draw = true
                end
            end

            -- drawing allowed?
            if draw then
                -- tab position
                v.dim_x = tab_x + Part.Global.win_x_offset_centered
                v.dim_y = self.dim_y

                -- tab size
                v.dim_w = segment
                v.dim_h = self.dim_h

                -- tab is last entry?
                if i == #self.entries then
                    -- add missing pixels to width
                    v.dim_w = segment + missing_pixels
                end
            end

            -- increment tab index
            tab_x = tab_x + segment
        end
    end
end

-- Tab : Group : Store Tab
-- -------------------------------------------

function tab.Group.TabGroup:storeTab()
    -- store active tab as extstate entry
    reaper.SetExtState(Part.Global.ext_section, self.ext_key, tostring(self.active_entry.title), true)
end

-- Tab : Group : Restore Tab
-- -------------------------------------------

function tab.Group.TabGroup:restoreTab()
    -- check if extstate exist
    if reaper.HasExtState(Part.Global.ext_section, self.ext_key) then
        -- get active tab from exstate
        local tab = reaper.GetExtState(Part.Global.ext_section, self.ext_key)

        -- go through entries
        for key, val in pairs(self.entries) do
            -- title matches extkey?
            if val.title == tab then
                -- activate tab
                self:setActiveEntry(val)

                break
            end
        end
    end
end

-- Tab : Group : Tab Check
-- -------------------------------------------

function tab.Group.TabGroup:tabCheck()
    -- group isn't a tab entry or is active tab?
    if self.tab == nil or self.tab:active() then
        -- tab is active
        return true
    end

    return false
end

-- Tab : Group : Set active Entry
-- -------------------------------------------

function tab.Group.TabGroup:setActiveEntry(entry)
    -- update the active entry of the group
    self.active_entry = entry
    self:storeTab()
    tab.Group.active_tab_changed = true
end

-- Tab : Group : Add Entry
-- -------------------------------------------

function tab.Group.TabGroup:addEntry(entry)
    -- register tab entry
    table.insert(self.entries, entry)

    -- first entry to be added?
    if #self.entries == 1 then
        -- activate entry
        self.active_entry = entry
    end
end

-- Tab : Group : Prepare
-- -------------------------------------------

function tab.Group.TabGroup:prepare()
    self.draw_x = Part.Functions.rescale(self.dim_x)
    self.draw_y = Part.Functions.rescale(self.dim_y)
    self.draw_h = Part.Functions.rescale(self.dim_h)

    if #self.entries <= 0 then
        self.draw_h = Part.Functions.rescale(4)
    end

    self:calculateDimensions()

    for i = 1, #self.entries do
        self.entries[i]:prepare()
    end
end

-- Tab : Group : Draw
-- -------------------------------------------

function tab.Group.TabGroup:draw()
    -- Tab Check
    if not self:tabCheck() then
        return
    end

    local x = self.draw_x
    local y = self.draw_y
    local h = self.draw_h

    Part.Draw.Graphics.drawRectangle(x, y, gfx.w, h, self.color_bg, nil)

    if self.level == 1 then
        Part.Draw.Graphics.drawRectangle(x, y + h, gfx.w, Part.Draw.Graphics.border, self.color_border)
    end

    local active_entry = nil

    for i = 1, #self.entries do
        local entry = self.entries[i]

        if not entry.state then
            entry:draw()
        else
            active_entry = entry
        end
    end

    -- draw active entry above other entries (shadow overlay)
    if active_entry ~= nil then
        active_entry:draw()
    end
end

return tab
