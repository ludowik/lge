class 'Model'

local v = 0.5

local p1 = vec3(-v, 0, -v)
local p2 = vec3( v, 0, -v)
local p3 = vec3( v, 0,  v)
local p4 = vec3(-v, 0,  v)

local f1 = vec3(-v, -v, -v)
local f2 = vec3( v, -v, -v)
local f3 = vec3( v,  v, -v)
local f4 = vec3(-v,  v, -v)

local b1 = vec3(-v, -v, v)
local b2 = vec3( v, -v, v)
local b3 = vec3( v,  v, v)
local b4 = vec3(-v,  v, v)

local u5 = vec3(v, v, v)

local cos, sin = math.cos, math.sin

function Model.setup()
    -- face
    texCoords_face = Buffer('vec2', {
            vec2(0,0),
            vec2(1,0),
            vec2(1,1),
            vec2(0,0),
            vec2(1,1),
            vec2(0,1)
        })

    -- triangle
    texCoords_triangle = Buffer('vec2', {
            vec2(0,0),
            vec2(1,0),
            vec2(0.5,1)
        })

    -- pyramid
    vertices_pyramid = Buffer('vec3', {
            f1,f2,u5, -- front
            f2,b2,u5, -- right
            b2,b1,u5, -- back
            b1,f1,u5, -- left
            f2,f1,b1,f2,b1,b2  -- down
        })

    -- tetrahedron
    vertices_tetra = Buffer('vec3', {
            f1,f3,b4,
            f1,b2,f3,
            b2,b4,f3,
            b2,f1,b4
        })
end

function Model.mesh(vertices, texCoords, normals, indices)
    local m = Mesh()

    m.vertices = vertices or m.vertices
    m.texCoords = texCoords or m.texCoords
    m.normals = normals or m.normals
    m.indices = indices or m.indices

    if m.normals == nil or #m.normals == 0 then
        m.normals = Model.computeNormals(m.vertices)
    end

    if m.indices == nil or #m.indices == 0 then
        m.vertices, m.texCoords, m.normals, m.colors, m.indices = Model.computeIndices(m.vertices, m.texCoords, m.normals, m.colors)
    end

    return m
end

function Model.add(m1, m2)
    if m2.vertices then
        m1.vertices:addItems(m2.vertices:clone())
    end
    if m2.colors then
        m1.colors:addItems(m2.colors:clone())
    end
    if m2.texCoords then
        m1.texCoords:addItems(m2.texCoords:clone())
    end
    if m2.normals then
        m1.normals:addItems(m2.normals:clone())
    end
end

function Model.set(m, p)
    m.vertices = p.vertices or m.vertices
    m.texCoords = p.texCoords or m.texCoords
    m.normals = p.normals or m.normals
end

function Model.computeIndices(vertices, texCoords, normals, colors)
    local v = Buffer('vec3')
    local t = texCoords and Buffer('vec2')
    local n = normals and Buffer('vec3')
    local c = colors and Buffer('Color')

    local indices = Buffer('unsigned short')
    local verticesIndices = {}
    local nbIndices = 1

    for i=1,#vertices do
        local find = false

        local key = string.format('%f;%f;%f', vertices[i].x, vertices[i].y, vertices[i].z)
        if verticesIndices[key] then
            for _j=1,#verticesIndices[key] do
                local j = verticesIndices[key][_j]
                if ((v[j] == vertices[i] ) and
                    (texCoords == nil or t[j] == texCoords[i]) and
                    (normals   == nil or n[j] == normals[i]))
                then
                    find = j
                    indices[i] = find -- index from 1
                    break
                end
            end
        else
            verticesIndices[key] = Array()
        end

        if not find then
            v[nbIndices] = vertices[i]
            if texCoords then
                t[nbIndices] = texCoords[i]
            end
            if normals then
                n[nbIndices] = normals[i]
            end
            if colors then
                c[nbIndices] = colors[i]
            end

            indices[i] = nbIndices -- index from 1
            verticesIndices[key]:add(nbIndices)
            nbIndices = nbIndices + 1
        end        
    end

    return v, t, n, c, indices
end

function Model.averageNormals(vertices, normals)
    local t = Buffer('vec3')

    for i=1,#normals do
        local vertex = vertices[i]
        local normal = normals[i]

        local ref = vertex.x.."."..vertex.y

        if t[ref] == nil then
            t[ref] = normal
        else
            t[ref] = t[ref] + normal
        end
    end

    for i=1,#normals do
        normals[i]:normalizeInPlace()
    end

    return t
end

function Model.gravityCenter(vertices)
    local v = Point()
    for i=1,#vertices do
        v = v + vertices[i]
    end

    v = v / #vertices

    for i=1,#vertices do
        vertices[i]:sub(v)
    end
end




function Model.transform(vertices, matrix)
    for i=1,#vertices do
        vertices[i] = matByVector(matrix, vertices[i]):tovec3()
    end

    return vertices
end

function Model.scale(vertices, w, h, e)
    w = w or 1
    e = e or h and 1 or w
    h = h or w

    local m = matrix()
    m = m:scale(w, h, e)

    return Model.transform(Table.clone(vertices), m)
end

function Model.translate(vertices, x, y, z)
    x = x or 0
    z = z or y and 0 or x
    y = y or x

    local m = matrix()
    m = m:translate(x, y, z)

    return Model.transform(Table.clone(vertices), m)
end

function Model.scaleAndTranslateAndRotate(vertices, x, y, z, w, h, e, ax, ay, az)
    x = x or 0
    z = z or y and 0 or x
    y = y or x

    w = w or 1
    h = h or w
    e = e or w

    ax = ax or 0
    ay = ay or 0
    az = az or 0

    m1 = translate_matrix(nil, x, y, z)

    m2 = rotate_matrix(nil, ax, 1,0,0, DEGREES)
    m3 = rotate_matrix(nil, ay, 0,1,0, DEGREES)
    m4 = rotate_matrix(nil, az, 0,0,1, DEGREES)

    m5 = scale_matrix(nil, w, h, e)

    return Model.transform(vertices:clone(), m1*m2*m3*m4*m5)
end

function Model.point(x, y)
    x = x or 0
    y = y or 0

    return Model.mesh(Buffer('vec3', vec3(x, y, 0)))
end

function Model.points(points)
    local vertices = Buffer('vec3')

    for i=1,#points,3 do
        vertices:insert(vec3(points[i+0], points[i+1], 0))
    end

    return Model.mesh(vertices)
end

function Model.line(x, y, w, h)
    x = x or 0
    y = y or 0

    w = w or 1
    h = h or 1

    local vertices = Buffer('vec3',
        vec3(x, y, 0),
        vec3(x+w, y+h, 0))

    return Model.mesh(vertices)
end

function Model.line3D(x, y, z, w, h, d)
    x = x or 0
    y = y or 0
    z = z or 0

    w = w or 1
    h = h or 1
    d = d or 1

    local vertices = Buffer('vec3',
        vec3(x, y, z),
        vec3(x+w, y+h, z+d))

    return Model.mesh(vertices)
end

function Model.rect(x, y, w, h)
    x = x or 0
    y = y or 0
    w = w or 1
    h = h or 1

    local vertices = Buffer('vec3',
        vec3(x+0, y+0, 0),
        vec3(x+w, y+0, 0),
        vec3(x+w, y+h, 0),
        vec3(x+0, y+0, 0),
        vec3(x+w, y+h, 0),
        vec3(x+0, y+h, 0))

    local texCoords = Buffer('vec2',
        vec2(0,0),
        vec2(1,0),
        vec2(1,1),
        vec2(0,0),
        vec2(1,1),
        vec2(0,1))

    return Model.mesh(vertices, texCoords)
end

function Model.rectBorder(x, y, w, h)
    x = x or 0
    y = y or 0
    w = w or 1
    h = h or 1

    local vertices = Buffer('vec3',
        vec3(x+0, y+0, 0),
        vec3(x+w, y+0, 0),
        vec3(x+w, y+h, 0),
        vec3(x+0, y+h, 0))

    return Model.mesh(vertices)
end

function Model.ellipse(x, y, w, h)
    x = x or 0
    y = y or 0
    w = w or 1
    h = h or 1

    local vertices = Buffer('vec3')

    local n = 128

    local x1, y1 = cos(0) / 2, sin(0) / 2
    local x2, y2 = 0, 0

    for i=n,0,-1 do
        x2 = cos(TAU * i / n) / 2
        y2 = sin(TAU * i / n) / 2

        vertices:insert(vec3())
        vertices:insert(vec3(x2, y2, 0))
        vertices:insert(vec3(x1, y1, 0))

        x1, y1 = x2, y2
    end

    return Model.mesh(vertices)
end

function Model.ellipseBorder(x, y, w, h)
    x = x or 0
    y = y or 0
    w = w or 1
    h = h or 1

    local vertices = Buffer('vec3')

    local n = 128

    local x, y

    for i=0,n do
        x = cos(TAU * i / n) / 2
        y = sin(TAU * i / n) / 2

        vertices:insert(vec3(x, y, 0))
    end

    return Model.mesh(vertices)
end

function Model.box(w, h, d)
    local vertices = Buffer('vec3', {
            f1, f2, f3, f1, f3, f4, -- front
            b2, b1, b4, b2, b4, b3, -- back
            b1, f1, f4, b1, f4, b4, -- left
            f2, b2, b3, f2, b3, f3, -- right
            f4, f3, b3, f4, b3, b4, -- top
            f2, f1, b1, f2, b1, b2, -- bottom
        })

    local wt = 1/4-1/100
    local ht = 1/3-1/100

    local texCoords = Buffer('vec2')

    local function add(coords, dx, dy)
        for i=0,5 do
            texCoords:insert(vec2(coords[i*2+1] + dx, coords[i*2+2] + dy))
        end
    end

    add({0,0, wt,0, wt,ht, 0,0, wt,ht, 0,ht}, 1/4, 1/3)
    add({0,0, wt,0, wt,ht, 0,0, wt,ht, 0,ht}, 3/4, 1/3)
    add({0,0, wt,0, wt,ht, 0,0, wt,ht, 0,ht}, 2/4, 1/3)
    add({0,0, wt,0, wt,ht, 0,0, wt,ht, 0,ht}, 0/4, 1/3)
    add({0,0, wt,0, wt,ht, 0,0, wt,ht, 0,ht}, 1/4, 2/3)
    add({0,0, wt,0, wt,ht, 0,0, wt,ht, 0,ht}, 1/4, 0/3)

    local m = Model.mesh(
        vertices,
        texCoords)

    -- front
    m:setRectColor(1, colors.green)

    -- back
    m:setRectColor(7, colors.yellow)

    -- left
    m:setRectColor(13, colors.orange)

    -- right
    m:setRectColor(19, colors.red)

    -- up
    m:setRectColor(25, colors.white)

    -- down
    m:setRectColor(31, colors.blue)

    return m
end

function Model.tetrahedron(x, y, z, w, h, d)
    x, y, z, w, h, d = positionAndSize(x, y, z, w, h, d)

    local vertices = vertices_tetra
    vertices = Model.scaleAndTranslateAndRotate(vertices, 0, 0, 0, w, h, d, 90)

    return Model.mesh(vertices,
        nil,
        Model.computeNormals(vertices_tetra))
end

function Model.pyramid(w, h, d)
    w = w or 1
    h = h or w
    d = d or w

    local vertices = vertices_pyramid

    local texCoords = Buffer('vec2')
    for s = 1,4 do
        texCoords:addItems(texCoords_triangle)
    end
    texCoords:addItems(texCoords_face)

    return Model.mesh(
        Model.scaleAndTranslateAndRotate(vertices, -w/2, -h/2, -d/2, w, h, d),
        texCoords)
end

function Model.cone(r, e, delta)
    r = r or 0.5
    e = e or 1

    local points = Buffer('vec3')
    Geometry.arc(points, 0, 0, r, 0, TAU, delta)

    local vertices = Buffer('vec3')

    local vc = vec3(r, r, 0.0)
    local v1 = points[1]

    for i = 2, #points do
        local v2 = points[i]
        meshAddTriangle(vertices, vc, v2, v1)
        v1 = v2
    end

    vc = vec3(r, r, e)
    v1 = points[1]

    for i = 2, #points do
        local v2 = points[i]
        meshAddTriangle(vertices, vc, v1, v2)
        v1 = v2
    end

    local texCoords = Buffer('vec2')
    for s = 1, 2*#points do
        texCoords:addItems(texCoords_triangle)
    end

    return Model.mesh(
        Model.scaleAndTranslateAndRotate(vertices, -r, -r, -e/2, 1, 1, 1, -90, 0, 0),
        texCoords)
end

function Model.cylinder(r1, r2, e, delta)
    r1 = r1 or 0.5
    r2 = r2 or 0.5

    e = e or 1

    delta = delta or TAU*.05

    local points1 = Buffer('vec3')
    Geometry.arc(points1, 0, 0, r1, 0, TAU, delta)
    points1 = Model.scaleAndTranslateAndRotate(points1, -r1, -r1)

    local points2 = Buffer('vec3')
    Geometry.arc(points2, 0, 0, r2, 0, TAU, delta)
    points2 = Model.scaleAndTranslateAndRotate(points2, -r2, -r2)

    local vertices = Buffer('vec3')

    local vc = vec3(0, 0, 0)
    local v1 = points1[1]

    for i = 2, #points1 do
        local v2 = points1[i]
        meshAddTriangle(vertices, vc, v2, v1)
        v1 = v2
    end

    vc = vec3(0, 0, e)
    v1 = points2[1]

    for i = 2, #points2 do
        local v2 = points2[i]
        meshAddTriangle(vertices, vc, vec3(v1.x, v1.y, e), vec3(v2.x, v2.y, e))
        v1 = v2
    end

    v1 = points1[1]
    v4 = points2[1]

    for i = 2, #points2 do
        local v2 = points1[i]
        local v3 = points2[i]
        meshAddRect(vertices, v1, v2, vec3(v3.x, v3.y, e), vec3(v4.x, v4.y, e))
        v1 = v2
        v4 = v3
    end

    local texCoords = Buffer('vec2')
    for s = 1, 2*#points1-2 do
        texCoords:addItems(texCoords_triangle)
    end
    for s = 2, #points2 do
        texCoords:addItems(texCoords_face)
    end

    return Model.mesh(
        vertices,
        texCoords)
end

function Model.obelix()
    local vertices = {}

    local a = Model.cylinder(1, 0.5, 2)
    local b = Model.cone(.5)

    Table.addItems(vertices, Model.scaleAndTranslateAndRotate(a.mesh.vertices))
    Table.addItems(vertices, Model.scaleAndTranslateAndRotate(b.mesh.vertices, 0, 0, 0))

    return Model.mesh(vertices, texCoords)
end

function Model.grass_band(vertices, p1, p2, w, h, angle)
    local e = sin(angle) * h

    local p3 = vec3(p2.x-w*.5, p2.y+e, p2.z+h)
    local p4 = vec3(p1.x+w*.5, p1.y+e, p1.z+h)

    meshAddRect(vertices, p1, p2, p3, p4)

    return p4, p3
end

function Model.grass_alea(vertices, texCoords, normals)
    local v = {}

    local w = random(0.25, 0.50)
    local h = random(7.5, 15)
    local e = random(0, h)

    local p1 = vec3(-w*.5, 0, 0)
    local p2 = vec3( w*.5, 0, 0)

    local n = 5

    local angle = 0

    for i = 1, n do
        p1, p2 = Model.grass_band(v, p1, p2, w*.5/n, h/n, angle)
        angle = angle + 90/n
    end

    Model.scaleAndTranslateAndRotate(v, random(0,wcell), random(0,wcell), 0, 1, 1, 1, random(0,360))

    table.addItems(vertices, v)
    table.addItems(normals, Model.computeNormals(v))
end

function Model.grass(n)
    local vertices = {}
    local texCoords = {}
    local normals = {}

    n = n or 1
    for i = 1, n do
        Model.grass_alea(vertices, texCoords, normals)
    end

    return Model.mesh(
        vertices, texCoords, normals)
end

function Model.ground(n)
    n = n or 100
    
    local dec = -(n-1)/2

    local vertices_face = Buffer('vec3', {
            p1,p2,p3,p1,p3,p4
        })

    local ground = mesh()
    for x=0,n-1 do
        for z=0,n-1 do
            Model.add(ground, {
                    vertices = Model.scaleAndTranslateAndRotate(vertices_face, x+dec, 0, z+dec),
                    texCoords_face = texCoords_face
                })
        end
    end
    return ground
end

function Model.plane(x, y, z, w, h, d)
    x, y, z, w, h, d = positionAndSize(x, y, z, w, h, d)

    local vertices_face = Buffer('vec3', {
            p1,p2,p3,p1,p3,p4
        })

    vertices_face = Model.scaleAndTranslateAndRotate(vertices_face, x, y, z, w, h, d, 0)

    return Model.mesh(
        vertices_face:clone(),
        texCoords_face:clone(),
        Model.computeNormals(vertices_face))
end

function Model.dalle(x, y, z)
    local vertices = Buffer('vec3')

    local m = 0.25
    for i = 0, 4 do
        vertices:addItems(Model.scaleAndTranslateAndRotate(vertices_box, m, i*10+m, 0, 50-m*2, 10-m*2, 2.5))
        vertices:addItems(Model.scaleAndTranslateAndRotate(vertices_box, 50+m, 50+i*10+m, 0, 50-m*2, 10-m*2, 2.5))
    end

    for i = 0, 4 do
        vertices:addItems(Model.scaleAndTranslateAndRotate(vertices_box, 50+i*10+m, m, 0, 10-m*2, 50-m*2, 2.5))
        vertices:addItems(Model.scaleAndTranslateAndRotate(vertices_box, i*10+m, 50+m, 0, 10-m*2, 50-m*2, 2.5))
    end

    vertices = Model.scaleAndTranslateAndRotate(vertices, x, y, z)

    return Model.mesh(
        vertices,
        texCoords)
end

function Model.complex()
    --  local str = "10004,20004,30004,44444"
    --  local str = "30000,31111,32222,43333"
    local str = "989898989,877777778,977777779,877777778,977777779,877777778,977777779,877777778,989898989"

    local vertices = {}

    local texCoords = {}

    local x = 0
    local z = 0

    local m = Model.box()
    for h in str:gmatch(".") do
        if h == ',' then
            x = 0
            z = z + 1
        else
            for y = 0, tonumber(h)-1 do
                local verticesbox, texCoordsbox = m.vertices, m.texCoords

                Table.addItems(vertices, Model.scaleAndTranslateAndRotate(verticesbox, x, y, z))
                if texCoordsbox then
                    Table.addItems(texCoords, texCoordsbox)
                end
            end

            x = x + 1
        end
    end

    return Model.mesh(
        vertices,
        texCoords,
        Model.computeNormals(vertices))
end

function Model.teapot()
    return Model.load('teapot')
end

function Model.skybox(w, h, d)
    w = w or 1
    h = w
    d = w

    local vertices = Buffer('vec3', {
            f1, f2, f3, f1, f3, f4, -- front
            b2, b1, b4, b2, b4, b3, -- back
            f2, b2, b3, f2, b3, f3, -- right
            b1, f1, f4, b1, f4, b4, -- left
            f4, f3, b3, f4, b3, b4, -- top
            b1, b2, f2, b1, f2, f1, -- bottom
        })

    return Model.mesh(
        Model.scaleAndTranslateAndRotate(vertices, 0, 0, 0, w, h, -d),
        texCoords_box,
        Model.computeNormals(vertices))
end

function Model.triangulate(points)
    local mypoints = Buffer('vec3')
    for i = 1, #points do
        mypoints:insert(vec3(points[i].x, points[i].y))
    end

    if #points == 1 then
        return {mypoints[1], mypoints[1], mypoints[1]}

    elseif #points == 2 then
        return {mypoints[1], mypoints[1], mypoints[2]}

    elseif #points == 3 then
        return mypoints
    end

    -- result
    local trivecs = Buffer('vec3')

    local steps_without_reduction = 0

    local i = 1

    while #mypoints >= 3 and steps_without_reduction < #mypoints do
        local v2i = i % #mypoints + 1
        local v3i = (i + 1) % #mypoints + 1

        local v1 = mypoints[i]
        local v2 = mypoints[v2i]
        local v3 = mypoints[v3i]

        local da = vec2.enclosedAngle(v1, v2, v3)

        local reduce = false
        if da >= 0 then
            -- The two edges bend inwards, candidate for reduction.
            reduce = true
            -- Check that there's no other point inside.
            for ii = 1, (#mypoints - 3) do
                local mod_ii = (i + 2 + ii - 1) % #mypoints + 1
                if vec2.isInsideTriangle(mypoints[mod_ii], v1, v2, v3) then
                    reduce = false
                end
            end
        end

        if reduce then
            trivecs:insert(v1)
            trivecs:insert(v2)
            trivecs:insert(v3)

            mypoints:remove(v2i)

            steps_without_reduction = 0
        else
            i = i + 1
            steps_without_reduction = steps_without_reduction + 1
        end

        if i > #mypoints then
            i = i - #mypoints
        end
    end
    return trivecs
end

function triangulate(...)
    return Model.triangulate(...)
end

Model.random = {}

function Model.random.polygon(r, rmax, rmin)
    r = r or math.random(10, 50)

    rmax = rmax or r
    rmin = rmin or r

    local vertices = Buffer('vec3')

    local angle = 0
    while angle < TAU do
        local len = math.random(rmin, rmax)

        local p = vec3(
            len * cos(angle),
            len * sin(angle),
            0)

        vertices:insert(p)

        angle = angle + math.random() * math.pi / 2
    end

    return vertices
end

function Model.load(fileName, normalize)
    local m = loadObj(fileName)
    if m then
        if #m.vertices == 0 and normalize then
            m.vertices = Model.normalize(m.vertices)
        end

        if #m.normals == 0 then
            m.normals = Model.computeNormals(m.vertices)
        end

        return m
    end
end


function Model.setColors(colors, clr)
    for i=#colors-5,#colors do
        colors[i] = clr
    end
end

function Model.computeNormals(vertices, indices, mode)
    local normals = Buffer('vec3')

    local n = indices and #indices or #vertices

    local v12, v13 = vec3(), vec3()

    local v1, v2, v3

    if not mode then
        for i=1,n,3 do
            if indices then
                v1 = vertices[indices[i]]
                v2 = vertices[indices[i+1]]
                v3 = vertices[indices[i+2]]
            else
                v1 = vertices[i]
                v2 = vertices[i+1]
                v3 = vertices[i+2]
            end

            v12:set(v2):sub(v1)
            v13:set(v3):sub(v1)

            local normal = v12:crossInPlace(v13):normalizeInPlace()

            normals[i  ] = normal:clone()
            normals[i+1] = normal:clone()
            normals[i+2] = normal:clone()
        end
    else
        -- TODO : bizarre l'algo ??
        for i=1,n-2 do
            if indices then
                v1 = vertices[indices[i]]
                v2 = vertices[indices[i+1]]
                v3 = vertices[indices[i+2]]
            else
                v1 = vertices[i]
                v2 = vertices[i+1]
                v3 = vertices[i+2]
            end

            v12:set(v2):sub(v1)
            v13:set(v3):sub(v1)

            local normal = v12:crossInPlace(v13):normalizeInPlace()

            if i%2 == 0 then
                normals[i] = normal:clone()
            else
                normals[i] = normal:unm()
            end
        end
    end

    return normals
end


function Model.minmax(vertices)
    local minVertex = vec3( math.MAX_INTEGER,  math.MAX_INTEGER)
    local maxVertex = vec3(-math.MAX_INTEGER, -math.MAX_INTEGER)

    for i=1,#vertices do
        local v = vertices[i]

        minVertex.x = min(minVertex.x, v.x)
        minVertex.y = min(minVertex.y, v.y)
        minVertex.z = min(minVertex.z, v.z or 0)

        maxVertex.x = max(maxVertex.x, v.x)
        maxVertex.y = max(maxVertex.y, v.y)
        maxVertex.z = max(maxVertex.z, v.z or 0)
    end

    return minVertex, maxVertex, maxVertex-minVertex
end

function Model.center(vertices)
    local minVertex, maxVertex, size = Model.minmax(vertices)

    local v = minVertex + size / 2
    for i=1,#vertices do
        vertices[i] = vertices[i] - v
    end

    return vertices
end

function Model.normalize(vertices, norm)
    norm = norm or 1

    local minVertex, maxVertex, size = Model.minmax(vertices)

    norm = norm / ((size.x + size.y + size.z) / 3)

    for i=1,#vertices do
        vertices[i] = vertices[i] * norm
    end

    return vertices
end

function Model.load(fileName, normalize)
    local m = loadObj(fileName)
    if m then
        if #m.vertices == 0 and normalize then
            m.vertices = Model.normalize(m.vertices)
        end

        if #m.normals == 0 then
            m.normals = Model.computeNormals(m.vertices)
        end

        return m
    end
end

function Model.sphere(x, y, z, w, h, d)
    x, y, z, w, h, d = positionAndSize(x, y, z, w, h, d)

    local hw, hh, hd = w/2, h/2, d/2

    local vertices = Buffer('vec3')

    local function coord(x, y, z, w, h, d, phi, theta)
        phi = rad(phi)
        theta = rad(theta)

        return vec3(
            x + hw * cos(phi) * sin(theta),
            y + hh * cos(phi) * cos(theta),
            z + hd * sin(phi))
    end

    local faces = 0
    local delta = (debugging() and 45) or 2

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

    local texCoords = Buffer('vec2')
    for s = 1, faces do
        texCoords:addItems(texCoords_face)
    end

    local normals = Buffer('vec3')
    for i = 1, #vertices do
        normals[i] = vertices[i]:normalize()
    end

    return Model.mesh(vertices, texCoords, normals)
end

function meshAddVertex(vertices, v)
    vertices:insert(v)
end

function meshAddTriangle(vertices, v1, v2, v3)
    vertices:insert(v1)
    vertices:insert(v2)
    vertices:insert(v3)
end

function meshAddRect(vertices, v1, v2, v3, v4)
    vertices:insert(v1)
    vertices:insert(v2)
    vertices:insert(v3)

    vertices:insert(v1)
    vertices:insert(v3)
    vertices:insert(v4)
end

function meshSetTriangleColors(colors, clr)
    meshAddVertex(colors, clr)
    meshAddVertex(colors, clr)
    meshAddVertex(colors, clr)
end
