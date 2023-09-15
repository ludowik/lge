local ids = {}

function id(name)
    name = name or 'global'
    ids[name] = (ids[name] or 0) + 1
    return ids[name]
end
