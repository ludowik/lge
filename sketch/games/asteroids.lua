function setup()
    scene = Scene()

    ship = Ship()
    bullets = Array()
    asteroids = Array()
    
    scene:add(ship)
    scene:add(bullets)
    scene:add(asteroids)

    for i=1,10 do
    end
end

function action(dt)
    if love.keyboard.isDown('space') then
        bullets:add(Bullet(vec2(), vec2.fromAngle(ship.angle)))
    end
    if love.keyboard.isDown('left') then
        ship.angle = ship.angle - TAU * dt
    end
    if love.keyboard.isDown('right') then
        ship.angle = ship.angle + TAU * dt
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


Ship = class()

function Ship:init()
    self.angle = 0
    self.vertices = Array{
        vec2(cos(0), sin(0)),
        vec2(cos(PI*1.2), sin(PI*1.2)),
        vec2(cos(PI*0.8), sin(PI*0.8))
    }
end

function Ship:draw()
    rotate(self.angle)
    
    scale(5, 5)

    beginShape()
    for i,point in ipairs(self.vertices) do
        vertex(point.x, point.y)
    end
    endShape(CLOSE)
end


Bullet = class()

function Bullet:init(position, velocity)
    self.position = vec2(position)
    self.velocity = vec2(velocity):normalize(W)
    self.distance = 0
end

function Bullet:update(dt)
    local dp = self.velocity * dt
    self.distance = self.distance + dp:len()
    self.position = self.position + dp
end

function Bullet:draw()
    fill(colors.white)
    circle(self.position.x, self.position.y, 2)
end


Asteroid = class()

