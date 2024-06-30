local layout = {}

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Image
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

layout.Image = Part.Layout.LayoutElement:new()

-- lookup table, used for detecting duplicates
layout.image_lookup = {}

function layout.Image:new(o, file, hdpi, scale, alpha)
    o = o or Part.Layout.LayoutElement:new(o)
    setmetatable(o, self)
    self.__index = self

    -- file path
    o.file = file

    -- scaling
    o.scale = scale or 1

    -- transparency
    o.alpha = alpha or 1

    -- use hdpi assets
    o.use_hdpi_assets = hdpi or false

    -- hdpi levels
    o.levels = { 100, 125, 150, 175, 200, 225, 250 }

    -- image handle is current image index
    o.handle = Part.Draw.Sprites.getNextFreeImageSlot()

    -- use existing handle or initially load image
    if layout.image_lookup[file] ~= nil then
        o.handle = layout.image_lookup[file].handle
    else
        o:load()
    end

    -- justification
    o.justHorz = 0
    o.justVert = 0

    -- transfer cursor dimensions
    Part.Cursor.applyCursorToTarget(o)

    -- register image in list
    table.insert(Part.List.layout, o)

    -- store image in lookup table
    layout.image_lookup[file] = o

    return o
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Image : Justify
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

-- left
function layout.Image:justLeft()
    self.justHorz = -1
end

-- right
function layout.Image:justRight()
    self.justHorz = 1
end

-- top
function layout.Image:justTop()
    self.justVert = -1
end

-- bottom
function layout.Image:justBottom()
    self.justVert = 1
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Image : Load
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function layout.Image:load()
    -- use hdpi assets?
    if self.use_hdpi_assets then
        -- go through levels
        for i = 0, #self.levels - 1 do
            -- construct filename from base filename and zoom level
            local filename = self.file .. ".png"

            -- load image
            if i == 0 then
                gfx.loadimg(self.handle + i, ScriptPath .. filename)
            else
                -- Find the position of the last slash
                local last_slash_Pos = self.file:match(".*()/")
                local before_last_folder = self.file:sub(1, last_slash_Pos - 1)
                local file = self.file:sub(last_slash_Pos + 1)
                local path = before_last_folder .. "/" .. self.levels[i + 1] .. "/" .. file .. ".png"
                gfx.loadimg(self.handle + i, ScriptPath .. path)
            end

            -- increment image index
            Part.Draw.Sprites.getNextFreeImageSlot()
        end
    else
        -- load image
        gfx.loadimg(self.handle, ScriptPath .. self.file .. ".png")

        -- increment image index
        Part.Draw.Sprites.getNextFreeImageSlot()
    end
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Image : Draw
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function layout.Image:draw()
    -- prepare dimensions
    local x = Part.Functions.rescale(self.dim_x, true)
    local y = Part.Functions.rescale(self.dim_y, false, true)
    local w = Part.Functions.rescale(self.dim_w)
    local h = Part.Functions.rescale(self.dim_h)

    -- set transparency
    Part.Color.setColor({ 0, 0, 0, self.alpha })

    -- use hdpi assets?
    if self.use_hdpi_assets then
        -- image handle offset
        local handle_plus = 0

        -- go through levels
        for key, val in pairs(self.levels) do
            -- level is matching scale?
            if Part.Global.scale * 100 >= val then
                -- increment handle offset
                handle_plus = key - 1
            end
        end

        -- set drawing cursor
        Part.Cursor.setCursor(x, y, w, h)

        -- get image dimensions
        local img_w, img_h = gfx.getimgdim(self.handle + handle_plus)

        -- justify left
        if self.justHorz == 0 then
            gfx.x = gfx.x + (w - img_w) / 2
        end

        -- justify right
        if self.justHorz > 0 then
            gfx.x = gfx.x + (w - img_w)
        end

        -- justify top
        if self.justVert == 0 then
            gfx.y = gfx.y + (h - img_h) / 2
        end

        -- justify bottom
        if self.justVert > 0 then
            gfx.y = gfx.y + (h - img_h)
        end

        -- draw image
        gfx.blit(self.handle + handle_plus, 1, 0)

        -- reset cursor
        Part.Cursor.setCursor(x, y, w, h)

        -- don't use hdpi assets?
    else
        Part.Cursor.setCursor(x, y, w, h)

        -- calculate image size
        local size = Part.Functions.rescale(self.scale * 100) / 100


        -- get image dimensions
        local img_w, img_h = gfx.getimgdim(self.handle)

        -- Part.Functions.rescale( dimensions
        img_w = Part.Functions.rescale(img_w)
        img_h = Part.Functions.rescale(img_h)

        -- justify left
        if self.justHorz == 0 then
            gfx.x = gfx.x + (w - img_w) / 2
        end

        -- justify right
        if self.justHorz > 0 then
            gfx.x = gfx.x + (w - img_w)
        end

        -- justify top
        if self.justVert == 0 then
            gfx.y = gfx.y + (h - img_h) / 2
        end

        -- justify bottom
        if self.justVert > 0 then
            gfx.y = gfx.y + (h - img_h)
        end

        -- draw image
        gfx.blit(self.handle, size, 0)

        -- reset cursor
        Part.Cursor.setCursor(x, y, w, h)
    end
end

return layout
