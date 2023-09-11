function setup()
    noLoop()
    parameter:action('reset', redraw)
end

function draw()
    local n = 20
    local size = H / n

    rectMode(CENTER)
    circleMode(CENTER)

    for x=0,n do
        for y=0,n do
            noStroke()
            fill(Color.random())
            rect(x * size + size / 2, y * size + size / 2, size, size)

            stroke(51)
            strokeSize(0.5)
            fill(Color.random())

            local sizeInternal = random(0.4, 0.85) * size
            if random() < 0.5 then
                rect(x * size + size / 2, y * size + size / 2, sizeInternal, sizeInternal)
            else
                circle(x * size + size / 2, y * size + size / 2, sizeInternal / 2)
            end
        end
    end
end
