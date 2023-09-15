local snowflakes = Array() -- array to hold snowflake objects

function setup()
    setOrigin(BOTTOM_LEFT)
end

function update(dt)
    -- create a random number of snowflakes each frame
    for i=1,random(5) do
        snowflakes:push(Snowflake())
    end

    for i=#snowflakes,1,-1 do
        local snowflake = snowflakes[i]
        snowflake:update(dt)
    end
end

function draw()
    background(colors.brown)

    fill(240/255)
    noStroke()

    for i,snowflake in ipairs(snowflakes) do
        snowflake:draw()
    end
end

class('Snowflake')

function Snowflake:init()
    -- initialize coordinates
    self.position = vec2(
        0,
        H + random(50, 0))

    self.initialangle = random(0, TAU)
    self.size = random(2, 5)

    -- radius of snowflake spiral
    -- chosen so the snowflakes are uniformly spread out in area
    self.radius = sqrt(random(pow(W/2, 2)))
end

function Snowflake:update(dt)
    -- x position follows a circle
    local w = 0.2 -- angular speed
    local angle = w * ElapsedTime + self.initialangle
    self.position.x = W / 2 + self.radius * sin(angle)

    -- different size snowflakes fall at slightly different y speeds
    self.position.y = self.position.y - pow(self.size, 0.5)

    -- delete snowflake if past end of screen
    if self.position.y < 0 then
        local index = snowflakes:indexOf(self)
        snowflakes:remove(index)
    end
end

function Snowflake:draw()
    ellipse(self.position.x, self.position.y, self.size)
end
