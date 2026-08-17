-- @version 1.3.2
-- @author Fleeesch
-- @description paRt Theme Adjuster
-- @noIndex

-- ================================================================
--          Script:
--          restart paRt Theme Adjuster
--
--          Called by Theme Adjuster itself in order to
--          restart itself.
--
--          [!]
--          Please do not delete this script from the
--          Reaper Action List. Doing so will likely cause
--          the Theme Adjustor crash on occasion.
--          
-- ================================================================

-- ext state address
local ext_section = "Fleeesch - paRt Theme Adjuster"

-- the command id for the paRt theme adjuster
local adjuster_command_id = "_RS6cc1a19365fa0f5b0b1ad6d3d9018dc41f087917"

-- trial index
local index = 0

-- limmit the amount of trials
local trial_count = 10

-- The Theme Adjuster might take a short time to close,
-- that's why there are multiple checks to avoid launching the Theme Adjuster
-- while it is still running
local function main()
    
    -- check if theme adjuster is not running anymore, launch it again
    local state = reaper.GetExtState(ext_section, "Status")
    
    if index > 0 and state ~= "running" then
        reaper.Main_OnCommand(reaper.NamedCommandLookup(adjuster_command_id),0)
    end

    -- keep trying
    if index < trial_count then
        reaper.defer(main)
    end
    
    index = index + 1
end

main()
