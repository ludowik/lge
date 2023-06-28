The2048 = class() : extends(Sketch)

function The2048:init()
    Sketch.init(self)
end

function The2048:draw()
    background()
    fill(colors.white)
    text("2048", self.size.x/2, self.size.y/2)
end
