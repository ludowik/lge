The2048 = class() : extends(Sketch)

function The2048:init()
    Sketch.init(self)
    self.anchor = Anchor(5)

    self:initGame()
end

function The2048:initGame()
    self.grid = Grid(4, 4)
    self:addCell()
end

function The2048:action(direction)
    if direction == 'left' then
        for i = 2,4 do
            for j = 1,4,1 do
                if (not self.grid:get(i-1, j) and self.grid:get(i, j))
                then
                    self.grid:set(i-1, j, self.grid:get(i, j))
                    self.grid:set(i, j, nil)
                end
            end
        end

    elseif direction == 'right' then
        for i = 3,1,-1 do
            for j = 1,4,1 do
                if (not self.grid:get(i+1, j) and self.grid:get(i, j))
                then
                    self.grid:set(i+1, j, self.grid:get(i, j))
                    self.grid:set(i, j, nil)
                end
            end
        end

    elseif direction == 'up' then
        for j = 2,4 do
            for i = 1,4,1 do
                if (not self.grid:get(i, j-1) and self.grid:get(i, j))
                then
                    self.grid:set(i, j-1, self.grid:get(i, j))
                    self.grid:set(i, j, nil)
                end
            end
        end

    elseif direction == 'down' then
        for j = 3,1,-1 do
            for i = 1,4,1 do
                if (not self.grid:get(i, j+1) and self.grid:get(i, j))
                then
                    self.grid:set(i, j+1, self.grid:get(i, j))
                    self.grid:set(i, j, nil)
                end
            end
        end
    end
end

function The2048:isGameOver()
    for i in range(4) do
        for j in range(4) do
            if not self.grid:get(i, j) then return false end
        end
    end
    return true
end

function The2048:addCell()
    local i, j
    
    repeat
        i, j = random(1, 4), random(1, 4)
    until not self.grid:get(i, j)
    
    self.grid:set(
        i,
        j,
        Array{2, 4}:random())
end

function The2048:update(dt)
    self:action('down')
end

function The2048:draw()
    background()

    rectMode(CENTER)            
    textMode(CENTER)

    local position, size, center
    
    center = self.anchor:pos(2.5, -3)
    size = self.anchor:size(4, 4) 
    rect(center.x, center.y, size.x+4, size.y+4)
    
    size = self.anchor:size(1, 1)

    for i in range(4) do
        for j in range(4) do
            local position = self.anchor:pos(i-.5, -(5-j)-1)
            local center = position + size / 2

            rect(center.x, center.y, size.x-4, size.y-4)

            text(i..','..j, position.x, position.y)
            
            local value = self.grid:get(i, j)
            if value then
                text(value, center.x, center.y)
            end
        end
    end
end

Grid = class() : extends(Array)

function Grid:init(w, h)
    assert(w, h)

    self.w = w
    self.h = h

    self.items = Array()
end

function Grid:offset(x, y)
    return x + y * self.w
end

function Grid:set(x, y, value)
    self.items[self:offset(x, y)] = value
end

function Grid:get(x, y)
    return self.items[self:offset(x, y)]
end
