vec2 = class()

if ffi then
    ffi.cdef [[
        typedef union vec2 {
            struct {
                float x;
                float y;
            };
            float values[2];
        } vec2;
    ]]

    ffi.metatype('vec2', vec2)

    function vec2:init(x, y)
        self = ffi and ffi.new('vec2') or self
        self:set(x, y)
        return self
    end

    function vec2:__pairs()
        return next, {x=self.x, y=self.y}, nil
    end
end

function vec2.fromArray(t)
    return vec2(t[1], t[2])
end

function vec2:init(x, y)
    self:set(x, y)
end

function vec2:set(x, y)
    local typeof = type(x)
    if typeof == 'table' or typeof == 'cdata' then
        x, y = x.x, x.y
    end
    
    assert((x and y) or (not x and not y))

    self.x = x or 0
    self.y = y or 0

    return self
end

function vec2:clone()
    return vec2(self.x, self.y)
end

function vec2.fromAngle(angle)
    return vec2(cos(angle), sin(angle))
end

function vec2.random(w, h)
    return vec2():randomize(w, h)
end

function vec2:randomize(w, h)
    if w then
        h = h or w
        self.x = random(w)
        self.y = random(h)
    else
        self.x = random()
        self.y = random()
    end
    return self
end

function vec2.randomInScreen()
    return vec2():randomize(W, H)
end

function vec2.randomAngle(angle)
    return vec2(1, 0):rotate(random(angle or TAU))
end

function vec2:__tostring()
    if isinteger(self.x) and isinteger(self.y) then
        return string.format("%d,%d", self.x, self.y)
    else
        return string.format("%.2f,%.2f", self.x, self.y)
    end
end

function vec2:unpack()
    return self.x, self.y
end

function vec2:rotateInPlace(angle)
    local c, s = cos(angle), sin(angle)
    self.x, self.y = c * self.x - s * self.y, s * self.x + c * self.y
    return self
end

function vec2:rotate(angle)
    local c, s = cos(angle), sin(angle)
    return vec2(
        c * self.x - s * self.y,
        s * self.x + c * self.y)
end

function vec2:__unm()
    return vec2(-self.x, -self.y)
end

function vec2.__eq(u, v)
    return
        (u.x == v.x) and
        (u.y == v.y)
end

function vec2.__add(u, v)
    return vec2(
        u.x + v.x,
        u.y + v.y)
end

function vec2.add(u, v, factor)
    factor = factor or 1
    u.x = u.x + v.x * factor
    u.y = u.y + v.y * factor
    return u
end

function vec2.__sub(u, v)
    return vec2(
        u.x - v.x,
        u.y - v.y)
end

function vec2.sub(u, v, factor)
    factor = factor or 1
    u.x = u.x - v.x * factor
    u.y = u.y - v.y * factor
    return u
end

function vec2.__mul(u, coef)
    if type(u) == 'number' then u, coef = coef, u end
    
    return vec2(
        u.x * coef,
        u.y * coef)
end

function vec2.mul(u, coef)
    u.x = u.x * coef
    u.y = u.y * coef
    return u
end

function vec2.__div(u, coef)
    return vec2(
        u.x / coef,
        u.y / coef)
end

function vec2.div(u, coef)
    u.x = u.x / coef
    u.y = u.y / coef
    return u
end

function vec2:dist(v)
    return (v-self):len()
end

function vec2:len()
    return sqrt(self.x ^ 2 + self.y ^ 2)
end

function vec2:normalize(len)
    return vec2.clone(self):normalizeInPlace(len)
end

function vec2:normalizeInPlace(norm)
    local len = self:len()
    if len == 0 then return self end

    local ratio = (norm or 1) / len
    self.x = self.x * ratio
    self.y = self.y * ratio
    return self
end

function vec2.scalar(u, v)
    return u.x * v.x + u.y * v.y
end

function vec2:floor()
    self.x = floor(self.x)
    self.y = floor(self.y)
    return self
end

function vec2:ceil()
    self.x = ceil(self.x)
    self.y = ceil(self.y)
    return self
end

function vec2:setHeading(angle)
    self:rotateInPlace(angle - self:heading())
    return self
end

function vec2:heading()
    return self:angleBetween(vec2(1, 0))
end

function vec2:angleBetween(v)
    local alpha1 = atan2(self.y, self.x)
    local alpha2 = atan2(v.y, v.x)
    return alpha2 - alpha1
end

function vec2:cross(v)
    return self:clone():crossInPlace(v)
end

function vec2:crossInPlace(v)
    local x = self.y * v.z - self.z * v.y
    local y = self.z * v.x - self.x * v.z

    self.x = x
    self.y = y

    return self
end

function vec2:draw()
    circle(self.x, self.y, 5)
end

function xy(x, ...)
    if type(x) == 'number' then return x, ... end
    return x.x, x.y
end

function vec2.unitTest()
    assert(vec2(1,2) == vec2(1,2))
    assert(vec2():set(1,2) == vec2(1,2))
    assert(vec2.random() ~= vec2.random())
    assert(vec2.random(10000) ~= vec2.random(10000))
    assert(vec2.random(1, 1) ~= vec2.random(1, 1))
    assert(vec2():len() == 0)
    assert(vec2(1,2):scalar(vec2(2,2)) == 6)

    assert(vec2(1,2):rotateInPlace(12) == vec2(1,2):rotate(12))
    assert(round(vec2(1,2):angleBetween(vec2(1,2):rotateInPlace(0.34)), 2) == 0.34)
end
