local par = {}

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Theme Parmaeter Lookup Table
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- contanis index numbers of parameters
par.theme_par_lookup = {
    hue = -1005,
    saturation = -1004,
    gamma = -1000,
    highlights = -1003,
    shadows = -1002,
    midtones = -1001
}

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Method : Import Theme Parameters from File
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function par.importThemeParameters(file)

    -- iteration index
    local idx = -1

    -- go through lines
    for line in io.lines(file) do

        -- check if line is not empty
        if line:match("%S") then

            -- word iteration index
            local word_idx = 0

            -- go through words
            for word in line:gmatch("%S+") do

                -- 2nd word is the parameter name
                if word_idx == 1 then

                    -- store line position as index number in lookup table
                    par.theme_par_lookup[word] = idx

                end

                -- increment word index
                word_idx = word_idx + 1

            end

        end

        -- increment line index
        idx = idx + 1

    end

end

return par