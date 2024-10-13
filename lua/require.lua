local __require = require
function require(module, env)
    if package.loaded[module] then
        return package.loaded[module]
    end

    local res
    if env then _G.env = env end

    if setfenv then
        setfenv(0, (_G.env or _G))
        res = __require(module)
    
    else        
        local file = package.searchpath(module, love.filesystem.getRequirePath()) 
        if not file then return end

        local chunk = loadfile(file, 'bt', (_G.env or _G))
        assert(chunk)
        res = chunk(module)
    end

    if env then _G.env = nil end
    return res
end

function try_require(module)
    local ok, result = pcall(
        function ()
            return require(module)
        end)
    return ok and result
end

function requireLib(path, modules)
    for i,module in ipairs(modules) do
        require(path..'.'..module)
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
    return source:match("([#_%w]+)%.lua$")
end
