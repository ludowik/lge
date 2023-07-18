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

function The2048:addCell()
    if self:isGameOver() then return end

    local i, j
    
    repeat
        i, j = random(1, 4), random(1, 4)
    until not self.grid:get(i, j)
    
    self.grid:set(
        i,
        j,
        Array{2, 4}:random())
end

function The2048:isGameOver()
    for i in range(4) do
        for j in range(4) do
            if not self.grid:get(i, j) then return false end
        end
    end
    return true
end

function The2048:action(direction, f)
    self:applyFunction(direction, self.move)
    self:applyFunction(direction, self.fusion)
    self:applyFunction(direction, self.move)

    self:addCell()
end

function The2048:applyFunction(direction, f)
    local change
    repeat
        change = 0
        if direction == 'left' then            
            for i = 2,4 do
                for j = 1,4,1 do
                    change = change + f(self, i, j, -1, 0)
                end
            end
        
        elseif direction == 'right' then
            for i = 3,1,-1 do
                for j = 1,4,1 do
                    change = change + f(self, i, j, 1, 0)
                end
            end

        elseif direction == 'up' then
            for j = 2,4 do
                for i = 1,4,1 do
                    change = change + f(self, i, j, 0, -1)
                end
            end

        elseif direction == 'down' then
            for j = 3,1,-1 do
                for i = 1,4,1 do
                    change = change + f(self, i, j, 0, 1)
                end
            end
        end
    until change == 0
end

function The2048:move(i, j, di, dj)
    if not self.grid:get(i+di, j+dj) and self.grid:get(i, j) then
        self.grid:set(i+di, j+dj, self.grid:get(i, j))
        self.grid:set(i, j, nil)
        return 1
    end
    return 0
end

function The2048:fusion(i, j, di, dj)
    if self.grid:get(i+di, j+dj) and self.grid:get(i, j) == self.grid:get(i+di, j+dj) then
        self.grid:set(i+di, j+dj, self.grid:get(i, j) * 2)
        self.grid:set(i, j, nil)
    end
    return 0
end

function The2048:keypressed(key, scancode, isrepeat)
    self:action(key)
end

function mouse:getDirection()
    if abs(mouse.move.x) > abs(mouse.move.y) then
        return mouse.move.x < 0 and 'left' or 'right'
    else
        return mouse.move.y < 0 and 'up' or 'down'
    end
end

function The2048:mousereleased(mouse)
    self:action(mouse:getDirection())    
end

function The2048:draw()
    background()

    rectMode(CENTER)            
    textMode(CENTER)

    local innerMarge = 5
    local center, size
    
    center = self.anchor:pos(2.5, -4)
    size = self.anchor:size(4, 4)

    noStroke()
    fill(colors.gray)
    rect(center.x, center.y, size.x + 2*innerMarge, size.y + 2*innerMarge, innerMarge)
    
    size = self.anchor:size(1, 1)

    local position, value
    for i in range(4) do
        for j in range(4) do
            position = self.anchor:pos(i-.5, -3-(4-j))
            center = position + size / 2

            value = self.grid:get(i, j)

            if value then
                noStroke()
                fill(Color.hsl(getPowOf2(value)/16))
                rect(center.x, center.y, size.x - innerMarge, size.y - innerMarge, innerMarge)

                stroke(colors.black)
                text(value, center.x, center.y)
            end
        end
    end
end

function getPowOf2(value)
    local n = 0
    while value >= 2 do
        value = value / 2
        n = n + 1
    end
    return n
end
