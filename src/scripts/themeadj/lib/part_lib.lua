-- @version 
-- @author Fleeesch
-- @description paRt Theme Adjuster
-- @noIndex



-- paRt table
if Part == nil then
    Part = {}
end

-- functions
Part.Functions = require("lib.res.lua.functions")

-- bank
Part.Bank = require("lib.res.lua.bank")
Part.Parameter = require("lib.res.lua.parameter")
Part.Parameter.Lookup.importThemeParameters()

-- global variables and lookup lists
local var = require("lib.res.lua.var") 
Part.Global = var.globals
Part.List = var.list

--      Bank Initialization
-- -----------------------------

-- initialize bank handler with bank selection parameter
Part.Bank.Handler = Part.Bank.Handler.BankHandler:new(nil, Part.Parameter.Theme.ThemeParameter:new(nil, "par_bank_selected", false,true))

-- global bank slot
Part.Bank.Slot.BankSlot:new(nil, true, "G", "bank_0", 1)

-- remaining bank slots (1 .. n)
for i = 1, Part.Global.bank_count do
    Part.Bank.Slot.BankSlot:new(nil, false, tostring(i), "bank_" .. tostring(i), i + 1)
end

-- ramining lua files
Part.Gui = require("lib.res.lua.gui")
Part.Message = require("lib.res.lua.message")
Part.Cursor = require("lib.res.lua.cursor")
Part.Color = require("lib.res.lua.color")
Part.Color.Lookup = require("lib.res.lua.color_palette")
Part.Draw = require("lib.res.lua.draw")
Part.Tab = require("lib.res.lua.tab")
Part.Layout = require("lib.res.lua.layout")
Part.Control = require("lib.res.lua.control")
Part.Control.Bank = require("lib.res.lua.control_bank")
Part.Version = require("lib.res.lua.version")
Part.Parameter.Map = require("lib.res.lua.parameter_map")
Part.Macro = require("lib.res.lua.macro")
