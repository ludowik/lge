local classList, classMap = {}, {}

function class(__className)
    local __inheritsFrom = nil
    if type(__className) == 'table' then 
        __inheritsFrom = __className
        __className = nil
    end

    assert(__className == nil or type(__className) == 'string')

    local klass = {
        __class = true,
        __className = __className or scriptName(3),
        __classInfo = scriptLink(3),
        __init = function (instance, ...) end,
        extends = extends,
        attrib = attrib,
        clone = table.clone,
    }
    klass.__index = klass

    setmetatable(klass, {
        __call = function (_, ...)
            local instance = setmetatable({}, klass)
            local init = klass.init or klass.__init
            return init(instance, ...) or instance
        end
    })
    klass.new = function (_, ...)
        local instance = setmetatable({}, klass)
        return instance
    end

    table.insert(classList, klass)
    classMap[klass] = klass

    if __className then
        (_G.env or _G)[__className] = klass
    end

    if __inheritsFrom then 
        klass:extends(__inheritsFrom)
    end

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

function classWithProperties(proto, base)
    base = base or proto
    if base.properties == nil then return end

    local get = base.properties.get
    if table.getnKeys(get) > 0 then
        proto.__index = function (tbl, key)
            if proto[key] then
                return proto[key]
            elseif get[key] then
                return get[key](tbl)
            elseif type(key) == 'number' and get.index then
                return get.index(tbl, key)
            else
                return rawget(tbl, key)
            end
        end
    end

    local set = base.properties.set
    if table.getnKeys(set) > 0 then
        proto.__newindex = function (tbl, key, value)
            if proto[key] then
                proto[key] = value
            elseif set[key] then
                set[key](tbl, value)
            elseif type(key) == 'number' and set.index then
                set.index(tbl, key, value)
            else
                rawset(tbl, key, value)
            end
        end
    end
end

function push2globals(klass)
    for propName, prop in pairs(klass) do
        if type(prop) == 'function' and type(propName) == 'string' and not propName:inList{'setup'} then
            _G[propName] = prop
        end
    end
end

function classSetup(env)
    env = env or _G

    for name,klass in pairs(env) do
        if type(klass) == 'table' and klass.__class then
            klass.__className = name
        end
    end

    for name,klass in pairs(classList) do
        if klass.setup then
            klass.setup()
            klass.setup = nil
        end
    end
end

function classUnitTesting()
    string.unitTest()
    
    for name,klass in pairs(classList) do
        if klass.unitTest then
            klass.unitTest()
            klass.unitTest = nil
        end
    end
end

function classnameof(object)
    return attributeof('__className', object) or type(object)
end

function attributeof(attrName, object)
    if not object or type(object) ~= 'table' then return end
    return object[attrName]
end

function typeof(object)
    local typeof = type(object)
    if typeof == 'table' then
        return attributeof('__className', object) or 'table'

    elseif typeof == 'cdata' then
        typeof = ffi.typeof(object)
        if typeof then
            return typeof
        end
        return 'cdata'
    end
    return typeof
end

function isclass(klass)
    return classMap[klass]
end

class().unitTest = function ()
    assert(true)
    assert(classnameof({}) == 'table')

    -- test properties
    local test = class()
    test.properties = {
        get = {},
        set = {}
    }

    test.properties.set.a = function (self, v) self._a = v end
    test.properties.get.a = function (self) return self._a end

    classWithProperties(test)
    local t = test()
    t.a = 12
    assert(t.a == 12)

    assert(classnameof(t) == 'class')
    assert(typeof(t) == 'class')
end
