--love.filesystem.setRequirePath('./?.lua;./?/init.lua;./?/!.lua')

require 'engine'

function isSketch(klass)
    if klass == Sketch then return true end
    if klass == nil or type(klass) ~= 'table' or klass.__inheritsFrom == nil then return false end
    return isSketch(klass.__inheritsFrom[1])
end

local environnements = {}
function declareSketch(name)
    if environnements[name] then return environnements[name] end
    local env = setmetatable({}, {__index = _G})
    environnements[name] = env
    setfenv(0, env)
    require(name)
    for k,v in pairs(env) do
        env.__name = name
            
        if isSketch(v) then
            _G[k] = v
            v.env = env
            env.__sketch = v
            break
        end
    end
    return env
end

function declareSketches()
    local directoryItems = love.filesystem.getDirectoryItems('sketch/')
    for _,item in ipairs(directoryItems) do
        local sketchName = item:gsub('%.lua', '')
        declareSketch('sketch.'..sketchName)
    end
end

function loadSketch(env)
    if env.__sketch then
        env.sketch = env.__sketch()

    elseif env.draw then
        env.sketch = Sketch()
        env.sketch.__className = env.__name:gsub('sketch%.', '')

        if env.setup then
            env.sketch.setup = function (...) return env.setup(...) end
            env.sketch.setup()
        end

        if env.update then
            env.sketch.update = function (_, ...) return env.update(...) end
        end

        if env.draw then
            env.sketch.draw = function (_, ...) return env.draw(...) end
        end
    end
end

function loadSketches()
    for k,env in pairs(environnements) do
        loadSketch(env)
    end
end

function load()
    declareSketches()
    loadSketches()

    process:setSketch(settings.sketch)
end
