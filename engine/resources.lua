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

function releaseResource(resType, resRef)
    if not resources[resType] then return end
    
    if resRef then
        local resInfo = resources[resType][resRef]
        if not resInfo then return end

        if resInfo.releaseRes then
            resInfo.releaseRes(resInfo.res)
        end
        resources[resType][resRef] = nil

    else        
        for i,resInfo in ipairs(resources[resType]) do
            if resInfo.releaseRes then
                resInfo.releaseRes(resInfo.res)
            end
        end
        resources[resType] = {}
    end
end
