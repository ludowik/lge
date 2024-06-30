Complex = class()

function Complex:init(a, b)
    self.a = a
    self.b = b
end

function Complex._add(c1, c2)
    return Complex(
        c1.a + c2.a,
        c1.b + c2.b
    )
end

function Complex._sub(c1, c2)
    return Complex(
        c1.a - c2.a,
        c1.b - c2.b
    )
end

function Complex._mul(c1, c2)
    return Complex(
        c1.a * c2.a - c1.b * c2.b,
        c1.a * c2.b + c1.b * c2.a
    )
end

function Complex:scale(s)
    return Complex(
        self.a * s,
        self.b * s
    )
end

function Complex:sqrt()
    local m = sqrt(self.a^2 + self.b^2)
    local angle = atan2(self.b, self.a)
    m = sqrt(m)
    angle = angle / 2
    return Complex(
        m * cos(angle),
        m * sin(angle)
    )
end