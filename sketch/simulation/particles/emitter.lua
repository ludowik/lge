Emitter = class() : extends(Node)

function Emitter:init(n)
    Node.init(self)

    self.absolutePosition = vec2(W/2, H/2)
    self.path = Array()

    self.particles = Node()

    self:addParticle(n)
end

function Emitter:addParticle(n)
    n = n or 100
    for i=1,n do
        self.particles:add(Particle(self))
    end
end

function Emitter:update(dt)
    self.particles:update(dt)

    for i=#self.particles.items,1,-1 do
        local particle = self.particles.items[i]
        if particle.life < -10 then
            self.particles.items:remove(i)
        end
    end

    self:addParticle(randomInt(3, 7))

    if #self.path > 0 then
        self.timer = 2
        if self.tween == nil then
            local point = self.path:remove(1)
            local distance = self.absolutePosition:dist(point)
            local speed = distance / 500
            self.tween = animate(self.absolutePosition, point, speed, 
                    tween.easing.linear,
                    function ()
                        self.tween = nil
                    end)
        end
    end

    if self.timer then
        self.timer = self.timer - dt
        if self.timer <= 0 then
            self:setPath()

            self.timer = nil
        end
    end
end

function Emitter:draw()
    self.particles:draw()
end

function Emitter:touched(touch)
    self:addPointToPath(touch.position)
end

function Emitter:addPointToPath(position)
    self.path:add(position:clone())
end

function Emitter:setPath()
    local x, y = W/2, H/2

    self:addPointToPath(vec2(x, y))

    local function spirale()
        local radius = 0
        for angle=0, TAU*4, TAU/36 do
            self:addPointToPath(vec2(
                    x + cos(angle)*radius,
                    y + sin(angle)*radius
                ))
            radius = radius + 1
        end
    end

    local function rect()
        local w, h = 100, 100
        self:addPointToPath(vec2(x-w, y-h))
        self:addPointToPath(vec2(x-w, y+h))
        self:addPointToPath(vec2(x+w, y+h))
        self:addPointToPath(vec2(x+w, y-h))
        self:addPointToPath(vec2(x-w, y-h))
    end

    local function random()
        for i =1,10 do
            self:addPointToPath(vec2().random())
        end
    end

    random()
end
