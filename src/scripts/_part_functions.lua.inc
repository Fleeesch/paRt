-- @description paRt helper script
-- @version 1.0.1
-- @author Fleeesch
-- @noindex NoIndex: true

-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--      Globals
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
SECTION = "fleeesch_part"

-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--      Function : Toggle Auto-Save
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

function toggleAutoSave()
    
    is_new_value, filename, sectionID, cmdID, mode, resolution, val, contextstr = reaper.get_action_context()
    
    state = reaper.GetToggleCommandState(cmdID)
    
    state_set = 1
    
    if state > 0 then
        state_set = 0
    end
    
    reaper.SetToggleCommandState(sectionID, tonumber(cmdID), state_set)
    
    if state_set > 0 then
        reaper.SetExtState(SECTION, "autosave", "1", true)
    else
        reaper.SetExtState(SECTION, "autosave", "0", true)
    end

end

-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--      Function : Get Data
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
function getData(index)

    for i = 0, 10 do
        key_par = "set" .. index .. "_p" .. i
        val_str = reaper.GetExtState(SECTION, key_par)
        val_int = tonumber(val_str)

        if val_int ~= nil then
            reaper.ThemeLayout_SetParameter(i, val_int, true)
        end
    
    end

end

-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--      Function : Set Data
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

function setData(index)

    for i = 0, 10 do
        p_str, p_desc, p_int, p_def, p_min, p_max = reaper.ThemeLayout_GetParameter(i)
        key_par = "set" .. index .. "_p" .. i
        reaper.SetExtState(SECTION, key_par, tostring(p_int), true)
    end

end

-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--      Function : Load Set
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

function loadSet(idx)
    
    nr = idx
    
    autosave = 0
    
    last_idx = tonumber(reaper.GetExtState(SECTION, "last_idx"))
    
    if last_idx ~= nil then
        
        if autosave > 0 then
            setData(last_idx)
        end
        
        if reaper.HasExtState(SECTION, "set_" .. idx) then
            getData(idx)
        end
    
    else
        setData(idx)
    end
    
    reaper.SetExtState(SECTION, "last_idx", tostring(idx), true)
    reaper.SetExtState(SECTION, "set_" .. idx, "true", true)
    
    reaper.ThemeLayout_RefreshAll()

end

-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--      Function : Save Set
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

function saveSet(idx)
    
    nr = idx
    
    last_idx = tonumber(reaper.GetExtState(SECTION, "last_idx"))
    
    if last_idx ~= nil then
        setData(last_idx)
    
    else
        setData(idx)
    end
    
    reaper.SetExtState(SECTION, "last_idx", tostring(idx), true)
    reaper.SetExtState(SECTION, "set_" .. idx, "true", true)
    
    reaper.ThemeLayout_RefreshAll()

end

-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--      Function : Clear Data
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

function clearData()
    
    reaper.DeleteExtState(SECTION, "last_idx", true)
    for idx = 0, 8 do
        for i = 0, 10 do
            key_par = "set" .. idx .. "_p" .. i
            reaper.DeleteExtState(SECTION, key_par, true)
        end
        
        reaper.DeleteExtState(SECTION, "set_" .. idx, true)
    end
end

-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--      Function : Apply To All
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

function applyToAll()
    
    clearData()
    
    for i = 0, 8 do
        setData(i)
    end

end
