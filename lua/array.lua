Array = class() : extends(table)
Array.add = table.insert

table.__className = 'table'

function Array:init(...)
    return ...
end

function Array:foreach(f)
    for i,v in ipairs(self) do
        f(v, i)
    end
end

function Array:foreachKey(f)
    for k,v in pairs(self) do
        f(v, k)
    end
end

function Array:remove(f)
    for i,v in ipairs(self, true) do
        if f(v) then
            table.remove(self, i)
        end
    end
end

function Array:random()
    return self[random(1, #self)]
end

function Array:tolua()
    return Array.__tolua(self, '')
end

function Array:__tolua(tab)
    local serializeTypes = {
        boolean = tostring,
        number = tostring,
        string = function (s) return '"'..s..'"' end,
        table = function (t) return Array.__tolua(t, tab..'\t') end, 
    }

    local function name(k)
        return type(k) == 'number' and '['..k..']' or k
    end
    
    local code = '{'

    for k,v in pairs(self) do
        if serializeTypes[type(v)] then
            code = code..'\n'                
            code = code..tab..'\t'..name(k)..' = '
            code = code..serializeTypes[type(v)](v)
            code = code..','
        end
    end

    code = code..'\n'..tab..'}'
    return code
end

function Array:unitTest()
    local t = Array()
    t:add('element')
    
    assert(t[1] == 'element')
    assert(#t == 1)

    assert(Array(t) == t)
    assert(Array() ~= t)
end
