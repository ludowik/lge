Hexagone = class() : extends(Sketch)

function Hexagone:init()
    Sketch.init(self)

    self.particles = Node()

    self.parameter:watch({object = self, expression = 'particles:count()'})
end

function Hexagone:update(dt)
    self.particles:add(Particle())
    self.particles:remove(function (item) return item.state == 'dead' end )
end

function Hexagone:draw()
    fill(0, 0, 0, 0.1)
    rect(0, 0, W, H)

    noFill()

    translate(W/2, H/2)

    self.particles:draw()
end


Particle = class()

Particle.DISTANCE = 30

function Particle:init()
    self.clr = Color(1, 0, 0)
    self.clr.a = random()

    self.position = vec2()
    self.angle = PI/13 + TAU/3 * random(1, 3)
    self.speed = random(250, 450)
    self.distance = Particle.DISTANCE
    self.life = random(5, 250)
end

function Particle:update(dt)
    local direction = vec2.fromAngle(self.angle)
    local deltaPosition = direction * self.speed * dt
    self.distance = self.distance - deltaPosition:len()

    if deltaPosition:len() > self.distance then
        deltaPosition:normalize(self.distance)
        self.distance = Particle.DISTANCE

        if random() < .5 then
            self.angle = self.angle + PI/3
        else
            self.angle = self.angle - PI/3
        end
    end

    self.position = self.position + deltaPosition

    self.life = self.life * 0.995

    if self.life <= 1 then 
        self.state = 'dead'
    end        
end

function Particle:draw()
    stroke(self.clr)
    strokeSize(map(self.life, 0, 20, 1, 2.5))

    function step(dt)
        self:update(dt)
        point(self.position.x, self.position.y)
    end

    for i in range(10) do
        step(DeltaTime/10)
    end
end
