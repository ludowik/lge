class('Camera')

local __cos, __sin, __acos, __asin = math.cos, math.sin, math.acos, math.asin

function Camera.setup()
    CAMERA_FPS = 'fps'
    CAMERA_MODEL = 'model'
end

function Camera:init(...)
    self.vEye = vec3()
    self.vAt = vec3()
    self.vUp = vec3()

    self.vDirection = vec3()
    self.vFront = vec3()
    self.vRight = vec3()
    self.vTemp = vec3()

    self.yaw = 0
    self.pitch = 0

    self.fovy = 45

    self.speed = 100
    self.sensitivity = 0.1

    self:updateVectors()

    self:set(...)

    self.mode = CAMERA_FPS
end

function Camera:set(eyeX, eyeY, eyeZ, atX, atY, atZ, upX, upY, upZ)
    if type(eyeX) ~= 'number' then
        if eyeZ then
            upX, upY, upZ = eyeZ.x, eyeZ.y, eyeZ.z
        end

        if eyeY then
            atX, atY, atZ = eyeY.x, eyeY.y, eyeY.z
        end

        if eyeX then
            eyeX, eyeY, eyeZ = eyeX.x, eyeX.y, eyeX.z
        end
    end

    if atX == nil then
        atX = 0
        atY = 0
        atZ = 0
    end

    if upX == nil then
        upX = 0
        upY = 1
        upZ = 0
    end

    self:eye(eyeX, eyeY, eyeZ)
    self:at(atX, atY, atZ)
    self:up(upX, upY, upZ)

    self:updateAngles()
end

function Camera:eye(x, y, z)
    if x then
        self.vEye:set(x, y, z)
    end
    return self.vEye
end

function Camera:at(x, y, z)
    if x then
        self.vAt:set(x, y, z)
    end
    return self.vAt
end

function Camera:up(x, y, z)
    if x then
        self.vUp:set(x, y, z)
    end
    return self.vUp
end

function Camera:direction()
    self.vDirection:set(self.vAt):sub(self.vEye)
    return self.vDirection
end

function Camera:front()
    self.vFront:set(self:direction()):normalizeInPlace()
    return self.vFront
end

function Camera:right()
    self.vRight:set(self:direction()):crossInPlace(self.vUp):normalizeInPlace()
    return self.vRight
end

function Camera:getMode()
    if self.mode == CAMERA_MODEL then
        return not isDown(KEY_FOR_MOUSE_MOVING) and CAMERA_MODEL or CAMERA_FPS
        
    else
        return not isDown(KEY_FOR_MOUSE_MOVING) and CAMERA_FPS or CAMERA_MODEL
    end
end

function Camera:update(dt)
    local dist = 10
    if isDown('up') then
        self:processKeyboardMovement('up', dt)
    elseif isDown('down') then
        self:processKeyboardMovement('down', dt)
    end
    
    if isDown('a')  then
        self:processKeyboardMovement('forward', dt)
    elseif isDown('q') then
        self:processKeyboardMovement('backward', dt)
    end

    if isDown('left') then
        self:processKeyboardMovement('left', dt)
    elseif isDown('right') then
        self:processKeyboardMovement('right', dt)
    end
end

function Camera:rotateX(a)
    self:processMovement(a)
    self:updateVectors()
end

function Camera:rotateY(a)
    self:processMouseMovement({dx=a, dy=0})
    self:updateVectors()
end

function Camera:moveForward(speed, dt)
    local up = self:up()
    local front = self:front()
    local right = self:right()
    local direction = self:direction()
    
    front.y = 0

    local velocity = self.speed * speed * dt
    self.vEye:add(front * velocity)
    self.vAt:set(self.vEye + direction)
end

function Camera:moveSideward(speed, dt)
    local up = self:up()
    local front = self:front()
    local right = self:right()
    local direction = self:direction()
    
    right.y = 0

    local velocity = self.speed * speed * dt
    self.vEye:sub(right * velocity)
    self.vAt:set(self.vEye + direction)
end

function Camera:moveUp(speed, dt)
    local up = self:up()
    local front = self:front()
    local right = self:right()
    local direction = self:direction()

    local velocity = self.speed * speed * dt
    self.vEye:add(up * velocity)
    self.vAt:set(self.vEye + direction)
end

function Camera:processKeyboardMovement(direction, dt)
    if direction == 'up' then
        self:moveUp(1, dt)

    elseif direction == 'down' then
        self:moveUp(-1, dt)

    elseif direction == 'forward' then
        self:moveForward(1, dt)

    elseif direction == 'backward' then
        self:moveForward(-1, dt)

    elseif direction == 'left' then
        self:moveSideward(1, dt)

    elseif direction == 'right' then
        self:moveSideward(-1, dt)
    end
end

function Camera:processMouseMovement(touch, constrainPitch)
    if self:getMode() == CAMERA_MODEL then
        self.vEye = self:rotateAround(self:at(), touch.dx, touch.dy, constrainPitch)
        self:updateAngles()
        
    else
        self.yaw, self.pitch = self:processMovement(self.yaw, self.pitch, touch.dx, touch.dy, constrainPitch)
        self:updateVectors()
    end
end

function Camera:processMovement(yaw, pitch, deltaX, deltaY, constrainPitch)
    deltaX = deltaX or 0
    deltaY = deltaY or 0

    constrainPitch = constrainPitch ~= nil and constrainPitch or true

    local xOffset = deltaX * self.sensitivity
    local yOffset = deltaY * self.sensitivity

    yaw = yaw + xOffset
    pitch = pitch + yOffset

    if constrainPitch then
        pitch = clamp(pitch, -89, 89)
    end

    return yaw, pitch
end

function Camera:processWheelMoveOnCamera(touch)
    if self:getMode() == CAMERA_MODEL then
        self:moveForward(touch.dy * 10, deltaTime)
    else
        self:moveForward(touch.dy * 10, deltaTime)
    end
end

function Camera:rotateAround(at, deltaX, deltaY, constrainPitch)
    local camera = Camera()
    
    camera:eye(self:at():unpack())
    camera:at(self:eye():unpack())
    camera:up(self:up():unpack())

    camera:updateAngles()

    camera.yaw, camera.pitch = camera:processMovement(camera.yaw, camera.pitch, deltaX, -deltaY, constrainPitch)
    camera:updateVectors()

    return camera:at()
end

function Camera:zoom(x, y)
    self.fovy = clamp(self.fovy - y, 1, 90)
end

function Camera:computeVectors(direction, yaw, pitch)
    self.vTemp.x = __cos(rad(yaw)) * __cos(rad(pitch))
    self.vTemp.y = __sin(rad(pitch))
    self.vTemp.z = __sin(rad(yaw)) * __cos(rad(pitch))

    return self.vTemp:normalizeInPlace(direction:len())
end

function Camera:updateVectors()
    self:direction()
    self.vAt:set(self.vEye):add(self:computeVectors(self.vDirection, self.yaw, self.pitch))
end

function Camera:computeAngles(front)
    local pitch = deg(__asin(front.y))
    local yaw = deg(__acos(clamp(front.x / __cos(rad(pitch)), -1, 1)))

    if front.z < 0 then
        yaw = -yaw
    end

    return pitch, yaw
end

function Camera:updateAngles()
    self.pitch, self.yaw = self:computeAngles(self:front())
end

local f, u, s = vec3(), vec3(), vec3()

function Camera:matrix()
    local eye = self:eye()
    local at = self:at()
    local up = self:up()

    f:set(at):sub(eye):normalizeInPlace()
    u:set(up):normalizeInPlace()
    s:set(f):crossInPlace(u):normalizeInPlace()

    u:set(s):crossInPlace(f)

    return matrix(
        s.x,  s.y,  s.z, -s:dot(eye),
        u.x,  u.y,  u.z, -u:dot(eye),
        -f.x, -f.y, -f.z,  f:dot(eye),
        0, 0, 0, 1)
end

function Camera:lookAt()
    lookAt(self:eye(), self:at(), self:up())
end
