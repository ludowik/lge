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
    setfenv(0, env)
    
    environnements[name] = env
    
    require(name)

    env.__name = name

    for k,v in pairs(env) do
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
    env.env = env

    if env.__sketch then
        env.sketch = env.__sketch()

    elseif env.draw then
        env.sketch = Sketch()
        env.sketch.__className = env.__name:gsub('sketch%.', '')

        env.parameter = env.sketch.parameter
        
        local function encapsulate(fname)
            if env[fname] then
                env.sketch[fname] = function (_, ...) return env[fname](...) end
            end
        end

        encapsulate('setup')
        encapsulate('update')
        encapsulate('draw')
        encapsulate('mousemoved')
        encapsulate('mousereleased')
        encapsulate('keypressed')

        env.sketch:setup()
    end
    
    env.sketch.env = env
end

function loadSketches()
    local environnementsList = Array()
    for k,env in pairs(environnements) do
        environnementsList:add(env)
    end
    environnementsList:sort(function (a, b) return a.__name < b.__name end)

    for k,env in ipairs(environnementsList) do
        loadSketch(env)
    end
end

function load()
    declareSketches()
    loadSketches()

    if love.filesystem.isFused() then
        processManager:setSketch('time_gym')
    else
        processManager:setSketch(getSettings('sketch'))
    end
end
