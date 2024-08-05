-- @version 1.1.4
-- @author Fleeesch
-- @description paRt Theme Adjuster
-- @noIndex



-- script path
local info = debug.getinfo(1, 'S');

ScriptPath = info.source:match [[^@?(.*[\/])[^\/]-$]]

-- package path
local path = ({reaper.get_action_context()})[2]:match('^.+[\\//]')
package.path = path .. "?.lua"

-- macro
require("lib.part_lib")
Part.Macro.SelectBankWithoutGui(4)