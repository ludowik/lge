Plot = class() : extends(Sketch)

function sigmoid(x)
    return 1 / (1 + math.exp(-x))
end

function Plot:init()
    Sketch.init(self, W, H)
end

function Plot:draw()
    background(0)
    stroke(colors.white)
    for x=-3,3,0.01 do
        point(W/2-x*100, 100+sigmoid(x)*100)
    end
end