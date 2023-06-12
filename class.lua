local classList = {}

function class(name)
    local klass = {
        __init = function(instance, ...)
        end,
        extends = extends
    }
    klass.__index = klass

    setmetatable(klass, {
        __call = function(...)
            local instance = setmetatable({}, klass)
            local init = klass.init or klass.__init
            return init(instance, ...) or instance
        end
    })
    return klass
end

function extends(klass, klassParent, ...)
    for fName, func in pairs(klassParent) do
        if type(func) == 'function' and not fName:inList{'extends', 'init', '__init', '__index'} then
            if klass[fName] == nil then
               klass[fName] = func
            end
        end
    end
    return klass
end
