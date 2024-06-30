local draw = {}

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Clear Complete Buffer
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function draw.clearCompleteBuffer()
    
    Part.Global.update_visible_elements = true
    
    for i, buffer in pairs(draw.buffer_list) do
        buffer:clear()
    end

    

end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Buffer
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

draw.Buffer = {}

function draw.Buffer:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    o.closed = false

    -- graphics slot
    o.slot = Part.Draw.Sprites.getNextFreeImageSlot()
    o.slot_snapshot = Part.Draw.Sprites.getNextFreeImageSlot()

    -- snapshot
    o.snapshot_s = 0
    o.snapshot_available = false

    -- about to be cleared
    o.pending_clear = false

    -- ready to write
    o.available = true


    return o
end


draw.buffer_bg = draw.Buffer:new(nil)
draw.buffer_control = draw.Buffer:new(nil)

draw.buffer_list = {draw.buffer_bg, draw.buffer_control}


-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Buffer : Is Open
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function draw.Buffer:isOpen()
    return not self.closed
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Buffer : Is Closed
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function draw.Buffer:isClosed()
    return self.closed
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Buffer : Close
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function draw.Buffer:close()
    self.closed = true
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Buffer : Activate
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function draw.Buffer:activate()
    gfx.dest = self.slot
    self.available = true
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Buffer : Deactivate
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function draw.Buffer:deactivate()
    gfx.dest = -1
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Buffer : Init
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function draw.Buffer:init()
    self:clear()
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Buffer : Output
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function draw.Buffer:output()
    gfx.dest = -1

    gfx.x = 0
    gfx.y = 0

    gfx.mode = 0
    gfx.a = 1

    gfx.blit(self.slot, 1, 0)
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Buffer : Process Pending Clearing
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function draw.Buffer:processPendingClearing()
    if not self.pending_clear then
        return
    end

    gfx.setimgdim(self.slot, -1, -1)
    gfx.setimgdim(self.slot, gfx.w, gfx.h)

    gfx.dest = -1

    self.closed = false

    self.pending_clear = false

    Part.Draw.Elements.prepareElements()
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Buffer : Clear
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function draw.Buffer:clear()
    self.pending_clear = true
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Buffer : Create Snapshot
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function draw.Buffer:createSnapshot()
    gfx.dest = self.slot_snapshot

    local w = math.max(gfx.w, Part.Global.win_w)
    local h = math.max(gfx.h, Part.Global.win_h)

    gfx.setimgdim(self.slot_snapshot, -1, -1)
    gfx.setimgdim(self.slot_snapshot, w, h)

    self.snapshot_w = w
    self.snapshot_h = h
    self.snapshot_s = Part.Global.scale

    gfx.x = 0
    gfx.y = 0
    gfx.a = 1

    gfx.blit(-1, 1, 0)

    gfx.dest = -1

    self.snapshot_available = true
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Buffer : Output Snapshot
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function draw.Buffer:outputSnapshot(alpha)
    if not self.snapshot_available then
        return
    end

    gfx.dest = -1

    local alpha = alpha or 1

    gfx.x = 0
    gfx.y = 0
    gfx.a = alpha

    local scale = calcScale() / self.snapshot_s

    gfx.blit(self.slot_snapshot, scale, 0)
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--  Buffer : Clear Snapshot
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function draw.Buffer:clearSnapshot()
    local dest_last = gfx.dest

    gfx.dest = self.slot_snapshot

    gfx.setimgdim(self.slot_snapshot, -1, -1)

    gfx.dest = dest_last

    self.snapshot_available = false
end

return draw