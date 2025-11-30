-- @version 1.2.2
-- @author Fleeesch
-- @description paRt Theme Adjuster
-- @noIndex



-- script path
local info = debug.getinfo(1, 'S');

ScriptPath = info.source:match [[^@?(.*[\/])[^\/]-$]]

-- package path
local path = ({ reaper.get_action_context() })[2]:match('^.+[\\//]')
package.path = path .. "?.lua"

-- macro
require("lib.part_lib")

local theme_file = Part.Gui.Theme.validateLoadingTheme("Dimmed")
-- theme needs to be loadable
if theme_file == nil then
    return
end

Part.Gui.Theme.loadTheme(theme_file)