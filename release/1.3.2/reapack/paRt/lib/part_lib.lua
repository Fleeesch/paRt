-- @version 1.3.2
-- @author Fleeesch
-- @description paRt Theme Adjuster
-- @noIndex

-- paRt table
if Part == nil then
    Part = {}
end

-- ================================================================
--          paRt Theme library
--
--          Core features for handling user adjustments
--          and general settings.
--
--          Works independently from the GUI and can be used
--          for macros that are launched in the background.
--          
-- ================================================================

-- functions
Part.Functions = require("lib.res.lua.functions")

-- config & bank
Part.Config = require("lib.res.lua.config")
Part.Bank = require("lib.res.lua.bank")

-- parameters
Part.Parameter = require("lib.res.lua.parameter")
Part.Parameter.Lookup.importThemeParameters()

-- global variables and lookup lists
local var = require("lib.res.lua.var")
Part.Global = var.globals
Part.List = var.list

-- custom parameter settings
Part.Parameter.Lookup.importCustomParameterSettings()

--      Config Handler
-- -----------------------------

-- initialize config handler
Part.Config.Handler = Part.Config.Handler.ConfigHandler:new(nil,
    Part.Parameter.Theme.ThemeParameter:new(nil, "par_config_selected", false, true))

--      Bank Slot Initialization
-- -----------------------------

-- initialize bank handler with bank selection parameter
Part.Bank.Handler = Part.Bank.Handler.BankHandler:new(nil,
    Part.Parameter.Theme.ThemeParameter:new(nil, "par_bank_selected", false, true))

-- global bank slot
Part.Bank.Slot.BankSlot:new(nil, true, "G", "bank_0", 1)

-- remaining bank slots (1 .. n)
for i = 1, Part.Global.bank_count do
    Part.Bank.Slot.BankSlot:new(nil, false, tostring(i), "bank_" .. tostring(i), i + 1)
end

--      Remaining LUA files
-- -----------------------------

--[[
    Do not change the order.
    There's a good chance for some nasty cross-referencing hidden in the files
    that still hasn't been taken care of.
]]

Part.Gui = require("lib.res.lua.gui")
Part.Theme = require("lib.res.lua.theme")
Part.Hint = require("lib.res.lua.hint")
Part.Hint.Lookup = require("lib.res.lua.hint_messages")
Part.Message = require("lib.res.lua.message")
Part.Cursor = require("lib.res.lua.cursor")
Part.Color = require("lib.res.lua.color")
Part.Color.Lookup = require("lib.res.lua.color_palette")
Part.Draw = require("lib.res.lua.draw")
Part.Tab = require("lib.res.lua.tab")
Part.Layout = require("lib.res.lua.layout")
Part.Control = require("lib.res.lua.control")
Part.Control.Config = require("lib.res.lua.control_config")
Part.Config = require("lib.res.lua.config")
Part.Parameter.Map = require("lib.res.lua.parameter_map")
Part.Macro = require("lib.res.lua.macro")
Part.Version = require("lib.res.lua.version")


