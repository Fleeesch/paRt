local gui = {}

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Screenset Handler
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

ScreensetHandler = {}

function ScreensetHandler:new(o)
    o = o or {}
    setmetatable(o, ScreensetHandler)
    self.__index = self

    -- lookup
    o.zoom_levels = { "100", "125", "150", "175", "200", "225", "250", "300" }
    o.mcp_lookup = { "Strip", "Meter Strip", "Normal", "Wide", "Extra Wide", "Sidebar" }
    o.tcp_lookup = { "Normal", "Inline FX", "Separate Faders", "Meter"}

    -- parameters
    o.mcp_parameter = nil
    o.mcp_master_parameter = nil
    o.tcp_parameter = nil
    o.tcp_master_parameter = nil

    -- comparison values
    o.mcp_last_layout = -1
    o.mcp_master_last_layout = -1
    o.tcp_last_layout = -1
    o.tcp_master_last_layout = -1  
    o.retina_last = -1

    return o
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Screenset Handler : Set MCP Parameter
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ScreensetHandler:setMcpParameter(parameter)
    self.mcp_parameter = parameter
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Screenset Handler : Set MCP Master Parameter
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ScreensetHandler:setMcpMasterParameter(parameter)
    self.mcp_master_parameter = parameter
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Screenset Handler : Set TCP Parameter
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ScreensetHandler:setTcpParameter(parameter)
    self.tcp_parameter = parameter
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Screenset Handler : Set TCP Master Parameter
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ScreensetHandler:setTcpMasterParameter(parameter)
    self.tcp_master_parameter = parameter
end


-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Screenset Handler : Get Zoom String
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ScreensetHandler:getZoomString()
    if gfx.ext_retina >= 3 then
        return "300"
    elseif gfx.ext_retina >= 250 then
        return "250"
    elseif gfx.ext_retina >= 225 then
        return "225"
    elseif gfx.ext_retina >= 200 then
        return "200"
    elseif gfx.ext_retina >= 175 then
        return "175"
    elseif gfx.ext_retina >= 150 then
        return "150"
    elseif gfx.ext_retina >= 125 then
        return "125"
    end
    return "100"
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Screenset Handler : Get Screenset Name
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ScreensetHandler:getScreensetName(lookup, parameter, sync)
    -- concatenation strings
    local zoom = self:getZoomString()
    local name = lookup[Part.Functions.cap(parameter + 1, 0, #lookup)]

    -- bank string
    local bank = "Bank " .. tostring(Part.Bank.Handler.bank_selected:getIndex() - 1)

    -- output string
    if name ~= nil then
        return zoom .. " - " .. name .. " - " .. bank
    else
        return zoom .. " - " .. bank
    end
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Screenset Handler : Update
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ScreensetHandler:update(force)

    -- !!! no more individual track screensets, apparently there's no performance improvment

    force = force or false


    -- store values
    --local mcp_layout = self.mcp_parameter:getValue()
    --local mcp_master_layout = self.mcp_master_parameter:getValue()
    --local tcp_layout = self.tcp_parameter:getValue()
    --local tcp_master_layout = self.tcp_master_parameter:getValue()

    -- global
    if force or gfx.ext_retina ~= self.retina_last then
        --local zoom = self:getZoomString()
        local zoom = '100'
        local bank = ' - Bank ' .. tostring(Part.Bank.Handler.bank_selected:getIndex() - 1)
        
        --reaper.ThemeLayout_SetLayout('!global', zoom .. " - " .. bank)
        reaper.ThemeLayout_SetLayout('global', '100')

        self.retina_last = gfx.ext_retina
        force = true
    end

    -- mcp
    --if force or self.mcp_parameter ~= nil and mcp_layout ~= self.mcp_last_layout then
    --    local name = self:getScreensetName(self.mcp_lookup, mcp_layout)
    --    reaper.ThemeLayout_SetLayout('mcp', name)
    --    self.mcp_last_layout = mcp_layout
    --end

    -- mcp master
    --if force or self.mcp_master_parameter ~= nil and mcp_master_layout ~= self.mcp_master_last_layout then
    --    local name = self:getScreensetName(self.mcp_lookup, mcp_master_layout)
    --    reaper.ThemeLayout_SetLayout('master_mcp', name)
    --    self.mcp_master_last_layout = mcp_master_layout
    --end

    -- tcp
    --if force or self.tcp_parameter ~= nil and tcp_layout ~= self.tcp_last_layout then
    --    local name = self:getScreensetName(self.tcp_lookup, tcp_layout)
    --    reaper.ThemeLayout_SetLayout('tcp', name)
    --    self.tcp_last_layout = tcp_layout
    --end 

    -- tcp master
    --if force or self.tcp_master_parameter ~= nil and tcp_master_layout ~= self.mcp_master_last_layout then
    --    local name = self:getScreensetName(self.tcp_lookup, tcp_master_layout)
    --    reaper.ThemeLayout_SetLayout('master_tcp', name)
    --    self.tcp_master_last_layout = tcp_master_layout
    --end    


end

return gui