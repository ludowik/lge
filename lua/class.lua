local classList = {}
function class(_, ...)
    assert(_ == nil)

    local info = debug.getinfo(2, "Sl")

    local klass = {
        __class = true,
        __className = info.source:gfind('.+/(.*)%.lua$')(),
        __classInfo = info.source:gsub('@', './')..':'..info.currentline,
        __init = function(instance, ...)
        end,
        extends = extends,
        attrib = attrib
    }
    klass.__index = klass

    setmetatable(klass, {
        __call = function(_, ...)
            local instance = setmetatable({}, klass)
            local init = klass.init or klass.__init
            local newInstance = init(instance, ...)
            if newInstance then
                instance = setmetatable(newInstance, klass)
            end
            return instance
        end
    })
    table.insert(classList, klass)
    return klass
end

local doNotOverride = {'extends', 'init', '__init', '__index'}
function extends(klass, ...)
    klass.__inheritsFrom = klass.__inheritsFrom or {}
    for _, klassParent in ipairs({...}) do
        table.insert(klass.__inheritsFrom, klassParent)
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

function push2globals(klass)
    for propName, prop in pairs(klass) do
        if type(prop) == 'function' then
            _G[propName] = prop
        end
    end
end

function classSetup()
    for name,klass in pairs(_G) do
        if type(klass) == 'table' and klass.__class then
            klass.__className = name
        end
    end
    for name,klass in pairs(classList) do
        if klass.setup then
            klass.setup()
        end
    end
end

function classUnitTesting()
    for name,klass in pairs(classList) do
        if klass.unitTest then
            klass.unitTest()
        end
    end
end

function composition(klass)
    if klass and klass.__className then
        if klass.__inheritsFrom then
            return klass.__className..' <= '..composition(klass.__inheritsFrom[1])
        else
            return klass.__className
        end
    end
end


class().unitTest = function () 
    assert(true)
end
