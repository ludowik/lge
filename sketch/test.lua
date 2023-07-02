MySketch = class() : extends(Sketch)

function MySketch:init()
    Sketch.init(self)
    self.clr = Color.random()
end

function MySketch:draw()
    background(self.clr)
end
