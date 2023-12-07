Mesh = class()

function Mesh:init(vertices, drawMode)
    self.vertices = vertices or {}
    self.drawMode = drawMode or 'triangles'
    self.usageMode = usageMode or 'static'
end

function Mesh:update()
    if not self.mesh then
        local vertexFormat = {
            {'VertexPosition', 'float', 3},
            {'VertexTexCoord', 'float', 2},
            {'VertexColor', 'byte', 4},            
        }
        self.mesh = love.graphics.newMesh(vertexFormat, self.vertices, self.drawMode, self.usageMode)
    end
end

function Mesh:draw(x, y, z, w, h, d)
    self:update()

    pushMatrix()

    if x then
        translate(x, y, z)
    end

    if w then
        scale(w, h, d)
    end

    if fill() then
        love.graphics.setColor(fill():rgba())
    end
    love.graphics.draw(self.mesh)
    
    popMatrix()
end

-- TODO
function Mesh:addRect(x, y, w, h, angle)
end

function Mesh:setRect(index, x, y, w, h, angle)
end

function Mesh:setRectColor(index, clr)
end
