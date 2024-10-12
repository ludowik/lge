
function pushMatrix()
    js.global:push()
end

function popMatrix()
    js.global:pop()
end

function resetMatrix()
    js.global:resetMatrix()
end

function resetMatrixContext()
end

function resetStyle()
    blendMode(NORMAL)

    stroke(colors.white)
    strokeSize(1)

    noFill()

    tint(colors.white)

    rectMode(CORNER)

    circleMode(CENTER)
    ellipseMode(CENTER)

    textMode(CORNER)
    textColor(colors.white)
    textPosition(0)

    fontName('comic')
    fontSize(22)

    -- noLight()
    -- noMaterial()

    -- styles.origin = origin or TOP_LEFT
end

function translate(...)
    return js.global:translate(xyz(...))
end

function scale(...)
    return js.global:scale(xyz(...))
end

function rotate(...)
    return js.global:rotate(...)
end

function perspective()
end

function camera()
end
