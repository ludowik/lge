Grid = class() : extends(Array)

function Grid:init(w, h)
    assert(w, h)

    self.w = floor(w)
    self.h = floor(h)

    self:clear(iniVaue)
end

function Grid:clear()
    self.items = Array()
end

function Grid:offset(x, y)
    return x + (y-1) * self.w
end

function Grid:set(x, y, value)
    local offset = self:offset(x, y)
    if offset < 1 or offset > self.w * self.h then 
        return 
    end
    self.items[offset] = value
end

function Grid:get(x, y)
    local offset = self:offset(x, y)
    if offset < 1 or offset > self.w * self.h then
        return
    end
    return self.items[offset]
end
