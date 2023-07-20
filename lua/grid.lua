Grid = class() : extends(Array)

function Grid:init(w, h)
    assert(w, h)

    self.w = w
    self.h = h

    self:clear()
end

function Grid:clear()
    self.items = Array()
end

function Grid:offset(x, y)
    return x + y * self.w
end

function Grid:set(x, y, value)
    self.items[self:offset(x, y)] = value
end

function Grid:get(x, y)
    return self.items[self:offset(x, y)]
end
