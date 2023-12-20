function setup()
    sketch.fb = FrameBuffer(w, h)

    i, j = 0, 0
    index = 0
end

function draw()
    local n = 6

    index = index + 1
    
    process = processManager:getSketch(index)
    if process.sketch == sketch then return end

    if not process.sketch then
        loadSketch(process)
    end

    local status, result = pcall(
        function ()
            love.graphics.setCanvas(process.sketch.fb.canvas)
            love.graphics.clear()

            resetMatrix()
            resetStyle(getOrigin())

            if index == 1 then
                process.sketch:update(1/60)
            end
            
            process.sketch:draw()
            
            loop()

            resetMatrix()

            love.graphics.setCanvas(sketch.fb.canvas)
            love.graphics.draw(process.sketch.fb.canvas, (2*X+W)/n*i, (2*Y+H)/n*j, 0, 1/n)
            love.graphics.setCanvas()

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
