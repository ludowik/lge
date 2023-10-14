Mesh = class()

function Mesh:init()
    --self.shader = Shader()
end

function Mesh:update()
    if self.vertices and not self.mesh then
        self.mesh = love.graphics.newMesh(self.vertices, 'fan')
    end
end

function Mesh:draw()
    self:update()
    if self.mesh then
        love.graphics.draw(self.mesh, 0, 0)
    end
end

-- TODO
function Mesh:addRect(x, y, w, h, angle)
end

function Mesh:setRect(index, x, y, w, h, angle)
end

function Mesh:setRectColor(index, clr)
end
