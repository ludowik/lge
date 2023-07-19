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
    background(self.backgroundColor)

    rectMode(CENTER)            
    textMode(CENTER)

    local innerMarge = 5
    local center, size
    
    center = self.anchor:pos(2.25, -3.5)
    size = self.anchor:size(4, 4)

    noStroke()
    fill(self.boardColor)
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

                fill(self.colors[getPowerOf2(value)] or self.defaultColor)
                rect(center.x, center.y, size.x - innerMarge, size.y - innerMarge, innerMarge)

                if value <= 4 then
                    textColor(self.textColor)
                else
                    textColor(colors.white)
                end
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

The2048.colors = {
    Color(238, 228, 218),
    Color(237, 224, 200),
    Color(242, 177, 121),
    Color(245, 149,  99),
    Color(246, 124,  95),
    Color(246,  94,  59),
    Color(237, 207, 114),
    Color(237, 204,  97),
    Color(237, 200,  80),
    Color(237, 197,  63),
    Color(237, 194,  46),
    Color(173, 183, 119),
    Color(170, 183, 102),
    Color(164, 183,  79),
    Color(161, 183,  63),
}

The2048.defaultColor = Color(161, 183,  63)
The2048.textColor = Color(118, 109, 100)
The2048.boardColor = Color(204, 192, 179)
The2048.backgroundColor = Color(250, 248, 239)

-- scoreBoardColor : Color(187, 173, 160)
-- buttonColor : Color(119, 110, 101)
