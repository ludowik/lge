class 'MeshRender'

local function vec2(x, y, uvx, uvy)
    return {x, y, uvx, uvy}
end

local format = {
    {"VertexPosition", "float", 3}, -- The x,y,z position of each vertex.
    {"VertexTexCoord", "float", 2}, -- The u,v texture coordinates of each vertex.
    {"VertexColor", "byte", 4},     -- The r,g,b,a color of each vertex.
    {"VertexNormal", "float", 3}    -- The x,y,z direction of each normal.
}

function MeshRender:init()
    self.uniforms = {}

    self.uniforms.instanceMode = 0

    self.instancePosition = Array()
    self.instanceScale = Array()
    self.instanceColor = Array()
end

function MeshRender:clear()
    self.__vertices = nil
    self.__buffers = Array()
end

function MeshRender:bufferHasChanged(name, b)
    assert(b)
    if (not self.__buffers[name] or
        self.__buffers[name].buffer ~= b or
        self.__buffers[name].size ~= #b)
    then
        self.__buffers[name] = {
            buffer = b,
            size = #b
        }
        return true
    end

    return false
end

function MeshRender:update()
    if not self.vertices or #self.vertices == 0 then return end

    if self.needUpdate or self:bufferHasChanged('vertices', self.vertices) then
        local vertices
        if self.vertices[1].x then
            vertices = Array()
            for i,v in ipairs(self.vertices) do
                local clr = self.colors[i] or colors.white
                vertices:insert({
                        v.x,
                        v.y,
                        v.z,
                        #self.texCoords > 0 and self.texCoords[i].x or 0,
                        #self.texCoords > 0 and self.texCoords[i].y or 0,
                        clr.r,
                        clr.g,
                        clr.b,
                        clr.a,
                        #self.normals > 0 and self.normals[i].x or 0,
                        #self.normals > 0 and self.normals[i].y or 0,
                        #self.normals > 0 and self.normals[i].z or 0,
                    })
            end
        else
            vertices = self.vertices
        end
        self.__vertices = vertices

        self.mesh = love.graphics.newMesh(format, vertices, self.drawMode or 'triangles', 'static')

        if self.indices and #self.indices > 0 then
            self.mesh:setVertexMap(self.indices)
        end
    end

    if #self.instancePosition > 0 then
        if self.needUpdate or self:bufferHasChanged('instancePosition', self.instancePosition) then
            self.uniforms.instanceMode = 1

--            self.instancePosition = self.instancePosition or {{1, 1, 1}}
            self.instanceScale = self.instanceScale or {{1, 1, 1}}
            self.instanceColor = self.instanceColor or {{.5, .5, .5, 1}}

            if not self.instanceID then
                self.instanceID = {}
                for i=1,#self.instancePosition do
                    table.insert(self.instanceID, {i})
                end
            end

            if #self.instanceColor < #self.instancePosition then
                local clr
                if #self.instanceColor > 0 then
                    clr = self.instanceColor[#self.instanceColor]
                else
                    clr = {__fill():unpack()}
                end

                for i=#self.instanceColor,#self.instancePosition-1 do
                    self.instanceColor:add(clr)
                end
            end            

            self.instanceMeshID = love.graphics.newMesh({
                    {"InstanceID", "float", 1}
                },
                self.instanceID, nil, "static")
            self.mesh:attachAttribute("InstanceID", self.instanceMeshID, "perinstance")

            self.instanceMeshPosition = love.graphics.newMesh({
                    {"InstancePosition", "float", 3}
                },
                self.instancePosition, nil, "static")
            self.mesh:attachAttribute("InstancePosition", self.instanceMeshPosition, "perinstance")

            if #self.instanceScale > 1 then
                self.instanceMeshScale = love.graphics.newMesh({
                        {"InstanceScale", "float", 3},
                    },
                    self.instanceScale, nil, "static")
                self.mesh:attachAttribute("InstanceScale", self.instanceMeshScale, "perinstance")
            end

            if #self.instanceColor > 0 then
                self.instanceMeshColor = love.graphics.newMesh({
                        {"InstanceColor", "float", 4},
                    },
                    self.instanceColor, nil, "static")
                self.mesh:attachAttribute("InstanceColor", self.instanceMeshColor, "perinstance")
            end
        end

    else
        self.uniforms.instanceMode = 0
    end

    self.needUpdate = false
end

function MeshRender:draw(...)
    if not self.vertices or #self.vertices == 0 then return end

    self:update()

    local vertices = self.__vertices
    if #vertices < 3 then return end

    love.graphics.setColor(colors.white:rgba())

    if type(self.texture) == 'string' then
        self.texture = Image.getImage(self.texture)
    end

    if self.texture then
        self.mesh:setTexture(self.texture.data)
    end

    MeshRender.drawModel(self, ...)
end

function MeshRender:getShader()
    return self.shader -- or shaders.default
end

function MeshRender:drawModel(x, y, z, w, h, d, n)
    local shader = self:getShader()

    local previousShader = love.graphics.getShader()
    love.graphics.setShader(shader.program)

    pushMatrix()
    do
        if x then
            translate(x, y, z)
        end

        if w then
            scale(w, h, d)
        end

        local clr = __fill() or __stroke()

        if clr then
            self:sendUniforms(shader)
            love.graphics.setColor(clr:unpack())

            if self.instancePosition and #self.instancePosition > 1 then
                love.graphics.drawInstanced(self.mesh, #self.instancePosition)

            elseif n and n > 1 then
                love.graphics.drawInstanced(self.mesh, n)

            else
                love.graphics.draw(self.mesh)
            end
        end
    end
    popMatrix()

    love.graphics.setShader(previousShader)
end

function MeshRender:drawInstanced(x, y, z, w, h, d, n)
    self:draw(x, y, z, w, h, d, n)
end

function MeshRender:sendUniforms(shader)
    local uniforms = self.uniforms
    
    uniforms.matrixModel = {modelMatrix():getMatrix()}
    uniforms.matrixPV = {pvMatrix():getMatrix()}
    
    local camera = getCamera()
    if camera then
        uniforms.cameraPos = camera.vEye
    end

    uniforms.lightMode = uniforms.lightModeExtra or (__light() and 1 or 0)
    if uniforms.lightMode > 0 then
        uniforms.lights = lights
        uniforms.material = currentMaterial    
    end

    self:_sendUniforms(shader, uniforms)

    if shader.uniforms then
        self:_sendUniforms(shader, shader.uniforms)
    end
end

function MeshRender:_sendUniforms(shader, uniforms, baseName)
    assert(uniforms)

    if uniforms then        
        for uniformName,uniform in pairs(uniforms) do
            self:sendUniform(shader, uniformName, uniform, baseName)
        end
    end
end

function MeshRender:sendUniform(shader, uniformName, uniform, baseName)
    local className = typeof(uniform)

    if className == 'table' and #uniform > 0 and classnameof(uniform[1]) == 'Light' then
        for i,light in ipairs(uniform) do
            self:_sendUniforms(shader, uniform[i], 'lights['..(i-1)..'].')
        end

    elseif className == 'Material' then
        self:_sendUniforms(shader, uniform, 'material.')

    else
        uniformName = (baseName or '')..uniformName

        if shader.program:hasUniform(uniformName) then
            if className == 'Color' then
                shader.program:send(uniformName, {uniform:unpack()})

            elseif className == 'vec2' then
                shader.program:send(uniformName, {uniform:unpack()})

            elseif className == 'vec3' then                
                shader.program:send(uniformName, {uniform:unpack()})

            elseif className == 'vec4' then
                shader.program:send(uniformName, {uniform:unpack()})

            elseif className == 'Image' then
                shader.program:send(uniformName, uniform.data)

            elseif className == 'boolean' then
                shader.program:send(uniformName, uniform and 1 or 0)

            else
                shader.program:send(uniformName, uniform)
            end

        else
            log('Send unknown uniform '..uniformName:quote()..' to shader '..shader.name:quote())
        end
    end
end
