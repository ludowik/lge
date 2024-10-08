js = require 'js'

package.path = './?.lua;./?/__init.lua;./lua/5.3/?.lua;./lua/5.3/?/init.lua'

loadstring = load

require 'js.src.love2p5'

require 'lua.require'
require 'lua'
require 'maths'

require 'graphics.color'
require 'graphics.anchor'
require 'graphics.font'
require 'graphics.graphics'
Graphics.setup = nil

require 'events'
require 'scene'

require 'engine.engine'
require 'engine.environment'
require 'engine.sketch'
require 'engine.sketch_loader'
require 'engine.process_manager'

require 'js.src.graphics'
require 'js.src.transform'

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
    window = js.global

    W = js.global.innerWidth
    H = js.global.innerHeight

    CX = W/2
    CY = H/2

    local ratio = 9/16

    if W == max(W, H) then
        H = W * ratio
    else
        W = H * ratio
    end

    MIN_SIZE = min(W, H)
    MAX_SIZE = max(W, H)

    SIZE = MIN_SIZE

    SCALE = 1
    
    LEFT = (js.global.innerWidth - W)/2
    TOP = (js.global.innerHeight - H)/2

    refreshRate = 60
    
    elapsedTime = 0

    mouse = Mouse()

    engine.load()
end

function __update()
    deltaTime = js.global.deltaTime / 1000
    elapsedTime = elapsedTime + deltaTime

    engine.update(deltaTime)
end

function __draw()
    blendMode(NORMAL)

    js.global:angleMode(js.global.RADIANS)
    js.global:colorMode(js.global.RGB, 1)

    engine.draw()
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
    [' '] = 'space',
}

keysDown = {}

function  __isKeyDown(key)
    return keysDown[key]
end

function  __keypressed()
    local key = keys[js.global.__key] or key
    keysDown[key] = true
    eventManager:keypressed(key)
end

function  __keyreleased()
    local key = keys[js.global.__key] or key
    keysDown[key] = false
    eventManager:keyreleased(key)
end

FrameBuffer = class()
function FrameBuffer:init()
    self.canvas = love.graphics.getCanvas()
end

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
end

function FrameBuffer:getImageData()    
end

function FrameBuffer:release()    
end

function FrameBuffer:setPixel(x, y, clr, ...)
    self.canvas.img:set(x, y, clr, ...)
end

function FrameBuffer:getPixel(x, y)
    local clr = self.canvas.img:get(x, y)
    return clr[0], clr[1], clr[2], clr[3]
end

function FrameBuffer:setContext()
end

function FrameBuffer:background()
    js.global:background(0, 0, 0, 1)
end

function FrameBuffer:draw()
--    self.canvas.img:updatePixels()
    js.global:image(self.canvas.img)
end


Image = class()

function Image:init(name)
    self.canvas = js.global:loadImage(name)

    self.width = self.canvas.width
    self.height = self.canvas.height
end

function Image:draw(x, y, w, h)
    js.global:image(self.canvas, x, y, w, h)
end

function FrameBuffer:mapPixel()
end


classSetup(_G)

unpack = table.unpack

function collectgarbage()
end

function setContext() 
end

function resetContext() 
end

function render2context()
end

function supportedOrientations()
end


function __loadASketch()
    local sketchesList = require 'sketches_list'
    declareSketches(sketchesList)

    classSetup()

    processManager:setSketch(getSetting('sketch', 'sketches'))
end

INIT = true
