mesh = class 'Mesh' : extends(MeshRender)

function Mesh:init(...)
    MeshRender.init(self)

    self:clear(...)
end

function Mesh:clear(vertices, colors, normals)
    MeshRender.clear(self)

    if vertices and vertices.vertices then 
        vertices, colors = vertices.vertices, vertices.colors
    end

    self.vertices = vertices or Buffer('vec3')
    self.colors = colors or Buffer('color')
    self.texCoords = Buffer('vec2')
    self.normals = normals or Buffer('vec3')
end

function Mesh:buffer(name)
    if name == 'position' then
        return self.vertices

    elseif name == 'colors' then
        return self.colors

    elseif name == 'texCoord' then
        return self.texCoords

    elseif name == 'normals' then
        return self.normals
    end
end

function Mesh:setColors(...)
    local clr = Color(...)

    self.colors = self.colors or Buffer('color')

    local vertexCount
    if type(self.vertices[1]) == 'cdata' then
        vertexCount = #self.vertices
        assert()
    else
        vertexCount = #self.vertices
    end

    for i=1,vertexCount do
        self.colors[self:getIndex(i)] = clr
    end

    return self
end

function Mesh:vertex(i, v)
    self.needUpdate = true

    self.vertices[i] = v
end

function Mesh:color(i, ...)
    self.needUpdate = true
    self.colorMode = 'colors'
    self.colors[self:getIndex(i)] = Color(...)
end

function Mesh:addRect(x, y, w, h, r)
    self.needUpdate = true

    local idx = #self.vertices + 1

    self:setRectTex(idx, 0, 0, 1, 1)
    self:setRectColor(idx, 1, 1, 1, 1)
    self:setRect(idx, x, y, w, h, r)

    return idx
end

function Mesh:setRect(idx, x, y, w, h, r)
    self.needUpdate = true

    r = r or 0

    self.vertices[idx+0] = vec3(-w/2,  h/2, 0)
    self.vertices[idx+1] = vec3(-w/2, -h/2, 0)
    self.vertices[idx+2] = vec3( w/2, -h/2, 0)
    self.vertices[idx+3] = vec3(-w/2,  h/2, 0)
    self.vertices[idx+4] = vec3( w/2, -h/2, 0)
    self.vertices[idx+5] = vec3( w/2,  h/2, 0)

    if r ~= 0 then
        local c = cos(r)
        local s = sin(r)

        for i = idx, idx+5 do
            local v = self.vertices[i]
            self.vertices[i]:set(
                v.x * c - v.y * s,
                v.y * c + v.x * s,
                0)
        end
    end

    local position = vec3(x, y, 0)
    for i = idx, idx+5 do
        self.vertices[i]:add(position)
    end
end

function Mesh:addRectCorner(x, y, w, h, r)
    self.needUpdate = true

    local idx = #self.vertices + 1

    self:setRectTex(idx, 0, 0, 1, 1)
    self:setRectColor(idx, 1, 1, 1, 1)
    self:setRectCorner(idx, x, y, w, h, r)

    return idx
end

function Mesh:setRectCorner(idx, x, y, w, h)
    self.needUpdate = true

    self.vertices[idx+0] = vec3(x  , y+h, 0)
    self.vertices[idx+1] = vec3(x  , y  , 0)
    self.vertices[idx+2] = vec3(x+w, y  , 0)
    self.vertices[idx+3] = vec3(x  , y+h, 0)
    self.vertices[idx+4] = vec3(x+w, y  , 0)
    self.vertices[idx+5] = vec3(x+w, y+h, 0)
end

function Mesh:getIndex(idx)
    if self.indices and #self.indices > 0 then
        return self.indices[idx]
    end  
    return idx
end

function Mesh:setRectColor(idx, ...)
    self.needUpdate = true

    local clr = Color(...)

    self.colors = self.colors or Buffer('color')
    for i = idx, idx+5 do
        self.colors[self:getIndex(i)] = clr
    end
end

function Mesh:setRectTex(idx, s, t, w, h)
    self.needUpdate = true

    local sw = s + w
    local th = t + h

    self.texCoords = self.texCoords or Buffer('vec2')

    self.texCoords[self:getIndex(idx+0)] = vec2(s , t)
    self.texCoords[self:getIndex(idx+1)] = vec2(s , th)
    self.texCoords[self:getIndex(idx+2)] = vec2(sw, th)
    self.texCoords[self:getIndex(idx+3)] = vec2(s , t)
    self.texCoords[self:getIndex(idx+4)] = vec2(sw, th)
    self.texCoords[self:getIndex(idx+5)] = vec2(sw, t)
end

function Mesh:setGradient(clr1, clr2)
    local clr = color(clr1)
    local step = (clr2 - clr1) / (#self.vertices - 1)
    for i=1,#self.vertices do
        self:color(i, clr.r, clr.g, clr.b, clr.a)
        clr.r = clr.r + step.r
        clr.g = clr.g + step.g
        clr.b = clr.b + step.b
        clr.a = clr.a + step.a
    end
end

function Mesh:normalize(norm)
    norm = norm or 1
    self.vertices = Model.normalize(self.vertices, norm)
    return self
end

function Mesh:center()
    Model.center(self.vertices)
    return self
end

function Mesh:boudingBox()
    local xmin, ymin, xmax, ymax = math.maxinteger, math.maxinteger, -math.maxinteger, -math.maxinteger

    for i,v in ipairs(self.vertices) do
        xmin = min(xmin, v.x)
        ymin = min(ymin, v.y)
        xmax = max(xmax, v.x)
        ymax = max(ymax, v.y)
    end
    return Rect(xmin, ymin, xmax-xmin, ymin-ymax)
end
