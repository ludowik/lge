Cardioid = class() : extends(Sketch)

function Cardioid:init()
    Sketch.init(self)

    self.parameter:integer('n', Bind(self, 'n'), 1, 1000, 200)
    self.parameter:integer('factor', Bind(self, 'factor'), 1, 200, 0)
end

function Cardioid:update(dt)
    self.factor = self.factor + 0.005
end

function Cardioid:draw()
    background(colors.black)

    translate(CX, CY)

    rotate(-elapsedTime)

    local diameter = min(W, H) * 0.9
    local radius = diameter / 2

    noFill()
    stroke(colors.white)
    circle(0, 0, radius)

    local da = TAU / self.n

    local function getPoint(i)
        local angle = i * da + PI
        local x = radius * cos(angle)
        local y = radius * sin(angle)
        return vec2(x, y)
    end

    for i=0,self.n do
        local a = getPoint(i)
        local b = getPoint(i * self.factor)
        stroke(Color.hsb((i * da) / TAU, 0.5, 0.5))
        line(a.x, a.y, b.x, b.y)
    end
end
