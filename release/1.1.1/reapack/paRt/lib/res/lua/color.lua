-- @version 1.1.1
-- @author Fleeesch
-- @description paRt Theme Adjuster
-- @noIndex


local color = { Lookup = {} }

-- ======================================================================
--                      Color functions
-- ======================================================================


--  Method : Set Color
-- -------------------------------------------

function color.setColor(color, rgb)
    -- return black when color is faulty
    if color == nil then
        return { 0, 0, 0, 1 }
    end

    -- correct alpha
    if color[4] == nil then
        color[4] = 1
    end

    -- rtg translation
    if rgb ~= nil and rgb then
        gfx.set(color[1] / 255, color[2] / 255, color[3] / 255, color[4])
    else
        gfx.set(color[1], color[2], color[3], color[4])
    end
end

--  Method : Lighten Color
-- -------------------------------------------

function color.lightenColor(color, factor)
    local color_new = Part.Functions.deepCopy(color)

    -- lighten rgb
    for i = 1, 3 do
        color_new[i] = color_new[i] + (factor * 255)
        color_new[i] = math.min(color_new[i], 255)
    end

    return color_new
end

return color
