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
