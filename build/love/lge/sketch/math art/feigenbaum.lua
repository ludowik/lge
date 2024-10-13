function setup()
    parameter:linksearch('feigenbaum')
    parameter:number('py', 0, 1, 0.5, reset)
    
    reset()

    sketch.fb = FrameBuffer(w, h)
end

function reset()
    start = true
end

function resize()
    reset()
end

function draw()
    if start then
        background(colors.white)

        stroke(colors.black)
        strokeSize(1)

        base = H * 0.25
        line(0, base, W, base)

        start = false
    end

    stroke(colors.black)
    strokeSize(0.5)

    noFill()

    local rMin = 2
    local rMax = 4
    local rStep = 0.001
    local iMax = 150

    local data = Array()

    local ratio = SIZE / (rMax - rMin)
    for r = rMin,rMax,rStep do
        y = py
        for index = 0,iMax do
            y = r * y * (1 - y)
            if index > iMax * 0.75 then
                data:add((r - rMin) * ratio)
                data:add(base + y * SIZE * 0.8)
            end
        end
    end

    strokeSize(1)
    
    points(data)
end
