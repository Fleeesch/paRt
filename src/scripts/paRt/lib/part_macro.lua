local macro = {}

function macro.SelectBankNoGui(idx)

    Part.Bank.Functions.loadParameterFile(true)
    Part.Global.initial_load = true
    Part.Bank.Handler:selectBank(idx+2)
    Part.Bank.Handler:update(true)
    reaper.ThemeLayout_RefreshAll()
    Part.Bank.Functions.storeParameterFile()
    
end

return macro