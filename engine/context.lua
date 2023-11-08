local previousCanvas
function setContext(fb)
    assert(fb)
    -- TODEL
    -- if fb == nil then return resetContext() end

    assert(fb and fb.canvas)

    previousCanvas = love.graphics.getCanvas()
    love.graphics.setCanvas(fb.canvas)
    pushMatrix()
end

function resetContext(fb)
    popMatrix()
    love.graphics.setCanvas(previousCanvas)
end

function render2context(context, f)
    assert(context)

    setContext(context)
    love.graphics.origin()

    f()

    resetContext()
end
