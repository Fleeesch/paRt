local layout = {}

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Bank Bar
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

layout.BankBar = Part.Layout.LayoutElement:new()

function layout.BankBar:new(o, handler)

    o = o or Part.Layout.LayoutElement:new(o)
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

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Bank Bar : Copy Mode
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function layout.BankBar:copyMode()
    -- inform that copy marking is active
    return self.copy_mode
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Bank Bar : Set Copy Mode
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function layout.BankBar:setCopyMode(on)
    -- update copy mode
    self.copy_mode = on

    -- grab source bank index during activation
    if on then
        self.copy_src_idx = self.handler.bank_selected:getIndex()
    end

end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Bank Bar : Setup Buttons
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function layout.BankBar:setupButtons()

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

    -- save
    Part.Cursor.setCursorSize(40, self.button_size)
    Part.Control.Bank.Save.ButtonBankSave:new(nil, self.handler, "Save")

    Part.Cursor.incCursor(Part.Cursor.getCursorW(), 0)

    -- load
    Part.Control.Bank.Load.ButtonBankLoad:new(nil, self.handler, "Load")

    Part.Cursor.incCursor(Part.Cursor.getCursorW() + 10, 0)

    -- reset values button
    Part.Control.Bank.Reset.ButtonBankReset:new(nil, self.handler, "Default Settings")

    Part.Cursor.incCursor(Part.Cursor.getCursorW() , 0)

    -- reset values button
    Part.Control.Bank.HardReset.ButtonBankResetHard:new(nil, self.handler, "Reset All")

end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Bank Bar : Draw
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function layout.BankBar:draw()

    -- prepare dimensions
    local x = Part.Functions.rescale(self.dim_x)
    local y = Part.Functions.rescale(self.dim_y + Part.Global.win_y_offset)
    local w = gfx.w
    local h = gfx.h - y

    -- draw background, rest of drawing is handled by individual elements
    Part.Draw.Graphics.drawRectangle(x, y, w, h, self.color_bg, self.color_border)

end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Bank Bar : Tab Check
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function layout.BankBar:tabCheck()
    return true
end

return layout