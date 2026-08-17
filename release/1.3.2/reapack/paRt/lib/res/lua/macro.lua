-- @version 1.3.2
-- @author Fleeesch
-- @description paRt Theme Adjuster
-- @noIndex

--[[
    Helpers that are used for actions that don't require a GUI.
    
    They are not absolutely necessary, but help in reducing labor and code redundancy
    in several ReaScript files that are essentially just doing the same thing with minor variations.
]] --

local macro = {}

--  select a bank without the theme adjuster GUI
-- ------------------------------------------------------------------
function macro.SelectBankWithoutGui(idx)
    Part.Bank.Functions.loadParameterFile(true)
    Part.Global.initial_load = true
    Part.Bank.Handler:selectBank(idx + 2)
    Part.Bank.Handler:update(true)
    reaper.ThemeLayout_RefreshAll()
    Part.Bank.Functions.storeParameterFile()
end

--  select a theme without the theme adjuster GUI
-- ------------------------------------------------------------------
function macro.SelectThemeWithoutGui(theme)
    -- try getting theme file
    local theme_file = Part.Theme.validateLoadingTheme(theme)

    -- abort if there is no valid theme file available
    if theme_file == nil then
        return
    end

    --Part.Bank.Functions.storeParameterFile()

    Part.Bank.Functions.loadParameterFile(true)
    Part.Global.initial_load = true
    Part.Theme.loadTheme(theme_file)
    Part.Bank.Functions.loadParameterFile(true)

    -- force load the parameter file, skipping theme change comparison


    -- initialize handlers
    -- Part.Bank.Handler:init()
    -- Part.Config.Handler:init()

    -- universal non-critical fixes required for older versions
    -- Part.Version.applyLegacyFixes()
end

return macro
