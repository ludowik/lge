local resources = {}

function getResource(resType, resRef, createRes, isValidRes, releaseRes)
    resources[resType] = resources[resType] or {}

    local resInfo = resources[resType][resRef]
    if (not resInfo) or (isValidRes and not isValidRes(resRef, res)) then
        if resInfo and releaseRes then
            releaseRes(resInfo.res)
        end
        
        assert(createRes)
        resources[resType][resRef] = {
            res = {createRes(resRef)},
            create = createRes,
            isValid = isValidRes,
            release = releaseRes,
        }
    end

    return unpack(resources[resType][resRef].res)
end

function releaseResource(resName)
    if not resources[resName] then
        return
    end
    for i,v in ipairs(resources[resName]) do
        if v.releaseRes then
            v.releaseRes(r.res)
        end
    end
    resources[resName] = {}
end
