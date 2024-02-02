local previousCanvas
function setContext(fb, depth)
    assert(fb and fb.canvas)

    previousCanvas = love.graphics.getCanvas()
    love.graphics.setCanvas({
        fb.canvas,
        stencil = false,
        depth = depth,
    })

    pushMatrix()
end

function resetContext(fb)
    popMatrix()
    love.graphics.setCanvas(previousCanvas)
end

function render2context(context, f)
    assert(context)

    setContext(context)
    resetMatrixContext()

    f()

    resetContext()
end
