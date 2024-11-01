Model = class()

function Model:init()
end

function Model.model(w, h, d)
    w = w or 0.5
    h = h or 0.5
    d = d or 0.5
    
    local data = {
        vertices = Array(),
        texCoords = Array(),
        colors = Array(),        
    }

    return data, w, h, d
end

function Model.line(x1, y1, x2, y2)
    local data = Model.model()

    local f1 = vec3(x1, y1, 0)
    local f2 = vec3(x2, y2, 0)
    
    Model.addFace(data, {f1, f2, f2, f1, f2, f1}, {colors.white}) -- line
    data.texCoords = {
        {-1}, {-1}, {1}, {-1}, {1}, {1},
    }

    return data
end

function Model.plane(w, h, d)
    local data, w, h, d = Model.model(w, h, d)
    h = 0
    
    local f3 = vec3( w,  h,  d)
    local f4 = vec3(-w,  h,  d)
    local b3 = vec3(-w,  h, -d)
    local b4 = vec3( w,  h, -d)
    
    Model.addFace(data, {f4, f3, b4, f4, b4, b3}, {colors.white}) -- up

    data.normals = Model.computeNormals(data.vertices)
    return data
end

function Model.ground(w, h, d, n)
    local data, w, h, d = Model.model(w, h, d)
    h = 0

    local f3 = vec3( w,  h,  d)
    local f4 = vec3(-w,  h,  d)
    local b3 = vec3(-w,  h, -d)
    local b4 = vec3( w,  h, -d)
    
    n = n or 10
    Model.addPlane(data, {f4, f3, b4, f4, b4, b3}, {colors.white}, n) -- up

    data.normals = Model.computeNormals(data.vertices)
    return data
end

function Model.box(w, h, d)
    local data, w, h, d = Model.model(w, h, d)
    
    local f1 = vec3(-w, -h,  d)
    local f2 = vec3( w, -h,  d)
    local f3 = vec3( w,  h,  d)
    local f4 = vec3(-w,  h,  d)
    
    local b1 = vec3( w, -h, -d)
    local b2 = vec3(-w, -h, -d)
    local b3 = vec3(-w,  h, -d)
    local b4 = vec3( w,  h, -d)
    
    Model.addFace(data, {f1, f2, f3, f1, f3, f4}, {colors.blue}) -- front
    Model.addFace(data, {b1, b2, b3, b1, b3, b4}, {colors.green}) -- back
    Model.addFace(data, {b2, f1, f4, b2, f4, b3}, {colors.red}) -- left
    Model.addFace(data, {f2, b1, b4, f2, b4, f3}, {colors.orange}) -- right
    Model.addFace(data, {f4, f3, b4, f4, b4, b3}, {colors.white}) -- up
    Model.addFace(data, {f2, f1, b2, f2, b2, b1}, {colors.yellow}) -- bottom

    local w, h = 1/4, 1/3
    data.texCoords = {
        {w,2*h}, {2*w,2*h}, {2*w,h}, {w,2*h}, {2*w,h}, {w,h},
        {3*w,2*h}, {0.99,2*h}, {0.99,h}, {3*w,2*h}, {0.99,h}, {3*w,h},
        {0,2*h}, {w,2*h}, {w,h}, {0,2*h}, {w,h}, {0,h},
        {2*w,2*h}, {3*w,2*h}, {3*w,h}, {2*w,2*h}, {3*w,h}, {2*w,h},
        {w,3*h}, {2*w,3*h}, {2*w,2*h}, {w,3*h}, {2*w,2*h}, {w,2*h},
        {w,h}, {2*w,h}, {2*w,0}, {w,h}, {2*w,0}, {w,0},
    }

    data.normals = Model.computeNormals(data.vertices)
    return data
end

function Model.skybox()
    local data, w, h, d = Model.model(10^5, 10^5, 10^5)
    
    local f1 = vec3(-w, -h, -d)
    local f2 = vec3( w, -h, -d)
    local f3 = vec3( w,  h, -d)
    local f4 = vec3(-w,  h, -d)
    
    local b1 = vec3( w, -h,  d)
    local b2 = vec3(-w, -h,  d)
    local b3 = vec3(-w,  h,  d)
    local b4 = vec3( w,  h,  d)
    
    Model.addFace(data, {f1, f2, f3, f1, f3, f4}, {colors.white}) -- front
    Model.addFace(data, {b1, b2, b3, b1, b3, b4}, {colors.white}) -- back
    Model.addFace(data, {b2, f1, f4, b2, f4, b3}, {colors.white}) -- left
    Model.addFace(data, {f2, b1, b4, f2, b4, f3}, {colors.white}) -- right
    Model.addFace(data, {f4, f3, b4, f4, b4, b3}, {colors.white}) -- up
    Model.addFace(data, {f2, f1, b2, f2, b2, b1}, {colors.white}) -- bottom

    local w, h = 1/4, 1/3
    data.texCoords = {
        {w,2*h}, {2*w,2*h}, {2*w,h}, {w,2*h}, {2*w,h}, {w,h},
        {3*w,2*h}, {0.99,2*h}, {0.99,h}, {3*w,2*h}, {0.99,h}, {3*w,h},
        {0,2*h}, {w,2*h}, {w,h}, {0,2*h}, {w,h}, {0,h},
        {2*w,2*h}, {3*w,2*h}, {3*w,h}, {2*w,2*h}, {3*w,h}, {2*w,h},
    }

    return data
end

function Model.sphere(w, h, d)
    local data, w, h, d = Model.model(w, h, d)
    
    local f1 = vec3(-w, -h,  d)
    local f2 = vec3( w, -h,  d)
    local f3 = vec3( w,  h,  d)
    local f4 = vec3(-w,  h,  d)
    
    local b1 = vec3( w, -h, -d)
    local b2 = vec3(-w, -h, -d)
    local b3 = vec3(-w,  h, -d)
    local b4 = vec3( w,  h, -d)
    
    Model.addPlane(data, {f1, f2, f3, f1, f3, f4}, {colors.blue}) -- front
    Model.addPlane(data, {b1, b2, b3, b1, b3, b4}, {colors.green}) -- back
    Model.addPlane(data, {b2, f1, f4, b2, f4, b3}, {colors.red}) -- left
    Model.addPlane(data, {f2, b1, b4, f2, b4, f3}, {colors.orange}) -- right
    Model.addPlane(data, {f4, f3, b4, f4, b4, b3}, {colors.white}) -- up
    Model.addPlane(data, {f2, f1, b2, f2, b2, b1}, {colors.yellow}) -- bottom

    for i,v in ipairs(data.vertices) do
        data.vertices[i] = {vec3.fromArray(v):normalize():div(2):unpack()}
    end

    data.normals = Model.computeNormals(data.vertices)
    return data
end

function Model.sphere2(w, h, d)
    local x, y, z = 0, 0, 0
    local data, w, h, d = Model.model(w, h, d)
    
    local hw, hh, hd = w, h, d

    local vertices = data.vertices

    local function coord(x, y, z, w, h, d, phi, theta)
        phi = rad(phi)
        theta = rad(theta)

        return vec3(
            x + hw * cos(phi) * sin(theta),
            y + hh * cos(phi) * cos(theta),
            z + hd * sin(phi))
    end

    local function meshAddRect(vertices, v1, v2, v3, v4)
        vertices:insert({v1:unpack()})
        vertices:insert({v2:unpack()})
        vertices:insert({v3:unpack()})
    
        vertices:insert({v1:unpack()})
        vertices:insert({v3:unpack()})
        vertices:insert({v4:unpack()})
    end
    
    local faces = 0
    local delta = 2

    local v1, v2, v3, v4
    for theta = 0, 360-delta, delta do
        for phi = 90, 270-delta, delta do
            v1 = coord(x, y, z, w, h, d, phi, theta)
            v2 = coord(x, y, z, w, h, d, phi, theta+delta)
            v3 = coord(x, y, z, w, h, d, phi+delta, theta+delta)
            v4 = coord(x, y, z, w, h, d, phi+delta, theta)

            meshAddRect(vertices,
                v1,
                v2,
                v3,
                v4)

            faces = faces + 1
        end
    end

    -- local texCoords = Buffer('vec2')
    -- for s = 1, faces do
    --     texCoords:addItems(texCoords_face)
    -- end

    -- local normals = Buffer('vec3')
    -- for i = 1, #vertices do
    --     normals[i] = vertices[i]:normalize()
    -- end

    data.normals = Model.computeNormals(data.vertices)
    return data
end

function Model.addFace(data, f, clr)
    data.texCoords:addArray{
        {0, 0}, {1, 0}, {1, 1}, {0, 0}, {1, 1}, {0, 1},
    }
    
    for i,v in ipairs(f) do
        data.vertices:add({v:unpack()})
        data.colors:add({(clr[i] or clr[1]):rgba()})
    end
end

function Model.addPlane(data, f, clr, n)
    n = n or 10

    local a, b, c
    a = (f[1])
    b = (f[2] - f[1]) / n
    c = (f[6] - f[1]) / n

    for i=1,n do
        for j=1,n do
            data.texCoords:addArray{
                {(i-1)/n, (j-1)/n},
                {(i  )/n, (j-1)/n},
                {(i  )/n, (j  )/n},
                {(i-1)/n, (j-1)/n},
                {(i  )/n, (j  )/n},
                {(i-1)/n, (j  )/n},
            }

            for _,v in ipairs(f) do
                data.vertices:add({(
                    (a) +
                    (v-a)/(n) +
                    (b)*(j-1) +
                    (c)*(i-1)
                ):unpack()})
                data.colors:add({(clr[i] or clr[1]):rgba()})
            end
        end
    end
end

function Model.computeNormals(vertices, indices)
    local normals = Buffer('vec3')

    local v12, v13 = vec3(), vec3()

    local n = indices and #indices or #vertices
    n = floor(n/3)*3
     
    local v1, v2, v3
    
    for i=1,n,3 do
        if indices then
            v1 = vec3.fromArray(vertices[indices[i]])
            v2 = vec3.fromArray(vertices[indices[i+1]])
            v3 = vec3.fromArray(vertices[indices[i+2]])
        else
            v1 = vec3.fromArray(vertices[i])
            v2 = vec3.fromArray(vertices[i+1])
            v3 = vec3.fromArray(vertices[i+2])
        end

        v12:set(v2):sub(v1)
        v13:set(v3):sub(v1)

        local normal = v12:crossInPlace(v13):normalizeInPlace()

        normals[i+0] = {normal:unpack()}
        normals[i+1] = normals[i+0]
        normals[i+2] = normals[i+0]
    end

    return normals
end

function Model.getMinMax(vertices, indices)
    local minx, miny, minz =  math.maxinteger,  math.maxinteger,  math.maxinteger
    local maxx, maxy, maxz = -math.maxinteger, -math.maxinteger, -math.maxinteger

    local function updateMinMax(v)
        minx = min(minx, v.x)
        miny = min(miny, v.y)
        minz = min(minz, v.z)

        maxx = max(maxx, v.x)
        maxy = max(maxy, v.y)
        maxz = max(maxz, v.z)
    end

    local n = indices and #indices or #vertices
    
    local v
    for i=1,n do
        if indices then
            v = vec3.fromArray(vertices[indices[i]])
        else
            v = vec3.fromArray(vertices[i])
        end

        updateMinMax(v)
    end

    return minx, miny, minz, maxx, maxy, maxz
end

function Model.centerVertices(vertices, indices)
    local minx, miny, minz, maxx, maxy, maxz = Model.getMinMax(vertices, indices)
    local n = indices and #indices or #vertices

    local d = -vec3(
        minx + (maxx - minx) / 2,
        miny + (maxy - miny) / 2,
        minz + (maxz - minz) / 2)

    local function translateVertex(v, d)
        v[1] = v[1] + d.x
        v[2] = v[2] + d.y
        v[3] = v[3] + d.z
    end

    for i=1,n do
        if indices then
            v = vertices[indices[i]]
        else
            v = vertices[i]
        end

        translateVertex(v, d)
    end

    return vertices
end

function Model.normalize(vertices, indices)
    local minx, miny, minz, maxx, maxy, maxz = Model.getMinMax(vertices, indices)
    local n = indices and #indices or #vertices

    local scale = 1 / max(
        (maxx - minx),
        (maxy - miny),
        (maxz - minz))

    local function scaleVertex(v, scale)
        v[1] = v[1] * scale
        v[2] = v[2] * scale
        v[3] = v[3] * scale
    end

    for i=1,n do
        if indices then
            v = vertices[indices[i]]
        else
            v = vertices[i]
        end

        scaleVertex(v, scale)
    end

    return vertices
end
