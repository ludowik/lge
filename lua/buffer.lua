Buffer = class()

function Buffer:init(type, t)
    t = t or {}
    setmetatable(t, Buffer)
    return t
end

function Buffer:resize(size)
    for i=1,size do
        self[i] = self[i] or 0
    end
    return self
end

function Buffer:reset()
    for i=#self,1,-1 do
        self[i] = nil
    end
end

function Buffer:add(...)
    return table.insert(self, ...)
end

function Buffer:insert(...)
    return table.insert(self, ...)
end
