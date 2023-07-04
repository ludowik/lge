MySketch = class() : extends(Sketch)

function MySketch:init()
    Sketch.init(self)
    self.clr = Color.random()
    self.anchor = Anchor()
end

function MySketch:draw()
    background(colors.black)

    self.anchor:draw()

    local size = self.anchor:size(1, 1)

    local x, y, w, h = size.x, size.y, size.x, size.y
    
    drawPoint(x, y, w, h)
    drawLine(x, y*3, w, h)
    drawRect(x, y*6, w, h)
    drawEllipse(x, y*9, w, h)
end

function drawPoint(x, y, w, h)
    strokeWidth(2)
    stroke(colors.red)
    point(x+w/2, y+h/2)

    strokeWidth(10)
    stroke(colors.green)
    points{x*3, y, x*3+w, y+h}

    strokeWidth(5)
    stroke(colors.white)
    points{{x*5, y, 1,0,0,1}, {x*5+w*2, y+h, 0,1,0,1}}
end

function drawLine(x, y, w, h)
    strokeWidth(2)
    stroke(colors.red)
    line(x, y+w/2, x+w, y+h/2)

    strokeWidth(10)
    stroke(colors.green)
    line(x*3, y, x*3+w, y+h*2)

    strokeWidth(5)
    stroke(colors.blue)
    line(x*5, y, x*5+w*2, y+h)
end

function drawRect(x, y, w, h)
    noStroke()
    fill(colors.red)
    rect(x, y, w, h)

    strokeWidth(10)
    stroke(colors.green)
    rect(x*3, y, w, h*2)

    strokeWidth(5)
    stroke(colors.blue)
    rect(x*5, y, w*2, h)
end

function drawEllipse(x, y, w, h)
    noStroke()
    fill(colors.red)
    circle(x+w/2, y+h/2, w/2)

    strokeWidth(10)
    stroke(colors.green)
    ellipse(x*3+w/2, y+h, w/2, h)

    strokeWidth(5)
    stroke(colors.blue)
    ellipse(x*6, y+h/2, w, h/2)
end
