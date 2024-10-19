function setup()
    a = vec2(getSetting('a', vec2()))
    b = vec2(getSetting('b', vec2()))

    parameter:number('a.x', Bind(a, 'x'), -2, 2)
    parameter:number('a.y', Bind(a, 'y'), -2, 2)

    parameter:number('b.x', Bind(b, 'x'), -2, 2)
    parameter:number('b.y', Bind(b, 'y'), -2, 2)
end

function release()
    setSetting('a', a)
    setSetting('b', b)
end

local near = nil
function mousepressed(mouse)
    local position = (mouse.position-vec2(CX, CY))/100
    if (a-position):len() < (b-position):len() then
        near = a
    else
        near = b
    end
end

function mousemoved(mouse)
    if near then
        near:set(
            (mouse.position.x-CX)/100,
            (mouse.position.y-CY)/100)
    end
end

function mousereleased()
    near = nil
end

function draw()
    background()

    local x, y = CX, CY
    translate(x, y)

    line(0, -H, 0, H)

    local r = 100 -- abs(mouse.position.y - CY)
    scale(r)

    strokeSize(2/r)
    stroke(colors.blue)

    rectMode(CENTER)
    line( 1,  0.0,   a.x,  a.y, 5/r, 5/r)
    line( 1,  0.0, 2-a.x, -a.y, 5/r, 5/r)

    line( 0, -0.5,   b.x,    b.y, 5/r, 5/r)
    line( 0, -0.5,  -b.x, -1-b.y, 5/r, 5/r)

    noFill()
    stroke(colors.red)
    
    beginShape()
    do
        --scaleShape(r)
        vertex(0, 1)
        vertex(1, 0)
        bezierVertex( a.x, a.y,  b.x, b.y,  0, -0.5)
        bezierVertex(-b.x, b.y, -a.x, a.y, -1, 0)
    end
    endShape(CLOSE)

    rect(0, 0, 2, 2)

    stroke(colors.green)
    heart(r)
end

function heart(r)
    beginShape()
    --scaleShape(r)

    local a = vec2(1.76, -0.75)
	local b = vec2(0.57, -1.58)

    do
        vertex(0, 1)
        vertex(1, 0)
        bezierVertex( a.x, a.y,  b.x, b.y,  0.0, -0.5)
        bezierVertex(-b.x, b.y, -a.x, a.y, -1.0,  0.0)
    end    
    endShape(CLOSE)
end
