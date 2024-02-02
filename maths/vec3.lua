vec3 = class()

local ffi = try_require 'ffi'
if ffi then
    ffi.cdef [[
        typedef union vec3 {
            struct {
                float x;
                float y;
                float z;
            };
            float values[3];
        } vec3;
    ]]

    ffi.metatype('vec3', vec3)

    function vec3:init(x, y, z)
        self = ffi and ffi.new('vec3') or self
        self:set(x, y, z)
        return self
    end

    function vec2:__pairs()
        return next, {x=self.x, y=self.y, z=self.z}, nil
    end
end

function vec3.fromArray(t)
    return vec3(t[1], t[2], t[3])
end

function vec3:init(x, y, z)
    self:set(x, y, z)
end

function vec3:set(x, y, z)
    local typeof = type(x)
    if typeof == 'table' or typeof == 'cdata' then
        x, y, z = x.x, x.y, x.z
    end
    
    self.x = x or 0
    self.y = y or self.x
    self.z = z or self.x

    return self
end

function vec3:clone()
    return vec3(self.x, self.y, self.z)
end

function vec3.random(w, h, d)
    return vec3():randomize(w, h, d)
end

function vec3:randomize(w, h, d)
    if w then
        h = h or w
        d = d or w
        self.x = random(w)
        self.y = random(h)
        self.z = random(d)
    else
        self.x = random()
        self.y = random()
        self.z = random()
    end
    return self
end

function vec3.randomAngle()
    local v = vec3()
    v.x = random(-1, 1)
    v.y = random(-1, 1)
    v.z = random(-1, 1)
    v:normalizeInPlace()
    return v
end

function vec3:__tostring()
    if isinteger(self.x) and isinteger(self.y) and isinteger(self.z) then
        return string.format("%d,%d,%d", self.x, self.y, self.z)
    else
        return string.format("%.2f,%.2f,%.2f", self.x, self.y, self.z)
    end
end

function vec3:unpack()
    return self.x, self.y, self.z
end

function vec3:__unm()
    return vec3(-self.x, -self.y, -self.z)
end

function vec3:__add(v, factor)
    factor = factor or 1
    return vec3(
        self.x + v.x * factor,
        self.y + v.y * factor,
        self.z + v.z * factor)
end

function vec3:add(v, factor)
    factor = factor or 1
    self.x = self.x + v.x * factor
    self.y = self.y + v.y * factor
    self.z = self.z + v.z * factor
    return self
end

function vec3:__sub(v, factor)
    factor = factor or 1
    return vec3(
        self.x - v.x * factor,
        self.y - v.y * factor,
        self.z - v.z * factor)
end

function vec3:sub(v, factor)
    factor = factor or 1
    self.x = self.x - v.x * factor
    self.y = self.y - v.y * factor
    self.z = self.z - v.z * factor
    return self
end

function vec3.__mul(u, coef)
    if type(u) == 'number' then u, coef = coef, u end
    
    return vec3(
        u.x * coef,
        u.y * coef,
        u.z * coef)
end

function vec3.mul(u, coef)
    u.x = u.x * coef
    u.y = u.y * coef
    u.z = u.z * coef
    return u
end

function vec3.__div(u, coef)
    if type(u) == 'number' then u, coef = coef, u end
    
    return vec3(
        u.x / coef,
        u.y / coef,
        u.z / coef)
end

function vec3.div(u, coef)
    u.x = u.x / coef
    u.y = u.y / coef
    u.z = u.z / coef
    return u
end

function vec3:dist(v)
    return (v-self):len()
end

function vec3:len()
    return sqrt(self.x ^ 2 + self.y ^ 2 + self.z ^ 2)
end

function vec3:normalize(len)
    return vec3.clone(self):normalizeInPlace(len)
end

function vec3:normalizeInPlace(len)
    local ratio = (len or 1) / self:len()
    self.x = self.x * ratio
    self.y = self.y * ratio
    self.z = self.z * ratio
    return self
end

function vec3.cross(a, b)
    return vec3(
        a.y * b.z - a.z * b.y,
        a.z * b.x - a.x * b.z,
        a.x * b.y - a.y * b.x)
end

function vec3.crossInPlace(a, b)    
    local x = a.y * b.z - a.z * b.y
    local y = a.z * b.x - a.x * b.z
    local z = a.x * b.y - a.y * b.x
    
    a.x, a.y, a.z = x, y, z
    
    return a
end

function vec3.dot(a, b)
    return (
        a.x * b.x +
        a.y * b.y +
        a.z * b.z)        
end

function vec3:rotateInPlace(angle)
    local c, s = cos(angle), sin(angle)
    self.x, self.z = c * self.x - s * self.z, s * self.x + c * self.z
    return self
end

function vec3:rotate(angle)
    local c, s = cos(angle), sin(angle)
    return vec3(
        c * self.x - s * self.y,
        self.y,
        s * self.z + c * self.z)
end
