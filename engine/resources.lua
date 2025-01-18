local resources = {}

function getResource(resType, resRef, createRes, isValidRes, releaseRes)
    resources[resType] = resources[resType] or Array()

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
            time = time()
        }
    else
        resInfo.time = time()
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

function gcResource(resType)
    if not resType then
        for resType,_ in pairs(resources) do
            gcResource(resType)
        end
        return
    end
    if not resources[resType] then return end

    log(resources[resType]:countKey())

    local now = time()
    for resRef,resInfo in pairs(resources[resType]) do
        if now - resInfo.time >= 5 then
            releaseResource(resType, resRef)
        end
    end
end
