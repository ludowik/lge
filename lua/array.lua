Array = class()

function Array:init()
    return {}
end

assert(not getmetatable(Array()))
