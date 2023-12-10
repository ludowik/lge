Mesh = class()

function Mesh:init(buffer, drawMode, usageMode)
    self.vertices = (buffer and buffer.vertices) or buffer or {}
    self.colors = (buffer and buffer.colors)
    self.texCoords = (buffer and buffer.texCoords)
    self.normals = (buffer and buffer.normals)

    self.bufs = {}

    self.drawMode = drawMode or 'triangles'
    self.usageMode = usageMode or 'static'
end

function Mesh:update()
    if not self.mesh then
        local format = Array{{'VertexPosition', 'float', 3}}
        self.mesh = love.graphics.newMesh(format, self.vertices, self.drawMode, self.usageMode)
        
        if self.colors and #self.colors > 0 then
            local format = {{'VertexColor', 'float', 4}}
            self.bufs.colors = love.graphics.newMesh(format, self.colors, nil, "static")
        end
        
        if self.texCoords and #self.texCoords > 0 then
            local format = {{'VertexTexCoord', 'float', 2}}
            self.bufs.texCoords = love.graphics.newMesh(format, self.texCoords, nil, "static")
        end        

        if self.normals and #self.normals > 0 then
            local format = {{'VertexNormal', 'float', 3}}
            self.bufs.normals = love.graphics.newMesh(format, self.normals, nil, "static")
        end
    end

    local shader = self.shader or Graphics3d.shader
    function attachBuffer(buf, bufName, flagName)
        if buf then
            self.mesh:attachAttribute(bufName, buf, 'pervertex')
            shader.program:send(flagName, 1)
        else
            shader.program:send(flagName, 0)
        end
    end

    attachBuffer(self.bufs.colors, 'VertexColor', 'useColor')
    attachBuffer(self.bufs.texCoords, 'VertexTexCoord', 'useTexCoord')
    attachBuffer(self.bufs.normals, 'VertexNormal', 'useNormal')
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

    local clr = fill() or colors.white
    love.graphics.setColor(clr:rgba())

    self:setShader(0)
    love.graphics.draw(self.mesh)
    self:restoreShader()
    
    popMatrix()
end

function Mesh:drawInstanced(instances, instancedBuffer)
    self:update()

    local clr = fill() or colors.white
    love.graphics.setColor(clr:rgba())
    
    local n = #instances

    instancedBuffer = instancedBuffer or self:instancedBuffer(instances)
        
    self.mesh:attachAttribute('InstancePosition', instancedBuffer, 'perinstance')
    self.mesh:attachAttribute('InstanceScale', instancedBuffer, 'perinstance')

    self:setShader(1)
    love.graphics.drawInstanced(self.mesh, n, 0, 0)
    self:restoreShader()
end

function Mesh:setShader(instanced)
    self.previousShader = love.graphics.getShader()
    
    local shader = self.shader or Graphics3d.shader
    love.graphics.setShader(shader.program)
    shader.program:send('useInstanced', instanced or 0)
end

function Mesh:restoreShader()
    love.graphics.setShader(self.previousShader)
end

function Mesh:instancedBuffer(instances)
    local n = #instances

    local bufferFormat = {
        {'InstancePosition', 'float', 3},
        {'InstanceScale', 'float', 3},        
    }

    local instancedBuffer = love.graphics.newMesh(bufferFormat, instances, nil, "static")
    return instancedBuffer
end

-- TODO
function Mesh:addRect(x, y, w, h, angle)
end

function Mesh:setRect(index, x, y, w, h, angle)
end

function Mesh:setRectColor(index, clr)
end
