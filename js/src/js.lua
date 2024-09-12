package.path = './?.lua;./?/init.lua;./lua/5.3/?.lua;./lua/5.3/?/init.lua'

js = require 'js'

require 'lua.require'

require 'lua.class'
require 'lua.table'
require 'lua.array'
require 'lua.string'
require 'lua.index'
require 'lua.state'
require 'lua.attrib'
require 'lua.iter'
require 'lua.grid'
require 'lua.function'

require 'maths.math'
require 'maths.vec2'
require 'maths.vec3'
require 'maths.rect'
require 'maths.random'

require 'graphics.color'
require 'graphics.anchor'

require 'events.mouse_event'
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

    MIN_SIZE = min(W, H)
    MAX_SIZE = max(W, H)

    SIZE = MIN_SIZE

    SCALE = 1

    LEFT = 5
    TOP = 5

    elapsedTime = 0

    parameter = Parameter('right')
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

    if env.sketch then
        if env.sketch.updateSketch then
            env.sketch:updateSketch(deltaTime)
        end
        return
    end
    return update and update(deltaTime)
end

function __draw()
    blendMode(NORMAL)

    js.global:angleMode(js.global.RADIANS)
    js.global:colorMode(js.global.RGB, 1)

    local result
    if env.sketch then
        if env.sketch.drawSketch then
            env.sketch:drawSketch()
        end
    else
        result = draw and draw()
    end

    --parameter:draw()

    return result
end

local function touchFromEvent(event)
    return {
            position = {
                x = event.clientX,
                y = event.clientY
            }
        }
end

function __mousepressed()
    if mousepressed then
        mousepressed(touchFromEvent(js.global.__event))
    end
end

function __mousereleased()
    if mousereleased then
        mousereleased(touchFromEvent(js.global.__event))
    end
end

function  __keypressed()
    if sketch.keypressed then
        sketch:keypressed(js.global.__key)
    end
end

function saveData()
    
end

love = {
    window = {
        getMode = function ()
        end
    },

    graphics = {
        getCanvas = function ()
            return {
                getWidth = function ()
                    return W
                end,
                getHeight = function ()
                    return H
                end
            }
        end,

        setCanvas = function ()    
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
        end
    },
}

FrameBuffer = class()

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
    env = declareSketch('lines', 'sketch.games.2048')
    loadSketch(env)
    __sketch = The2048
    classSetup(env)
end

