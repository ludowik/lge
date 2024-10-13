js = require 'js'

package.path = './?.lua;./?/__init.lua;./lua/5.3/?.lua;./lua/5.3/?/init.lua'

loadstring = load

require 'js.src.love2p5'

require 'lua.require'
require 'lua'
require 'lib'
require 'maths'

require 'graphics.color'
require 'graphics.anchor'
require 'graphics.font'
require 'graphics.font_icons'
require 'graphics.graphics'
Graphics.setup = nil

require 'events'
require 'scene'

require 'engine.version'
require 'engine.engine'
require 'engine.environment'
require 'engine.sketch'
require 'engine.sketch_loader'
require 'engine.process_manager'

require 'js.src.graphics'
require 'js.src.transform'
require 'js.src.audio'

function loop()
    Graphics.loop()
end

function noLoop()
    Graphics.noLoop()
end

function captureLogo()
end

function noise(...)
    return js.global:noise(...)
end

function __init()
    js.global:frameRate(30)
    js.global:textAlign(js.global.LEFT, js.global.TOP)

    W = js.global.innerWidth
    H = js.global.innerHeight

    CX = W/2
    CY = H/2

    local ratio = 9/16

    if W == max(W, H) then
        W = H * ratio
    else
        H = W / ratio
    end

    W = math.floor(W)
    H = math.floor(H)

    MIN_SIZE = min(W, H)
    MAX_SIZE = max(W, H)

    SIZE = MIN_SIZE

    SCALE = 1
    
    LEFT = 5
    TOP = 5

    refreshRate = 60
    
    elapsedTime = 0

    mouse = Mouse()

    return Engine.load()
end

function __update()
    env.deltaTime = js.global.deltaTime / 1000
    env.elapsedTime = env.elapsedTime + env.deltaTime
    env.frameCount = env.frameCount + 1

    return Engine.update(env.deltaTime)
end

function __draw()
    blendMode(NORMAL)

    js.global:angleMode(js.global.RADIANS)
    js.global:colorMode(js.global.RGB, 1)

    return Engine.draw()
end

function __mousepressed()
    eventManager:mousepressed(0, js.global.__event.x, js.global.__event.y)
end

function __mousemoved()
    eventManager:mousemoved(0, js.global.__event.x, js.global.__event.y)
end

function __mousereleased()
    eventManager:mousereleased(0, js.global.__event.x, js.global.__event.y)
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

FrameBuffer = class()

function FrameBuffer:init(w, h)
    self.width = w or W
    self.height = h or H

    self.texture = {
        setFilter = function ()
        end,
    }

    self.canvas = {
        img = js.global:createImage(self.width, self.height),

        getWidth = function ()
            return self.width
        end,

        getHeight = function ()
            return self.height
        end,
    }

    self.pixelDensity = self.canvas.img:pixelDensity()
end

function FrameBuffer:getImageData()
    if self.pixels then return self.canvas end
    self.canvas.img:loadPixels()
    self.pixels = self.canvas.img.pixels
    return self.canvas
end

function FrameBuffer:release()    
end

function FrameBuffer:setPixel(x, y, r, g, b, a)
    if type(r) == 'table' then r, g, b, a = r.r, r.g, r.b, r.a end
    self:getImageData()
    local d = self.pixelDensity
    local offset = 4 * (x + y * self.width) * d
    self.pixels[offset+0] = r * 255
    self.pixels[offset+1] = g * 255
    self.pixels[offset+2] = b * 255
    self.pixels[offset+3] = (a or 1) * 255
end

function FrameBuffer:getPixel(x, y)
    self:getImageData()
    local d = self.pixelDensity
    local offset = 4 * (x + y * self.width) * d
    return
        self.pixels[offset+0] / 255,
        self.pixels[offset+1] / 255,
        self.pixels[offset+2] / 255,
        self.pixels[offset+3] / 255
end

function FrameBuffer:setContext()
end

function FrameBuffer:background()
    self.canvas.img:reset(0, 0, 0, 1)
end

function FrameBuffer:update()
    if self.pixels then
        self.canvas.img:updatePixels()
    end
end

function FrameBuffer:draw(x, y, w, h)
    self:update()
    js.global:image(self.canvas.img, x, y, w or self.width, h or self.height)
end

function FrameBuffer:mapPixel(f)
    self:getImageData()

    local d = 4 * self.pixelDensity
    local offset = 0
    local r, g, b, a
    local pixels = self.pixels

    for y=0,self.height-1 do
        for x=0,self.width-1 do
            r, g, b, a = f(x, y)

            pixels[offset+0] = r * 255
            pixels[offset+1] = g * 255
            pixels[offset+2] = b * 255
            pixels[offset+3] = (a or 1) * 255

            offset = offset + d
        end
    end
end


Image = class()

function Image:init(name)
    self.canvas = js.global:loadImage(name)
    self.texture = {
        setFilter = function ()
        end,
    }

    self.width = self.canvas.width
    self.height = self.canvas.height
end

function Image:update()
end

function Image:draw(x, y, w, h)
    js.global:image(self.canvas, x, y, w, h)
end

function Image:getImageData()
    return self.canvas
end


Mesh = class()

function Mesh:draw()
end


classSetup(_G)

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

function __loadASketch()
    local sketchesList = require 'engine.sketch_list'    
    declareSketches(sketchesList)

    classSetup()

    processManager:setSketch(getSetting('sketch', 'sketches'))
    --processManager:setSketch('particles')    
end

INIT = true
