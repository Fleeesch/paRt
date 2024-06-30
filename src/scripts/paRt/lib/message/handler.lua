local message = {}

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Block Messages
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

message.block_messages = false

function message.blockMessages(block)
    message.block_messages = block
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Method : Show Message
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function message.showMessage(text, symbol, type)

    -- only show messages when allowed
    if message.block_messages then
        return
    end
    
    -- requires message handler
    if Part.Gui.MessageHandler ~= nil then
        Part.Gui.MessageHandler:showMessage(text, symbol, type)
    end
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Message Handler
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

message.MessageHandler = {}

function message.MessageHandler:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    Part.Cursor.applyCursorToTarget(o)

    -- messages to be displayed
    o.messages = {}

    -- delay and fade-out-time
    o.delay = 50
    o.fade_out = 20

    -- original y-position (for message placement)
    o.y_pos = 0

    -- padding between messages
    o.message_pad = 10

    -- character limit before line-break
    o.char_limit = 80

    return o
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Message Handler : Add Message
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function message.MessageHandler:showMessage(text, symbol, type)

    -- create message
    local msg = Part.Message.Entry.MessageEntry:new(nil, text, symbol, type,self)

    -- shift handler position
    self:shiftOffset(-msg.height)

    -- update created message position
    msg:setPosition(self.y_pos)

    -- register message
    table.insert(self.messages, msg)

end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Message Handler : Shift Offset
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function message.MessageHandler:shiftOffset(offset)

    -- get padding
    local pad = self.message_pad

    -- flip padding depending on the shift direction
    if offset < 0 then
        pad = -pad
    end

    -- apply offset
    self.y_pos = self.y_pos + offset + pad
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Message Handler : Draw
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function message.MessageHandler:draw()

    -- skip if there are no messages
    if #self.messages <= 0 then
        return
    end

    -- dimensions
    local x = Part.Functions.rescale(self.dim_x)
    local y = Part.Functions.rescale(self.dim_y)
    local w = Part.Functions.rescale(self.dim_w)
    local h = Part.Functions.rescale(self.dim_h)

    -- daw messages
    for key, val in pairs(self.messages) do
        val:draw()
    end

    -- required message shift
    local total_shift = 0

    -- go through messages
    for key, val in pairs(self.messages) do

        -- message can be killed?
        if val.kill then

            -- reshift the offset
            self:shiftOffset(val.height)

            -- increment total shift
            total_shift = total_shift - val.height - self.message_pad

            -- remove message from lookup table
            table.remove(self.messages, key)
            break
        end

    end

    -- apply total shift to messages
    if total_shift ~= 0 then
        for key, val in pairs(self.messages) do
            val.pos_offset = val.pos_offset - total_shift
        end
    end

end

return message