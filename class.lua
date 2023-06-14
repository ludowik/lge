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

local doNotOverride = {'extends', 'init', '__init', '__index'}

function extends(klass, ...)
    for _, klassParent in ipairs({...}) do
        for propName, prop in pairs(klassParent) do
            if klass[propName] == nil then 
                if (type(prop) == 'function' and not doNotOverride[propName] or 
                    type(prop) == 'number')
                then
                    klass[propName] = prop
                end
            end
        end
    end
    return klass
end
