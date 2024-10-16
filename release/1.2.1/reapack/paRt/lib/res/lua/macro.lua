-- @version 1.2.1
-- @author Fleeesch
-- @description paRt Theme Adjuster
-- @noIndex

local macro = {}

-- select a bank without the theme adjuster GUI
function macro.SelectBankWithoutGui(idx)

    Part.Bank.Functions.loadParameterFile(true)
    Part.Global.initial_load = true
    Part.Bank.Handler:selectBank(idx+2)
    Part.Bank.Handler:update(true)
    reaper.ThemeLayout_RefreshAll()
    Part.Bank.Functions.storeParameterFile()
    
end

return macro