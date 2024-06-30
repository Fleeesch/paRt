local tab = {}

tab.active_tab_changed = false

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Update Tap Entries
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function tab.updateTabEntries()

    if tab.active_tab_changed then        
        Part.Draw.Buffer.clearCompleteBuffer()
        tab.active_tab_changed = false
    end

    for idx, group in pairs(Part.List.tab_group) do
        for idx2, entry in pairs(group.entries) do
            entry.state = entry == group.active_entry
        end
    end
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Restore Tabs
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function tab.restoreTabs()
    -- go through tab groups
    for key, val in pairs(Part.List.tab_group) do
        -- restore tabs of group
        val:restoreTab()
    end

    Part.Draw.Elements.filterVisibleElements()
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Tab : Group
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

tab.TabGroup = {}

function tab.TabGroup:new(o, name, tab, level)
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

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Tab : Calculate Dimensions
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function tab.TabGroup:calculateDimensions()
    
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

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Tab : Group : Store Tab
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function tab.TabGroup:storeTab()
    -- store active tab as extstate entry
    reaper.SetExtState(Part.Global.ext_section, self.ext_key, tostring(self.active_entry.title), true)
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Tab : Group : Restore Tab
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function tab.TabGroup:restoreTab()
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

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Tab : Group : Tab Check
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function tab.TabGroup:tabCheck()
    -- group isn't a tab entry or is active tab?
    if self.tab == nil or self.tab:active() then
        -- tab is active
        return true
    end

    return false
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Tab : Group : Set active Entry
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function tab.TabGroup:setActiveEntry(entry)
    -- update the active entry of the group
    self.active_entry = entry
    self:storeTab()
    tab.active_tab_changed = true
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Tab : Group : Add Entry
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function tab.TabGroup:addEntry(entry)
    -- register tab entry
    table.insert(self.entries, entry)

    -- first entry to be added?
    if #self.entries == 1 then
        -- activate entry
        self.active_entry = entry
    end
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Tab : Group : Prepare
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function tab.TabGroup:prepare()
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

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Tab : Group : Draw
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function tab.TabGroup:draw()
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
