local __ipairs = ipairs

function ipairsStandard(t)
    local n = #t
    local i = 0
    return function ()
        i = i + 1
        if i > n then 
            return nil
        end
        return i,t[i]
    end
end

function ipairsReverse(t)
    local n = #t
    local i = n + 1
    return function ()
        i = i - 1
        if i < 1 then 
            return nil
        end
        return i,t[i]
    end
end

function ipairs(t, reverseIteration)
    if reverseIteration then
        return ipairsReverse(t)
    else
        return __ipairs(t)
        --return ipairsStandard(t)
    end
end

function range(n)
    local i = 0
    return function ()
        i = i + 1
        if i > n then 
            return nil
        end
        return i
    end
end

function index(n)
    local i = -1
    return function ()
        i = i + 1
        if i >= n then 
            return nil
        end
        return i
    end
end
