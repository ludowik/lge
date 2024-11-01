Mesh = class()

function Mesh:init(buffer, drawMode, usageMode)
    self.vertices = (buffer and buffer.vertices) or buffer or {}
    self.colors = (buffer and buffer.colors) or {}
    self.texCoords = (buffer and buffer.texCoords) or {}
    self.normals = (buffer and buffer.normals) or {}

    self.bufs = {}
    self.uniforms = {
        useColor = false,
        useLight = false,
        useMaterial = false,
        useRelief = false,
        useHeightMap = false,
        computeHeight = false,
        border = false,
    }

    self.drawMode = drawMode or 'triangles'
    self.usageMode = usageMode or 'static'

    self.shader = Graphics3d.shaders.shader3d
    self.image = nil
    self.clr = nil
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

    if self.image then
        self.image:update()
        self.mesh:setTexture(self.image.texture or self.image.canvas)
    else
        self.mesh:setTexture()
    end
end

function Mesh:createBuffer(buf, bufName, newType, type, size, drawMode, usageMode)
    if buf and #buf > 0 then
        local format
        if love.getVersion() > 11 then
            format = {{name=bufName, format=newType}}
        else
            format = {{bufName, type, size}}
        end
        return love.graphics.newMesh(format, buf, drawMode, usageMode or 'static')
    end
end

function Mesh:attachBuffer(buf, bufName, flagName, shader)
    if buf then
        self.mesh:attachAttribute(bufName, buf, 'pervertex')
        self.uniforms[flagName] = true
    else
        self.uniforms[flagName] = false
    end
end

function Mesh:draw(x, y, z, w, h, d)
    x, y, z, w, h, d = Graphics3d.params(x, y, z, w, h, d)
    
    self:update()

    pushMatrix()

    if x then
        translate(x, y, z)
    end

    if w then
        scale(w, h, d)
    end

    local clr = self.clr or fill() or colors.white
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

    instancedBuffer = getResource('mesh', instances, function (instances)
        return self:instancedBuffer(instances)
    end)
        
    self.mesh:attachAttribute('InstancePosition', instancedBuffer, 'perinstance')
    self.mesh:attachAttribute('InstanceScale', instancedBuffer, 'perinstance')
    self.mesh:attachAttribute('InstanceColor', instancedBuffer, 'perinstance')

    self:useShader(1)
    love.graphics.drawInstanced(self.mesh, n, 0, 0)
    self:restoreShader()
end

function Mesh:instancedBuffer(instances)
    local n = #instances

    local bufferFormat
    if love.getVersion() > 11 then
        bufferFormat = {
            {name='InstancePosition', format='floatvec3'},
            {name='InstanceScale', format='floatvec3'},
            {name='InstanceColor', format='floatvec4'},
        }
    else
        bufferFormat = {
            {'InstancePosition', 'float', 3},
            {'InstanceScale', 'float', 3},
            {'InstanceColor', 'float', 4},
        }
    end

    return love.graphics.newMesh(bufferFormat, instances, self.drawMode, self.usageMode)
end

function Mesh:useShader(instanced)
    self.previousShader = love.graphics.getShader()    
    love.graphics.setShader(self.shader.program)

    if env.sketch.cam then
        self.uniforms.cameraPos = env.sketch.cam.eye
    end

    local lights = light()
    local useLight = lights and true or false

    self:sendUniforms(self.uniforms)
    self:sendUniforms({
        useLight = useLight,
        useLightAmbient = argument(self.uniforms.useLightAmbient, useLight),
        useLightDiffuse = argument(self.uniforms.useLightDiffuse, useLight),
        useLightSpecular = argument(self.uniforms.useLightSpecular, useLight),
        lights = lights,

        useInstanced = instanced or false,
        
        matrixModel = {modelMatrix():getMatrix()},
        matrixPV = {pvMatrix():getMatrix()},

        strokeSize = strokeSize(),
        strokeColor = stroke() or colors.white,
        fillColor = fill() or colors.white,

        deltaTime = deltaTime,
        elapsedTime = elapsedTime,
    })

end

function Mesh:sendUniforms(uniforms, prefix)
    self.shader:sendUniforms(uniforms, prefix)
end

function Mesh:sendUniform(uniformName, ...)
    self.shader:sendUniform(uniformName, ...)
end

function Mesh:restoreShader()
    love.graphics.setShader(self.previousShader)
end

function Mesh:addRect(...)
    local idx = #self.vertices/6 + 1
    
    self:setRect(idx, ...)
    self:setRectColor(idx, colors.white)
    self:setRectTex(idx, 0, 0, 1, 1)

    return idx
end

function Mesh:setRect(idx, x, y, w, h, angle, z)
    local i = (idx - 1) * 6

    z = z or 0
    
    -- TODO : rotate
    self.vertices[i+1] = {x, y, z}
    self.vertices[i+2] = {x+w, y, z}
    self.vertices[i+3] = {x+w, y+h, z}
    self.vertices[i+4] = {x, y, z}
    self.vertices[i+5] = {x+w, y+h, z}
    self.vertices[i+6] = {x, y+h, z}
end

function Mesh:addPlane(...)
    local idx = #self.vertices/6 + 1
    
    self:setPlane(idx, ...)
    self:setRectColor(idx, colors.white)
    self:setRectTex(idx, 0, 0, 1, 1)

    return idx
end

function Mesh:setPlane(idx, x, y, w, h, angle, z)
    local i = (idx - 1) * 6

    z = z or 0
    
    -- TODO : rotate
    self.vertices[i+1] = {x, z, y}
    self.vertices[i+2] = {x+w, z, y}
    self.vertices[i+3] = {x+w, z, y-h}
    self.vertices[i+4] = {x, z, y}
    self.vertices[i+5] = {x+w, z, y-h}
    self.vertices[i+6] = {x, z, y-h}
end

function Mesh:setRectColor(idx, clr)
    local i = (idx - 1) * 6

    local clrAsArray = {clr:unpack()}

    self.colors[i+1] = clrAsArray
    self.colors[i+2] = clrAsArray
    self.colors[i+3] = clrAsArray
    self.colors[i+4] = clrAsArray
    self.colors[i+5] = clrAsArray
    self.colors[i+6] = clrAsArray
end

function Mesh:setRectTex(idx, s, t, w, h)
    local i = (idx - 1) * 6

    local sw = s + w
    local th = t + h

    self.texCoords[i+1] = {s , t}
    self.texCoords[i+2] = {s , th}
    self.texCoords[i+3] = {sw, th}
    self.texCoords[i+4] = {s , t}
    self.texCoords[i+5] = {sw, th}
    self.texCoords[i+6] = {sw, t}
end

function  Mesh:vertex(i, v)
    if v then
        self.vertices[i] = v
    else
        return self.vertices[i]
    end
end

function Mesh:computeNormals()
    self.normals = Model.computeNormals(self.vertices)
end