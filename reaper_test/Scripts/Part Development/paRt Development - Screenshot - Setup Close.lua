-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Dependencies
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

-- dependency path
local info = debug.getinfo(1, 'S');
ScriptPath = info.source:match [[^@?(.*[\/])[^\/]-$]]
local path = ({reaper.get_action_context()})[2]:match('^.+[\\//]')
package.path = path .. "?.lua"

-- include
PartTools = require("lib.part_tools")

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Main Process
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -    

PartTools.setFullscreen(false)
