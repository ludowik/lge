require 'engine'

function newSketch()
    local info = debug.getinfo(2, "Sl")
    local className = info.source:gfind('.+/(.*)%.lua$')()
    _G[className] = class() : extends(Sketch)
    return _G[className]
end

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
        if isSketch(v) then
            _G[k] = v
            v.env = env
            env.__sketch = v
        end
    end
    return env
end

function declareSketches()
    local directoryItems = love.filesystem.getDirectoryItems('sketch/')
    for _,item in ipairs(directoryItems) do
        declareSketch('sketch.'..item:gsub('%.lua', ''))
    end
end

function loadSketches()
    for k,env in pairs(environnements) do
        env.__sketch()
    end
end

declareSketches()

function load()
    loadSketches()

    local sketch = declareSketch('sketch.blinking_circles')
    sketchCircles = Sketch()
    sketchCircles.draw = sketch.draw

    process:setSketch('Hexagone')
end
