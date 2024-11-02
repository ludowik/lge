function evaluateExpression(expression)
    return evaluateCode('return '..tostring(expression))
end

function evaluateCode(source)
    assert(source)

    local f, err = loadstring(source, nil, 't', (_G.env or _G))
    if not f then log(source, err) return err end
    
    local ok, result = pcall(f)
    if not ok then log(source, result) return result end
    
    return result
end
