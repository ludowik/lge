Grid = class() : extends(Array)

function Grid:init(w, h, initValue)
    assert(w, h)

    self.w = floor(w)
    self.h = floor(h)

    self:clear(initValue)
end

function Grid:clear(initValue)
    self.items = Array()
    if initValue then
        for i in range(self.w) do
            for j in range(self.h) do
                if type(initValue) == 'function' then
                    self:set(i, j, initValue(i, j))
                else
                    self:set(i, j, initValue)
                end
            end
        end
    end
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

function Grid:foreach(f)
    for i in range(self.w) do
        for j in range(self.h) do
            local cell = self:get(i, j)
            if cell then
                f(cell, i, j)
            end
        end
    end
end
