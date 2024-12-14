Array = class() : extends(table)

table.__className = 'table'

function Array:init(t)
    t = t or {}
    setmetatable(t, Array)
    return t
end

function Array:count(f)
    assert(not f)
    return #self
end

Array.add = table.insert
Array.push = table.insert

Array.pop = table.remove
Array.shift = function(t) return table.remove(t, 1) end

table.unpack = table.unpack or unpack
Array.unpack = table.unpack

Array.clone = table.clone

function Array:addArray(t)
    for _, v in ipairs(t) do
        table.insert(self, v)
    end
    return self
end 

function Array:concat(sep)
    sep = sep or ''

    local txt = ''
    for i=1,#self do
        if i > 1 then 
            txt = txt..sep
        end
        txt = txt..tostring(self[i])
    end
    return txt --:trim(sep)
end

function Array:removeIfTrue(f)
    for i, v in ipairs(self, true) do
        if f(v) then
            table.remove(self, i)
        end
    end
    return self
end

function Array:ipairs()
    return ipairs(self)
end

function Array:forn(n, functionOrValue)
    if type(functionOrValue) == 'function' then
        for i=1,n do
            self[i] = functionOrValue(i)
        end
    else
        for i=1,n do
            self[i] = functionOrValue or i
        end
    end
    return self
end

function Array:foreach(f, ...)
    for i=1,#self do
        local v = self[i]
        f(v, i, ...)
    end
    return self
end

function Array:foreachKey(f, ...)
    for k, v in pairs(self) do
        f(v, k, ...)
    end
    return self
end

function Array:indexOf(item)
    for i=1,#self do
        local v = self[i]
        if item == v then return i end
    end
end

function Array:keyOf(item)
    for k, v in pairs(self) do
        if item == v then return k end
    end
end

function Array:first()
    return self[1]
end

function Array:last()
    return self[#self]
end

function Array:nextIndex(i)
    i = i + 1
    if i > #self then i = 1 end
    return i
end

function Array:previousIndex(i)
    i = i - 1
    if i < 1 then i = #self end
    return i
end

function Array:next(item)
    local i = self:indexOf(item) or #self
    if i < #self then
        return self[i+1]
    else
        return self[1]
    end
end

function Array:random()
    local i = randomInt(1, #self)
    return self[i], i
end

function Array:removeRandom()
    local i = randomInt(1, #self)
    return self:remove(i), i
end

function Array:shuffle(seedValue)
    if seedValue then
        seed(seedValue)
    end

    for _=1,#self do
        local v, i = self:removeRandom()
        self:push(v)
    end
end

function Array:release()
    for i=1,#self do
        local v = self[i]
        if v.release then
            v:release()
        end
    end
    return self
end

function Array:update(dt)
    for i=1,#self do
        local v = self[i]
        if v.update then
            v:update(dt)
        end
    end
    return self
end

function Array:draw(dt, ...)
    for i=1,#self do
        local v = self[i]
        if v.draw then
            v:draw(...)
        end
    end
    return self
end

function Array:cross(f, ...)
    local n = #self

    self.comparaison = 0
    for i = 1, n - 1 do
        local v1 = self[i]
        for j = i + 1, n do
            local v2 = self[j]
            f(v1, v2, i, j, ...)
            self.comparaison = self.comparaison + 1
        end
    end
    return self
end

function Array:map(f)
    local list = Array()
    for i=1,#self do
        local v = self[i]
        list:add(f(v, i))
    end
    return list
end

function Array:chainIt()
    local n = #self
    self[1].__previous = self[n]
    self[n].__next = self[1]

    for i = 1, n - 1 do
        self[i].__next = self[i + 1]
        self[i + 1].__previous = self[i]
    end
end

function Array:max()
    if #self == 0 then return end

    local maxValue = math.mininteger
    for i=1,#self do
        local v = self[i]
        maxValue = max(maxValue, v)
    end
    return maxValue
end

function Array:tolua()
    return Array.__tolua(self, '')
end

local __serializeObjects = {}
function Array:__tolua(tab)
    if __serializeObjects[self] then return '#ref' end
    __serializeObjects[self] = self

    local serializeTypes = {
        boolean = tostring,
        number = tostring,
        string = function(s) return '"' .. s .. '"' end,
        table = function(t) return Array.__tolua(t, tab .. '\t') end,
    }

    local function name(k)
        return type(k) == 'number' and '[' .. k .. ']' or k
    end

    local code = '{'

    if #self > 0 then
        for k, v in ipairs(self) do
            if serializeTypes[type(v)] then
                code = code .. '\n'
                code = code .. tab .. '\t' .. serializeTypes[type(v)](v)
                code = code .. ','
            end
        end
    else
        for k, v in pairs(self) do
            if serializeTypes[type(v)] then
                code = code .. '\n'
                code = code .. tab .. '\t' .. name(k) .. ' = ' .. serializeTypes[type(v)](v)
                code = code .. ','
            end
        end
    end

    __serializeObjects[self] = nil

    code = code .. '\n' .. tab .. '}'
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
