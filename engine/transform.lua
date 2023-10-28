local __tan, __atan, __rad, __deg, __sqrt, __cos, __sin = math.tan, math.atan, math.rad, math.deg, math.sqrt, math.cos, math.sin

local stack = Array()
local useDefaultSystem = false

function resetMatrix()
    if useDefaultSystem then
        love.graphics.origin()
        love.graphics.translate(X, Y)
        return
    end

    __modelMatrix = love.math.newTransform()
    __projectionMatrix = love.math.newTransform()
    __viewMatrix = love.math.newTransform()

    ortho()
    translate(X, Y)

    stack = Array()
end

function pushMatrix()
    if useDefaultSystem then
        love.graphics.push()
        return
    end

    stack:push(__modelMatrix:clone())
    stack:push(__projectionMatrix:clone())
    stack:push(__viewMatrix:clone())
end

function popMatrix()
    if useDefaultSystem then
        love.graphics.pop()
        return
    end

    __viewMatrix = stack:pop()
    __projectionMatrix = stack:pop()
    __modelMatrix = stack:pop()

    setTransformation()
end

function translate(x, y, z)
    if useDefaultSystem then
        love.graphics.translate(x, y)
        return
    end

    translate_matrix(__modelMatrix, x, y, z)
    setTransformation()
end

function translate_matrix(m, x, y, z)
    local translate = love.math.newTransform()
    translate:setMatrix(
        1, 0, 0, x,
        0, 1, 0, y,
        0, 0, 1, z or 0,
        0, 0, 0, 1)

    m = m or love.math.newTransform()
    if m then
        m:apply(translate)
        return m
    else
        return translate
    end
end

function rotate(angle, x, y, z)
    if useDefaultSystem then
        love.graphics.rotate(angle)
        return
    end

    rotate_matrix(__modelMatrix, angle, x, y, z)
    setTransformation()
end

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

    local rotate = love.math.newTransform()
    if x == 1 then        
        rotate:setMatrix(
            1, 0, 0, 0,
            0, c,-s, 0,
            0, s, c, 0,
            0, 0, 0, 1)
    
    elseif y == 1 then
        rotate:setMatrix(
            c, 0, s, 0,
            0, 1, 0, 0,
            -s, 0, c, 0,
            0, 0, 0, 1)
    
    else --if z == 1 then -- default
        rotate:setMatrix(
            c,-s, 0, 0,
            s, c, 0, 0,
            0, 0, 1, 0,
            0, 0, 0, 1)
    end

    m = m or love.math.newTransform()
    if m then
        m:apply(rotate)
        return m
    else
        return rotate
    end
end

function scale(sx, sy, sz)
    if useDefaultSystem then
        love.graphics.scale(sx, sy)
        return
    end
    
    scale_matrix(__modelMatrix, sx, sy, sz)
    setTransformation()
end

function scale_matrix(m, sx, sy, sz)
    sy = sy or sx
    sz = sz or sx

    local scale = love.math.newTransform()
    scale:setMatrix(
        sx, 0,  0, 0,
        0, sy,  0, 0,
        0,  0, sz, 0,
        0,  0,  0, 1)

    m = m or love.math.newTransform()    
    if m then
        m:apply(scale)
        return m
    else
        return scale
    end
end

function ortho(left, right, bottom, top, near, far)
    local l = left or 0
    local r = right or W or 400

    local b = bottom or 0
    local t = top or H or 400

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
    ortho()

    -- TODO :with model and not projection ????

    translate_matrix(__modelMatrix, W/2, H/2)

    local alpha = __atan(1/__sqrt(2))
    local beta = PI/4

    rotate_matrix(__modelMatrix, alpha, 1, 0, 0)
    rotate_matrix(__modelMatrix, beta, 0, 1, 0)

    if n then
        scale_matrix(__modelMatrix, n, n, n)
    end

    setTransformation()
end

function perspective(fovy, aspect, near, far)
    local w = W or 400
    local h = H or 400

    fovy = fovy or 45    

    aspect = aspect or (w / h)

    near = near or 0.1
    far = far or 100000

    local range = __tan(__rad(fovy*0.5)) * near

    local left = -range * aspect
    local right = range * aspect

    local bottom = -range
    local top = range

    __projectionMatrix:setMatrix(
        (2 * near) / (right - left), 0, (right + left)/(right - left), 0,
        0, (2 * near) / (top - bottom), (top + bottom)/(top - bottom), 0,
        0, 0, - (far + near) / (far - near), - (2 * far * near) / (far - near),
        0, 0, - 1, 0)
    
    setTransformation()
end

function camera(eye, target, up)
    eye = eye or vec3()    
    target = target or vec3()
    up = up or vec3(0, 1, 0)

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

function setTransformation()
    love.graphics.replaceTransform(scale_matrix(nil, (W)/2, (H)/2, 1))
    love.graphics.applyTransform(translate_matrix(nil, 1, 1, 0))

    love.graphics.applyTransform(__projectionMatrix)
    love.graphics.applyTransform(__viewMatrix)
    love.graphics.applyTransform(__modelMatrix)
    --love.graphics.replaceTransform(__modelMatrix)
end
