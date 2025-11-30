-- @version 1.2.2
-- @author Fleeesch
-- @description paRt Theme Adjuster
-- @noIndex
local config = { Functions = {}, Handler = {}, Save = {}, Load = {}, HardReset = {}, Reset = {} }


-- ==========================================================================================
--                      Config : Handler
-- ==========================================================================================

--  Config Handler
-- -------------------------------------------

config.Handler.ConfigHandler = {}

function config.Handler.ConfigHandler:new(o, config_parameter)
    o = o or {}
    setmetatable(o, config.Handler.ConfigHandler)
    self.__index = self

    -- selected configuration index
    o.config_selected = 0

    -- configuration index theme parameter
    o.config_parameter = config_parameter

    return o
end

--  Conifg Handler : Init
-- -------------------------------------------

function config.Handler.ConfigHandler:init()
    -- select bank based on bank-select-parameter
    self:selectConfig(self.config_parameter:getValue())
    self:update(true)
end

--  Config Handler : Selected Bank
-- -------------------------------------------

function config.Handler.ConfigHandler:selectedConfig()
    return self.config_selected
end

--  Config Handler : Select Config
-- -------------------------------------------

function config.Handler.ConfigHandler:selectConfig(idx)
    -- select config based on index
    self.config_selected = idx
    
    -- update config-select parameter
    self.config_parameter:setValue(idx)
end

--  Control : Config File Button : Get selected Config File Path
-- -----------------------------------------------------------------------
function config.Handler.ConfigHandler:getSelectedConfigFilePath()
    
    if self:selectedConfig() == nil then
        return nil
    end

    local index = self:selectedConfig()
    local conf = Part.Global.config_dir

    return conf .. "/config_" .. index .. ".partmap"
end

--  Config Handler : Save Config
-- -------------------------------------------

function config.Handler.ConfigHandler:saveConfig(use_index)
    -- use selected config index
    if use_index then
        -- get file path
        local file_name = self:getSelectedConfigFilePath()
        
        -- pending save
        table.insert(Part.List.pending_action, {
            func = Part.Bank.Functions.storeParameterFile,
            args = { file_name }
        })

        Part.Draw.Graphics.splashMessage('Saving ' .. Part.Functions.extractFileName(file_name) .. '...')
        return
    else
        -- use file browser extension
        local retval, file_name = reaper.JS_Dialog_BrowseForSaveFile(nil, nil, nil, "*.partmap\0*.partmap")

        if retval == 1 then
            if Part.Functions.extractExtension(file_name) ~= "partmap" then
                file_name = file_name .. ".partmap"
            end

            -- pending save
            table.insert(Part.List.pending_action, {
                func = Part.Bank.Functions.storeParameterFile,
                args = { file_name }
            })

            Part.Draw.Graphics.splashMessage('Saving ' .. Part.Functions.extractFileName(file_name) .. '...')
        end
    end
end

--  Config Handler : Load Config
-- -------------------------------------------

function config.Handler.ConfigHandler:loadConfig(use_index)
    -- selected config index
    if use_index then
        -- get file path
        local file_name = self:getSelectedConfigFilePath()

        -- add to pending save
        table.insert(Part.List.pending_action, {
            func = Part.Bank.Functions.loadParameterFile,
            args = { true, file_name }
        })

        Part.Draw.Graphics.splashMessage('Loading ' .. Part.Functions.extractFileName(file_name) .. '...')
        return
    else
        -- use file browser extension
        local retval, file_name = reaper.JS_Dialog_BrowseForOpenFiles(nil, nil, nil, "*.partmap\0*.partmap", false)

        if retval == 1 then
            -- pending load
            table.insert(Part.List.pending_action, {
                func = Part.Bank.Functions.loadParameterFile,
                args = { true, file_name }
            })

            Part.Draw.Graphics.splashMessage('Loading ' .. Part.Functions.extractFileName(file_name) .. '...')
        end
    end
end

--  Config Handler : Update
-- -------------------------------------------

function config.Handler.ConfigHandler:update(force)
    -- update selected config if changed externally
    if not force and self.config_parameter:getValue() ~= self:selectedConfig() then
         force = true
         self:selectConfig(self.config_parameter:getValue())
    end

    -- there has to be a config selected
    if self:selectedConfig() == nil then
        self:selectConfig(0)
         return
    end

end


return config
