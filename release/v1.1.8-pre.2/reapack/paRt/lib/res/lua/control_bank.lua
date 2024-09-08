-- @version v1.1.8-pre.2
-- @author Fleeesch
-- @description paRt Theme Adjuster
-- @noIndex



local control = { ButtonBank = {}, Copy = {}, Save = {}, Load = {}, HardReset = {}, Reset = {}, Select = {} }

-- ===============================================================================
--                      Control : Bank
-- ===============================================================================

--  Control : Bank Button
-- -------------------------------------------
control.ButtonBank = Part.Control.Control:new()

function control.ButtonBank:new(o, handler, text)
    o = o or Part.Control.Control:new(o)
    setmetatable(o, self)
    self.__index = self

    -- use cursor dimensions
    Part.Cursor.applyCursorToTarget(o)

    -- bank handler
    o.handler = handler

    -- button toggle state
    o.state = false

    -- button is clicked
    o.click = false

    -- text displayed within button
    o.text = text

    -- default string flags
    o.flags = 5

    -- function
    o.func = ""

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

--  Control : Bank Button : Reset Submit
-- -------------------------------------------

function control.ButtonBank:resetSubmit()
    self.submit_counter = 0
end

--  Control : Bank Button : Use Submit
-- -------------------------------------------

function control.ButtonBank:useSubmit()
    self.use_submit = true
end

--  Control : Bank Button : Set Font Flags
-- -------------------------------------------

function control.ButtonBank:setFontFlags(flags)
    self.font_flags = flags
end

--  Control : Bank Button : Cet Color
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

-- ===============================================================================
--                      Control : Bank : Copy
-- ===============================================================================


--  Control : Bank Button Copy
-- -------------------------------------------
control.Copy.ButtonBankCopy = control.ButtonBank:new()

function control.Copy.ButtonBankCopy:new(o, handler, text)
    o = o or control.ButtonBank:new(o, handler, text)
    setmetatable(o, self)
    self.__index = self

    o.color_bg_on = Part.Color.Lookup.color_palette.color.red
    o.color_fg_on = Part.Color.Lookup.color_palette.bank_bar.button.on_fg


    return o
end

--  Control : Bank Button Copy : Update State
-- -------------------------------------------

function control.Copy.ButtonBankCopy:updateState()
    self.state = self.handler:copyModeActive()
end

--  Control : Bank Button Copy : Action
-- -------------------------------------------

function control.Copy.ButtonBankCopy:action()
    local copy_state = self.handler:copyModeActive()

    if copy_state then
        local do_copy = false

        -- trigger a copy process when at least one bank is marked for copying
        for _, val in pairs(Part.List.control_button_bank_select) do
            if val:isCopyTarget() then
                val:highlight()
                do_copy = true
            end
        end

        -- copy success
        if do_copy then
            Part.Draw.Graphics.splashMessage('Copying Part.Bank...')

            table.insert(Part.List.pending_action, {
                func = Part.Bank.Functions.triggerBankCopyProcess,
                args = {}
            })
        end

        --deactivate copy mode
        self.handler:setCopyMode(not copy_state, nil)
    else
        for i = 1, #Part.List.control_button_bank_select do
            Part.List.control_button_bank_select[i]:clearCopyState()
        end

        self.handler:setCopyMode(not copy_state, self.handler:selectedBank())
    end
end

-- ===============================================================================
--                      Control : Bank : Load
-- ===============================================================================


--  Control : Bank Button Load
-- -------------------------------------------
control.Load.ButtonBankLoad = control.ButtonBank:new()

function control.Load.ButtonBankLoad:new(o, handler, text)
    o = o or control.ButtonBank:new(o, handler, text)
    setmetatable(o, self)
    self.__index = self

    return o
end

--  Control : Bank Button Load : Action
-- -------------------------------------------

function control.Load.ButtonBankLoad:action()
    if self.handler:copyModeActive() then
        return
    end

    local retval, file_name = reaper.JS_Dialog_BrowseForOpenFiles(nil, nil, nil, "Lua Files\0*.partmap", false)

    if retval == 1 then
        -- pending load
        table.insert(Part.List.pending_action, {
            func = Part.Bank.Functions.loadParameterFile,
            args = { true, file_name }
        })

        Part.Draw.Graphics.splashMessage('Loading ' .. Part.Functions.extractFileName(file_name) .. '...')
    end
end

-- ===============================================================================
--                      Control : Bank : Reset - Hard
-- ===============================================================================


--  Control : Bank Button Reset Hard
-- -------------------------------------------
control.HardReset.ButtonBankResetHard = control.ButtonBank:new()

function control.HardReset.ButtonBankResetHard:new(o, handler, text)
    o = o or control.ButtonBank:new(o, handler, text)
    setmetatable(o, self)
    self.__index = self

    o:useSubmit()

    return o
end

--  Control : Bank Button : Get Output Text
-- -------------------------------------------

function control.HardReset.ButtonBankResetHard:getOutputText()
    if self:submitPending() then
        return "Sure?"
    end

    return self.text
end

--  Control : Bank Button Reset : Submit
-- -------------------------------------------

function control.HardReset.ButtonBankResetHard:submit()
    if self.handler:copyModeActive() then
        return
    end

    if self:submitPending() then
        self:action()
        self.submit_counter = 0
        return
    else
        self.submit_counter = self.submit_time
    end
end

--  Control : Bank Button Reset : Action
-- -------------------------------------------

function control.HardReset.ButtonBankResetHard:action()
    if self.handler:copyModeActive() then
        return
    end

    self:highlight()

    table.insert(Part.List.pending_action, {
        func = Part.Bank.Functions.hardResetAllParameters,
        args = {}
    })

    Part.Draw.Graphics.splashMessage("Resetting all Parameters...")
end

-- ===============================================================================
--                      Control : Bank : Reset
-- ===============================================================================


--  Control : Bank Button Reset
-- -------------------------------------------
control.Reset.ButtonBankReset = control.ButtonBank:new()

function control.Reset.ButtonBankReset:new(o, handler, text)
    o = o or control.ButtonBank:new(o, handler, text)
    setmetatable(o, self)
    self.__index = self

    o:useSubmit()

    return o
end

--  Control : Bank Button : Get Output Text
-- -------------------------------------------

function control.Reset.ButtonBankReset:getOutputText()
    if self:submitPending() then
        return "Sure?"
    end

    return self.text
end

--  Control : Bank Button Reset : Submit
-- -------------------------------------------

function control.Reset.ButtonBankReset:submit()
    if self.handler:copyModeActive() then
        return
    end

    if self:submitPending() then
        self:action()
        self.submit_counter = 0
        return
    else
        self.submit_counter = self.submit_time
    end
end

--  Control : Bank Button Reset : Action
-- -------------------------------------------

function control.Reset.ButtonBankReset:action()
    if self.handler:copyModeActive() then
        return
    end

    self:highlight()

    table.insert(Part.List.pending_action, {
        func = Part.Bank.Functions.restoreParameterDefaults,
        args = {}
    })

    Part.Draw.Graphics.splashMessage("Loading Default Settings...")
end

-- ===============================================================================
--                      Control : Bank : Save
-- ===============================================================================


--  Control : Bank Button Save
-- -------------------------------------------
control.Save.ButtonBankSave = control.ButtonBank:new()

function control.Save.ButtonBankSave:new(o, handler, text)
    o = o or control.ButtonBank:new(o, handler, text)
    setmetatable(o, self)
    self.__index = self


    return o
end

--  Control : Bank Button Save : Action
-- -------------------------------------------

function control.Save.ButtonBankSave:action()
    if self.handler:copyModeActive() then
        return
    end

    local retval, file_name = reaper.JS_Dialog_BrowseForSaveFile(nil, nil, nil, "Lua Files\0*.partmap")

    if retval == 1 then
        if Part.Functions.extractExtension(file_name) ~= "partmap" then
            file_name = file_name .. ".partmap"
        end

        -- pending save
        table.insert(Part.List.pending_action, {
            func = Part.Bank.Functions.storeParameterFile,
            args = { file_name }
        })

        Part.Draw.Graphics.splashMessage('Saving ' .. Part.Functions.extractFileName(file_name) .. '...')
    end
end

-- ===============================================================================
--                      Control : Bank : Select
-- ===============================================================================


--  Control : Bank Button Select
-- -------------------------------------------
control.Select.ButtonBankSelect = control.ButtonBank:new()

function control.Select.ButtonBankSelect:new(o, handler, text, bank)
    o = o or control.ButtonBank:new(o, handler, text)
    setmetatable(o, self)
    self.__index = self

    o.bank = bank

    o.copy_target = false

    o.color_select_bg_off = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.bank_bar.button.off_bg)
    o.color_select_fg_off = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.bank_bar.button.off_fg)
    o.color_select_bg_on = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.color.cyan)
    o.color_select_fg_on = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.bank_bar.button.on_fg)
    o.color_copy_bg_off = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.bank_bar.button.copy.off_bg)
    o.color_copy_fg_off = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.bank_bar.button.copy.off_fg)
    o.color_copy_bg_on = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.bank_bar.button.copy.on_bg)
    o.color_copy_fg_on = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.bank_bar.button.copy.on_fg)
    o.color_copy_bg_src = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.bank_bar.button.copy.src_bg)
    o.color_copy_fg_src = Part.Functions.deepCopy(Part.Color.Lookup.color_palette.bank_bar.button.copy.src_fg)

    o:colorsDefault()

    table.insert(Part.List.control_button_bank_select, o)

    return o
end

--  Control : Bank Button Select : Colors Default
-- ---------------------------------------------------

function control.Select.ButtonBankSelect:colorsDefault()
    self.color_bg_off = self.color_select_bg_off
    self.color_fg_off = self.color_select_fg_off
    self.color_bg_on = self.color_select_bg_on
    self.color_fg_on = self.color_select_fg_on
end

--  Control : Bank Button Select : Colors Copy
-- ------------------------------------------------

function control.Select.ButtonBankSelect:colorsCopy()
    self.color_bg_off = self.color_copy_bg_off
    self.color_fg_off = self.color_copy_fg_off

    if self:isCopySource() then
        self.color_bg_on = self.color_copy_bg_src
        self.color_fg_on = self.color_copy_fg_src
    else
        self.color_bg_on = self.color_copy_bg_on
        self.color_fg_on = self.color_copy_fg_on
    end
end

--  Control : Bank Button Select : Clear Copy State
-- ----------------------------------------------------

function control.Select.ButtonBankSelect:clearCopyState()
    self.copy_target = false
end

--  Control : Bank Button Select : Is Copy Source
-- --------------------------------------------------

function control.Select.ButtonBankSelect:isCopySource()
    return self.handler.copy_mode_trigger == self.bank
end

--  Control : Bank Button Select : Is Copy Target
-- -------------------------------------------------

function control.Select.ButtonBankSelect:isCopyTarget()
    if self:isCopySource() then
        return false
    end

    return self.copy_target
end

--  Control : Bank Button Select : Update State
-- -------------------------------------------------

function control.Select.ButtonBankSelect:updateState()
    if not self.handler:copyModeActive() then
        self:colorsDefault()

        self.state = self.handler.bank_selected == self.bank
    else
        self:colorsCopy()

        if self:isCopySource() then
            self.state = true
        else
            self.state = self.copy_target
        end
    end
end

--  Control : Bank Button Select : Action
-- -------------------------------------------

function control.Select.ButtonBankSelect:action()
    if not self.handler:copyModeActive() then
        self.handler:selectBank(self.bank:getIndex())
    else
        if not self:isCopySource() then
            self.copy_target = not self.copy_target
        end
    end
end

return control
