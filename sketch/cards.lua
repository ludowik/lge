function setup()
    a = vec2(getSetting('a', vec2()))
    b = vec2(getSetting('b', vec2()))
    c = vec2(getSetting('c', vec2()))

    parameter:number('a.x', Bind(a, 'x'), -2, 2)
    parameter:number('a.y', Bind(a, 'y'), -2, 2)

    parameter:number('b.x', Bind(b, 'x'), -2, 2)
    parameter:number('b.y', Bind(b, 'y'), -2, 2)

    parameter:number('c.x', Bind(c, 'x'), -2, 2)
    parameter:number('c.y', Bind(c, 'y'), -2, 2)
end

function release()
    setSetting('a', a)
    setSetting('b', b)
    setSetting('c', c)
end

local near = nil
function mousepressed(mouse)
    local position = (mouse.position-vec2(CX, CY))/100
    if (a-position):len() < (b-position):len() then
        near = a
    else
        near = b
    end
    near = c
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
    line(-W, 0, W, 0)

    local r = 200

    noFill()
    strokeSize(1)
    stroke(colors.blue)

    line( 1,  0.0,   a.x,  a.y, 5/r, 5/r)
    line( 1,  0.0, 2-a.x, -a.y, 5/r, 5/r)

    line( 0, -0.5,   b.x,    b.y, 5/r, 5/r)
    line( 0, -0.5,  -b.x, -1-b.y, 5/r, 5/r)

    rectMode(CENTER)
    rect(0, 0, 2*r, 2*r)

    noFill()
    stroke(colors.red)
    --spade(r, a, b)

    stroke(colors.green)
    spade(r)
end

function spade(r, a, b)
    beginShape()
    scaleShape(r)
    strokeSize(2/r)

    a = a or vec2(1.76, 0.75)
	b = b or vec2(0.57, 1.58)

    do
        vertex(0.0,  0.5)
        bezierVertex(-b.x, b.y, -a.x, a.y, -1.0, -0.0)
        vertex(0, -1)
        vertex(1,  0)
        bezierVertex(a.x, a.y, b.x, b.y, 0.0, 0.5)

        bezierVertex(c.x, c.y, c.x, c.y, 0.75, 1.5)
        vertex(-0.75, 1.5)
        bezierVertex(-c.x, c.y, -c.x, c.y, 0.0, 0.5)
        

    end    
    endShape(CLOSE)
end

function heart(r, a, b)
    beginShape()
    scaleShape(r)
    strokeSize(1/r)

    a = a or vec2(1.76, -0.75)
	b = b or vec2(0.57, -1.58)

    do
        vertex(0, 1)
        vertex(1, 0)
        bezierVertex( a.x, a.y,  b.x, b.y,  0.0, -0.5)
        bezierVertex(-b.x, b.y, -a.x, a.y, -1.0,  0.0)
    end    
    endShape(CLOSE)
end


function draw()
    background(colors.white)
    
    img = img or Image('resources/images/pique.png')

    local clr = colors.black
    img:mapPixel(function (x, y, r, g, b, a)
        return clr.r, clr.g, clr.b, a
    end)

    sprite(img, 0, 0)
end
