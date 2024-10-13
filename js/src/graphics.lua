TOP_LEFT = 'top_left'
BOTTOM_LEFT = 'bottom_left'

local __backgroundColor
function background(clr, ...)
    __backgroundColor = Color.fromParam(clr, ...) or colors.black
    return js.global:background(__backgroundColor:unpack())
end

function getBackgroundColor()
    return __backgroundColor
end

ADD = js.global.ADD
NORMAL = js.global.BLEND
MULTIPLY = js.global.MULTIPLY
function blendMode(mode)
    return js.global:blendMode(mode)
end

CENTER = js.global.CENTER
CORNER = js.global.CORNER
function rectMode(mode)
    if mode == CENTER then
        return js.global:rectMode(js.global.CENTER)
    else
        return js.global:rectMode(js.global.CORNER)
    end
end

function circleMode(...)
    return js.global:ellipseMode(...)
end

function ellipseMode(...)
    return js.global:ellipseMode(...)
end

function fill(clr, ...)
    clr = Color.fromParam(clr, ...)
    return js.global:fill(clr.r, clr.g, clr.b, clr.a)
end
function noFill() js.global:noFill() end

function stroke(clr, ...)
    clr = Color.fromParam(clr, ...)
    return js.global:stroke(clr.r, clr.g, clr.b, clr.a)
end
function noStroke() js.global:noStroke() end

function strokeSize(...)
    return js.global:strokeWeight(...)
end

function textColor(clr, ...)
    clr = Color.fromParam(clr, ...)
    return js.global:fill(clr.r, clr.g, clr.b, clr.a)
end

function tint(clr, ...)
    clr = Color.fromParam(clr, ...)
    return js.global:tint(clr.r, clr.g, clr.b, clr.a)
end
function noTint() js.global:noTint() end

local __fontName = DEFAULT_FONT_NAME
function fontName(name)
    if name then
        __fontName = __fontName or name
        js.global:textFont(name)
    end
    return __fontName
end

function fontSize(size)
    return js.global:textSize(size)
end

local __textMode
function textMode(mode, ...)
    __textMode = mode or __textMode
    return __textMode
end

local __y = 0

function text(str, x, y, limit, align)    
    y = y or 0

    local ws, hs = textSize(str)
    textPosition(y + hs)

    local mode = textMode()
    if mode == CENTER then
        x = x - ws / 2
        y = y - hs / 2
    end

    if not limit and align == 'right' then
        x = x - ws
    end

    js.global:push()
    js.global:noStroke()
    js.global:text(str, x, y)
    js.global:pop()
end

function textPosition(y)
    if y then __y = y end
    return __y
end

function textSize(...)
    return
        js.global:textWidth(...),
        js.global:textAscent(...) + js.global:textDescent(...)
end

function point(...)
    return js.global:point(...)
end

function points(data)
    beginShape(POINTS)
    for i=1,#data,2 do
        vertex(data[i], data[i+1])
    end
    endShape()
end

function line(...)
    return js.global:line(...)
end

function polyline(data)
    beginShape(LINES)
    for i=1,#data,2 do
        vertex(data[i], data[i+1])
    end
    endShape()
end

function rect(...)
    return js.global:rect(...)
end

function circle(x, y, r)
    return js.global:circle(x, y, r*2)
end

function ellipse(x, y, w, h)
    return js.global:ellipse(x, y, w, h)
end

function arc(x, y, rx, ry, a1, a2)
    return js.global:arc(x, y, 2*rx, 2*ry, a1, a2)
end

POINTS = js.global.POINTS
LINES = js.global.LINES

CLOSE = js.global.CLOSE

Shape = class()

function Shape:init(kind)
    self.kind = kind or js.global.TRIANGLES_FAN
    self.vertices = Array()
end

function Shape:add(...)
    self.vertices:add{...}
end

function Shape:draw()
    js.global:beginShape(self.kind)
    self.vertices:foreach(function (arg)
        js.global:vertex(table.unpack(arg))
    end)
    js.global:endShape(self.mode)
end

function beginShape(kind)
    __shape = Shape(kind)
end

function vertex(...)
    __shape:add(...)
end

function endShape(mode)
    __shape.mode = mode
    __shape:draw()
    return __shape
end

function scaleShape(scaleFactor)
    __shape.scaleFactor = scaleFactor
end

function spriteMode(...)
    js.global:imageMode(...)
end

function sprite(img, x, y, w, h)
    img:draw(
        x or 0,
        y or 0, w, h)
end

function zLevel()
end

function box()
end

function boxBorder()
end
