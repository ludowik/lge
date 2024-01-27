local resources = {}
function getResource(from, init, valid, release)
    local res = resources[from]
    if (not res) or (valid and not valid(from, res)) then
        if res and release then release(res) end
        resources[from] = init and init(from) or from
    end

    return resources[from]
end
