function background(clr, ...)
    clr = Color.fromParam(clr, ...)
    return js.global:background(clr.r, clr.g, clr.b, clr.a)
end

ADD = js.global.ADD
NORMAL = js.global.BLEND
function blendMode(...)
    return js.global:blendMode(...)
end

CENTER = js.global.CENTER
CORNER = js.global.CORNER
function rectMode(...)
    return js.global:rectMode(...)
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
    return js.global:stroke(clr.r, clr.g, clr.b, clr.a)
end

function fontSize(size)
    return js.global:textSize(size)
end

function textMode(...)
    return js.global:textAlign(...)
end

function text(...)
    return js.global:text(...)
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

function circle(...)
    return js.global:circle(...)
end

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