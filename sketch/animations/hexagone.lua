Hexagone = class() : extends(Sketch)

function Hexagone:init()
    Sketch.init(self)

    self.particles = Node()
end

function Hexagone:update(dt)
    if random() < 0.5 then
        self.particles:add(Particle())
    end
    self.particles:removeIfTrue(function (item) return item.state == 'dead' end )
end

function Hexagone:draw()
    background(0, 0, 0, 0.05)

    translate(W/2, H/2)

    self.particles:draw()
end


Particle = class()

Particle.DISTANCE = 50

Particle.n = 0

function Particle:init()
    Particle.n = Particle.n + 1

    self.clr = Color.hsl(Particle.n / 1024)
    self.clr.a = 0.8

    self.position = vec2()
    self.angle = PI/13 + TAU/3 * random(1, 3)
    self.speed = random(50, 150)
    self.distance = Particle.DISTANCE
    self.chanceToDie = 0.1
end

function Particle:update(dt)
    local direction = vec2.fromAngle(self.angle)
    local deltaPosition = direction * self.speed * dt
    self.distance = self.distance - deltaPosition:len()

    if deltaPosition:len() > self.distance then
        if random() <= self.chanceToDie then
            self.state = 'dead'
        else
            deltaPosition:normalize(self.distance)
            self.distance = Particle.DISTANCE

            if random() < .5 then
                self.angle = self.angle + PI/3
            else
                self.angle = self.angle - PI/3
            end

            local pctChange = 0.4
            self.speed = self.speed + (random() * pctChange - pctChange/2) * self.speed
        end
    end

    self.position = self.position + deltaPosition
end

function Particle:draw()
    stroke(self.clr)
    strokeSize(4)

    function step(dt)
        self:update(dt)
        point(self.position.x, self.position.y)
    end

    for i in range(10) do
        step(DeltaTime/10)
    end
end
