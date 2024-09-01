js = require 'js'

require 'lua.require'
require 'lua.class'
require 'lua.array'
require 'lua.string'

require 'maths.math'
require 'maths.vec2'
require 'maths.rect'
require 'maths.random'

require 'graphics.color'

require 'events.mouse_event'
require 'events.event_manager'

require 'scene.bind'
require 'scene.layout'
require 'scene.ui'
require 'scene.ui_button'
require 'scene.ui_slider'
require 'scene.node'
require 'scene.scene'
require 'scene.parameter'

Color.setup()
--EventManager.setup()

function loop()
    return js.global:loop()
end

function noLoop()
    return js.global:noLoop()
end

background = function (clr, ...)
    clr = Color.fromParam(clr, ...)
    return js.global:background(clr.r, clr.g, clr.b)
end

ADD = js.global.ADD
NORMAL = js.global.BLEND
blendMode = function (...)
    return js.global:blendMode(...)
end

CENTER = js.global.CENTER
CORNER = js.global.CORNER
rectMode = function (...)
    return js.global:rectMode(...)
end

fill = function (clr, ...)
    clr = Color.fromParam(clr, ...)
    return js.global:fill(clr.r, clr.g, clr.b)
end
noFill = function () js.global:noFill() end

stroke = function (clr, ...)
    clr = Color.fromParam(clr, ...)
    return js.global:stroke(clr.r, clr.g, clr.b)
end
noStroke = function () js.global:noStroke() end

strokeSize = function (...)
    return js.global:strokeWeight(...)
end

textColor = function (clr, ...)
    clr = Color.fromParam(clr, ...)
    return js.global:stroke(clr.r, clr.g, clr.b)
end

fontSize = function (size)
    return js.global:textSize(size)
end

textMode = function (...)
    return js.global:textAlign(...)
end

text = function (...)
    return js.global:text(...)
end

textSize = function (...)
    return
        js.global:textWidth(...),
        js.global:textAscent(...) + js.global:textDescent(...)
end

pushMatrix = function ()
    js.global:push()
end

translate = function (...)
    return js.global:translate(...)
end

rotate = function (...)
    return js.global:rotate(...)
end

point = function (...)
    return js.global:point(...)
end

line = function (...)
    return js.global:line(...)
end

rect = function (...)
    return js.global:rect(...)
end

CLOSE = js.global.CLOSE
beginShape = function (...)
    return js.global:beginShape(...)
end

vertex = function (...)
    return js.global:vertex(...)
end

endShape = function (...)
    js.global:endShape(...)
end

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

env = _G

function __setup()
    parameter = Parameter('right')
    return setup and setup()
end

function __draw()
    deltaTime = js.global.deltaTime / 1000
    elapsedTime = elapsedTime + deltaTime

    blendMode(NORMAL)

    js.global:angleMode(js.global.RADIANS)
    js.global:colorMode(js.global.RGB, 1)

    local result = draw and draw()

    --parameter:draw()

    return result
end

require 'sketch.geometric art.collatz'
