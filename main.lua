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

require 'sketch.test'
require 'sketch.2048'
require 'sketch.screen'
require 'sketch.plot'

function load()
    MySketch()
    MySketch()
    MySketch()
    MySketch()
    The2048()
    TV()
    Plot()
end
