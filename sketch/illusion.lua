function setup()
    array = Array()

    local size = W / 3
    
    function addPoint(angle)
        local point = vec2.fromAngle(angle) * size
        animate(point, point:rotate(PI), 1, {loop=tween.loop.pingpong})
        array:add(point)
    end

    addPoint(PI*1/8)
    addPoint(PI*2/8)
    addPoint(PI*3/8)
    addPoint(PI*4/8)
    addPoint(PI*5/8)
    addPoint(PI*6/8)
    addPoint(PI*7/8)
    addPoint(PI*8/8)
end

function draw()
    background()

    translate(W/2, H/2)

    array:draw()
end
