local ids = {}

function id(name)
    name = name or '__globalID'
    ids[name] = (ids[name] or 0) + 1
    return ids[name]
end

class().unitTest = function ()
    for i=1,100 do
        assert(id() == i)
    end
    assert(id() ~= id('new'))
    assert(id('new') == id('new')-1)
    assert(id('new1') == id('new2'))
end
