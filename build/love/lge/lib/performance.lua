function runningTime(f, n)
    local startTime = os.clock()

    n = n or (10 ^ 9)
    while n > 0 do
        n = n - 1
        f()
    end
    
    local endTime = os.clock()
    return endTime - startTime
end

function localGlobalOrBuiltin()
    local local_min = math.min
    log('local min', runningTime(function () local min = local_min end))
    log('global min', runningTime(function () local min = min end))
    log('math.min', runningTime(function () local min = math.min end))
end