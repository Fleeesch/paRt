-- @description paRt helper script
-- @version 1.0
-- @author Fleeesch
-- @noindex NoIndex: true

local info = debug.getinfo(1,'S');
script_path = info.source:match[[^@?(.*[\/])[^\/]-$]]
dofile(script_path .. "_part_functions.lua.inc")

saveSet(4)