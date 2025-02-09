function evaluateExpression(expression)
    return evaluateCode('return '..tostring(expression))
end

function evaluateCode(source)
    assert(source)

    local f, err = loadstring(source, nil, 't', (_G.env or _G))
    if not f then info(source, err) return err end
    
    local status, result = xpcall(f, function (msg)
        info(source, msg)
    end)
    
    return result
end
