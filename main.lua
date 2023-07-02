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
loadSketch('sketch.test')
loadSketch 'sketch.2048'
loadSketch 'sketch.screen'
loadSketch 'sketch.plot'
loadSketch 'sketch.upgrade'
loadSketch 'sketch.anchor_grid'

setupClass()

unitTesting()

Anchor = class()

function Anchor:init(ni, nj)
    self.ni = ni
    self.nj = nj or math.ceil(H/(W/ni))
end

function Anchor:pos(i, j)
    return vec2((i-1)*(W/self.ni), (j-1)*(H/self.nj))
end

function Anchor:size(i, j)
    return vec2(i*(W/self.ni), j*(H/self.nj))
end

function drawAnchorGrid(anchor)
    anchor = anchor or Anchor(9, 9)

    stroke(colors.white)
    strokeWidth(1)

    for i in range(anchor.ni) do
        for j in range(anchor.nj) do
            line(
                anchor:pos(i, j).x,
                anchor:pos(1, j).y,
                anchor:pos(i, j).x + anchor:size(1, 1).x,
                anchor:pos(1, j).y)

            line(
                anchor:pos(i, j).x + anchor:size(1, 1).x,
                anchor:pos(1, j).y,
                anchor:pos(i, j).x + anchor:size(1, 1).x,
                anchor:pos(1, j).y + anchor:size(1, 1).y)
        end
    end
end

function load()
    MySketch()
    The2048()
    TV()
    Plot()
    UpgradeApp()
    anchor_grid()
end
