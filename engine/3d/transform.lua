local __tan, __atan, __rad, __deg, __sqrt, __cos, __sin = math.tan, math.atan, math.rad, math.deg, math.sqrt, math.cos, math.sin
local love2d = love

local model_matrices = {}
local view_matrices = {}
local projection_matrices = {}

local model, view, projection

local function setTransformation()    
    love.graphics.replaceTransform(scale_matrix(nil, (W)/2, (H)/2, 1))
    love.graphics.applyTransform(translate_matrix(nil, 1, 1, 0))

    love.graphics.applyTransform(projectionMatrix())
    love.graphics.applyTransform(viewMatrix())
    love.graphics.applyTransform(modelMatrix())

end

local function setMatrix(m, mode, ...)
    m:setMatrix(mode or 'row', ...)
end

function pvMatrix()
    return projection * view
end

function pvmMatrix()
    return projection * view * model
end

function matrix()
    return love.math.newTransform()
end

function modelMatrix(m)
    if m then 
        model = m:clone()
        setTransformation()
    end
    return model
end

function viewMatrix(m)
    if m then 
        view = m:clone()
        setTransformation()
    end
    return view
end

function matByVector(m, v)
    local vm = love.math.newTransform()
    setMatrix(vm, nil,
        v.x,0,0,0,
        v.y,0,0,0,
        v.z,0,0,0,
        1,0,0,0)

    local res = m * vm
    local values = {
        res:getMatrix()
    }
    return vec4(values[1], values[5], values[9], values[13])
end

function projectionMatrix(m)
    if m then 
        projection = m:clone()
        setTransformation()
    end
    return projection
end

function resetMatrix(resetAll)
    model = love.math.newTransform()

    if resetAll then
        view = love.math.newTransform()
        projection = love.math.newTransform()
    end

    ortho()
    translate(X, Y)

    setTransformation()
end

function pushMatrix(all)
    table.insert(model_matrices, model)
    model = model:clone()

    if all then
        table.insert(view_matrices, view)
        view = view:clone()

        table.insert(projection_matrices, projection)
        projection = projection:clone()
    end
end

function popMatrix(all)
    model = table.remove(model_matrices)

    if all then
        view = table.remove(view_matrices)        
        projection = table.remove(projection_matrices)
    end

    setTransformation()
end

function translate(x, y, z)
    translate_matrix(model, x, y, z)    
    setTransformation()
end

function translate_matrix(m, x, y, z)
    m = m or love.math.newTransform()

    assert(x)
    y = y or x
    z = z or 0

    local translate = love.math.newTransform()
    setMatrix(translate, nil,
        1,0,0,x,
        0,1,0,y,
        0,0,1,z or 0,
        0,0,0,1)
    m:apply(translate)

    return m
end

function scale(w, h, d)
    scale_matrix(model, w, h, d)
    setTransformation()
end

function scale_matrix(m, w, h, d)
    m = m or love.math.newTransform()

    assert(w)
    h = h or w
    d = d or w

    local scale = love.math.newTransform()
    setMatrix(scale, nil,
        w,0,0,0,
        0,h,0,0,
        0,0,d,0,
        0,0,0,1)
    m:apply(scale)

    return m
end

function rotate(angle, x, y, z)
    rotate_matrix(model, angle, x, y, z)
    setTransformation()
end

function rotate_matrix(m, angle, x, y, z, mode)
    m = m or love.math.newTransform()

    x = x or 0
    y = y or 0
    z = z or 1

    local c, s
    if mode == DEGREES then
        c, s = __cos(__rad(angle)), __sin(__rad(angle))
    else
        c, s = __cos(angle), __sin(angle)
    end

    if x == 1 then
        local rotate = love.math.newTransform()
        setMatrix(rotate, nil,
            1,0,0,0,
            0,c,-s,0,
            0,s,c,0,
            0,0,0,1)
        m:apply(rotate)
    end

    if y == 1 then
        local rotate = love.math.newTransform()
        setMatrix(rotate, nil,
            c,0,s,0,
            0,1,0,0,
            -s,0,c,0,
            0,0,0,1)
        m:apply(rotate)

    end

    if z == 1 then -- default
        local rotate = love.math.newTransform()
        setMatrix(rotate, nil,
            c,-s,0,0,
            s,c,0,0,
            0,0,1,0,
            0,0,0,1)
        m:apply(rotate)
    end

    return m
end

function ortho(left, right, bottom, top, near, far)
    local l = left or 0
    local r = right or W or 400

    local b = bottom or 0
    local t = top or H or 400

    local n = near or -1000
    local f = far or 1000

    setMatrix(projection, nil,
        2/(r-l), 0, 0, -(r+l)/(r-l),
        0, 2/(t-b), 0, -(t+b)/(t-b),
        0, 0, -2/(f-n), -(f+n)/(f-n),
        0, 0, 0, 1)

    setTransformation()
end

function ortho3D()
    isometric(10)
end

function isometric(n)
    ortho()

    -- TODo :with model and not projection ????

    translate_matrix(model, W/2, H/2)

    local alpha = __atan(1/__sqrt(2))
    local beta = PI/4

    rotate_matrix(model, alpha, 1, 0, 0)
    rotate_matrix(model, beta, 0, 1, 0)

    if n then
        scale_matrix(model, n, n, n)
    end

    setTransformation()
end

function perspective(fovy, aspect, near, far)
    local camera = getCamera()
    if camera then
        fovy = camera.fovy or fovy or 45
    else
        fovy = fovy or 45
    end

    local w = W or 400
    local h = H or 400

    aspect = aspect or (w / h)

    near = near or 0.1
    far = far or 100000

    local range = __tan(__rad(fovy*0.5)) * near

    local left = -range * aspect
    local right = range * aspect

    local bottom = -range
    local top = range

    setMatrix(projection, nil,
        (2 * near) / (right - left), 0, (right + left)/(right - left), 0,
        0, (2 * near) / (top - bottom), (top + bottom)/(top - bottom), 0,
        0, 0, - (far + near) / (far - near), - (2 * far * near) / (far - near),
        0, 0, - 1, 0)

    setTransformation()
end

function lookAt(eye, target, up)
    eye = eye or vec3()    
    target = target or vec3()
    up = up or vec3(0, 1, 0)

    local f = (target - eye):normalize()
    local s = f:cross(up):normalize()
    local u = s:cross(f)

    view = love.math.newTransform()
    setMatrix(view, nil,
        s.x, s.y, s.z, -s:dot(eye),
        u.x, u.y, u.z, -u:dot(eye),
        -f.x, -f.y, -f.z, f:dot(eye),
        0, 0, 0, 1)

    setTransformation()
end

function camera(eye_x, eye_y, eye_z, at_x, at_y, at_z, up_x, up_y, up_z)
    local env = _G.app or _G.env.scene or _G.env
    env.__camera = Camera(eye_x, eye_y, eye_z, at_x, at_y, at_z, up_x, up_y, up_z)
    return env.__camera
end

function getCamera()
    return _G.env and (
        (_G.env.__camera) or
        (_G.env.scene and _G.env.scene.__camera) or
        (_G.env.app and _G.env.app.__camera))
end

