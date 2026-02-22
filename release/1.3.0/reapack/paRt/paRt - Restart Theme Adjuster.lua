-- @version 1.2.7
-- @author Fleeesch
-- @description paRt Theme Adjuster
-- @noIndex

local ext_section = "Fleeesch - paRt Theme Adjuster"
local adjuster_command_id = "_RS6cc1a19365fa0f5b0b1ad6d3d9018dc41f087917"

local index = 0

-- limmit the amount of trials
local trial_count = 10

local function main()
    
    -- check if theme adjuster is not running anymore, launch it again
    local state = reaper.GetExtState(ext_section, "Status")
    if index > 0 and state ~= "running" then
        reaper.Main_OnCommand(reaper.NamedCommandLookup(adjuster_command_id),0)
    end

    if index < trial_count then
        reaper.defer(main)
    end
    
    index = index + 1
end

main()
