do
    Test = class() : extends(Sketch)

    function Test:init()
        Sketch.init(self)
        self.clr = Color.random()
    end

    function Test:draw()
        background(self.clr)
        fill(colors.white)
    end
end

MySketch = Test
