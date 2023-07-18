function string:inList(list)
    assert(type(list) == 'table')
    for _, v in pairs(list) do if v == self then return true end end
end

function string.unitTest()
    assert(('list'):inList{'list'})
    assert(not ('not in list'):inList{'list'})
end
