The2048 = class() : extends(Sketch)

DELAY = 0.05

function The2048:init()
    Sketch.init(self)

    self.anchor = Anchor(4.5)

    self.grid = Grid(4, 4)
    
    self.cellSize = self.anchor:size(1, 1)

    self.score = 0
    self.scoreMax = 0

    self.actions = Array()

    self.parameter:action('reset', function () self:initGame() end)

    self.parameter:watch('Score', Bind(self, 'score'))
    self.parameter:watch('Best', Bind(self, 'scoreMax'))

    if not self:loadGame() then
        self:initGame()
    end
end

function The2048:initGame()
    self.score = 0

    self.grid:clear()

    self.cells = Array()
    self.animations = Array()
    
    self:addCell()
end

function The2048:loadGame()
    local status, result = xpcall(function () return self:__loadGame() end, nilf)
    if status then
        return result
    end
end

function The2048:__loadGame()
    self.grid:clear()
    
    self.cells = Array()
    self.animations = Array()

    -- load data
    local data = readFile('2048')
    if not data or not data.cells then return false end

    -- use data to restore the game
    for k,value in pairs(data.cells) do
        local index = tonumber(k)
        local i, j = (index-1)%4+1, floor((index-1)/4)+1
        self:setCell(i, j, self:newCell(i, j, value))
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

    self.grid:foreach(function (cell, i, j)
        local k = self.grid:offset(i, j)
        data.cells[k] = cell.value
    end)

    -- save data
    saveFile('2048', data)
end

function The2048:newCell(i, j, value)
    local newCell = {
        value = value,
        position = self:cellPosition(i, j),
    }

    self.cells:add(newCell)

    return newCell
end

function The2048:addCell(level)
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
    local value = Array{2, 4}:random()
    local newCell = self:newCell(i, j, value)
    self:setCell(i, j, newCell)

    newCell.scale = vec2()

    self.animations:add{
        source = newCell,
        level = (level or 0),
        target = {scale = vec2(1,1)},
        delay = DELAY,
    }
end

function The2048:isGameOver()
    self.level = 0

    local change = self:applyFunction('all', self.moveOrFusionAvailable, false)
    return change == 0 and true
end

function The2048:action(direction, f)
    self.level = 0

    local change = 0
    change = change + self:applyFunction(direction, self.moveOrFusion, true)
    -- change = change + self:applyFunction(direction, self.move, true)
    -- change = change + self:applyFunction(direction, self.fusion, false)
    -- change = change + self:applyFunction(direction, self.move, true)

    if change > 0 then
        self:addCell(self.level)
    end

    self.grid:foreach(function (cell) cell.fusion = nil end)

    self.animations:add{
        source = self,
        target = {},
        level = self.level + 1,
        delay = 0,
        callback = function () self:saveGame() end,
    }
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
        self.level = self.level + (change > 0 and 1 or 0)
    until change == 0 or not repeatOnChange

    return totalChange
end

function The2048:getCell(i, j)
    return self.grid:getCell(i, j)
end

function The2048:setCell(i, j, cell)
    return self.grid:setCell(i, j, cell)
end

function The2048:get(i, j)
    return self.grid:get(i, j)
end

function The2048:set(i, j, value)
    return self.grid:set(i, j, value)
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

function The2048:moveOrFusion(i, j, di, dj)
    return self:move(i, j, di, dj) + self:fusion(i, j, di, dj)
end

function The2048:move(i, j, di, dj)
    if not self:get(i+di, j+dj) and self:get(i, j) then
        local cell = self:getCell(i, j)
        self:setCell(i, j, nil)
        self:setCell(i+di, j+dj, cell)

        self.animations:add{
            source = cell,
            level = self.level,
            from = {position = self:cellPosition(i, j)},
            target = {position = self:cellPosition(i+di, j+dj)},
            delay = DELAY,
        }
        return 1
    end
    return 0
end

function The2048:fusion(i, j, di, dj)
    local startCell = self:getCell(i, j)
    local endCell = self:getCell(i+di, j+dj)

    if (startCell.value and endCell.value and 
        startCell.value == endCell.value and 
        not startCell.fusion and
        not endCell.fusion)
    then
        local value = 2 * endCell.value
        endCell.drawValue = endCell.value
        endCell.value = value
        endCell.fusion = true

        self:setCell(i, j, nil)

        self.score = self.score + value
        self.scoreMax = max(self.score, self.scoreMax)

        self.animations:add{
            source = startCell,
            level = self.level,
            from = {position = self:cellPosition(i, j)},
            target = {position = self:cellPosition(i+di, j+dj)},
            delay = DELAY,
            callback = function ()
                startCell.value = -1
                endCell.drawValue = nil
            end,
        }
        return 1
    end
    return 0
end

function The2048:keypressed(key)
    if self:isGameOver() then
        self:initGame()
    else
        if #self.actions <= 0 then
            self.actions:add(key)
        end
    end
end

function The2048:mousemoved(mouse)
    local direction = mouse:getDirection()
    if direction then
        self:keypressed(direction)
    end
end

function The2048:cellPosition(i, j)
    return self.anchor:pos(i-.75, -3-(3.5-j))
end

function The2048:update(dt)
    if #self.actions > 0 and #self.animations == 0 then
        self:action(self.actions:remove(1))
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

    for _, anim in ipairs(self.animations) do
        local currentLevel = self.animations[1].level
        if currentLevel ~= anim.level then break end

        if anim.tween == nil then
            for k, v in pairs((anim.from or {})) do
                anim.source[k] = anim.from[k]
            end
            anim.tween = animate(anim.source, anim.target, anim.delay, function ()
                if anim.callback then anim.callback() end
            end)
        end
    end
    self.animations:removeIfTrue(function (cell) return cell.tween and cell.tween.state == 'dead' end)

    for _,cell in ipairs(self.cells) do
        Tile.draw(cell, cell.position, self.cellSize)
    end
    self.cells:removeIfTrue(function (cell) return cell.value == -1 end)

    if self:isGameOver() then
        background(0, 0, 0, 0.5)

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

Tile = class()
Tile.innerMarge = 5

function Tile:draw(position, cellSize)
    pushMatrix()

    local center = position + cellSize / 2

    translate(center.x, center.y)

    if self.translate then
        translate(self.translate.x, self.translate.y)
    end

    if self.scale then
        scale(self.scale.x, self.scale.y)
    end

    local value = self.drawValue or self.value

    noStroke()
    fill(The2048.colors[getPowerOf2(value)] or The2048.defaultColor)
    rect(0, 0, cellSize.x - Tile.innerMarge, cellSize.y - Tile.innerMarge, Tile.innerMarge)

    if value <= 4 then
        textColor(The2048.textColor)
    else
        textColor(colors.white)
    end
    text(value, 0, 0)

    popMatrix()
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
