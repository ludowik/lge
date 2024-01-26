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
    local nx, ny
    if not grid:get(self.x, self.y+1) then
        nx, ny = self.x, self.y+1

    elseif self.x > 1 and not grid:get(self.x-1, self.y+1) and self.x < W and not grid:get(self.x+1, self.y+1) then
        if random() < 0.5 then
            nx, ny = self.x-1, self.y+1
        else
            nx, ny = self.x+1, self.y+1
        end
    
    elseif self.x > 1 and not grid:get(self.x-1, self.y+1) then
        nx, ny = self.x-1, self.y+1

    elseif self.x < W and not grid:get(self.x+1, self.y+1) then
        nx, ny = self.x+1, self.y+1
    end

    if nx and Rect(0, 0, grid.w, grid.h):contains(vec2(nx, ny)) then
        self:set(nx, ny)
    end
end

function Particle:draw()
    strokeSize(1)
    point(self.x-1, self.y-1)
end

function setup()
    grid = Grid(160, 100)

    particles = Array()
    particles:add(Particle(grid.w/2, 1))
end

function update(dt)
    particles:update()
end

function draw()
    background()

    translate(W/2, H/2)
    
    SCALE = 8
    scale(SCALE)
    translate(-grid.w/2, -grid.h/2)

    rect(1, 1, grid.w, grid.h)
    
    particles:draw()
end

function mousemoved(mouse)
    local position = ((mouse.position - vec2(W, H)/2)/SCALE + vec2(grid.w, grid.h)/2):floor()
    if Rect(0, 0, grid.w, grid.h):contains(position) then
        particles:add(Particle(position.x, position.y))
    end
end
