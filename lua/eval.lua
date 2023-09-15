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
        local status, res = pcall(f)
        if status then
            return res
        end
    else
        print(err)
    end
end
