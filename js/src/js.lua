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
    declareSketches(
    {
        {name='fetch', filePath='sketch.fetch', category='{__category}'},
        {name='oric', filePath='sketch.oric', category='{__category}'},
        {name='sketches', filePath='sketch.sketches', category='{__category}'},
        {name='calc', filePath='sketch.apps.calc', category='apps'},
        {name='icon', filePath='sketch.apps.icon', category='apps'},
        {name='logo', filePath='sketch.apps.logo', category='apps'},
        {name='time_gym', filePath='sketch.apps.time_gym', category='apps'},
        {name='chaos', filePath='sketch.cellular_automaton.chaos', category='cellular_automaton'},
        {name='gol', filePath='sketch.cellular_automaton.gol', category='cellular_automaton'},
        {name='reaction_diffusion', filePath='sketch.cellular_automaton.reaction_diffusion', category='cellular_automaton'},
        {name='sandpile', filePath='sketch.cellular_automaton.sandpile', category='cellular_automaton'},
        {name='waves', filePath='sketch.cellular_automaton.waves', category='cellular_automaton'},
        {name='ascii', filePath='sketch.creative art.ascii', category='creative art'},
        {name='galactic', filePath='sketch.creative art.galactic', category='creative art'},
        {name='illusion', filePath='sketch.creative art.illusion', category='creative art'},
        {name='tron', filePath='sketch.creative art.tron', category='creative art'},
        {name='vasarely', filePath='sketch.creative art.vasarely', category='creative art'},
        {name='2d', filePath='sketch.demos.2d', category='demos'},
        {name='clock', filePath='sketch.demos.clock', category='demos'},
        {name='easings', filePath='sketch.demos.easings', category='demos'},
        {name='font_icons', filePath='sketch.demos.font_icons', category='demos'},
        {name='fonts', filePath='sketch.demos.fonts', category='demos'},
        {name='geojson', filePath='sketch.demos.geojson', category='demos'},
        {name='graph', filePath='sketch.demos.graph', category='demos'},
        {name='info', filePath='sketch.demos.info', category='demos'},
        {name='interpreter', filePath='sketch.demos.interpreter', category='demos'},
        {name='keyboard', filePath='sketch.demos.keyboard', category='demos'},
        {name='loto', filePath='sketch.demos.loto', category='demos'},
        {name='micro', filePath='sketch.demos.micro', category='demos'},
        {name='mouse', filePath='sketch.demos.mouse', category='demos'},
        {name='myline', filePath='sketch.demos.myline', category='demos'},
        {name='octree', filePath='sketch.demos.octree', category='demos'},
        {name='primitives', filePath='sketch.demos.primitives', category='demos'},
        {name='quadtree', filePath='sketch.demos.quadtree', category='demos'},
        {name='rainbow', filePath='sketch.demos.rainbow', category='demos'},
        {name='randoms', filePath='sketch.demos.randoms', category='demos'},
        {name='sorting', filePath='sketch.demos.sorting', category='demos'},
        {name='sound', filePath='sketch.demos.sound', category='demos'},
        {name='touches', filePath='sketch.demos.touches', category='demos'},
        {name='viewer', filePath='sketch.demos.viewer', category='demos'},
        {name='2048', filePath='sketch.games.2048', category='games'},
        {name='asteroids', filePath='sketch.games.asteroids', category='games'},
        {name='morpion', filePath='sketch.games.morpion', category='games'},
        {name='solitaire', filePath='sketch.games.solitaire', category='games'},
        {name='sudoku', filePath='sketch.games.sudoku', category='games'},
        {name='tetris', filePath='sketch.games.tetris', category='games'},
        {name='triomino', filePath='sketch.games.triomino', category='games'},
        {name='flow_fields', filePath='sketch.generative art.flow_fields', category='generative art'},
        {name='tree', filePath='sketch.generative art.tree', category='generative art'},
        {name='worley_noise', filePath='sketch.generative art.worley_noise', category='generative art'},
        {name='blend_dots', filePath='sketch.geometric art.blend_dots', category='geometric art'},
        {name='blend_rects', filePath='sketch.geometric art.blend_rects', category='geometric art'},
        {name='blinking_circles', filePath='sketch.geometric art.blinking_circles', category='geometric art'},
        {name='circle_noise', filePath='sketch.geometric art.circle_noise', category='geometric art'},
        {name='circle_waves', filePath='sketch.geometric art.circle_waves', category='geometric art'},
        {name='collatz', filePath='sketch.geometric art.collatz', category='geometric art'},
        {name='geometries', filePath='sketch.geometric art.geometries', category='geometric art'},
        {name='hexagone', filePath='sketch.geometric art.hexagone', category='geometric art'},
        {name='labyrinth', filePath='sketch.geometric art.labyrinth', category='geometric art'},
        {name='lines', filePath='sketch.geometric art.lines', category='geometric art'},
        {name='packing_circles', filePath='sketch.geometric art.packing_circles', category='geometric art'},
        {name='phyllotaxis', filePath='sketch.geometric art.phyllotaxis', category='geometric art'},
        {name='rects', filePath='sketch.geometric art.rects', category='geometric art'},
        {name='recursive_circles', filePath='sketch.geometric art.recursive_circles', category='geometric art'},
        {name='rose', filePath='sketch.geometric art.rose', category='geometric art'},
        {name='rotating_squares', filePath='sketch.geometric art.rotating_squares', category='geometric art'},
        {name='schotter', filePath='sketch.geometric art.schotter', category='geometric art'},
        {name='scribble', filePath='sketch.geometric art.scribble', category='geometric art'},
        {name='voronoy', filePath='sketch.geometric art.voronoy', category='geometric art'},
        {name='cardioid', filePath='sketch.math art.cardioid', category='math art'},
        {name='feigenbaum', filePath='sketch.math art.feigenbaum', category='math art'},
        {name='fourier', filePath='sketch.math art.fourier', category='math art'},
        {name='functions', filePath='sketch.math art.functions', category='math art'},
        {name='lorentz', filePath='sketch.math art.lorentz', category='math art'},
        {name='mandelbrot', filePath='sketch.math art.mandelbrot', category='math art'},
        {name='noise', filePath='sketch.math art.noise', category='math art'},
        {name='pi', filePath='sketch.math art.pi', category='math art'},
        {name='superformula', filePath='sketch.math art.superformula', category='math art'},
        {name='ulam_spiral', filePath='sketch.math art.ulam_spiral', category='math art'},
        {name='basics', filePath='sketch.physics.basics', category='physics'},
        {name='firework', filePath='sketch.simulation.firework', category='simulation'},
        {name='galaxy', filePath='sketch.simulation.galaxy', category='simulation'},
        {name='particles', filePath='sketch.simulation.particles', category='simulation'},
        {name='snowflakes', filePath='sketch.simulation.snowflakes', category='simulation'},
    }        
    )

    classSetup()

    processManager:setSketch(getSetting('sketch', 'sketches'))
end

INIT = true
