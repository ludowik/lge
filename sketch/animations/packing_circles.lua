-- TODO : use mechanism to limits the cross join

function setup()
    circles = Node()
end

function update(dt)
    circles:update(dt)

    circles:cross(
        function (c1, c2)
            local direction = c2.position - c1.position
            local distance = direction:len()
            if distance <= c1.size.x + c2.size.x then
                c1.packed = true
                c2.packed = true
            end
        end)

    local countPacked = 0
    circles:foreach(function (circle)
        if not circle.packed then
            countPacked = countPacked + 1
        end
    end)
    for i=countPacked,5 do
        local x = randomInt(-X, W+2*X)
        local y = randomInt(-Y, H+2*Y)

        local findPosition = true
        for j,circle in circles:ipairs() do
            if (circle.position - vec2(x, y)):len() <= circle.size.x then
                findPosition = false
                break
            end
        end
    
        if findPosition then
            circles:add(Circle(x, y))
        end
    end
end

function draw()
    circles:draw()
end

Circle = class() : extends(Rect)

function Circle:init(x, y)
    Rect.init(self, x, y, 1, 1)
    self.clr = Color.random()

    self.packed = false
end

function Circle:update(dt)
    if not self.packed then
        self.size.x = self.size.x + 1
    end
end

function Circle:draw()
    noStroke()
    fill(self.clr)
    circle(self.position.x, self.position.y, self.size.x-0.5)
end
