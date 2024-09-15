vec4 = class()

if ffi then
    ffi.cdef [[
        typedef union vec4 {
            struct {
                float x;
                float y;
                float z;
                float w;
            };
            float values[4];
        } vec4;
    ]]

    ffi.metatype('vec4', vec4)

    function vec4:init(x, y, z, w)
        self = ffi and ffi.new('vec4') or self
        self:set(x, y, z, w)
        return self
    end

    function vec4:__pairs()
        return next, {x=self.x, y=self.y, z=self.z, w=self.w}, nil
    end
end

function vec4.fromArray(t)
    return vec4(t[1], t[2], t[3], t[4])
end

function vec4:init(x, y, z, w)
    self:set(x, y, z, w)
end

function vec4:set(x, y, z, w)
    local typeof = type(x)
    if typeof == 'table' or typeof == 'cdata' then
        x, y, z, w = x.x, x.y, x.z, x.w
    end
    
    assert((x and y and z and w) or (not x and not y and not z and not w))

    self.x = x or 0
    self.y = y or 0
    self.z = z or 0
    self.w = w or 0

    return self
end

function vec4:clone()
    return vec4(self.x, self.y, self.z, self.w)
end

function vec4.random(...)
    return vec4():randomize(...)
end

function vec4.randomInScreen()
    return vec4():randomize(MIN_SIZE, MIN_SIZE, MIN_SIZE, MIN_SIZE)
end

function vec4:randomize(x, y, z, w)
    if x then
        y = y or x
        z = z or x
        w = w or x
        self.x = random(x)
        self.y = random(y)
        self.z = random(z)
        self.w = random(w)
    else
        self.x = random()
        self.y = random()
        self.z = random()
        self.w = random()
    end
    return self
end

function vec4.randomAngle()
    local v = vec4()
    v.x = random(-1, 1)
    v.y = random(-1, 1)
    v.z = random(-1, 1)
    v.w = random(-1, 1)
    v:normalizeInPlace()
    return v
end

function vec4:__tostring()
    if isinteger(self.x) and isinteger(self.y) and isinteger(self.z) and isinteger(self.w) then
        return string.format("%d,%d,%d,%d", self.x, self.y, self.z, self.w)
    else
        return string.format("%.2f,%.2f,%.2f,%.2f", self.x, self.y, self.z, self.w)
    end
end

function vec4:unpack()
    return self.x, self.y, self.z, self.w
end

function vec4:__unm()
    return vec4(-self.x, -self.y, -self.z, -self.w)
end

function vec4:__add(v, factor)
    factor = factor or 1
    return vec4(
        self.x + v.x * factor,
        self.y + v.y * factor,
        self.z + v.z * factor,
        self.w + v.w * factor)
end

function vec4:add(v, factor)
    factor = factor or 1
    self.x = self.x + v.x * factor
    self.y = self.y + v.y * factor
    self.z = self.z + v.z * factor
    self.w = self.w + v.w * factor
    return self
end

function vec4:__sub(v, factor)
    factor = factor or 1
    return vec4(
        self.x - v.x * factor,
        self.y - v.y * factor,
        self.z - v.z * factor,
        self.w - v.w * factor)
end

function vec4:sub(v, factor)
    factor = factor or 1
    self.x = self.x - v.x * factor
    self.y = self.y - v.y * factor
    self.z = self.z - v.z * factor
    self.w = self.w - v.w * factor
    return self
end

function vec4.__mul(u, coef)
    if type(u) == 'number' then u, coef = coef, u end
    
    return vec4(
        u.x * coef,
        u.y * coef,
        u.z * coef,
        u.w * coef)
end

function vec4.mul(u, coef)
    u.x = u.x * coef
    u.y = u.y * coef
    u.z = u.z * coef
    u.w = u.w * coef
    return u
end

function vec4.__div(u, coef)
    if type(u) == 'number' then u, coef = coef, u end
    
    return vec4(
        u.x / coef,
        u.y / coef,
        u.z / coef,
        u.w / coef)
end

function vec4.div(u, coef)
    u.x = u.x / coef
    u.y = u.y / coef
    u.z = u.z / coef
    u.w = u.w / coef
    return u
end

function vec4:dist(v)
    return (v-self):len()
end

function vec4:len()
    return sqrt(self.x ^ 2 + self.y ^ 2 + self.z ^ 2 + self.w ^ 2)
end

function vec4:normalize(len)
    return vec4.clone(self):normalizeInPlace(len)
end

function vec4:normalizeInPlace(norm)
    local len = self:len()
    if len == 0 then return self end
    
    local ratio = (norm or 1) / len
    self.x = self.x * ratio
    self.y = self.y * ratio
    self.z = self.z * ratio
    self.w = self.w * ratio
    return self
end

function xyzw(x, ...)
    if type(x) == 'number' then return x, ... end
    return x.x, x.y, (x.z or 0), (x.w or 0)
end
