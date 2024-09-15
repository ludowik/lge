js = require 'js'

package.path = './?.lua;./?/__init.lua;./lua/5.3/?.lua;./lua/5.3/?/init.lua'

loadstring = load

arg = {
}

io = {
    stdout = {
        setvbuf = function ()
        end
    }
}

love = {
    getVersion = function ()
        return 0, 9, 0, 'p5'
    end,

    system = {
        getOS = function ()
            return 'web'
        end,
    },

    window = {
        getMode = function ()
        end,
    },
    
    graphics = {
        getCanvas = function ()
            return {
                getWidth = function ()
                    return W
                end,
                getHeight = function ()
                    return H
                end,
            }
        end,

        setCanvas = function ()    
        end,

        reset = function ()
        end,

        clear = function ()
        end,

        origin = function ()
        end,

        translate = function ()
        end,

        scale = function ()
        end,

        draw = function ()
        end,

        present = function ()
        end,

        setWireframe = function ()
        end,

        setShader = function ()
        end,
        
        setDepthMode = function ()
        end,

        setColor = function ()
        end,

        setBlendMode = function ()            
        end,
    },

    keyboard = {
        setKeyRepeat = function ()
        end,
    },
    
    filesystem = {
        getInfo = function ()
            return {
                modtime = 0
            }
        end,

        getDirectoryItems = function ()
            return {}    
        end,

        getSaveDirectory = function ()
            return ''
        end,

        createDirectory = function ()
        end,

        write = function (fileName, data)
            js.global.localStorage:setItem(fileName, data)
        end,

        read = function (filename)
            return js.global.localStorage:getItem(filename)
        end,

        load = function (filename)
            local data = love.filesystem.read(filename)
            return loadstring(data)
        end
    },

    mouse ={
        isDown = function ()
            return true
        end,
    },

    timer = {
        getTime = function ()
            return js.global.Date:now()
        end,

        getFPS = function ()
            return js.global:getTargetFrameRate()
        end,
    },
    
    touch = {
        getTouches = function ()
            return js.global.touches
        end
    }
}

require 'lua.require'

require 'lua'

require 'maths.math'
require 'maths.vec2'
require 'maths.vec3'
require 'maths.rect'
require 'maths.types'
require 'maths.random'

require 'graphics.color'
require 'graphics.anchor'

require 'events.mouse_event'
require 'events.mouse'
require 'events.event_manager'

require 'scene.bind'
require 'scene.ui'
require 'scene.ui_button'
require 'scene.ui_slider'
require 'scene.ui_expression'
require 'scene.layout'
require 'scene.node'
require 'scene.scene'
require 'scene.parameter'
require 'scene.animate'

require 'engine.engine'
require 'engine.environment'
require 'engine.sketch'
require 'engine.sketch_loader'
require 'engine.process_manager'

require 'js.src.graphics'
require 'js.src.transform'

function loop()
    return js.global:loop()
end

function noLoop()
    return js.global:noLoop()
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

    MIN_SIZE = min(min(W, H), max(W, H)*ratio)
    MAX_SIZE = max(max(W, H), min(W, H)/ratio)

    SIZE = MIN_SIZE

    SCALE = 1
    
    LEFT = 5
    TOP = 50

    refreshRate = 60
    
    elapsedTime = 0

    engine.load()
end

function __setup()
    if __sketch then
        if __sketch.setup then 
            __sketch.setup()
        end
        
        sketch = __sketch()
        return
    end

    return setup and setup()
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
    mouse = Mouse()
    eventManager:mousepressed(0, js.global.__event.x, js.global.__event.y)
end

function __mousemoved()
    eventManager:mousemoved(0, js.global.__event.x, js.global.__event.y)
end

function __mousereleased()
    eventManager:mousereleased(0, js.global.__event.x, js.global.__event.y)
end

function  __keypressed()
    if sketch.keypressed then
        sketch:keypressed(js.global.__key)
    end
end

FrameBuffer = class()
function FrameBuffer:init()
    self.canvas = love.graphics.getCanvas()
end

function FrameBuffer:init(w, h)
    self.width = w or W
    self.height = h or H

    self.canvas = {
        img = js.global:createImage(self.width, self.height),
        getWidth = function ()
            return self.width
        end,
        getHeight = function ()
            return self.height
        end
    }
end

function FrameBuffer:setPixel(x, y, clr, ...)
    self.canvas.image:set(x, y, clr, ...)
end

classSetup(_G)

setfenv = function ()
end

unpack = table.unpack

function loadASketch()
    env = declareSketch('lines', 'sketch.games.triomino')
    loadSketch(env)
    __sketch = Triomino
    classSetup(env)
end

INIT = true

