function setup()
    noLoop()
    parameter:action('reset', redraw)
end

function draw()
    local m = 12
    local size = even(W/(m+1))
    local n = round(H/size)-1

    rectMode(CENTER)
    circleMode(CENTER)

    for x=1,m do
        for y=1,n do
            noStroke()
            fill(Color.random())
            rect(x * size, y * size, size, size)

            stroke(51)
            strokeSize(0.5)
            fill(Color.random())

            local sizeInternal = random(0.4, 0.85) * size
            if random() < 0.5 then
                rect(x * size, y * size, sizeInternal, sizeInternal)
            else
                circle(x * size, y * size, sizeInternal/2)
            end
        end
    end
end
