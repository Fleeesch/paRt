-- @version 1.2.2
-- @author Fleeesch
-- @description paRt Theme Adjuster
-- @noIndex

--[[
    This section handles configurationis; originally this was the job of bank.lua before v1.2.2.
    ]] --

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
function config.Handler.ConfigHandler:getSelectedConfigFilePath(loading_context)
    --
    --      Helper Function: Find Fallback Config by Index
    -- =======================================================
    local function find_fallback_config_by_index(path, index)
        -- path needs to be valid
        if not path or path == "" then return nil end
        if not reaper.EnumerateFiles(path, 0) then return nil end

        -- filename for config identification including the index
        local prefix = "config_" .. tostring(index)
        local i = 0

        -- iterate folder
        while true do
            local fn = reaper.EnumerateFiles(path, i)

            -- stop at end
            if not fn then break end

            -- return file if there's a match
            if fn:match("%.partmap$") and fn:sub(1, #prefix) == prefix then
                return path .. "/" .. fn
            end

            -- increment index
            i = i + 1
        end

        -- return a pseudo filename for later error messages
        return "/Slot " .. tostring(i + 1) .. " Fallback Config"
    end
    -- =======================================================

    -- loading context
    loading_context = loading_context or false

    -- don't do anything if no config is selected
    if self:selectedConfig() == nil then
        return nil
    end

    -- store index and config source path
    local index = self:selectedConfig()
    local conf = Part.Global.config_dir

    -- basic target file
    local target_file = conf .. "/slot/config_slot_" .. tostring(index + 1) .. ".partmap"

    -- when loading something, look for a fallback file if target doesn't exist
    if loading_context and not reaper.file_exists(target_file) then
        -- default config path
        local default_path = conf .. "/default/"

        -- find fallback config
        return find_fallback_config_by_index(default_path, index + 1)
    end

    -- return file path for regular slot config
    return target_file
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
        local file_name = self:getSelectedConfigFilePath(true)

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
