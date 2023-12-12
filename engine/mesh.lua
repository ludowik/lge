Mesh = class()

function Mesh:init(buffer, drawMode, usageMode)
    self.vertices = (buffer and buffer.vertices) or buffer or {}
    self.colors = (buffer and buffer.colors)
    self.texCoords = (buffer and buffer.texCoords)
    self.normals = (buffer and buffer.normals)

    self.bufs = {}

    self.drawMode = drawMode or 'triangles'
    self.usageMode = usageMode or 'static'

    self.shader = Graphics3d.shader
end

function Mesh:update()
    if not self.mesh then
        self.mesh = self:createBuffer(self.vertices, 'VertexPosition', 'float', 3, self.drawMode, self.usageMode)
        self.bufs.colors = self:createBuffer(self.colors, 'VertexColor', 'float', 4)
        self.bufs.texCoords = self:createBuffer(self.texCoords, 'VertexTexCoord', 'float', 2)
        self.bufs.normals = self:createBuffer(self.normals, 'VertexNormal', 'float', 3)
    end

    self:attachBuffer(self.bufs.colors, 'VertexColor', 'useColor')
    self:attachBuffer(self.bufs.texCoords, 'VertexTexCoord', 'useTexCoord')
    self:attachBuffer(self.bufs.normals, 'VertexNormal', 'useNormal')
end

function Mesh:createBuffer(buf, bufName, type, size, drawMode, usageMode)
    if buf and #buf > 0 then
        local format = {{bufName, type, size}}
        return love.graphics.newMesh(format, buf, drawMode, usageMode or 'static')
    end
end

function Mesh:attachBuffer(buf, bufName, flagName, shader)
    if buf then
        self.mesh:attachAttribute(bufName, buf, 'pervertex')
        self.shader.program:send(flagName, 1)
    else
         self.shader.program:send(flagName, 0)
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

    local clr = fill() or colors.white
    love.graphics.setColor(clr:rgba())

    self:useShader(0)
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

    self:useShader(1)
    love.graphics.drawInstanced(self.mesh, n, 0, 0)
    self:restoreShader()
end

function Mesh:useShader(instanced)
    self.previousShader = love.graphics.getShader()
    
    love.graphics.setShader(self.shader.program)

    self.shader.program:send('useInstanced', instanced or 0)

    if self.shader.program:hasUniform('camera') and env.sketch.cam then
        local fromCamera = env.sketch.cam.target - env.sketch.cam.eye
        self.shader.program:send('camera', {fromCamera.x, fromCamera.y, fromCamera.z, 1.})
    end
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
