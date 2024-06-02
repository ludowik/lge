function setup()
    sketch.fb = FrameBuffer(w, h)

    i, j = 0, 0
    index = 0

    --noLoop()
end

function draw()
    local n = 10

    index = index + 1
    
    process = processManager:getSketch(index)
    if process.sketch == sketch then return end

    if not process.sketch then        
        loadSketch(process)
        log(process.sketch.__className)
    end

    local origin = TOP_LEFT

    local status, result = pcall(
        function ()
            local previousCanvas = love.graphics.getCanvas()
            love.graphics.setCanvas({
                process.sketch.fb.canvas,
                stencil = false,
                depth = true,
            })
            love.graphics.clear(0, 0, 0, 1, true, false, 1)

            resetMatrix()
            resetStyle()

            if index == 1 then
                process.sketch:update(1/60)
            end
            
            process.sketch:draw()

            loop()
            
            resetMatrix()
            resetStyle(origin)

            setOrigin(origin)

            love.graphics.setCanvas(previousCanvas)
            love.graphics.draw(process.sketch.fb.canvas, (W)/n*i, (H)/n*j, 0, 1/n)            

            i = i + 1

            if i % n == 0 then
                i = 0 
                j = j + 1
            end
        end)

    if index == processManager:count() then
        i, j = 0, 0
        index = 0
    end
end
