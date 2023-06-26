Array = class() : extends(table)
Array.add = table.insert

table.__className = 'table'

function Array:init(...)
    return ...
end

function Array:unitTest()
    local t = Array()
    t:add('element')
    
    assert(t[1] == 'element')
    assert(#t == 1)

    assert(Array(t) == t)
    assert(Array() ~= t)
end
