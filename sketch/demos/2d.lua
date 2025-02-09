Sketch2d = class() : extends(Sketch)

function Sketch2d:init()
    Sketch.init(self)
    self.clr = Color.random()

    image = Image('rusty_metal.jpg')
end

function Sketch2d:draw()
    background(colors.black)

    local W, H = W, H
    local anchor
    if deviceOrientation == PORTRAIT then
        anchor = Anchor(9, 20)
    else
        anchor = Anchor(9, 20)
        translate(0, H)
        rotate(-PI/2)
        W, H = H, W
    end

    anchor:draw()

    stroke(0.5)

    line(0, 0, W, H)
	line(0, H, W, 0)
	
    noFill()

    circle(CX, CY, CX)
	circle(CX, CY, CY)
    
	rect(0, 0, W, H)

    local pos = anchor:pos(2, 1)
    local size = anchor:size(1, 1)

    local x, y, w, h = pos.x, pos.y, size.x, size.y
    
    for _,f in ipairs{
        drawPoint,
        drawLine,
        drawRect,
        drawCircle,
        drawEllipse,
        drawBlendMode,
        drawSprite
    } do
        blendMode(NORMAL)
        fill(colors.white)
        f(x, y, w, h)
        y = y + h*3
    end
end

function drawPoint(x, y, w, h)
    strokeSize(20)
    stroke(colors.red)
    point(x, y+h)

    x = x + 2*w
    points{{x, y, 1,0,0,1}, {x+w, y+h*2, 0,1,0,1}}

    x = x + 2*w
    points{{x, y+h/2, 1,0,0,1}, {x+w*2, y+3*h/2, 0,1,0,1}}
end

function drawLine(x, y, w, h)
    strokeSize(10)
    stroke(colors.red)
    line(x-0.5*w, y+w, x+w/2, y+h)

    x = x + 2*w
    strokeSize(10)
    stroke(colors.green)
    line(x, y, x+w, y+h*2)

    x = x + 2*w
    strokeSize(5)
    stroke(colors.blue)
    line(x, y+h/2, x+2*w, y+h+h/2)
end

function drawRect(x, y, w, h)
    rectMode(CORNER)
    
    noStroke()
    fill(colors.red)
    rect(x-0.5*w, y+h/2, w, h)

    x = x + 2*w
    strokeSize(10)
    stroke(colors.green)
    rect(x, y, w, h*2)

    x = x + 2*w
    strokeSize(5)
    stroke(colors.blue)
    rect(x, y+h/2, w*2, h)
end

function drawCircle(x, y, w, h)
    circleMode(CENTER)
    
    noStroke()
    fill(colors.red)
    circle(x, y+h, w/2)

    x = x + 2.5*w
    strokeSize(10)
    stroke(colors.green)
    circle(x, y+h, w)

    x = x + 2.5*w
    strokeSize(5)
    stroke(colors.blue)
    circle(x, y+h, w)
end

function drawEllipse(x, y, w, h)
    ellipseMode(CENTER)

    noStroke()
    fill(colors.red)
    ellipse(x, y+h, w/4, h/2)

    x = x + 2.5*w
    strokeSize(10)
    stroke(colors.green)
    ellipse(x, y+h, w/2, h)

    x = x + 2.5*w
    strokeSize(5)
    stroke(colors.blue)
    ellipse(x, y+h, w, h/2)
end

function drawBlendMode(x, y, w)
    local r = w * 2 / 3
    noStroke()

    local function drawCircles(mode, x, y)
        blendMode(mode)

        fill(1, 0, 0)
        circle(x-r/2, y-r/2, r)

        fill(0, 1, 0)
        circle(x+r/2, y-r/2, r)

        fill(0, 0, 1)
        circle(x, y+r/2, r)
    end

    drawCircles(NORMAL, x, y + 3*r/2)

    x = x + 2.5*w
    drawCircles(ADD, x, y + 3*r/2)

    x = x + 2.5*w
    fill(colors.gray)
    rect(x - 2*r, y - r/2, 4*r, 4*r)
    drawCircles(MULTIPLY, x, y + 3*r/2)
end

function drawSprite(x, y, w, h)
    sprite(image, x, y, 2*w, 2*h)
end
