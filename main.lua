print(love.filesystem.getAppdataDirectory())
print(love.filesystem.getSaveDirectory())

local major, minor, revision, codename = love.getVersion()
local str = string.format("Version %d.%d.%d - %s", major, minor, revision, codename)
print(str)

--love.filesystem.mount('lca.love', '')

__require = require
require = function (fileName)
    fileName = fileName:gsub('%.', '%/')
    print('load file '..fileName)
    local chunk, err = love.filesystem.load(fileName..'.lua')
    if chunk then
        return chunk()
    else
        return __require(fileName)
    end
end

require 'engine.lge'

require 'sketch.sketch'

function load()
    MySketch()
    MySketch()
    MySketch()
    MySketch()
    MySketch()
end

-- function love.draw()
-- 	local safeX, safeY, safeW, safeH = love.window.getSafeArea()

-- 	love.graphics.translate(safeX, safeY)
-- 	love.graphics.rectangle("line", 0, 0, safeW, safeH)
-- 	love.graphics.line(0, 0, safeW, safeH)
-- 	love.graphics.line(0, safeH, safeW, 0)
-- 	love.graphics.circle('line', safeW/2, safeH/2, safeW/2)
-- 	love.graphics.circle('line', safeW/2, safeH/2, safeH/2)
-- end

