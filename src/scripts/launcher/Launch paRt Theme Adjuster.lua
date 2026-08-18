-- @version 1.3.2
-- @author Fleeesch
-- @description paRt Theme Adjuster
-- @noIndex

--[[
    Launches the paRt Theme Adjuster script based on it's command ID.
    The ID is generated from a strict relative path, moving the adjuster script to another
    location will crash the script.
]]--

reaper.Main_OnCommand(reaper.NamedCommandLookup("_RS6cc1a19365fa0f5b0b1ad6d3d9018dc41f087917"), 0)
