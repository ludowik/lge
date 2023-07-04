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
    
    noStroke()
    fill(colors.green)
    rect(x, y, w, h)

    stroke(colors.red)
    strokeWidth(10)
    rect(x*3, y, w, h*2)

    stroke(colors.blue)
    strokeWidth(5)
    rect(x*5, y, w*2, h)

    y = size.y * 4

    noStroke()
    fill(colors.green)
    circle(x+w/2, y+h/2, w/2)

    stroke(colors.red)
    strokeWidth(10)
    ellipse(x*3+w/2, y+h, w/2, w)

    stroke(colors.blue)
    strokeWidth(5)
    ellipse(x*6, y+h/2, w, w/2)

    y = size.y * 7

    strokeWidth(2)
    line(x, y+w/2, x+w, y+w/2)

    stroke(colors.red)
    strokeWidth(10)
    line(x*3, y, x*3+w, y+h)

    strokeWidth(5)
    line(x*5, y, x*5+w*2, y+h)
end
