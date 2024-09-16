local __cos, __sin, __degrees, __radians = math.cos, math.sin, math.deg, math.rad

ffi = require 'ffi'

ffi.cdef [[
    typedef union matrix {
        struct {
            float i0, i1, i2, i3, i4, i5, i6, i7, i8, i9, i10, i11, i12, i13, i14, i15;
        };
        float values[16];
	} matrix;
]]

local mt = {}

function mt:__index(key)
    if type(key) == 'number' then
        return self.values[key - 1]
    else
        return rawget(mt, key)
    end
end

-- n rows x m columns
function mt:__tostring()
    local str = ''
    local i = 0
    for n = 0, 3 do
        str = str .. n .. ':'
        for m = 0, 3 do
            str = str .. formatNumber(self.values[i]) .. ','
            i = i + 1
        end
        str = str .. NL
    end
    return str:trim(NL):trim(',')
end

function mt:unpack()
    return self.i0, self.i1, self.i2, self.i3, self.i4, self.i5, self.i6,
           self.i7, self.i8, self.i9, self.i10, self.i11, self.i12, self.i13,
           self.i14, self.i15
end

function mt:set(...) self.values = {...} end

function mt.random()
    local m = matrix()
    for i = 0, 15 do m.values[i] = random(100) end
    return m
end

function mt:transpose()
    local m = matrix()
    for x = 0, 3 do
        for y = 0, 3 do m.values[y * 4 + x] = self.values[x * 4 + y] end
    end

    return m
end

function mt:__eq(mat)
    if not self or not mat then return false end

    if self.values == mat.values then return true end

    for i = 0, 15 do if self.values[i] ~= mat.values[i] then return false end end

    return true
end

function mt.scale(...)
    local m2 = matrix()
    local values = m2.values

    function mt.scale(m1, sx, sy, sz, res)
        values[0] = sx
        values[5] = sy or sx
        values[10] = sz or sx
        return m1:__mul(m2, res)
    end

    return mt.scale(...)
end

function mt.translate(...)
    local m2 = matrix()
    local values = m2.values

    function mt.translate(m1, x, y, z, res)
        values[3] = x
        values[7] = y
        values[11] = z or 0
        return m1:__mul(m2, res)
    end

    return mt.translate(...)
end

function mt.rotate(...)
    local m2x = matrix()
    local m2y = matrix()
    local m2z = matrix()

    local c, s
    function mt.rotate(m1, angle, x, y, z, res, mode)
        mode = mode or angleMode()
        if mode == DEGREES then
            c, s = __cos(__radians(angle)), __sin(__radians(angle))
        else
            c, s = __cos(angle), __sin(angle)
        end

        if x == 1 then
            m2x.i5 = c
            m2x.i6 = -s
            m2x.i9 = s
            m2x.i10 = c
            return m1:__mul(m2x, res)

        elseif y == 1 then
            m2y.i0 = c
            m2y.i2 = s
            m2y.i8 = -s
            m2y.i10 = c
            return m1:__mul(m2y, res)

        else -- z == 1 (default)
            m2z.i0 = c
            m2z.i1 = -s
            m2z.i4 = s
            m2z.i5 = c
            return m1:__mul(m2z, res)

        end
    end

    return mt.rotate(...)
end

function mt.__mul(m1, m2, res)
    res = res or __matrix()

    local value

    local values1 = m1.values
    local values2 = m2.values

    local n4, j = 0, 0

    for n = 0, 3 do
        n4 = n * 4

        for m = 0, 3 do

            value = 0
            for i = 0, 3 do
                value = value + values1[n4 + i] * values2[i * 4 + m]
            end

            res.values[j] = value

            j = j + 1

        end
    end

    return res
end

local res, bm
function mt:mulVector(b)
    res = res or matrix()

    bm = bm or matrix()
    bm.i0 = b.x
    bm.i4 = b.y
    bm.i8 = b.z
    bm.i12 = 1

    self:__mul(bm, res)

    return vec4(res.i0, res.i4, res.i8, res.i12)
end

function mt.tobytes(m1) return m1.values end

function mt.perf()
    Performance.timeit('none', function(i) end)

    Performance.timeit('create matrix', function(i)
        matrix(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15)
    end)

    Performance.timeit('create and set matrix', function(i, m)
        m:set(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15)
    end, matrix())

    Performance.timeit('multiply matrix',
                       function(i, m1, m2) local m = m1 * m2 end, matrix(),
                       matrix())
end

__matrix = ffi.metatype('matrix', mt)

class 'matrix' -- : meta(__matrix)

function matrix:init(i0, ...)
    local mat
    if i0 == nil then
        mat = __matrix()
        mat.i0 = 1
        mat.i5 = 1
        mat.i10 = 1
        mat.i15 = 1
    else
        mat = __matrix(i0, ...)
    end
    return mat
end

function matrix.test()
    local m = matrix()
    assert(m == m)
    assert(matrix():__eq(matrix()))

    local function assertMatrixIdentity(m)
        for i = 1, 16 do
            if i == 1 or i == 6 or i == 11 or i == 16 then
                assert(m[i] == 1)
            else
                assert(m[i] == 0)
            end
        end
    end

    assertMatrixIdentity(matrix())

    local m = matrix():translate(1, 2, 3)

    m = matrix.random()
    assert(m:transpose():transpose() == m)
end
