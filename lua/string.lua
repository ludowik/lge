NL = '\n'

function string:inList(list)
    assert(type(list) == 'table')
    for _, v in pairs(list) do if v == self then return true end end
end

function string:random()
    local i = randomInt(1, #self)
    return self:sub(i, i)
end

function string.unitTest()
    assert(('list'):inList{'list'})
    assert(not ('not in list'):inList{'list'})
end
