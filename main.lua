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

require 'engine.lge'

require 'sketch.sketch'
require 'sketch.2048'

function load()
    MySketch()
    MySketch()
    MySketch()
    MySketch()
    MySketch()
    The2048()
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

