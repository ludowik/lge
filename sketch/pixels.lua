Pixels = class() : extends(Sketch)

function Pixels:init()
    Sketch.init(self)

    self.pixels = Array()
    for x in range(W) do
        for y in range(H) do
            self.pixels:add{x, y, x/W, 0, 0, 1}
        end
    end 
end

function Pixels:draw()
    stroke(colors.white)
    points(self.pixels)
end
