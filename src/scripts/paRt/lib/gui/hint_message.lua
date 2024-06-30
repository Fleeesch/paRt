local gui = {}

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Hint Message
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

HintMessage = {}

function HintMessage:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    o.draw_x = 0
    o.draw_y = 0
    o.draw_w = 0
    o.draw_h = 0
    o.last_alpha = 0
    o.buffer_slot = 10

    o.font_size = 16
    o.height_size = 20
    o.paragraph_line_size = 8
    o.padding = 6
    o.shadow_size = 3

    o.source = nil

    o.remove = false

    return o
end

gui.hint_message = HintMessage:new()

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Hint Message : Buffer
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function HintMessage:buffer()
    local source = self.source

    -- padding
    local p = Part.Functions.rescale(self.padding)
    local s = Part.Functions.rescale(self.shadow_size)

    -- colors
    local color_bg = source.color_bg
    local color_border = source.color_border
    local color_fg = source.color_fg
    local color_shadow = source.color_shadow

    -- attributes
    local font_size = self.font_size
    local line_height = Part.Functions.rescale(self.height_size)
    local paragraph_line_height = Part.Functions.rescale(self.paragraph_line_size)

    -- generate text block
    local lines = Part.Functions.textBlock(source.text, 30)

    -- calculate max width from string measurements, record line height
    local max_w = 0
    local max_h = 0

    -- measure string
    Part.Draw.Graphics.setFont(self.font_size)

    for _, line in pairs(lines) do
        max_w = math.max(gfx.measurestr(line), max_w)

        if line == "[Linebreak]" then
            max_h = max_h + paragraph_line_height
        else
            max_h = max_h + line_height
        end
    end

    -- add padding to max dimnesions
    max_w = max_w + p * 2
    max_h = max_h + p * 2

    -- dimensions
    local x = 0
    local y = 0
    local w = max_w
    local h = max_h

    self.draw_w = w
    self.draw_h = h

    -- clear buffer
    gfx.setimgdim(self.buffer_slot, -1, -1)
    gfx.setimgdim(self.buffer_slot, w + s, h + s)

    local last_dest = gfx.dest
    gfx.dest = self.buffer_slot

    -- background
    Part.Cursor.setCursorPos(0, 0)
    Part.Draw.Graphics.drawRectangle(s, s, w, h, color_shadow)
    Part.Draw.Graphics.drawRectangle(0, 0, w, h, color_bg, color_border)

    -- draw text line by line
    Part.Cursor.setCursorPos(0 + p, 0 + p)

    Part.Color.setColor(color_fg)

    local color_text_highlight = Part.Color.Lookup.color_palette.hint.text_highlight

    -- iterate lines
    for _, line in pairs(lines) do
        -- linebreak exception
        if line == "[Linebreak]" then
            gfx.x = Part.Cursor.getCursorX()
            gfx.y = gfx.y + paragraph_line_height
        else
            -- iterate words
            for word in line:gmatch("%S+") do
                -- highlight
                if word:match("%[.*%]") then
                    -- filter extra symbols
                    word = word:gsub("%[([^%[%]]*)%]", "%1")
                    word = word:gsub("|", " ")

                    -- change formatting
                    Part.Color.setColor(color_text_highlight,true)
                    Part.Draw.Graphics.setFont(font_size, "b")
                end

                -- print word
                gfx.drawstr(word .. " ")
                Part.Draw.Graphics.setFont(font_size)
                Part.Color.setColor(color_fg, true)
            end

            gfx.x = Part.Cursor.getCursorX()
            gfx.y = gfx.y + line_height
        end
    end
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Hint Message : Set Source
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function HintMessage:setSource(source)
    local show = source ~= self.source

    self.source = source
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Hint Message : Clear
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function HintMessage:clear()
    self.remove = true
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Hint Message : Draw
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function HintMessage:draw()
    if self.source == nil then
        return
    end
    

    -- cursor offset
    local offset = 12
    local padding = 10
    local p = Part.Functions.rescale(padding)
    local o = Part.Functions.rescale(offset)

    -- get fade-in factor
    local alpha = self.source:displayFactor()

    if alpha > 0 and self.last_alpha <= 0 then
        self:buffer()
    end

    local track_mouse = alpha >= self.last_alpha
    self.last_alpha = alpha

    -- clear hint after fade-out
    if self.remove and alpha <= 0 then
        self.source = nil
        return
    end

    -- mouse trakcing
    if track_mouse then
        self.draw_x = gfx.mouse_x
        self.draw_y = gfx.mouse_y
    end

    -- coordinates
    local x = self.draw_x + o
    local y = self.draw_y + o

    -- x axis overshoot flip
    if x + self.draw_w + p > gfx.w then
        x = x - self.draw_w - p * 2
    end

    -- y axis overshoot flip
    if y + self.draw_h + p > gfx.h then
        y = y - self.draw_h - p * 2
    end

    -- draw buffered images
    local dest_last = gfx.dest
    gfx.dest = -1
    gfx.x = x
    gfx.y = y
    gfx.a = alpha
    gfx.blit(self.buffer_slot, 1, 0)
    gfx.dest = dest_last
end

return gui