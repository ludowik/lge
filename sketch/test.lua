function setup()
    parameter:integer('stepAngle', 1, 40, 1)

    local r = (SIZE-TOP)/2
    local step = 20

    waves = Node()

    for i = 1, 20 do
        waves:add(Wave(r, i*step))
    end
end

function update(dt)
   waves:update(dt)
end

function draw()
    background(0, 0, 0, 0.05)

    translate(CX, CY)

    waves:draw()
end

Wave = class()

function Wave:init(r, shift)
    self.r = r
    self.deltaAngle = 0
    self.shift = shift
    self.movement = 0
    self.period = 1
end

function Wave:update(dt)
    self.deltaAngle = self.deltaAngle + dt * 30
    self.movement = cos(rad(self.deltaAngle))
end

function Wave:draw()
    local r = self.r
    local deltaAngle = self.deltaAngle
    local shift = self.shift
    local movement = self.movement
    local period = self.period

    fill(colors.white)

    beginShape(POINTS)
    for angle = 0, 360, stepAngle do
        local x = map(angle, 0, 360, -r, r)
        local magnitude = r * sqrt(1 - (x/r)^2)
        local y = magnitude * sin(rad(angle + deltaAngle + shift * movement) * period)
        vertex(x, y)
        --ellipse(x, y, 1, 3)
    end
    endShape()
end
