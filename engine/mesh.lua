Mesh = class()

function Mesh:init(buffer, drawMode, usageMode)
    self.vertices = (buffer and buffer.vertices) or buffer or {}
    self.colors = (buffer and buffer.colors)
    self.texCoords = (buffer and buffer.texCoords)
    self.normals = (buffer and buffer.normals)

    self.bufs = {}
    self.uniforms = {
        useColor = 1,
        useLight = 0,
    }

    self.drawMode = drawMode or 'triangles'
    self.usageMode = usageMode or 'static'

    self.shader = Graphics3d.shader
end

function Mesh:update()
    if not self.mesh then
        self.mesh = self:createBuffer(self.vertices, 'VertexPosition', 'floatvec3', 'float', 3, self.drawMode, self.usageMode)

        self.bufs.colors = self:createBuffer(self.colors, 'VertexColor', 'floatvec4', 'float', 4, self.drawMode, self.usageMode)
        self.bufs.texCoords = self:createBuffer(self.texCoords, 'VertexTexCoord', 'floatvec2', 'float', 2, self.drawMode, self.usageMode)
        self.bufs.normals = self:createBuffer(self.normals, 'VertexNormal', 'floatvec3', 'float', 3, self.drawMode, self.usageMode)
    end

    self:attachBuffer(self.bufs.colors, 'VertexColor', 'useColor')
    self:attachBuffer(self.bufs.texCoords, 'VertexTexCoord', 'useTexCoord')
    self:attachBuffer(self.bufs.normals, 'VertexNormal', 'useNormal')
end

function Mesh:createBuffer(buf, bufName, newType, type, size, drawMode, usageMode)
    if buf and #buf > 0 then
        local format
        if getOS() == 'ios' then
            format = {{name=bufName, format=newType}}
        else
            format = {{bufName, type, size}}
        end
        return love.graphics.newMesh(format, buf, drawMode, usageMode or 'static')
    end
end

function Mesh:send(uniformName, ...)
    self.shader:send(uniformName, ...)
end

function Mesh:attachBuffer(buf, bufName, flagName, shader)
    if buf then
        self.mesh:attachAttribute(bufName, buf, 'pervertex')
        self:send(flagName, 1)
    else
        self:send(flagName, 0)
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

    self:send('useInstanced', instanced or 0)

    if env.sketch.cam then
        self.uniforms.cameraPos = env.sketch.cam.eye
        self.uniforms.cameraToLight = (vec3(-100, 100, -100) - env.sketch.cam.eye):normalize()
    end

    self:sendUniforms(self.uniforms)
end

function Mesh:sendUniforms(uniforms, prefix)
    for k,v in pairs(uniforms) do
        local name = (prefix or '')..k
        if type(v) == 'table' and #v > 0 and type(v[1]) == 'table' then
            for i,o in ipairs(v) do
                self:sendUniforms(o, k..'['..(i-1)..'].')
            end

        elseif self.shader.program:hasUniform(name) then        
            if type(v) == 'boolean' then
                self:send(name, v and 1 or 0)
            
            elseif classnameof(v) == 'Color' then
                self:send(name, {v:unpack()})
            
            elseif classnameof(v) == 'vec2' then
                self:send(name, {v:unpack()})
            
            elseif classnameof(v) == 'vec3' then
                self:send(name, {v:unpack()})

            else
                self:send(name, v)
            end
        end 
    end
end

function Mesh:restoreShader()
    love.graphics.setShader(self.previousShader)
end

function Mesh:instancedBuffer(instances)
    local n = #instances

    local bufferFormat
    if getOS() == 'ios' then
        bufferFormat = {
            {name='InstancePosition', format='floatvec3'},
            {name='InstanceScale', format='floatvec3'},        
        }
    else
        bufferFormat = {
            {'InstancePosition', 'float', 3},
            {'InstanceScale', 'float', 3},        
        }
    end

    local instancedBuffer = love.graphics.newMesh(bufferFormat, instances, self.drawMode, self.usageMode)
    return instancedBuffer
end

-- TODO
function Mesh:addRect(x, y, w, h, angle)
end

function Mesh:setRect(index, x, y, w, h, angle)
end

function Mesh:setRectColor(index, clr)
end
