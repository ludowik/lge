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

function __setup()
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

    if sketch then
        if sketch.updateSketch then
            sketch:updateSketch(deltaTime)
        end
        return
    end
    return update and update(deltaTime)
end

function __draw()
    blendMode(NORMAL)

    js.global:ellipseMode(js.global.RADIUS)
    js.global:angleMode(js.global.RADIANS)
    js.global:colorMode(js.global.RGB, 1)

    local result
    if sketch then
        if sketch.drawSketch then
            sketch:drawSketch()
        end
    else
        result = draw and draw()
    end

    --parameter:draw()

    return result
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
                end,
            }
        end,

        setCanvas = function ()    
        end,

        clear = function ()
        end,

        origin = function ()
        end,

        scale = function ()
        end,

        translate = function ()
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
function FrameBuffer:init()
    self.canvas = love.graphics.getCanvas()
end

Color.setup()

classSetup(_G)

setfenv = function ()
end

env = declareSketch('lines', 'sketch.geometric art.lines')
loadSketch(env)
classSetup(env)

sketch = env.sketch

