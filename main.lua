-- __require = require
-- require = function (fileName)
--     fileName = fileName:gsub('%.', '%/')
--     print('load file '..fileName)
--     local chunk, err = love.filesystem.load(fileName..'.lua')
--     if chunk then
--         return chunk()
--     else
--         return __require(fileName)
--     end
-- end

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

function loadSketch(name)
    local env = setmetatable({}, {__index = _G})
    setfenv(0, env)
    require(name)
    for k,v in pairs(env) do
        if isSketch(v) then
            _G[k] = v
            v.env = env
        end
    end
    return env
end

loadSketch 'sketch.test'
loadSketch 'sketch.2048'
loadSketch 'sketch.screen'
loadSketch 'sketch.plot'
loadSketch 'sketch.upgrade'
loadSketch 'sketch.anchor_grid'

setupClass()

unitTesting()

function load()
    The2048()
    TV()
    Plot()
    UpgradeApp()
    anchor_grid()
    MySketch()
end
