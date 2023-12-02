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
            {'VertexColor', 'byte', 4},
            --{'VertexTexCoord', 'float', 2},
        }
        self.mesh = love.graphics.newMesh(vertexFormat, self.vertices, self.drawMode, self.usageMode)
    end
end

function Mesh:draw(x, y, z, w, h, d)
    self:update()

    pushMatrix()

    scale(w, h, d)
    translate(x, y, z)

    love.graphics.setColor(fill():rgba())
    love.graphics.draw(self.mesh, 0, 0)
    
    popMatrix()
end

-- TODO
function Mesh:addRect(x, y, w, h, angle)
end

function Mesh:setRect(index, x, y, w, h, angle)
end

function Mesh:setRectColor(index, clr)
end
