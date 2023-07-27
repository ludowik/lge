The2048 = class() : extends(Sketch)

function The2048:init()
    Sketch.init(self)

    self.anchor = Anchor(4.5)

    self.grid = Grid(4, 4)

    self.score = 0
    self.scoreMax = 0

    self.parameter:action('reset', function () self:initGame() end)

    self.parameter:watch('score', Bind(self, 'score'))
    self.parameter:watch('scoreMax', Bind(self, 'scoreMax'))   

    self.parameter:watch('tween', '#tweenManager')

    if not self:loadGame() then
        self:initGame()
    end
end

function The2048:initGame()
    self.grid:clear()
    self:addCell()

    self.score = 0
end

function The2048:loadGame()
    self.grid:clear()

    -- load data
    local data = readFile('2048')
    if not data or not data.cells then return false end

    -- use data to restore the game
    for k,value in pairs(data.cells) do
        self.grid.items[tonumber(k)] = {value = value}
    end

    self.score = data.score or 0
    self.scoreMax = data.scoreMax or score

    return true
end

function The2048:saveGame(data)
    -- generate data to save
    local data = {
        cells = Array(),
        score = self.score,
        scoreMax = self.scoreMax,
    }

    self.grid.items:foreachKey(function (cell, k) data.cells[k] = cell.value end)

    -- save data
    saveFile('2048', data)
end

function The2048:addCell()
    local availablePosition = Array()
    for i in range(4) do
        for j in range(4) do
            if not self:get(i, j) then
                availablePosition:add({i, j})
            end
        end
    end

    if #availablePosition == O then
        return
    end

    local i, j = unpack(availablePosition:random())
    self:set(
        i,
        j,
        Array{2, 4}:random())

    self:animateNew(i, j)
end

function The2048:isGameOver()
    local change = self:applyFunction('all', self.moveOrFusionAvailable, false)
    return change == 0 and true
end

function The2048:action(direction, f)
    local change = 0
    change = change + self:applyFunction(direction, self.move, true)
    change = change + self:applyFunction(direction, self.fusion, false)
    change = change + self:applyFunction(direction, self.move, true)

    if change > 0 then
        self:addCell()
    end

    self:saveGame()
end

function The2048:applyFunction(direction, f, repeatOnChange)
    local totalChange = 0
    local change
    repeat
        change = 0
        if direction == 'all' or direction == 'left' then            
            for i = 2,4 do
                for j = 1,4,1 do
                    change = change + f(self, i, j, -1, 0)
                end
            end
        end
        if direction == 'all' or direction == 'right' then
            for i = 3,1,-1 do
                for j = 1,4,1 do
                    change = change + f(self, i, j, 1, 0)
                end
            end
        end
        if direction == 'all' or direction == 'up' then
            for j = 2,4 do
                for i = 1,4,1 do
                    change = change + f(self, i, j, 0, -1)
                end
            end
        end
        if direction == 'all' or direction == 'down' then
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

function The2048:getCell(i, j)
    return self.grid:get(i, j) or {}
end

function The2048:setCell(i, j, cell)
    return self.grid:set(i, j, cell)
end

function The2048:get(i, j)
    local cell = self:getCell(i, j)
    return cell.value
end

function The2048:set(i, j, value)
    local cell = self.grid:get(i, j)
    if not cell then
        cell = {}
        self.grid:set(i, j, cell)
    end
    cell.value = value
end

function The2048:moveOrFusionAvailable(i, j, di, dj)
    if not self:get(i+di, j+dj) and self:get(i, j) then
        return 1
    end
    if self:get(i+di, j+dj) and self:get(i, j) == self:get(i+di, j+dj) then
        return 1
    end
    return 0
end

function The2048:move(i, j, di, dj)
    if not self:get(i+di, j+dj) and self:get(i, j) then
        local cell = self:getCell(i, j)
        cell.fromPosition = cell.fromPosition or self:cellPosition(i, j)
        self:setCell(i+di, j+dj, cell)
        self:setCell(i, j, nil)
        return 1
    end
    return 0
end

function The2048:fusion(i, j, di, dj)
    if self:get(i+di, j+dj) and self:get(i, j) == self:get(i+di, j+dj) then
        local value = 2 * self:get(i, j)
        self:set(i+di, j+dj, value)
        self:set(i, j, nil)

        self.score = self.score + value
        self.scoreMax = max(self.score, self.scoreMax)
        return 1
    end
    return 0
end

function The2048:animateNew(i, j)
    local cell = self.grid:get(i, j)
    if cell then
        if cell.tween then
            cell.scale = nil
            cell.tween:stop()
        end

        cell.scale = vec2()
        cell.tween = animate(cell, {scale = vec2(1, 1)}, 0.2, function (tween)
            cell.scale = nil
        end)
    end
end

function The2048:animateMove(ifrom, jfrom, i, j)
    local cell = self.grid:get(i, j)
    local cellFrom = self.grid:get(ifrom, jfrom)
    if cell then
        cell.position = self:cellPosition(ifrom, jfrom)
        cell.tweens = {
            {cell, {position = self:cellPosition(i, j)}, 2, function () cell.position = nil end}
        }
        animate(unpack(cell.tweens[1]))
    end
end

function The2048:keypressed(key)
    if self:isGameOver() then
        self:initGame()
    else
        self:action(key)
    end
end

function The2048:mousereleased(mouse)
    self:keypressed(mouse:getDirection())
end

function The2048:cellPosition(i, j)
    return self.anchor:pos(i-.75, -3-(3.5-j))
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

    local position, cell
    for i in range(4) do
        for j in range(4) do
            cell = self:getCell(i, j)

            if cell.value then
                push()

                if cell.position then
                    position = cell.position
                else
                    position = self:cellPosition(i, j)
                end

                center = position + size / 2

                translate(center.x, center.y)

                if cell.scale then
                    scale(cell.scale.x, cell.scale.y)
                end

                if cell.rotate then
                    rotate(cell.rotate)
                end

                if cell.translate then
                    translate(cell.translate.x, cell.translate.y)
                end

                noStroke()

                fill(self.colors[getPowerOf2(cell.value)] or self.defaultColor)
                rect(0, 0, size.x - innerMarge, size.y - innerMarge, innerMarge)

                if cell.value <= 4 then
                    textColor(self.textColor)
                else
                    textColor(colors.white)
                end
                text(cell.value, 0, 0)

                pop()
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
