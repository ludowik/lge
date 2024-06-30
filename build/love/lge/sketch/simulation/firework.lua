Firework = class() : extends(Sketch)

function Firework:init()
    Sketch.init(self)
    
    setOrigin(BOTTOM_LEFT)

    self.particles = Array()
    self.parameter:watch('#env.sketch.particles')

    gravity = vec2(0, -10)
end

function Firework:update(dt)
    if random() < .1 then
        local x = W / 8
        local particle = ParticleFirework(vec2(random(x, W-x), 0), 'parent')
        particle:applyForce(vec2(0, 800))

        self.particles:add(particle)
    end

    self.particles:update(dt)

    for i=#self.particles,1,-1 do
       local particle = self.particles[i]
       if particle.state == 'dead' then
           self.particles:remove(i)
        end
    end
end

function Firework:draw()
    background(51)
    noStroke()
    self.particles:draw()
end

class 'ParticleFirework'

function ParticleFirework:init(position, state, clr, life, mass, radius)
    self.position = position

    self.acc = vec2()
    self.vel = vec2()

    self.state = state

    self.clr = clr or Color.random()
    
    self.life = life or 2
    self.mass = mass or 1
    
    self.radius = radius or 3
end

function ParticleFirework:applyForce(f)
    self.acc:add(f)
end

function ParticleFirework:update(dt)
    self:applyForce(gravity * self.mass)

    self.vel:add(self.acc, dt)

    self.position:add(self.vel)

    self.acc:set(0, 0)

    if self.state == 'parent' and self.vel.y < 0 then
        self.state = 'dead'
        for i=1,50 do
            local particle = ParticleFirework(self.position:clone(), 'child', self.clr, 2, 0.5, 2)

            local force = vec2.randomAngle() * random(200, 240)
            particle:applyForce(force)

            sketch.particles:add(particle)
        end

    elseif self.state == 'child' then
        self.life = self.life - dt
        if self.life < 0 then
            self.state = 'dead'
        end
    end
end

function ParticleFirework:draw()
    noStroke()
    fill(self.clr)
    
    circle(self.position.x, self.position.y, self.radius * self.life)
end
