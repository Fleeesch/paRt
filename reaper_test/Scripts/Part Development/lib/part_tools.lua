local part = {}

part.resolution = {
    fhd = { name = "fhd", w = 1920, h = 1080, dpi = 100, setup_index = 1, setup_time = { dpi = 10, resolution = 10 } },
    qhd = { name = "qhd", w = 2560, h = 1440, dpi = 100, setup_index = 1, setup_time = { dpi = 10, resolution = 10 } },
    uhd = { name = "uhd", w = 3840, h = 2160, dpi = 150, setup_index = 1, setup_time = { dpi = 10, resolution = 10 } }
}

local cmd_setdpi = "sw/setdpi/SetDpi.exe"
local cmd_nircmd = "sw/nircmd/nircmdc.exe"
local cmd_changescreenresolution = "sw/change_screen_resolution/ChangeScreenResolution.exe"

part.fullscreen_active = false
part.floating_toolbar_visible = false



function part.storeInitialStates()
    local command_id_fullscreen = 40346
    local command_id_floating_toolbar = 41084

    part.fullscreen_active = reaper.GetToggleCommandState(command_id_fullscreen) ~= 0
    part.floating_toolbar_visible = reaper.GetToggleCommandState(command_id_floating_toolbar) ~= 0
end

function part.restoreInitialStates()
    part.setFullscreen(part.fullscreen_active)
    part.showFloatingToolbar(part.floating_toolbar_visible)
end

function part.setFullscreen(state)
    -- fullscreen toggle id
    local command_id = 40346

    local is_fullscreen = reaper.GetToggleCommandState(command_id) ~= 0

    if state ~= is_fullscreen then
        reaper.Main_OnCommand(command_id, 0)
    end
end

function part.showFloatingToolbar(state)
    -- show floating toolbar
    local command_id = 41084

    local toolbar_visible = reaper.GetToggleCommandState(command_id) ~= 0

    if state ~= toolbar_visible then
        reaper.Main_OnCommand(command_id, 0)
    end
end

local function wait(sec)
    local t = reaper.time_precise() + sec
    while reaper.time_precise() < t do
        reaper.defer(function() end)
    end
end

local function run(cmd, args)
    if args then
        os.execute("start /min " .. ScriptPath .. "/" .. cmd .. " " .. args)
    else
        os.execute("start /min " .. ScriptPath .. "/" .. cmd)
    end
end

local function setResolution(w, h)
    --run(cmd_nircmd, "setdisplay " .. tostring(w) .. " " .. tostring(h) .. " 32")
    run(cmd_changescreenresolution, "/w=" .. tostring(w) .. " /h=" .. tostring(h) .. " /d=0 /f=60 /b=32")
end

local function setDpi(dpi)
    run(cmd_setdpi, dpi .. " 1")
end

local function saveScreenshot(name)
    run(cmd_nircmd, "savescreenshot \"" .. ScriptPath .. "/sshot/" .. name .. ".png\"")
end

function part.resetDisplay()
    part.setupFormat(part.resolution.qhd)
end

function part.CaptureDpi(dpi)
    -- change resolution
    -- run(cmd_nircmd .. " setdisplay 1920 1080 24")

    -- -- change DPI scaling
    setResolution(1920, 1080)

    -- -- give Windows time
    -- wait(0.8)   -- 0.5–1.0 sec usually safe

    -- -- your custom pre-screenshot actions
    -- reaper.Main_OnCommand(123456, 0)  -- whatever custom action ID you use

    -- -- wait for Reaper redraw
    -- wait(0.4)

    -- -- screenshot
    -- run([[C:\tools\nircmd.exe savescreenshot "D:\shots\shot_125.png"]])
end

function part.setupFormat(format)
    setResolution(format.w, format.h)
    -- wait(format.setup_time.resolution)
    setDpi(format.dpi)
    -- wait(format.setup_time.dpi)
end

function part.SetupReaper(index)
    if index == 1 then
        -- reaper.Main_OnCommand(40454,0) -- load window set 1
        reaper.Main_OnCommand(40444, 0) -- load track view  1
    end

    reaper.Main_OnCommand(41239, 0) -- load selection set 1
end

function part.CaptureFormat(format, theme)
    -- change DPI scaling

    part.setupFormat(format)
    part.SetupReaper(format.setup_index)
    -- wait(1)
    saveScreenshot(format.name .. "_" .. theme)


    -- -- give Windows time
    -- wait(0.8)   -- 0.5–1.0 sec usually safe

    -- -- your custom pre-screenshot actions
    -- reaper.Main_OnCommand(123456, 0)  -- whatever custom action ID you use

    -- -- wait for Reaper redraw
    -- wait(0.4)

    -- -- screenshot
    -- run([[C:\tools\nircmd.exe savescreenshot "D:\shots\shot_125.png"]])
end

return part
