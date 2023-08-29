Shape = class()

CLOSE = 'close'

function Shape:init()
    self.vertices = Array()
end

function Shape:draw()
    if self.mode == CLOSE then
        polygon(self.vertices)
    else
        polyline(self.vertices)
    end
end

local shape

function beginShape()
    shape = Shape()
end

function vertex(x, y)
    shape.vertices:add(x)
    shape.vertices:add(y)
end

function endShape(mode)
    shape.mode = mode     
    shape:draw()
    return shape
end
