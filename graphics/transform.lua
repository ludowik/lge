local __tan, __atan, __rad, __deg, __sqrt, __cos, __sin = math.tan, math.atan, math.rad, math.deg, math.sqrt, math.cos, math.sin

local stack = Array()

function resetMatrix(resetStack)
    resetMatrixContext(resetStack)
end

function resetMatrixContext(resetStack)
    __modelMatrix = love.math.newTransform()
    __projectionMatrix = love.math.newTransform()
    __viewMatrix = love.math.newTransform()

    ortho()

    if resetStack then
        stack = Array()
    end
end

function pushMatrix()
    stack:push(__modelMatrix:clone())
    stack:push(__projectionMatrix:clone())
    stack:push(__viewMatrix:clone())
end

function popMatrix()
    __viewMatrix = stack:pop()
    __projectionMatrix = stack:pop()
    __modelMatrix = stack:pop()

    setTransformation()
end

function pvMatrix()
    return __projectionMatrix * __viewMatrix
end

function pvmMatrix()
    return __projectionMatrix * __viewMatrix * __modelMatrix
end

function modelMatrix()
    return __modelMatrix
end

function viewMatrix()
    return __viewMatrix
end

function projectionMatrix()
    return __projectionMatrix
end

function positionParameter(x, y, z)
    if type(x) == 'table' then 
        return x.x, x.y, x.z
    else
        return x, y, z
    end
end

function translate(x, y, z)
    x, y, z = positionParameter(x, y, z)
    translate_matrix(__modelMatrix, x, y, z)
    setTransformation()
end

local __tm = love.math.newTransform()
function translate_matrix(m, x, y, z)
    __tm:setMatrix(
        1, 0, 0, x,
        0, 1, 0, y,
        0, 0, 1, z or 0,
        0, 0, 0, 1)

    m = m or love.math.newTransform()
    if m then
        m:apply(__tm)
        return m
    else
        return __tm
    end
end

function rotate(angle, x, y, z)
    x, y, z = positionParameter(x, y, z)
    rotate_matrix(__modelMatrix, angle, x, y, z)
    setTransformation()
end

local __rm = love.math.newTransform()
function rotate_matrix(m, angle, x, y, z)
    x = x or 0
    y = y or 0
    z = z or 1

    local c, s
    -- if mode == DEGREES then
    --     c, s = cos(rad(angle)), sin(rad(angle))
    -- else
    c, s = cos(angle), sin(angle)
    -- end

    if x == 1 then
        __rm:setMatrix(
            1, 0, 0, 0,
            0, c,-s, 0,
            0, s, c, 0,
            0, 0, 0, 1)
    
    elseif y == 1 then
        __rm:setMatrix(
            c, 0, s, 0,
            0, 1, 0, 0,
            -s, 0, c, 0,
            0, 0, 0, 1)
    
    else --if z == 1 then -- default
        __rm:setMatrix(
            c,-s, 0, 0,
            s, c, 0, 0,
            0, 0, 1, 0,
            0, 0, 0, 1)
    end

    m = m or love.math.newTransform()
    if m then
        m:apply(__rm)
        return m
    else
        return __rm
    end
end

function scale(sx, sy, sz)
    sx, sy, sz = positionParameter(sx, sy, sz)
    scale_matrix(__modelMatrix, sx, sy, sz)
    setTransformation()
end

local __sm = love.math.newTransform()
function scale_matrix(m, sx, sy, sz)
    sy = sy or sx
    sz = sz or sx

    __sm:setMatrix(
        sx, 0,  0, 0,
        0, sy,  0, 0,
        0,  0, sz, 0,
        0,  0,  0, 1)

    m = m or love.math.newTransform()
    if m then
        m:apply(__sm)
        return m
    else
        return __sm
    end
end

local function setMatrix(m, mode, ...)
    m:setMatrix(mode or 'row', ...)
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

function applyMatrix(m)
    __modelMatrix:apply(m)
end

function ortho(left, right, bottom, top, near, far)
    local l = left or 0
    local r = right or W

    local b = bottom or 0
    local t = top or H

    local n = near or -1000
    local f = far or 1000

    __projectionMatrix:setMatrix(
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
    ortho(0, W, H, 0)

    translate_matrix(__modelMatrix, CX, CY)

    local alpha = __atan(1/__sqrt(2))
    local beta = -PI/4

    rotate_matrix(__modelMatrix, alpha, 1, 0, 0)
    rotate_matrix(__modelMatrix, beta, 0, 1, 0)

    n = n or 1
    scale_matrix(__modelMatrix, n, n, n)

    set3dMode()

    setTransformation()
end

function perspective(fovy, aspect, near, far)
    local w = W or 400
    local h = H or 400

    fovy = fovy or 45

    aspect = aspect or (w / h)

    near = near or 0.1
    far = far or 10^10

    local range = __tan(__rad(fovy*0.5)) * near

    local left = -range * aspect
    local right = range * aspect

    local bottom = range
    local top = -range
    
    __modelMatrix = love.math.newTransform()
    scale_matrix(__modelMatrix, 1, 1, 1)
    
    __projectionMatrix:setMatrix(
        (2 * near) / (right - left), 0, (right + left)/(right - left), 0,
        0, (2 * near) / (top - bottom), (top + bottom)/(top - bottom), 0,
        0, 0, -(far + near) / (far - near), -(2 * far * near) / (far - near),
        0, 0, -1, 0)

    set3dMode()

    setTransformation()

    local camera = env.sketch.cam
    if camera then
        lookat(camera.eye, camera.target, camera.up)

        rotate(camera.angleX, 1, 0, 0)
        rotate(camera.angleY, 0, 1, 0)
    end
end

function cameraParameter(eye, target, up, ...)
    if type(eye) == 'number' then
        eye = vec3(eye, target, up)
        target = vec3(...)
        up = vec3(0, 1, 0)

    else
        assert(eye == nil or type(eye) == 'table' or type(eye) == 'cdata')
        eye = eye or vec3()
        target = target or vec3()
        up = up or vec3(0, 1, 0)
    end

    return eye, target, up
end

function camera(eye, target, up, ...)
    eye, target, up = cameraParameter(eye, target, up, ...)

    env.sketch.cam = {
        eye = eye,
        target = target,
        up = up,
        angleX = 0,
        angleY = 0,
        mode = MODEL,
    }
    
    lookat(eye, target, up)
end

MODEL = 'model'
CAMERA = 'camera'

function cameraMode(mode)
    if mode then
        env.sketch.cam.mode = mode 
    end
    return env.sketch.cam.mode
end

function lookat(eye, target, up)    
    eye, target, up = cameraParameter(eye, target, up)

    local f = (target - eye):normalize()
    local s = f:cross(up):normalize()
    local u = s:cross(f)

    __viewMatrix:setMatrix(
        s.x, s.y, s.z, -s:dot(eye),
        u.x, u.y, u.z, -u:dot(eye),
        -f.x, -f.y, -f.z, f:dot(eye),
        0, 0, 0, 1)

    setTransformation()
end

function _lookat(eye, target, up)    
    eye, target, up = cameraParameter(eye, target, up)

    local q = Quaternion.lookAt(eye, target, up)

    local t = translate_matrix(nil, -eye.x, -eye.y, -eye.z)
    __viewMatrix = q:toRotationMatrix()
    __viewMatrix:apply(t)

    setTransformation()
end

function set3dMode()
    love.graphics.setFrontFaceWinding('ccw')

    if love.getVersion() > 11 then
        love.graphics.setMeshCullMode('front')
    else
        love.graphics.setMeshCullMode('back')
    end

    love.graphics.setDepthMode('less', true)
    love.graphics.clear(true, false, 1)

    setOrigin(BOTTOM_LEFT)
end

function setTransformation()
    love.graphics.replaceTransform(scale_matrix(nil, (W)/2, (H)/2, 1))
    love.graphics.applyTransform(translate_matrix(nil, 1, 1, 0))

    love.graphics.applyTransform(__projectionMatrix)
    love.graphics.applyTransform(__viewMatrix)
    love.graphics.applyTransform(__modelMatrix)
end
