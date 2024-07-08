Shape = class()

POINTS = 'points'
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

    if self.shader then
       self.oldShader = love.graphics.getShader()
       love.graphics.setShader(self.shader.program)
    end
    
    if self.type == POINTS then
        points(self.vertices)

    elseif self.type == LINES then
        for i=1,#self.vertices,4 do
            line(self.vertices[i], self.vertices[i+1], self.vertices[i+2], self.vertices[i+3])
        end

    elseif self.mode == CLOSE then
        polygon(self.vertices)

    else
        polyline(self.vertices)
    end

    if self.shader then
       love.graphics.setShader(self.oldShader)
    end

    popMatrix()
end

local shape

function beginShape(type)
    shape = Shape(type)
end

function vertex(x, y, z)
    shape.vertices:add(x)
    shape.vertices:add(y)

    if z then
        shape.shader = Graphics3d.shaders.shader3d
        shape.vertices:add(z)
    end
end

local function lerp(a, b, t)
    return (1 - t) * a + t * b
end

function bezierVertex(x2, y2, x3, y3, x4, y4)
    bezierCube(
        { x = shape.vertices[#shape.vertices - 1], y = shape.vertices[#shape.vertices] },
        { x = x2, y = y2 },
        { x = x3, y = y3 },
        { x = x4, y = y4 })
end

function bezierQuadratic(a, b, c)
    local xab, yab, xbc, ybc, x, y
    for t=0,1,0.5 do
        xab = lerp(a.x, b.x, t)
        yab = lerp(a.y, b.y, t)

        xbc = lerp(b.x, c.x, t)
        ybc = lerp(b.y, c.y, t)

        x = lerp(xab, xbc, t)
        y = lerp(yab, ybc, t)

        vertex(x, y)
    end
end

function bezierCube(a, b, c, d)
    local xab, yab, xbc, ybc, xcd, ycd, x1, y1, x2, y2, x, y;
    for t=0,1,0.05 do
        xab = lerp(a.x, b.x, t)
        yab = lerp(a.y, b.y, t)

        xbc = lerp(b.x, c.x, t)
        ybc = lerp(b.y, c.y, t)

        xcd = lerp(c.x, d.x, t)
        ycd = lerp(c.y, d.y, t)

        x1 = lerp(xab, xbc, t)
        y1 = lerp(yab, ybc, t)

        x2 = lerp(xbc, xcd, t)
        y2 = lerp(ybc, ycd, t)

        x = lerp(x1, x2, t)
        y = lerp(y1, y2, t)

        vertex(x, y)
    end

    vertex(d.x, d.y)
end

function endShape(mode)
    shape.mode = mode     
    shape:draw()
    return shape
end

function scaleShape(scaleFactor)
    shape.scaleFactor = scaleFactor
end
