Galaxy = class() : extends(Sketch)

galaxyRadius = 100
starsCount = 40
step = 20

function Galaxy:init()
    Sketch.init(self)
    
    self.parameter:integer('stars', 'starsCount', 10, 200)
        :attrib{
            callback = function () self:reset() end,
            incrementValue = 50,
        }

    self.parameter:integer('step', 'step', 10, 100)
        :attrib{
            incrementValue = 10,
        }

    self:reset()
end

function Galaxy:reset()
    self.stars = Array()
    self.speeds = Array()
    self.masses = Array()

    for i in range(starsCount) do
        local angle = random() * TAU
        local dist = random(galaxyRadius)
        self.stars:add({
            cos(angle) * dist,
            sin(angle) * dist,
            random(),
            random(),
            random(),
            random(),
        })
        
        angle = random(TAU)
        dist = random(galaxyRadius/10)
        self.speeds:add(vec2(
            cos(angle) * dist,
            sin(angle) * dist
        ))
        self.masses:add(random(1, 5))
    end

    self.stars:add({
        0,
        0,
        1,
        1,
        0,
        1,
    })
    self.speeds:add(vec2())
    self.masses:add(1000)
end

function Galaxy:update(dt)
    for i in range(step) do
        self:step(0.002)
    end
end

function Galaxy:step(dt)
    local smoothingLength = 1

    local stars = self.stars
    local speeds = self.speeds

    local force = vec2()
    local speed, dx, dy, f, dist, invF

    for i,star in ipairs(stars) do
        force:set()

        speed = speeds[i]

        for j,other in ipairs(stars) do
            if i ~= j then
                dx = (other[1] - star[1])
                dy = (other[2] - star[2])

                f = dx^2 + dy^2
                dist = sqrt(f)

                invF = self.masses[j] / (f + smoothingLength)

                force.x = force.x + (dx/dist) * invF
                force.y = force.y + (dy/dist) * invF
            end
        end

        speed.x = speed.x + force.x * dt
        speed.y = speed.y + force.y * dt
    end

    for i,star in ipairs(self.stars) do
        speed = speeds[i]

        star[1] = star[1] + speed.x * dt
        star[2] = star[2] + speed.y * dt

        -- keep in space
        if star[1] > galaxyRadius then
            star[1] = star[1] - 2*galaxyRadius
        elseif star[1] < -galaxyRadius then 
            star[1] = star[1] + 2*galaxyRadius
        end

        if star[2] > galaxyRadius then
            star[2] = star[2] - 2*galaxyRadius
        elseif star[2] < -galaxyRadius then 
            star[2] = star[2] + 2*galaxyRadius
        end
    end
end

function Galaxy:draw()
    background(Color(0,0,0,0.02))

    local scaleSize = W / (2 * galaxyRadius)

    stroke(colors.white)

    translate(W/2, H/2)
    scale(scaleSize)
    
    noStroke()
    for i,star in ipairs(self.stars) do
        fill(star[3], star[4], star[5], star[6])
        circle(star[1], star[2], map(self.masses[i], 1, 1000, 0.5, 3))
    end
end
