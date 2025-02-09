js = require 'js'

package.path = './?.lua;./?/__init.lua;./lua/5.3/?.lua;./lua/5.3/?/init.lua'

loadstring = load
nilf = function () end

require 'engine_js.src.love2p5'

require 'lua.require'
require 'lua'
require 'lib'
require 'maths'

require 'graphics.color'
require 'graphics.anchor'
require 'graphics.font'
require 'graphics.font_icons'
require 'graphics.graphics'
require 'graphics.graphics2d'
require 'graphics.shape'
require 'graphics.light'
require 'graphics.material'
require 'graphics.image'
--require 'graphics.transform'

require 'events'
require 'scene'

require 'engine.version'
require 'engine.engine'
require 'engine.environment'
require 'engine.sketch'
require 'engine.sketch_loader'
require 'engine.process_manager'

require 'engine_js.src.graphics'
require 'engine_js.src.transform'
require 'engine_js.src.audio'

function noise(...)
    return js.global:noise(...)
end

function __initall()
    Engine.load()

    refreshRate = 30

    js.global:frameRate(refreshRate)
    js.global:textAlign(js.global.LEFT, js.global.TOP)

    Graphics.initMode()
end

function __update()    
    env.deltaTime = js.global.deltaTime / 1000
    env.elapsedTime = env.elapsedTime + env.deltaTime
    env.frameCount = env.frameCount + 1

    return Engine.update(env.deltaTime)
end

function __draw()
    blendMode(REPLACE)
    Graphics.resetStyle()
    return Engine.draw()
end

function __debugGraphics()
    js.global.pg:background(1, 1, 1, 1)
    js.global.pg:rect(5, 5, 155, 55)
    js.global.pg:text('hello', 5, 5, 155, 55)

    js.global:image(js.global.pg, 0, 0)
end

function __mousepressed()
    local x, y = scaleMouseProperties(js.global.__event.x, js.global.__event.y)
    eventManager:mousepressed(0, x, y)
end

function __mousemoved()
    local x, y = scaleMouseProperties(js.global.__event.x, js.global.__event.y)
    eventManager:mousemoved(0, x, y)
end

function __mousereleased()
    local x, y = scaleMouseProperties(js.global.__event.x, js.global.__event.y)
    eventManager:mousereleased(0, x, y)
end

local keys = {
    ['Enter'] = 'enter',
    ['ArrowDown'] = 'down',
    ['ArrowUp'] = 'up',
    ['ArrowLeft'] = 'left',
    ['ArrowRight'] = 'right',
    ['Control'] = 'lctrl',
    [' '] = 'space',
}

keysDown = {}

function  __isKeyDown(key)
    return keysDown[key]
end

function  __textinput()
    local key = js.global.__key
    eventManager:search(key)
end

function  __keypressed()
    local key = keys[js.global.__key] or js.global.__key
    keysDown[key] = true
    eventManager:keypressed(key)
end

function  __keyreleased()
    local key = keys[js.global.__key] or js.global.__key
    keysDown[key] = false
    eventManager:keyreleased(key)
end

function __orientationchange()
    Graphics.setDeviceOrientation(js.global.__orientation:startWith('landscape') and LANDSCAPE or PORTRAIT)

    Graphics.initMode()

    local sketch = processManager:current()

    sketch.fb = nil
    sketch:setMode(W, H, sketch.persistence)
    sketch:resize()

    redraw()
end

-- FrameBuffer = class()

-- function FrameBuffer:init(w, h)
--     self.width = w or W
--     self.height = h or H

--     self.texture = {
--         setFilter = function ()
--         end,

--         draw = function (_, x, y, w, h)
--             js.global:image(self.canvas.img, x, y, w or self.width, h or self.height)
--         end,

--         getWidth = function ()
--             return self.width
--         end,

--         getHeight = function ()
--             return self.height
--         end,
--     }

--     self.canvas = {
--         img = js.global:createImage(self.width, self.height),

--         getWidth = function ()
--             return self.width
--         end,

--         getHeight = function ()
--             return self.height
--         end,
--     }

--     self.pixelDensity = self.canvas.img:pixelDensity()
-- end

-- function FrameBuffer:getImageData()
--     if self.pixels then return self.canvas end
--     self.canvas.img:loadPixels()
--     self.pixels = self.canvas.img.pixels
--     return self.canvas
-- end

-- function FrameBuffer:release()    
-- end

-- function FrameBuffer:setPixel(x, y, r, g, b, a)
--     if type(r) == 'table' then r, g, b, a = r.r, r.g, r.b, r.a end
--     self:getImageData()
--     local d = self.pixelDensity
--     local offset = 4 * (x + y * self.width) * d
--     self.pixels[offset+0] = r * 255
--     self.pixels[offset+1] = g * 255
--     self.pixels[offset+2] = b * 255
--     self.pixels[offset+3] = (a or 1) * 255
-- end

-- function FrameBuffer:getPixel(x, y)
--     self:getImageData()
--     local d = self.pixelDensity
--     local offset = 4 * (x + y * self.width) * d
--     return
--         self.pixels[offset+0] / 255,
--         self.pixels[offset+1] / 255,
--         self.pixels[offset+2] / 255,
--         self.pixels[offset+3] / 255
-- end

-- function FrameBuffer:setContext()
-- end

-- function FrameBuffer:resetContext()
-- end

-- function FrameBuffer:background()
--     self.canvas.img:reset(0, 0, 0, 1)
-- end

-- function FrameBuffer:update()
--     if self.pixels then
--         self.canvas.img:updatePixels()
--     end
-- end

-- function FrameBuffer:draw(x, y, w, h)
--     self:update()
--     js.global:image(self.canvas.img, x, y, w or self.width, h or self.height)
-- end

-- function FrameBuffer:render(f)
--     self:setContext()
--     f()
--     self:resetContext()
-- end

-- function FrameBuffer:mapPixel(f)
--     self:getImageData()

--     local d = 4 * self.pixelDensity
--     local offset = 0
--     local r, g, b, a
--     local pixels = self.pixels

--     for y=0,self.height-1 do
--         for x=0,self.width-1 do
--             r, g, b, a = f(x, y)

--             pixels[offset+0] = r * 255
--             pixels[offset+1] = g * 255
--             pixels[offset+2] = b * 255
--             pixels[offset+3] = (a or 1) * 255

--             offset = offset + d
--         end
--     end
-- end


-- Image = class() : extends(FrameBuffer)

-- function Image:init(name)
--     FrameBuffer.init(self)

--     self.canvas =  {
--         img = js.global:loadImage(name),

--         getWidth = function ()
--             return self.width
--         end,

--         getHeight = function ()
--             return self.height
--         end,
--     }

--     self.width = self.canvas.img.width
--     self.height = self.canvas.img.height
-- end

-- function Image:update()
-- end

-- function Image:draw(x, y, w, h)
--     js.global:image(self.canvas.img, x, y, w or self.width, h or self.height)
-- end

Mesh = class()

function Mesh:draw()
end


classSetup()

unpack = table.unpack

function collectgarbage()
    return 1
end

function setContext() 
end

function resetContext()
end

function render2context()
end

function supportedOrientations()
end

function request()
end

math.newRandomGenerator = class()

function math.newRandomGenerator:setSeed(seed)
    self.seed = seed
end

function math.newRandomGenerator:random(...)
    return random(...)
end

love.math.setRandomSeed = math.randomseed
love.math.setSeed = math.randomseed
love.math.randomNormal = function ()
    return js.global:randomGaussian()
end
