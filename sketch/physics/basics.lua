function setup()
    setOrigin(BOTTOM_LEFT)

    scene = Scene()
    physics = Physics()

    for i=1,20 do
        scene:add(Ball(50+i*5, 50*i))
    end

    parameter:watch('physics.countCollision')
end

function update(dt)
    physics:update(dt)
end

function draw()
    background()

    line(0, 0, W, 0)
    line(0, H, W, H)

    scene:draw()
end


Ball = class()

function Ball:init(x, y)
    self.position = vec3(
        x or random(W*.1, W*.9),
        y or random(H*.5,H*1.5),
        0)

    self.body = Body(DYNAMIC, CIRCLE, self.position, 30)
end

function Ball:draw()
    local position = self.body.position * physics.pixelRatio
    local radius = self.body.radius * physics.pixelRatio

    circle(position.x, position.y, radius)
end


Physics = class()

function Physics:init()
    self.bodies = Array()

    self.gravity = vec3(0, -9.8, 0)
    self.pixelRatio = 32
    self.dt = 0
end

function Physics:collision(dt)
    self.countCollision = 0

    for _,body in ipairs(self.bodies) do
        body:keepInArea()
    end

    for i=1,#self.bodies do
        local b1 = self.bodies[i]

        for j=i+1,#self.bodies do
            local b2 = self.bodies[j]
            
            -- detect collision
            local direction = b2.position - b1.position
            local distance = direction:len()
            
            local distanceMin = b1.radius + b2.radius

            if distance <= distanceMin then
                self.countCollision = self.countCollision + 1

                -- resolve collision
                local n = direction:normalize()

                local p = 2 * (
                    b1.linearVelocity.x * n.x +
                    b1.linearVelocity.y * n.y -
                    b2.linearVelocity.x * n.x -
                    b2.linearVelocity.y * n.y ) / (b1.mass + b2.mass)

                b1.linearVelocity.x = b1.linearVelocity.x - p * b1.mass * n.x
                b1.linearVelocity.y = b1.linearVelocity.y - p * b1.mass * n.y

                b2.linearVelocity.x = b2.linearVelocity.x + p * b2.mass * n.x
                b2.linearVelocity.y = b2.linearVelocity.y + p * b2.mass * n.y

                direction = n * (distanceMin - distance)

                b1.position = b1.position - direction / 2
                b2.position = b2.position + direction / 2
            end
        end
    end
end

function Physics:update(dt)
    local fixDeltaTime = 0.0005
    
    self.dt = self.dt + dt
    while self.dt > 0 do
        self.dt = self.dt - fixDeltaTime
        self.bodies:update(fixDeltaTime)
        self:collision(fixDeltaTime)
    end
end


Body = class()

function Body:init(bodyType, shapeType, position, radius)
    self.position = vec3(position) / physics.pixelRatio
    self.radius = (radius or 1) / physics.pixelRatio

    self.acceleration = vec3()
    self.linearVelocity = vec3()

    self.damping = 0.9
    self.bouncing = 0.85

    self.mass = 1

    physics.bodies:add(self)
end

function Body:update(dt)
    -- linear velocity
    local force = physics.gravity:clone()
    self.acceleration = force

    self.linearVelocity = self.linearVelocity + self.acceleration * dt
    self.position = self.position + self.linearVelocity * dt
    
    -- linear damping
    self.linearVelocity = self.linearVelocity * math.pow(self.damping, dt)
end

function Body:keepInArea()
    if self.position.y - self.radius <= 0 then
        self.position.y = self.radius
        self.linearVelocity.y = -self.bouncing * self.linearVelocity.y    
    end
    
    if self.position.x - self.radius <= 0 then
        self.position.x = self.radius
        self.linearVelocity.x = -self.bouncing * self.linearVelocity.x    
    end
    
    if self.position.x + self.radius > W / physics.pixelRatio then
        self.position.x = (W / physics.pixelRatio) - self.radius
        self.linearVelocity.x = -self.bouncing * self.linearVelocity.x
    end
end
