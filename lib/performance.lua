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

Performance = class()

function Performance.timeit(name, f)
    local t = runningTime(f, 100)
    log(name, t)
    return t
end

function Performance.compare(name1, f1, name2, f2)
    local t1 = Performance.timeit(name1, f1)
    local t2 = Performance.timeit(name2, f2)
    log(name1, name2, tofraction(t2/t1))
end
