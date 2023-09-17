NL = '\n'

function string:inList(list)
    assert(type(list) == 'table')
    for _, v in pairs(list) do if v == self then return true end end
end

function string.contains(s, ...)
    local args = {...}
    if #args == 1 and type(args[1]) == 'table' then
        args = args[1]
    end

    for i,v in ipairs(args) do
        if s:find(v) then
            return true
        end
    end
    return false
end

function string:random()
    local i = randomInt(1, #self)
    return self:sub(i, i)
end

function string.unitTest()
    assert(('list'):inList{'list'})
    assert(not ('not in list'):inList{'list'})
end
