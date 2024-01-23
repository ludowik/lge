Particle = class() 

function Particle:init(x, y)
    self:set(x, y)
end

function Particle:set(x, y)
    if self.x then
        grid:set(self.x, self.y, nil)
    end

    self.x = x
    self.y = y
    grid:set(x, y, self)
end

function Particle:update()
    if not grid:get(self.x, self.y+1) then
        self:set(self.x, self.y+1)
    end
end

function Particle:draw()
    strokeSize(3)
    point(self.x, self.y)
end

function setup()
    grid = Grid(300, 200)
    particles = Array()
end

function update(dt)
    particles:add(Particle(grid.w/2, 1))
    particles:update()
end

function draw()
    background()
    particles:draw()
end
