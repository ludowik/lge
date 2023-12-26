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

function Model.test(w, h, d)
    local data, w, h, d = Model.model(w, h, d)

    local f1 = vec3(-w, -h,  d)
    local f2 = vec3( w, -h,  d)
    local f3 = vec3( w,  h,  d)
    local f4 = vec3(-w,  h,  d)
    
    local b1 = vec3( w, -h, -d)
    local b2 = vec3(-w, -h, -d)
    local b3 = vec3(-w,  h, -d)
    local b4 = vec3( w,  h, -d)

    Model.addFace(data, {f1, f2, f3, f1, f3, f4}, {colors.blue, colors.blue, colors.blue, colors.red, colors.red, colors.red}) -- front
    Model.addFace(data, {b2, f1, f4, b2, f4, b3}, {colors.red}) -- left
    
    local t = vec3(1, 0, 0)
    Model.addFace(data, {t+f1, t+f3, t+f2, t+f1, t+f4, t+f3}, {colors.blue, colors.blue, colors.blue, colors.red, colors.red, colors.red}) -- front 2

    return data
end

function Model.addFace(data, f, clr)
    data.texCoords:addArray{
        {0, 0},
        {1, 0},
        {1, 1},
        {0, 0},
        {1, 1},
        {0, 1},
    }
    
    for i,v in ipairs(f) do
        data.vertices:add({v:unpack()})
        data.colors:add({(clr[i] or clr[1]):rgba()})
    end
end

function Model.computeNormals(vertices, indices)
    local normals = Buffer('vec3')

    local n = indices and #indices or #vertices

    local v12, v13 = vec3(), vec3()

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
