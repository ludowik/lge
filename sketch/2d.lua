Sketch2d = class() : extends(Sketch)

function Sketch2d:init()
    Sketch.init(self)
    self.clr = Color.random()
    self.anchor = Anchor(15)

    image = Image('rusty_metal.jpg')
end

function Sketch2d:draw()
    background(colors.black)

    stroke(0.25)

    line(0, 0, W, H)
	line(0, H, W, 0)
	
	circle(W/2, H/2, W/2)
	circle(W/2, H/2, H/2)
    
    noFill()
	rect(0, 0, W, H)

    self.anchor:draw()

    local size = self.anchor:size(1, 1)
    local x, y, w, h = size.x, size.y, size.x, size.y
    
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
    point(x+w/2, y+h/2)

    strokeSize(10)
    stroke(colors.gray)
    points{{x*3, y, 1,0,0,1}, {x*3+w, y+h*2, 0,1,0,1}}

    strokeSize(5)
    stroke(colors.white)
    points{{x*5, y, 1,0,0,1}, {x*5+w*2, y+h, 0,1,0,1}}
end

function drawLine(x, y, w, h)
    strokeSize(2)
    stroke(colors.red)
    line(x, y+w, x+w, y+h)

    strokeSize(10)
    stroke(colors.green)
    line(x*3, y, x*3+w, y+h*2)

    strokeSize(5)
    stroke(colors.blue)
    line(x*5, y+h/2, x*5+w*2, y+h+h/2)
end

function drawRect(x, y, w, h)
    noStroke()
    fill(colors.red)
    rect(x, y+h/2, w, h)

    strokeSize(10)
    stroke(colors.green)
    rect(x*3, y, w, h*2)

    strokeSize(5)
    stroke(colors.blue)
    rect(x*5, y+h/2, w*2, h)
end

function drawCircle(x, y, w, h)
    circleMode(CENTER)
    
    noStroke()
    fill(colors.red)
    circle(x+w/2, y+h, w/2)

    strokeSize(10)
    stroke(colors.green)
    circle(x*3+w/2, y+h, w)

    strokeSize(5)
    stroke(colors.blue)
    circle(x*6, y+h, w)
end

function drawEllipse(x, y, w, h)
    ellipseMode(CENTER)

    noStroke()
    fill(colors.red)
    ellipse(x+w/2, y+h, w/2)

    strokeSize(10)
    stroke(colors.green)
    ellipse(x*3+w/2, y+h, w/2, h)

    strokeSize(5)
    stroke(colors.blue)
    ellipse(x*6, y+h, w, h/2)
end

function drawBlendMode(x, y, r)
    r = r * 2 / 3
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

    drawCircles(NORMAL, x + 3*r/2, y + 3*r/2)
    drawCircles(ADD, x + 4*r + 3*r/2, y + 3*r/2)

    fill(colors.gray)
    rect(x + 8*r - r/2, y - r/2, 4*r, 4*r)
    drawCircles(MULTIPLY, x + 8*r + 3*r/2, y + 3*r/2)
end

function drawSprite(x, y, w, h)
    sprite(image, x, y, 2*w, 2*h)
end
