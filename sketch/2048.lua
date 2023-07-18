The2048 = class() : extends(Sketch)

function The2048:init()
    Sketch.init(self)
    self.anchor = Anchor(4.5)

    self:initGame(readFile('2048'))
end

function The2048:initGame(data)
    self.grid = Grid(4, 4)

    if data and #data > 0 then
        for k,v in pairs(data) do
            self.grid.items[tonumber(k)] = v
        end
    else
        self:addCell()
    end
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
    local change = 0
    change = change + self:applyFunction(direction, self.move, true)
    change = change + self:applyFunction(direction, self.fusion, false)
    change = change + self:applyFunction(direction, self.move, true)

    if change > 0 then
        self:addCell()
    end

    saveFile('2048', self.grid.items)
end

function The2048:applyFunction(direction, f, repeatOnChange)
    local change, totalChange = 0, 0
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
        totalChange = totalChange + change
    until change == 0 or not repeatOnChange

    return totalChange
end

function The2048:move(i, j, di, dj)
    local grid = self.grid
    if not grid:get(i+di, j+dj) and grid:get(i, j) then
        grid:set(i+di, j+dj, grid:get(i, j))
        grid:set(i, j, nil)
        return 1
    end
    return 0
end

function The2048:fusion(i, j, di, dj)
    local grid = self.grid
    if grid:get(i+di, j+dj) and grid:get(i, j) == grid:get(i+di, j+dj) then
        grid:set(i+di, j+dj, grid:get(i, j) * 2)
        grid:set(i, j, nil)
        return 1
    end
    return 0
end

function The2048:keypressed(key, scancode, isrepeat)
    if not self:isGameOver() then
        self:action(key)
    end
end

function The2048:mousereleased(mouse)
    if self:isGameOver() then
        self:initGame()
    else
        self:action(mouse:getDirection())
    end
end

function The2048:draw()
    background()

    rectMode(CENTER)            
    textMode(CENTER)

    local innerMarge = 5
    local center, size
    
    center = self.anchor:pos(2.25, -3.5)
    size = self.anchor:size(4, 4)

    noStroke()
    fill(colors.gray)
    rect(center.x, center.y, size.x + 2*innerMarge, size.y + 2*innerMarge, innerMarge)
    
    size = self.anchor:size(1, 1)

    local position, value
    for i in range(4) do
        for j in range(4) do
            position = self.anchor:pos(i-.75, -3-(3.5-j))
            center = position + size / 2

            value = self.grid:get(i, j)

            if value then
                noStroke()
                fill(Color.hsl(getPowerOf2(value)/16))
                rect(center.x, center.y, size.x - innerMarge, size.y - innerMarge, innerMarge)

                stroke(colors.black)
                text(value, center.x, center.y)
            end
        end
    end

    if self:isGameOver() then
        background(0, 0, 0, 0.6)

        stroke(colors.white)
        fill(colors.black)

        fontSize(50)
        local gameOver = 'Game Over'
        local w, h = textSize(gameOver)

        rectMode(CENTER)
        rect(W/2, H/2, w*1.2, h*1.2, 20)

        textMode(CENTER)
        text(gameOver, W/2, H/2)
    end
end
