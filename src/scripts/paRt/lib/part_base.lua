-- paRt table
if Part == nil then
    Part = {}
end

-- bank
Part.Bank = {}
Part.Bank.Functions = require("lib.bank.functions")
Part.Bank.HandlerFunctions = require("lib.bank.handler")
Part.Bank.Slot = require("lib.bank.slot")
Part.Bank.ParameterSet = require("lib.bank.parameter_set")

-- parameter
Part.Parameter = require("lib.parameter.parameter")
Part.Parameter.Group = require("lib.parameter.group")
Part.Parameter.Reaper = require("lib.parameter.reaper")
Part.Parameter.Theme = require("lib.parameter.theme")
Part.Parameter.Banked = require("lib.parameter.banked")

-- banking requires theme parameters
Part.Parameter.Lookup = require("lib.parameter.theme_lookup")

-- import theme parameter list
Part.Parameter.Lookup.importThemeParameters(ScriptPath .. "walter_parameter_list.txt")

-- universal functions
Part.Functions = require("lib.functions.functions")

-- global variables and lookup lists
Part.Global = require("lib.var.global")
Part.List = require("lib.var.list")

-- initialize bank handler with bank selection parameter
Part.Bank.Handler = Part.Bank.HandlerFunctions.BankHandler:new(nil, Part.Parameter.Theme.ThemeParameter:new(nil, "par_bank_selected", false,true))

-- global bank slot
Part.Bank.Slot.BankSlot:new(nil, true, "G", "bank_0", 1)

-- remaining bank slots (1 .. n)
for i = 1, Part.Global.bank_count do
    Part.Bank.Slot.BankSlot:new(nil, false, tostring(i), "bank_" .. tostring(i), i + 1)
end

-- universal functions
Part.Functions = require("lib.functions.functions")

-- gui
Part.Gui = {}
Part.Gui.Theme = require("lib.gui.theme")
Part.Gui.Window = require("lib.gui.window")
Part.Gui.Hint = require("lib.gui.hint_message")
Part.Gui.Hint.Lookup = require("lib.gui.hint_lookup")
Part.Gui.Keyboard = require("lib.gui.input_keyboard")
Part.Gui.Mouse = require("lib.gui.input_mouse")

-- message
Part.Message = {}
Part.Message.Handler = require("lib.message.handler")
Part.Message.Entry = require("lib.message.entry")

-- cursor
Part.Cursor = require("lib.cursor.cursor")

-- color
Part.Color = require("lib.color.color")
Part.Color.Lookup = require("lib.color.lookup")

-- drawing
Part.Draw = {}
Part.Draw.Graphics = require("lib.draw.graphics")
Part.Draw.Sprites = require("lib.draw.sprites")
Part.Draw.Elements = require("lib.draw.elements")
Part.Draw.Buffer = require("lib.draw.buffer")

-- tab
Part.Tab = {}
Part.Tab.Entry = require("lib.tab.entry")
Part.Tab.SubEntry = require("lib.tab.entry_sub")
Part.Tab.Group = require("lib.tab.group")

-- layout
Part.Layout = require("lib.layout.layout")
Part.Layout.Group = require("lib.layout.group")
Part.Layout.Label = require("lib.layout.label")
Part.Layout.Image = require("lib.layout.image")
Part.Layout.BankBar = require("lib.layout.bank_bar")
Part.Layout.Text = require("lib.layout.text")

-- controls
Part.Control = require("lib.control.control")
Part.Control.Hint = require("lib.control.hint")
Part.Control.Slider = require("lib.control.slider")
Part.Control.Knob = require("lib.control.knob")
Part.Control.Button = require("lib.control.button")
Part.Control.ButtonBank = require("lib.control.button_bank")
Part.Control.Marker = require("lib.control.marker")
Part.Control.Bank = require("lib.control.bank.bank")
Part.Control.Bank.Select = require("lib.control.bank.select")
Part.Control.Bank.Copy = require("lib.control.bank.copy")
Part.Control.Bank.Load = require("lib.control.bank.load")
Part.Control.Bank.Save = require("lib.control.bank.save")
Part.Control.Bank.Reset = require("lib.control.bank.reset")
Part.Control.Bank.HardReset = require("lib.control.bank.reset_hard")

-- version control
Part.Version = require("lib.version.version")

-- parameter mapping
Part.Parameter.Map = require("lib.parameter.map")
