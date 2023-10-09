Shape = class()

LINES = 'lines'
CLOSE = 'close'

function Shape:init(type)
    self.vertices = Array()
    self.type = type
    self.scaleFactor = 1
end

function Shape:draw()
    if #self.vertices < 4 then return end

    pushMatrix()
    scale(self.scaleFactor)
    
    if self.type == LINES then
        for i=1,#self.vertices,4 do
            line(self.vertices[i], self.vertices[i+1], self.vertices[i+2], self.vertices[i+3])
        end
    elseif self.mode == CLOSE then
        polygon(self.vertices)
    else
        polyline(self.vertices)
    end

    popMatrix()
end

local shape

function beginShape(type)
    shape = Shape(type)
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

function scaleShape(scaleFactor)
    shape.scaleFactor = scaleFactor
end
