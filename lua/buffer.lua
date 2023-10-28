Buffer = class()

function Buffer:init(type, t)
    return t or {}
end

function Buffer:resize(size)
    for i in range(size) do
        self[i] = self[i] or 0
    end
    return self
end

function Buffer:reset()
    for i in range(#self) do
        self[i] = nil
    end
end

function Buffer:add(...)
    return table.insert(self, ...)
end

function Buffer:insert(...)
    return table.insert(self, ...)
end
