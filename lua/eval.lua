global = {}

function evaluateExpression(expression)
    local src = (
        "global.__temp__ = "..tostring(expression)..NL..
        "return global.__temp__")
    return evaluateCode(src)
end

function evaluateCode(source)
    assert(source)

    local f, err = loadstring(source)
    if f then
        local ok, result = pcall(f)
        if ok then
            return result
        end
    else
        log(err)
    end
end
