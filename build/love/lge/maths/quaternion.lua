if getOS() == 'web' then return end

Quaternion = class()

function Quaternion:init(w, x, y, z)
    self.w = w or 0
    self.x = x or 0
    self.y = y or 0
    self.z = z or 0
end

function Quaternion.__add(q1, q2)
    return Quaternion(
        q1.w + q2.w,
        q1.x + q2.x,
        q1.y + q2.y,
        q1.z + q2.z
    )
end

function Quaternion.__sub(q1, q2)
    return Quaternion(
        q1.w - q2.w,
        q1.x - q2.x,
        q1.y - q2.y,
        q1.z - q2.z
    )
end

function Quaternion.__mul(q1, q2)
    return Quaternion(
        q1.w * q2.w - q1.x * q2.x - q1.y * q2.y - q1.z * q2.z,
        q1.w * q2.x + q1.x * q2.w + q1.y * q2.z - q1.z * q2.y,
        q1.w * q2.y - q1.x * q2.z + q1.y * q2.w + q1.z * q2.x,
        q1.w * q2.z + q1.x * q2.y - q1.y * q2.x + q1.z * q2.w
    )
end

function Quaternion:conjugate()
    return Quaternion(self.w, -self.x, -self.y, -self.z)
end

function Quaternion:magnitude()
    return math.sqrt(self.w^2 + self.x^2 + self.y^2 + self.z^2)
end

function Quaternion:normalize()
    local mag = self:magnitude()
    return Quaternion(self.w / mag, self.x / mag, self.y / mag, self.z / mag)
end

function Quaternion:toRotationMatrix(m)
    local q = self:normalize()
    local w, x, y, z = q.w, q.x, q.y, q.z

    m = m or love.math.newTransform()
    m:setMatrix(
        1 - 2*y^2 - 2*z^2, 2*x*y - 2*w*z, 2*x*z + 2*w*y, 0,
        2*x*y + 2*w*z, 1 - 2*x^2 - 2*z^2, 2*y*z - 2*w*x, 0,
        2*x*z - 2*w*y, 2*y*z + 2*w*x, 1 - 2*x^2 - 2*y^2, 0,
        0, 0, 0, 1)

    return m
end

function Quaternion.lookAt(positionA, positionB, up)
    local forward = (positionB - positionA):normalize()
    local right = forward:cross(up):normalize()
    local newUp = right:cross(forward):normalize()

    -- F = normalize(target - camera);   // lookAt
    -- R = normalize(cross(F, worldUp)); // sideaxis
    -- U = cross(R, F);                  // rotatedup

    local q = Quaternion()

    R = right
    U = newUp
    F = forward

    local trace = R.x + U.y + F.z
    if (trace > 0.0) then
        local s = 0.5 / sqrt(trace + 1.0)
        q.w = 0.25 / s;
        q.x = (U.z - F.y) * s;
        q.y = (F.x - R.z) * s;
        q.z = (R.y - U.x) * s;
    else
        if (R.x > U.y and R.x > F.z) then
            local s = 2.0 * sqrt(1.0 + R.x - U.y - F.z);
            q.w = (U.z - F.y) / s;
            q.x = 0.25 * s;
            q.y = (U.x + R.y) / s;
            q.z = (F.x + R.z) / s;
        elseif (U.y > F.z) then
            local s = 2.0 * sqrt(1.0 + U.y - R.x - F.z);
            q.w = (F.x - R.z) / s;
            q.x = (U.x + R.y) / s;
            q.y = 0.25 * s;
            q.z = (F.y + U.z) / s;
        else
            local s = 2.0 * sqrt(1.0 + F.z - R.x - U.y);
            q.w = (R.y - U.x) / s;
            q.x = (F.x + R.z) / s;
            q.y = (F.y + U.z) / s;
            q.z = 0.25 * s;
        end
    end

    return q
end

function Quaternion:unitTest()
    local q = Quaternion(0.7071, 0.0, 0.7071, 0.0) -- Quaternion representing a 90-degree rotation around the y-axis
    local rotationMatrix = q:toRotationMatrix()

    local forward = vec3(0, 0, -1) -- Assuming you have a Vector3 class for representing 3D vectors
    local up = vec3(0, 1, 0)
    local qLookAt = Quaternion():lookAt(forward, up)
    local rotationMatrix = qLookAt:toRotationMatrix()

    local q1 = Quaternion(1, 2, 3, 4)
    local q2 = Quaternion(5, 6, 7, 8)

    local result_add = q1 + q2
    local result_sub = q1 - q2
    local result_mul = q1 * q2
    local conjugate_q1 = q1:conjugate()
    local magnitude = q1:magnitude()
    local normalized_q1 = q1:normalize()
end
