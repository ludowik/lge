function setup()
    scene = Scene()

    ship = Ship()
    bullets = Node()
    asteroids = Node()
    
    scene:add(ship)
    scene:add(bullets)
    scene:add(asteroids)

    for i=1,10 do
        asteroids:add(Asteroid())
    end
end

function keypressed(key)
    if key == 'space' then
        bullets:add(Bullet(ship.position, vec2.fromAngle(ship.angle)))
    end
end

function action(dt)
    ship.linearForce = vec2()
    ship.angularForce = 0
    
    if love.keyboard.isDown('right') then
        ship.angularForce = PI
    end
    if love.keyboard.isDown('left') then
        ship.angularForce = -PI
    end
    
    if love.keyboard.isDown('up') then
        ship.linearForce = vec2.fromAngle(ship.angle):normalize(100)
    end

    if love.keyboard.isDown('down') then
        ship.linearForce = -vec2.fromAngle(ship.angle):normalize(50)
    end
end

function update(dt)
    action(dt)

    bullets:removeIfTrue(function (bullet) return bullet.hit or bullet.distance > W end)
    asteroids:removeIfTrue(function (asteroid) return asteroid.destroyed end)

    scene:update(dt)

    for _,bullet in bullets:ipairs() do
        for _,asteroid in asteroids:ipairs() do
            if asteroid.boundingBox:contains(bullet.position) then
                bullet.hit = true
                asteroid.hit = true
            end
        end
    end
end

function draw()
    background()

    translate(W/2, H/2)
    translate(-ship.position.x, -ship.position.y)

    scene:draw()
end


Object = class()

function Object:init()
end

function Object:draw()
    noFill()

    beginShape()
    for i,point in ipairs(self.vertices) do
        vertex(point.x, point.y)
    end
    endShape(CLOSE)
end


Ship = class() : extends(Object)

function Ship:init()
    Object.init(self)

    local size = 15

    self.position = vec2()
    self.linearForce = vec2()
    self.linearVelocity = vec2()

    self.angle = 0
    self.angularForce = 0
    self.angularVelocity = 0

    self.vertices = Array{
        size * vec2(cos(0), sin(0)),
        size * vec2(cos(PI*1.2), sin(PI*1.2)),
        size * vec2(cos(PI*0.8), sin(PI*0.8))
    }
end

function Ship:update(dt)
    self.linearVelocity = self.linearVelocity + self.linearForce * dt
    self.linearVelocity = self.linearVelocity * 0.992
    self.position = self.position + self.linearVelocity * dt

    self.angularVelocity = self.angularVelocity + self.angularForce * dt
    self.angularVelocity = self.angularVelocity * 0.98
    self.angularVelocity = clamp(self.angularVelocity, -PI, PI)
    self.angle = self.angle + self.angularVelocity * dt
end

function Ship:draw()
    translate(self.position.x, self.position.y)
    rotate(self.angle)
    Object.draw(self)
end


Bullet = class()

function Bullet:init(position, linearVelocity)
    self.position = vec2(position)
    self.linearVelocity = vec2(linearVelocity):normalize(100)
    self.distance = 0
end

function Bullet:update(dt)
    local dp = self.linearVelocity * dt
    self.position = self.position + dp

    self.distance = self.distance + dp:len()
    self.position = self.position + dp
end

function Bullet:draw()
    fill(colors.white)
    circle(self.position.x, self.position.y, 2)
end


Asteroid = class() : extends(Object)

function Asteroid:init(position, radius, linearVelocity)
    Object.init(self)

    self.position = position or (vec2.randomInScreen() - vec2(W/2, H/2))

    self.vertices = Array()

    self.angle = 0
    self.radius = radius or (random(20, 50))

    self.linearVelocity = linearVelocity or (vec2.randomAngle():normalize(randomInt(25)))
    self.angularVelocity = random(-PI / 4, PI / 4)
    
    local n = randomInt(12, 20)
    for i=1,n do
        local len = random(self.radius/2, self.radius)
        self.vertices:add(len * vec2(cos(2*PI*i/n), sin(2*PI*i/n)))
    end
end

function Asteroid:updateBoudingBox()
    local minx, miny =  math.maxinteger,  math.maxinteger
    local maxx, maxy = -math.maxinteger, -math.maxinteger

    local function updateMinMax(v)
        v = v:rotate(self.angle) + self.position

        minx = min(minx, v.x)
        miny = min(miny, v.y)

        maxx = max(maxx, v.x)
        maxy = max(maxy, v.y)
    end

    for _,v in ipairs(self.vertices) do
        updateMinMax(v)
    end

    self.boundingBox = Rect(minx, miny, maxx-minx, maxy-miny)
end

function Asteroid:update(dt)
    local center = ship.position

    if self.hit then
        self.destroyed = true
        if self.boundingBox:getArea() > 1500 then
            local radius = self.radius / 2
            asteroids:add(Asteroid(self.position+self.linearVelocity, radius,  self.linearVelocity))
            asteroids:add(Asteroid(self.position-self.linearVelocity, radius, -self.linearVelocity))
        end
    else
        self.position = self.position + self.linearVelocity * dt
        self.angle = self.angle + self.angularVelocity * dt

        if self.position.x <= center.x - W/2 then
            self.position.x = self.position.x + W

        elseif self.position.x > center.x + W/2 then
            self.position.x = self.position.x - W
        end

        if self.position.y <= center.y - H/2 then
            self.position.y = self.position.y + H

        elseif self.position.y > center.y + H/2 then
            self.position.y = self.position.y - H
        end

        self:updateBoudingBox()
    end
end

function Asteroid:draw()
    translate(self.position.x, self.position.y)

    fontSize(9)
    stroke(colors.red)
    textMode(CENTER)
    text(floor(self.boundingBox:getArea()), 0, 0)

    rotate(self.angle)

    stroke(colors.white)
    Object.draw(self)
end
