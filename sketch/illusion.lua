function setup()
    array = Array()

    size = W / 3
    
    local function addPoint(angle, distance)
        local point1 = -vec2.fromAngle(angle) * distance
        local point2 = -vec2.fromAngle(angle) * size
        
        animate(point1, point2, distance/size,
            function ()
                animate(point1, point1:rotate(PI), 1, {loop=tween.loop.pingpong})
            end)
        
        array:add(point1)
    end

    addPoint(PI*0/8, 0)
    addPoint(PI*1/8, size / 3)
    addPoint(PI*2/8, size * 2 / 3)
    addPoint(PI*3/8, size * 6/7)
    addPoint(PI*4/8, size)
    addPoint(PI*5/8, size * 6/7)
    addPoint(PI*6/8, size * 2 / 3)
    addPoint(PI*7/8, size / 3)

    noLoop();
end

function mousereleased()
    redraw()
end

function draw()
    background()

    translate(W/2, H/2)

    local function drawLine(angle)
        local point1 = vec2.fromAngle(angle) * size
        local point2 = point1:rotate(PI)

        line(point1.x, point1.y, point2.x, point2.y)
    end


    drawLine(PI*0/8)
    drawLine(PI*1/8)
    drawLine(PI*2/8)
    drawLine(PI*3/8)
    drawLine(PI*4/8)
    drawLine(PI*5/8)
    drawLine(PI*6/8)
    drawLine(PI*7/8)

    noStroke()
    fill(colors.red)

    array:draw()
end
