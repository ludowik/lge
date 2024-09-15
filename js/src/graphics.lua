function background(clr, ...)
    clr = Color.fromParam(clr, ...) or colors.black
    return js.global:background(clr.r, clr.g, clr.b, clr.a)
end

ADD = js.global.ADD
NORMAL = js.global.BLEND
function blendMode(...)
    return js.global:blendMode(...)
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

function fontName(name)
    return js.global:textFont(name)
end

function fontSize(size)
    return js.global:textSize(size)
end

function textMode(mode, ...)
    if mode == CENTER then
        return js.global:textAlign(js.global.CENTER, js.global.CENTER)
    else
        return js.global:textAlign(js.global.LEFT, js.global.TOP)
    end
end

function text(txt, x, y)
    return js.global:text(txt, x, y)
end

function textPosition()
    return 0
end

function textSize(...)
    return
        js.global:textWidth(...),
        js.global:textAscent(...) + js.global:textDescent(...)
end

function point(...)
    return js.global:point(...)
end

function line(...)
    return js.global:line(...)
end

function rect(...)
    return js.global:rect(...)
end

function circle(x, y, r)
    return js.global:circle(x, y, r*2)
end

POINTS = js.global.POINTS
CLOSE = js.global.CLOSE
function beginShape(...)
    return js.global:beginShape(...)
end

function vertex(...)
    return js.global:vertex(...)
end

function endShape(...)
    js.global:endShape(...)
end

function spriteMode(...)
    js.global:imageMode(...)
end

function sprite(img)
    img.canvas.img:updatePixels()
    js.global:image(img.canvas.img)
end

Graphics = {
    loop,
    noLoop,
    redraw,
}