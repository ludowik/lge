Particle = class()

MAX_LIFE = 350

function Particle:init(emitter)
    Particle.initImage(30)

    self.position = vec2(emitter.absolutePosition.x, emitter.absolutePosition.y)
    self.linearVelocity = Particle.randomDirection()
    self.life = random(MAX_LIFE)
end

function Particle:update(dt)
    self.position.x = self.position.x + self.linearVelocity.x * dt
    self.position.y = self.position.y + self.linearVelocity.y * dt

    self.life = self.life - dt*100
end

function Particle:draw()
    local r = randomInt(max(1, ceil(self.life/2)))
    tint(self.life, r, r, 50)

    local size = map(self.life, 0, MAX_LIFE, 5, 25)

    spriteMode(CENTER)
    sprite(Particle.img, self.position.x, self.position.y, size, size)
end

function Particle.randomDirection()
    n = n or 50

    local angle = random(-TAU/8, TAU/8)+TAU/4
    local radius = random(n/2, n)

    return vec2(
        cos(angle) * radius,
        sin(angle) * radius)
end

function Particle.initImage(n)
    if Particle.img then return end

    n = n or 200
    local img = FrameBuffer(n, n)
    img:setContext()

    resetMatrixContext()
    
    background(0)
    ellipseMode(CENTER)
    for i=n,1,-1 do
        noStroke()
        fill(1, 1, 1, map(i, 1, n, 1, 0))
        ellipse(n/2, n/2, i/2, i/2)
    end
    
    resetContext()
    
    Particle.img = img
    return img
end
