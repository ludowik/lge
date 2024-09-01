js = require 'js'

require 'lua.require'
require 'lua.class'
require 'lua.array'
require 'graphics.color'

Color.setup()

function loop()
    js.global:loop()
end

function noLoop()
    js.global:noLoop()
end

background = function (clr, ...)
    clr = Color.fromParam(clr, ...)
    js.global:background(clr.r, clr.g, clr.b)
end

ADD = js.global.ADD
NORMAL = js.global.BLEND
blendMode = function (...)
    js.global:blendMode(...)
end

CENTER = js.global.CENTER
CORNER = js.global.CORNER
rectMode = function (...)
    js.global:rectMode(...)
end

fill = function (clr, ...)
    clr = Color.fromParam(clr, ...)
    js.global:fill(clr.r, clr.g, clr.b)
end
noFill = function () js.global:noFill() end

stroke = function (clr, ...)
    clr = Color.fromParam(clr, ...)
    js.global:stroke(clr.r, clr.g, clr.b)
end
noStroke = function () js.global:noStroke() end

translate = function (...)
    js.global:translate(...)
end

rotate = function (...)
    js.global:rotate(...)
end

rect = function (...)
    js.global:rect(...)
end

window = js.global

W = js.global.innerWidth / window.devicePixelRatio
H = js.global.innerHeight / window.devicePixelRatio

MIN_SIZE = math.min(W, H)
MAX_SIZE = math.max(W, H)

elapsedTime = 0

function __setup()
    return setup and setup()
end

function __draw()
    deltaTime = js.global.deltaTime / 1000
    elapsedTime = elapsedTime + deltaTime

    blendMode(NORMAL)

    js.global:angleMode(js.global.RADIANS)
    js.global:colorMode(js.global.RGB, 1)

    return draw and draw()
end

require 'sketch.geometric art.blend_rects'
