MySketch = class() : extends(Sketch)

function MySketch:init()
    Sketch.init(self)

    self:randomize()

    Image.init(self, self.size.x, self.size.y)
end

function MySketch:randomize()
    Rect.randomize(self)
    self.clr = Color.random()
end

function MySketch:draw()
    background(255)
    fill(self.clr)
    text("hello "..self.index)
end
