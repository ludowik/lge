global = {}

function evalExpression(expression)
    local src = (
        "global.__temp__ = "..tostring(expression)..NL..
        "return global.__temp__")
    return evalCode(src)
end

function evalCode(source)
    assert(source)

    local f, err = loadstring(source)
    if f then
        local ok, result = pcall(f)
        if ok then
            return result
        end
    else
        print(err)
    end
end
