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

function action(dt)
    if love.keyboard.isDown('space') then
        bullets:add(Bullet(vec2(), vec2.fromAngle(ship.angle)))
    end

    ship.angularVelocity = 0
    
    if love.keyboard.isDown('left') then
        ship.angularVelocity = -TAU
    end
    if love.keyboard.isDown('right') then
        ship.angularVelocity = TAU
    end
end

function update(dt)
    action(dt)

    bullets:removeIfTrue(function (bullet) return bullet.distance > W end )
    scene:update(dt)
end

function draw()
    background()
    translate(W/2, H/2)
    scene:draw()
end


Object = class()

function Object:init()
end

function Object:draw()
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

    self.angle = 0
self.angularVelocity = 0

    self.vertices = Array{
        size * vec2(cos(0), sin(0)),
        size * vec2(cos(PI*1.2), sin(PI*1.2)),
        size * vec2(cos(PI*0.8), sin(PI*0.8))
    }
end

function Ship:update(dt)
    self.angle = self.angle + self.angularVelocity * dt
end

function Ship:draw()
    rotate(self.angle)
    Object.draw(self)
end


Bullet = class()

function Bullet:init(position, linearVelocity)
    self.position = vec2(position)
    self.linearVelocity = vec2(linearVelocity):normalize(W)
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

function Asteroid:init()
    Object.init(self)

    self.position = vec2.randomInScreen() - vec2(W/2, H/2)

    self.vertices = Array()

    self.angle = 0
    self.radius = random(20, 50)

    self.linearVelocity = vec2.randomAngle():normalize(randomInt(25))
    self.angularVelocity = PI / 4
    
    local n = randomInt(5, 7)
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
    local dp = self.linearVelocity * dt
    self.position = self.position + dp

    self.angle = self.angle + self.angularVelocity * dt

    if self.position.x <= -W/2 then
        self.position.x = self.position.x + W
    elseif self.position.x > W/2 then
        self.position.x = self.position.x - W
    end

    if self.position.y <= -H/2 then
        self.position.y = self.position.y + H
    elseif self.position.y > H/2 then
        self.position.y = self.position.y - H
    end

    self:updateBoudingBox()
end

function Asteroid:draw()
    self.boundingBox:draw()

    translate(self.position.x, self.position.y)
    rotate(self.angle)
    Object.draw(self)
end
