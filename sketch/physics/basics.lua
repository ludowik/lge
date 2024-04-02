function setup()
    setOrigin(BOTTOM_LEFT)

    scene = Scene()
    physics = Physics()

    for i=1,100 do
        scene:add(Ball(50+i*5, 100*i, random(10, 25)))
    end

    parameter:watch('physics.countDetectCollision')
    parameter:watch('physics.countCollision')
    parameter:watch('physics.quadtree.level')
    parameter:watch('physics.quadtree.addNode')

    parameter:boolean('gravity', 'withGravity', true)
end

function update(dt)
    physics:update(dt)
end

function mousepressed()
    scene:add(Ball())
end

function draw()
    background()

    line(0, 0, W, 0)
    line(0, H, W, H)

    scene:draw()
    physics:draw()
end


Ball = class()

function Ball:init(x, y, radius)
    self.position = vec3(
        x or random(W*.1, W*.9),
        y or random(H*.5, H*1.5),
        0)

    self.radius = random(20, 50)

    self.body = Body(DYNAMIC, CIRCLE, self.position, self.radius)
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

    self.quadtree = Quadtree(Quadtree.DYNAMIC, Body.intersect, 5)
end

function Physics:update(dt)
    local fixDeltaTime = dt
    
    self.dt = self.dt + dt
    while self.dt > 0 do
        self.dt = self.dt - fixDeltaTime
        self.bodies:update(fixDeltaTime)
        self:collision(fixDeltaTime)
    end
end

function Physics:collision(dt)
    self.countDetectCollision = 0
    self.countCollision = 0

    self.quadtree:update(self.bodies)

    self.quadtree:cross(function (b1, b2)        
        self.countDetectCollision = self.countDetectCollision + 1

        -- detect collision
        local direction = b2.position - b1.position
        local distance = direction:len()
        
        local distanceMin = b1.radius + b2.radius

        if distance <= distanceMin then
            self.countCollision = self.countCollision + 1

            -- resolve collision
            local n = direction / distance

            local p = 2 * n * (
                b1.linearVelocity.x * n.x +
                b1.linearVelocity.y * n.y -
                b2.linearVelocity.x * n.x -
                b2.linearVelocity.y * n.y ) / (b1.mass + b2.mass)

            b1.linearVelocity = b1.linearVelocity - p * b1.mass * b1.bouncing
            b2.linearVelocity = b2.linearVelocity + p * b2.mass * b2.bouncing

            direction = direction:normalize(distanceMin - distance)

            b1.position = b1.position - direction * b1.mass / (b1.mass + b2.mass)
            b2.position = b2.position + direction * b2.mass / (b1.mass + b2.mass)
        end
    end)

    for _,body in ipairs(self.bodies) do
        body:keepInArea()
    end
end

function Physics:draw()
    scale(self.pixelRatio)
    strokeSize(1/self.pixelRatio)
    self.quadtree:draw()
end


Body = class() : extends(Rect)

function Body:init(bodyType, shapeType, position, radius)
    self.position = vec3(position) / physics.pixelRatio
    self.radius = radius / physics.pixelRatio

    self.size = vec3(
        self.radius * 2,
        self.radius * 2, 0)

    self.center = self.position - self.size / 2

    self.acceleration = vec3()
    self.linearVelocity = vec3()

    self.damping = 0.85
    self.bouncing = 0.85

    self.mass = self.radius

    physics.bodies:add(self)
end

function Body:intersect(r)
    local cornerRect = Rect(r.position.x-r.size.x/2, r.position.y-r.size.y/2, r.size.x, r.size.y)
    return Rect.intersect(self, cornerRect)
end

function Body:applyForce(force)
    self.acceleration:add(force)
end

function Body:update(dt)
    -- linear velocity
    if withGravity then
        self:applyForce(physics.gravity)
    end

    self.linearVelocity = self.linearVelocity + self.acceleration * dt
    self.linearVelocity = self.linearVelocity:normalize(min(15, self.linearVelocity:len()))

    self.position = self.position + self.linearVelocity * dt
    
    -- linear damping
    self.linearVelocity = self.linearVelocity * math.pow(self.damping, dt)

    -- reset acceleration
    self.acceleration:set()
end

function Body:keepInArea()
    if self.position.y - self.radius < 0 then
        self.position.y = self.radius
        self.linearVelocity.y = -self.bouncing * self.linearVelocity.y    
    end
    
    if self.position.x - self.radius < 0 then
        self.position.x = self.radius
        self.linearVelocity.x = -self.bouncing * self.linearVelocity.x    
    end
    
    if self.position.x + self.radius >= W / physics.pixelRatio then
        self.position.x = (W / physics.pixelRatio) - self.radius
        self.linearVelocity.x = -self.bouncing * self.linearVelocity.x
    end
end
