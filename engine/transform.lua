local stack = Array()

local useDefaultSystem = false

function resetMatrix()
    print(useDefaultSystem)

    if useDefaultSystem then
        love.graphics.origin()
        love.graphics.translate(X, Y)
        return
    end

    __modelMatrix = love.math.newTransform()
    translate(X, Y)
    stack = Array()
end

function pushMatrix()
    if useDefaultSystem then
        love.graphics.push()
        return
    end

    stack:push(__modelMatrix:clone())
end

function popMatrix()
    if useDefaultSystem then
        love.graphics.pop()
        return
    end

    __modelMatrix = stack:pop()
    love.graphics.replaceTransform(__modelMatrix)
end

function translate(x, y, z)    
    if useDefaultSystem then
        love.graphics.translate(x, y)
        return
    end

    local translate = love.math.newTransform()
    translate:setMatrix(
        1, 0, 0, x,
        0, 1, 0, y,
        0, 0, 1, z or 0,
        0, 0, 0, 1)
    __modelMatrix:apply(translate)

    love.graphics.replaceTransform(__modelMatrix)
end

function rotate(angle, x, y, z)
    if useDefaultSystem then
        love.graphics.rotate(angle)
        return
    end

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
        local rotate = love.math.newTransform()
        rotate:setMatrix(
            1, 0, 0, 0,
            0, c,-s, 0,
            0, s, c, 0,
            0, 0, 0, 1)
        __modelMatrix:apply(rotate)
    end

    if y == 1 then
        local rotate = love.math.newTransform()
        rotate:setMatrix(
             c, 0, s, 0,
             0, 1, 0, 0,
            -s, 0, c, 0,
             0, 0, 0, 1)
        __modelMatrix:apply(rotate)
    end

    if z == 1 then -- default
        local rotate = love.math.newTransform()
        rotate:setMatrix(
            c,-s, 0, 0,
            s, c, 0, 0,
            0, 0, 1, 0,
            0, 0, 0, 1)
        __modelMatrix:apply(rotate)
    end

    love.graphics.replaceTransform(__modelMatrix)
end

function scale(sx, sy, sz)
    sy = sy or sx
    sz = sz or sx

    if useDefaultSystem then
        love.graphics.scale(sx, sy)
        return
    end

    local scale = love.math.newTransform()
    scale:setMatrix(
        sx, 0,  0, 0,
        0, sy,  0, 0,
        0,  0, sz, 0,
        0,  0,  0, 1)
    __modelMatrix:apply(scale)

    love.graphics.replaceTransform(__modelMatrix)
end
