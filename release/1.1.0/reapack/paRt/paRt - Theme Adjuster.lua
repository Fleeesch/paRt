-- @version 1.1.0
-- @author Fleeesch
-- @description paRt Theme Adjuster
-- @noIndex



Part = {}

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  External Files
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--
-- store script path
local info = debug.getinfo(1, 'S');
ScriptPath = info.source:match [[^@?(.*[\/])[^\/]-$]]
Restart_Command_id="_RS8dc6c730d9860a7787be4d2defc319dd2cdfdc44"

-- package path
local path = ({reaper.get_action_context()})[2]:match('^.+[\\//]')
package.path = path .. "?.lua"

-- base library
require("lib.part_lib")

-- gui mapping
Part.Gui.Theme.checkCurrentTheme()
Part.Gui.Macros = require("lib.res.lua.map_macros")
require("lib.res.lua.map")

Part.Version.setVersion("1.06")



-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Draw
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function Part.draw()
    Part.Gui.Window.detectDpiChange()
    Part.Gui.Window.detectWindowResize()

    Part.Tab.Group.updateTabEntries()

    Part.Draw.Buffer.buffer_bg:processPendingClearing()
    Part.Draw.Buffer.buffer_control:processPendingClearing()

    -- process pending action
    for i = 1, #Part.List.pending_action do
        Part.List.pending_action[i].func(table.unpack(Part.List.pending_action[i].args))
    end

    Part.List.pending_action = {}

    -- check if theme has changed
    if Part.Global.ticks > 0 then
        Part.Gui.Theme.checkForThemeChange()
    end

    -- update banks
    if Part.Global.initial_load then
        Part.Bank.Handler:update()
    end

    -- user input
    Part.Gui.Keyboard:update()
    Part.Gui.Mouse:update()

    -- background graphics
    if Part.Draw.Buffer.buffer_bg:isOpen() then
        Part.Draw.Buffer.buffer_bg:activate()
        Part.Draw.Graphics.drawBackground()
        Part.Draw.Graphics.drawInfoBar()
        Part.Draw.Buffer.buffer_bg:deactivate()
    end

    -- bank bar
    Part.Gui.BankBar:draw()

    -- validate paRt theme
    if Part.Gui.Theme.validateTheme() then
        if Part.Global.update_visible_elements then
            Part.Draw.Elements.filterVisibleElements()
        end

        -- routines
        for i = 1, #Part.List.routine do
            Part.List.routine[i]:routine()
        end

        for i = 1, #Part.List.theme_parameter_buffer do
            Part.List.theme_parameter_buffer[i]:buffer()
        end

        -- static background graphics
        if Part.Draw.Buffer.buffer_bg:isOpen() then
            Part.Draw.Buffer.buffer_bg:activate()

            -- layout elements
            for i = 1, #Part.List.visible_layout do
                Part.List.visible_layout[i]:draw()
            end

            -- images
            for i = 1, #Part.List.visible_layout_image do
                Part.List.visible_layout_image[i]:draw()
            end

            Part.Draw.Buffer.buffer_bg:close()
            Part.Draw.Buffer.buffer_bg:deactivate()
        end

        -- draw buffered graphics
        Part.Draw.Buffer.buffer_bg:output()

        -- controls
        for i = 1, #Part.List.visible_control do
           Part.List.visible_control[i]:draw()
        end

        -- output
        for i = 1, #Part.List.visible_layout_redraw do
            Part.List.visible_layout_redraw[i]:draw()
        end

        -- tabs
        for i = 1, #Part.List.tab_group do
            Part.List.tab_group[i]:draw()
        end


        -- control hints
        for i = 1, #Part.List.visible_control_hint do
            Part.List.visible_control_hint[i]:draw()
        end

        -- pop-up messages
        Part.Gui.MessageHandler:draw()

        -- draw single active hint
        Part.Gui.Hint.hint_message:draw()

        -- refesh theme when required
        Part.Functions.handleThemeRefresh()
    else
        -- missing theme message
        Part.Draw.Graphics.drawBackground()
        Part.Draw.Graphics.drawThemeError()
    end

    -- optional splash messages
    Part.Draw.Graphics.drawSplashMessage()

    -- recommended by the reascript documentation
    gfx.update()
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Main Loop
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function Part.main()

    -- change theme refresh frequency according to track count
    Part.Parameter.Theme.updateThemeParameterRefreshRate()

    -- window reset
    if Part.Gui.Keyboard.isPressed("r") then
        Part.Gui.Window.setWindowPosition(Part.Global.winpos_default_x, Part.Global.winpos_default_y)
    end

    -- window terminate
    if Part.Gui.Keyboard.isPressed("esc") or Part.Global.gui_closed then
        Part.exit(true)
    end

    -- script restart
    if Part.Global.restart_shortcut and Part.Gui.Keyboard.isPressed("t") then
        Part.reload(true)
    end

    -- drawing process
    Part.draw()


    -- tick counter
    Part.Global.ticks = Part.Global.ticks + 1

    -- endless loop
    if Part.Global.keep_running then
        reaper.runloop(Part.main)
    end

    -- save data after changes occured
    Part.Bank.Functions.pendingSave()
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Reload
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function Part.reload(store_settings)
    Part.exit(store_settings)
    reaper.Main_OnCommand(reaper.NamedCommandLookup(Restart_Command_id),0)
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Exit
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

-- gets called on exit
function Part.exit(store_settings)
    -- store window position
    Part.Gui.Window.storeWindow()

    -- create a snapshot if theme is valid
    if Part.Gui.Theme.validateTheme() and store_settings ~= nil and store_settings then
        Part.Bank.Functions.storeParameterFile()
    end
    
    reaper.SetExtState(Part.Global.ext_section,"Status","stopped",false)

    -- close window, stop main loop
    gfx.quit()
    Part.Global.keep_running = false
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Main Process
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

-- setup knob graphics
Part.Draw.Sprites.createAssets()

-- create window
Part.Gui.Window.initWindow()

Part.Draw.Buffer.buffer_bg:init()
Part.Draw.Buffer.buffer_control:init()

-- check for part theme before main loop begins
if Part.Gui.Theme.validateTheme(true) then
    -- draw once to initialize elements
    Part.draw()

    -- restore previously opened tabs
    Part.Tab.Group.restoreTabs()

    
    -- force load the parameter file, skipping theme change comparison
    Part.Bank.Functions.loadParameterFile(true)
    
    Part.Global.initial_load = true
    
    -- initialize bank handler
    Part.Bank.Handler:init()

end

-- main loop
Part.main()

reaper.SetExtState(Part.Global.ext_section,"Status","running",false)