function setup()
    noLoop()
    parameter:action('reset', redraw)
end

function draw()
    background()
    
    local cellSize = even(MIN_SIZE/(12+1))

    local m = round(W/cellSize)-1
    local n = round(H/cellSize)-1

    rectMode(CENTER)
    circleMode(CENTER)

    blendMode(NORMAL)

    for x=1,m do
        for y=1,n do
            noStroke()
            
            fill(Color.random())
            rect(x * cellSize, y * cellSize, cellSize, cellSize)
            
            local sizeInternal = random(0.65, 0.85) * cellSize
            fill(Color.random())
            if random() < 0.5 then
                rect(x * cellSize, y * cellSize, sizeInternal, sizeInternal)
            else
                circle(x * cellSize, y * cellSize, sizeInternal/2)
            end
        end
    end
end
