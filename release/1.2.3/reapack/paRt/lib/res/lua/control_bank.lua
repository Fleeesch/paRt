-- @version 1.2.3
-- @author Fleeesch
-- @description paRt Theme Adjuster
-- @noIndex


--[[
    Controls with a bank context.
    Get's a separate file since the bank system is a little more complex and represents
    a different context than the one of theme parameters.
]]--

local control = { ButtonBank = {}, Copy = {}, Select = {} }

-- ===============================================================================
--                      Control : Bank
-- ===============================================================================

--  Control : Bank Button
-- -------------------------------------------
control.ButtonBank = Part.Control.Config.ButtonConfig:new()

function control.ButtonBank:new(o, handler, text)
    o = o or Part.Control.Config.ButtonConfig:new(o, text)
    setmetatable(o, self)
    self.__index = self

    -- use cursor dimensions
    Part.Cursor.applyCursorToTarget(o)

    -- bank handler
    o.handler = handler


    -- bank
    o.bank = nil

    -- font flags
    o.font_flags = ""

    -- bank index
    o.index = nil

    -- mark for copy process
    o.copy_success = false

    -- highlight overlay
    o.highlight_counter = 0

    -- submit feature
    o.use_submit = false
    o.submit_time = 70
    o.submit_counter = 0


    -- default colors
    o.color_bg_off = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.bank_bar.button.off_bg)
    o.color_fg_off = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.bank_bar.button.off_fg)
    o.color_bg_on = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.color.cyan)
    o.color_fg_on = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.bank_bar.button.on_fg)
    o.color_border = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.bank_bar.button.border)
    o.color_submit_ol = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.bank_bar.button.submit_overlay)


    if handler ~= nil then
        -- with must cover text
        Part.Draw.Graphics.setFont(14 / Part.Global.scale)
        local str_s = gfx.measurestr(o.text)
        o.dim_w = math.max(str_s + 10, o.dim_w)
        Part.Cursor.setCursorSize(o.dim_w, Part.Cursor.getCursorH())

        -- add to lists
        table.insert(Part.List.control_button_bank, o)
        table.insert(Part.List.control, o)
    end


    return o
end

--  Control : Bank Button : Set Font Flags
-- -------------------------------------------

function control.ButtonBank:setFontFlags(flags)
    self.font_flags = flags
end

--  Control : Bank Button : Set Color
-- -------------------------------------------

function control.ButtonBank:setColor(fg, bg, fg_on, bg_on, border)
    -- foreground
    if type(fg) == "table" or fg == nil then
        self.color_fg_off = fg
    end

    -- background
    if type(bg) == "table" or bg == nil then
        self.color_bg_off = bg
    end

    -- foreground on-state
    if type(fg_on) == "table" or fg_on == nil then
        self.color_fg_on = fg
    end

    -- background on-state
    if type(bg_on) == "table" or bg_on == nil then
        self.color_bg_on = bg
    end

    -- border
    if type(border) == "table" or border == nil then
        self.color_border = border
    end
end

--  Control : Bank Button : Update State
-- -------------------------------------------

function control.ButtonBank:updateState()

end

--  Control : Bank Button : Submit Pending
-- -------------------------------------------

function control.ButtonBank:submitPending()
    if not self.use_submit then
        return false
    end

    if self.submit_counter > 0 then
        return true
    end

    return false
end

--  Control : Bank Button : Submit
-- -------------------------------------------

function control.ButtonBank:submit()
    if self:submitPending() then
        self:action()
        self.submit_counter = 0
        return
    else
        self.submit_counter = self.submit_time
    end
end

--  Control : Bank Button : Action
-- -------------------------------------------

function control.ButtonBank:action(press)

end

--  Control : Bank Button : Highlight
-- -------------------------------------------

function control.ButtonBank:highlight()
    self.highlight_counter = 1
end

--  Control : Bank Button : Get Output Text
-- -------------------------------------------

function control.ButtonBank:getOutputText()
    return self.text
end

--  Control : Bank Button : Prepare
-- -------------------------------------------

function control.ButtonBank:prepare()
    self.draw_x = Part.Functions.rescale(self.dim_x)
    self.draw_y = Part.Functions.rescale(self.dim_y + Part.Global.win_y_offset)
    self.draw_w = Part.Functions.rescale(self.dim_w)
    self.draw_h = Part.Functions.rescale(self.dim_h)

    self.draw_inner_x = self.draw_x + Part.Draw.Graphics.border
    self.draw_inner_y = self.draw_y + Part.Draw.Graphics.border
    self.draw_inner_w = self.draw_w - Part.Draw.Graphics.border * 2
    self.draw_inner_h = self.draw_h - Part.Draw.Graphics.border * 2
end

--  Control : Bank Button : Draw
-- -------------------------------------------

function control.ButtonBank:draw()
    -- get dimensions
    local x = self.draw_x
    local y = self.draw_y
    local w = self.draw_w
    local h = self.draw_h

    local inner_x = self.draw_inner_x
    local inner_y = self.draw_inner_y
    local inner_w = self.draw_inner_w
    local inner_h = self.draw_inner_h

    -- get colors
    local color_bg = self.color_bg_off
    local color_fg = self.color_fg_off
    local color_border = self.color_border
    local color_submit = self.color_submit_ol

    self:updateState()

    if self.state then
        color_bg = self.color_bg_on
        color_fg = self.color_fg_on
    end

    -- mouse action flags
    local hover = false
    local click = false

    -- initial click
    if Part.Gui.Mouse.Drag.isOff() and Part.Gui.Mouse.hoverCheck(self) then
        hover = true

        if Part.Gui.Mouse.leftClick() then
            click = true
            Part.Gui.Mouse.Drag.on(self)
        end
    end

    -- hover lightening
    if hover and not click then
        color_bg = Part.Color.lightenColor(color_bg, 0.15)
        color_fg = Part.Color.lightenColor(color_fg, 0.15)
    end

    -- action trigger
    if Part.Gui.Mouse.Drag.isTarget(self) then
        color_bg = Part.Color.lightenColor(color_bg, 0.3)
        color_fg = Part.Color.lightenColor(color_fg, 0.3)

        if Part.Gui.Mouse.leftRelease() and Part.Gui.Mouse.hoverCheck(self) then
            if not self.use_submit then
                self:action()
            else
                self:submit()
            end
        end
    end

    -- background
    Part.Draw.Graphics.drawRectangle(x, y, w, h, color_bg, color_border)

    -- submit handling
    if self:submitPending() then
        self.submit_counter = self.submit_counter - 1

        local sub_w = Part.Functions.map(self.submit_counter, 0, self.submit_time, 0, inner_w)

        Part.Draw.Graphics.drawRectangle(inner_x, inner_y, sub_w, inner_h, color_submit)
    end


    -- text
    local text_out = self:getOutputText()
    Part.Cursor.setCursorPos(x, y)
    Part.Color.setColor(color_fg, true)
    Part.Draw.Graphics.setFont(13, self.font_flags)
    gfx.drawstr(text_out, self.flags, x + w, y + h)

    -- highlight overlay
    if self.highlight_counter > 0 then
        local m = self.highlight_counter + 1
        gfx.muladdrect(inner_x, inner_y, inner_w, inner_h, m, m, m)
        self.highlight_counter = self.highlight_counter - 0.1
    end
end



return control
