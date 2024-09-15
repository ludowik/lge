s = require 'js'

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

        setTitle = function (title)
            js.global.title = title
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

        getRequirePath = function ()
            return package.path
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

    keyboard ={
        isDown = function ()
            return false
        end,

        setKeyRepeat = function ()
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
    },

    audio = {
        newSource = function ()
            return {}
        end
    },
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
require 'scene.ui_check'
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
--    Graphics.loop()
    local sketch = processManager:current()
    sketch.loopMode = 'loop'
end

function noLoop()
--    Graphics.noLoop()
    local sketch = processManager:current()
    sketch.loopMode = 'none'
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

    MIN_SIZE = min(min(W, H), max(W, H)*ratio)
    MAX_SIZE = max(max(W, H), min(W, H)/ratio)

    SIZE = MIN_SIZE

    SCALE = 1
    
    LEFT = 5
    TOP = 50

    refreshRate = 60
    
    elapsedTime = 0

    mouse = Mouse()

    engine.load()
end

function __update()
    deltaTime = js.global.deltaTime / 1000
    elapsedTime = elapsedTime + deltaTime

    engine.update(deltaTime)

    -- local current = processManager:next()
    -- print(current.__className)
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

function  __keypressed()
    if js.global.__key == 'enter' then 
        local current = processManager:next()
        if current.loopMode == 'loop' then
            js.global:loop()
        else
            js.global:noLoop()
        end
    end
    eventManager:keypressed(js.global.__key)
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
    declareSketches({
        {name='fetch', filePath='sketch.fetch'},
        {name='oric', filePath='sketch.oric'},
        {name='sketches', filePath='sketch.sketches'},
        {name='calc', filePath='sketch.apps.calc'},
        {name='logo', filePath='sketch.apps.logo'},
        {name='time_gym', filePath='sketch.apps.time_gym'},
        {name='chaos', filePath='sketch.cellular_automaton.chaos'},
        {name='gol', filePath='sketch.cellular_automaton.gol'},
        {name='sandpile', filePath='sketch.cellular_automaton.sandpile'},
        {name='waves', filePath='sketch.cellular_automaton.waves'},
        {name='ascii', filePath='sketch.creative art.ascii'},
        {name='galactic', filePath='sketch.creative art.galactic'},
        {name='illusion', filePath='sketch.creative art.illusion'},
        {name='tron', filePath='sketch.creative art.tron'},
        {name='vasarely', filePath='sketch.creative art.vasarely'},
        {name='2d', filePath='sketch.demos.2d'},
        {name='clock', filePath='sketch.demos.clock'},
        {name='easings', filePath='sketch.demos.easings'},
        {name='font_icons', filePath='sketch.demos.font_icons'},
        {name='fonts', filePath='sketch.demos.fonts'},
        {name='geojson', filePath='sketch.demos.geojson'},
        {name='graph', filePath='sketch.demos.graph'},
        {name='info', filePath='sketch.demos.info'},
        {name='interpreter', filePath='sketch.demos.interpreter'},
        {name='keyboard', filePath='sketch.demos.keyboard'},
        {name='loto', filePath='sketch.demos.loto'},
        {name='micro', filePath='sketch.demos.micro'},
        {name='mouse', filePath='sketch.demos.mouse'},
        {name='myline', filePath='sketch.demos.myline'},
        {name='octree', filePath='sketch.demos.octree'},
        {name='primitives', filePath='sketch.demos.primitives'},
        {name='quadtree', filePath='sketch.demos.quadtree'},
        {name='rainbow', filePath='sketch.demos.rainbow'},
        {name='randoms', filePath='sketch.demos.randoms'},
        {name='sorting', filePath='sketch.demos.sorting'},
        {name='sound', filePath='sketch.demos.sound'},
        {name='touches', filePath='sketch.demos.touches'},
        {name='viewer', filePath='sketch.demos.viewer'},
        {name='2048', filePath='sketch.games.2048'},
        {name='asteroids', filePath='sketch.games.asteroids'},
        {name='morpion', filePath='sketch.games.morpion'},
        {name='solitaire', filePath='sketch.games.solitaire'},
        {name='sudoku', filePath='sketch.games.sudoku'},
        {name='tetris', filePath='sketch.games.tetris'},
        {name='triomino', filePath='sketch.games.triomino'},
        {name='flow_fields', filePath='sketch.generative art.flow_fields'},
        {name='tree', filePath='sketch.generative art.tree'},
        {name='blend_dots', filePath='sketch.geometric art.blend_dots'},
        {name='blend_rects', filePath='sketch.geometric art.blend_rects'},
        {name='blinking_circles', filePath='sketch.geometric art.blinking_circles'},
        {name='circle_noise', filePath='sketch.geometric art.circle_noise'},
        {name='circle_waves', filePath='sketch.geometric art.circle_waves'},
        {name='collatz', filePath='sketch.geometric art.collatz'},
        {name='geometries', filePath='sketch.geometric art.geometries'},
        {name='hexagone', filePath='sketch.geometric art.hexagone'},
        {name='labyrinth', filePath='sketch.geometric art.labyrinth'},
        {name='lines', filePath='sketch.geometric art.lines'},
        {name='packing_circles', filePath='sketch.geometric art.packing_circles'},
        {name='phyllotaxis', filePath='sketch.geometric art.phyllotaxis'},
        {name='rects', filePath='sketch.geometric art.rects'},
        {name='recursive_circles', filePath='sketch.geometric art.recursive_circles'},
        {name='rose', filePath='sketch.geometric art.rose'},
        {name='rotating_squares', filePath='sketch.geometric art.rotating_squares'},
        {name='schotter', filePath='sketch.geometric art.schotter'},
        {name='scribble', filePath='sketch.geometric art.scribble'},
        {name='voronoy', filePath='sketch.geometric art.voronoy'},
        {name='cardioid', filePath='sketch.math art.cardioid'},
        {name='feigenbaum', filePath='sketch.math art.feigenbaum'},
        {name='fourier', filePath='sketch.math art.fourier'},
        {name='functions', filePath='sketch.math art.functions'},
        {name='mandelbrot', filePath='sketch.math art.mandelbrot'},
        {name='noise', filePath='sketch.math art.noise'},
        {name='pi', filePath='sketch.math art.pi'},
        {name='ulam_spiral', filePath='sketch.math art.ulam_spiral'},
        {name='basics', filePath='sketch.physics.basics'},
        {name='pixels', filePath='sketch.shader art.pixels'},
        {name='firework', filePath='sketch.simulation.firework'},
        {name='galaxy', filePath='sketch.simulation.galaxy'},
        {name='particles', filePath='sketch.simulation.particles'},
        {name='snowflakes', filePath='sketch.simulation.snowflakes'},
    })

    classSetup()

    processManager:setSketch('2048')
end

INIT = true
