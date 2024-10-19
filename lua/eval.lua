function evaluateExpression(expression)
    return evaluateCode("return "..tostring(expression))
end

function evaluateCode(source)
    assert(source)

    local f, err = loadstring(source, nil, 't', (_G.env or _G))
    if f then
        local ok, result = pcall(f)
        if ok then
            return result
        end
    else
        log(err)
    end
end
