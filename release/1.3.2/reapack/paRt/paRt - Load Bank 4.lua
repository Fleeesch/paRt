-- @version 1.3.2
-- @author Fleeesch
-- @description paRt Theme Adjuster
-- @noIndex

-- ================================================================
--          paRt Theme Adjuster
--          Bank loading script
--
--          Selects a paRt Bank without an
--          active Theme Adjuster GUI
--          
-- ================================================================

-- script path
local info = debug.getinfo(1, 'S');

ScriptPath = info.source:match [[^@?(.*[\/])[^\/]-$]]

-- package path
local path = ({reaper.get_action_context()})[2]:match('^.+[\\//]')
package.path = path .. "?.lua"

-- macro
require("lib.part_lib")
Part.Macro.SelectBankWithoutGui(3)