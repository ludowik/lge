function try_require(module)
    local ok, result = pcall(
        function ()
            return require(module)
        end)
    return ok and result
end

function requireLib(modules)
    for i,module in ipairs(modules) do
        require(scriptPath(level):gsub('/', '.')..'.'..module)
    end
end

function scriptPath(level)
    level = level or 3
    local source = debug.getinfo(level, "S").source
    return source:match("[@]*(.+)[/\\][#_%w]+%.lua$")
end

function scriptLink(level)
    level = level or 3
    local info = debug.getinfo(level, "Sl")
    local source = info.source:gsub('@', './')..':'..info.currentline
    return source
end

function scriptName(level)
    level = level or 3
    local source = debug.getinfo(level, "S").source
    return source:match("(%w+)%.lua$")
end
