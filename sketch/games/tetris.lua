-- TODO : save/load

Tetris = class() : extends(Sketch)

function Tetris:init()
    Sketch.init(self)

    cellSize = Anchor(14):size(1).x
    
    moves = {
        left = vec2(-1, 0),
        right = vec2(1, 0),
        down = vec2(0, 1),
    }

    self.tetriminos = Array {
        Tetrimino('I', { 0, 1, 2, 3, 4, 0, 0 }, colors.blue:lighten()),
        Tetrimino('O', { 0, 2, 3, -4, 0, 2, 3, 0 }, colors.yellow:darken()),
        Tetrimino('T', { 0, 2, 0, 1, 2, 3 }, colors.purple),
        Tetrimino('L', { 0, 3, 0, 1, 2, 3 }, colors.orange),
        Tetrimino('J', { 0, 1, 0, 1, 2, 3 }, colors.blue:lighten()),
        Tetrimino('Z', { 0, 2, 3, 0, 1, 2 }, colors.red:lighten()),
        Tetrimino('S', { 0, 1, 2, 0, 2, 3 }, colors.green)
    }

    self.pointsByLine = {
        {1, 40},
        {2, 100},
        {3, 300},
        {4, 1200},
    }

    self.gravityByLevel = {
        { 0, 1/64},
        {30, 1/48},
        {35, 1/40},
        {40, 1/32},
        {50, 1/24},
        {60, 1/16},
        {70, 1/8},
        {80, 1/6},
        {90, 1/4},
        {100, 2.5/8},
        {120, 3/8},
        {140, 3.5/8},
        {160, 1/2},
        {180, 4.5/8},
        {200, 1/64},
        {220, 1/8},
        {230, 2/8},
        {234, 3/8},
        {238, 4/8},
        {242, 5/8},
        {246, 6/8},
        {250, 7/8},
        {254, 1},
        {300, 2},
        {330, 3},
        {360, 4},
        {400, 5},
        {420, 4},
        {460, 3},
        {500, 20},
    }

    self:initGame()

    self.scene = Scene()
    
    self.parameter:action('new game', function () self:initGame() end)
end

function Tetris:initGame()
    self.__isGameOver = false

    self.grid = TetrisGrid(10, 20)

    self.stack = Array()
    self:completeStack()

    self.lines = 0
    self.score = 0

    self.level = 1
    self.gravity = self:getValueFromIndex(self.gravityByLevel, self.level)

    self:nextTetrimino()
end

function Tetris:completeStack()
    while #self.stack < 3 do
        self.stack:push(self.tetriminos:random():clone())
    end
end

function Tetris:isGameOver()
    return self.__isGameOver
end

function Tetris:getValueFromIndex(array, index)
    local value = 0
    for i,v in ipairs(array) do
        if index < v[1] then
            return value
        end
        value = v[2]
    end
    return value
end

function Tetris:autotest()
    if self:isGameOver() then self:initGame() end

    self:keypressed(Array{
        'left',
        'right',
        'up',
        'down',
--        'space',
    }:random())
end

function Tetris:keypressed(key)
    if self:isGameOver() then
        if key == 'return' then
            self:initGame()
        end
        return
    end

    if key == 'left' then
        self:makeTranslation(self.current, moves.left)

    elseif key == 'right' then
        self:makeTranslation(self.current, moves.right)

    elseif key == 'down' then
        self:makeTranslation(self.current, moves.down)
    
    elseif key == 'up' then
        self:makeRotation(self.current, false)
    
    elseif key == 'space' then
        self:playTetrimino()

    elseif key == 'n' then
        self:initGame()
    end
end

function Tetris:mousepressed(mouse)
    if self:isGameOver() then
        self:initGame()
        return
    end
    self.startPosition = vec2(mouse.position.x, mouse.position.y)
end

function Tetris:mousemoved(mouse)
    local direction = mouse.position - self.startPosition
    
    local dx = direction.x
    local dy = direction.y
    
    if abs(dx) >= cellSize then
        self.startPosition = vec2(mouse.position.x, mouse.position.y)
        if dx > 0 then
            self:makeTranslation(self.current, moves.right)
        else
            self:makeTranslation(self.current, moves.left)
        end

    elseif dy >= cellSize then
        self.startPosition = vec2(mouse.position.x, mouse.position.y)
        self:makeTranslation(self.current, moves.down)
    end
end

function Tetris:mousereleased(mouse)
    local touches = love.touch.getTouches()
    if #touches == 1 then
        self:playTetrimino()

    elseif mouse.presses == 1 then
        if mouse.position.x < 2*cellSize then
            self:playTetrimino()
        else
            self:makeRotation(self.current, true)
        end
    end
end

function Tetris:playTetrimino()
    while self:makeTranslation(self.current, moves.down) do end
    self:pushTetrimino()
    self:hasLines()
    self:nextTetrimino()
end

function Tetris:pushTetrimino()
    local tetrimino = self.current.grid
    local position = self.current.position
    local x, y = position.x, position.y
    tetrimino:foreach(function (block, i, j)
        if not block.value then return end
        self.grid:set(x+i, y+j, block.value)
    end)
end

function Tetris:nextTetrimino()
    self.current = self.stack:shift()
    self.current.position:set(floor((self.grid.w-self.current.grid.w)/2), -self.current.minY)

    self:updateShadow(self.current)

    self.distance = 0

    self:completeStack()

    if not self:isAvailableMove(self.current, {translation=moves.down}) then
        self.current = nil
        self.__isGameOver = true
    end
end

function Tetris:updateShadow()
    self.shadow = self.current:clone()
    while self:isAvailableMove(self.shadow, {translation=moves.down}) do
        self.shadow.position:add(moves.down)
    end
end

function Tetris:makeMove(tetrimino, move)
    if move.translation ~= nil then
        tetrimino:makeTranslation(tetrimino, move.translation)
    end
    if move.rotation ~= nil then
        tetrimino:makeTranslation(tetrimino, move.rotation)
    end
end

function Tetris:makeTranslation(tetrimino, translation)
    if self:isAvailableMove(tetrimino, {translation=translation}) then
        self.lastMove = 'translation'
        tetrimino.position:add(translation)
        self:updateShadow()
        if translation == moves.down then
            self.distance = 0
        end
        return true
    end
    return false
end

function Tetris:makeRotation(tetrimino, clockwise)
    if self:isAvailableMove(tetrimino, {rotation=clockwise}) then
        self.lastMove = 'rotation'
        tetrimino:rotate(clockwise)
        self:updateShadow()
        return true
    end

    local translations = {moves.down}

    for _,translation in ipairs(translations) do
        if self:isAvailableMove(tetrimino, {translation=translation, rotation=clockwise}) then
            self.lastMove = 'rotation'
            tetrimino.position:add(translation)
            tetrimino:rotate(clockwise)
            self:updateShadow()
            return true
        end
    end

    return false
end

function Tetris:isAvailableMove(tetrimino, move)
    local grid = tetrimino.grid
    local position = tetrimino.position
    
    if move.translation ~= nil then
        position = tetrimino.position + move.translation
    end
    
    if move.rotation ~= nil then
        grid = grid:rotate(move.rotation)
    end

    local x, y = position.x, position.y

    local availableMove = true
    grid:foreach(function (block, i, j)
        if not block.value then return end
        if (x + i < 1 or
            y + j < 1 or
            x + i > self.grid.w or
            y + j > self.grid.h or
            self.grid:get(x+i, y+j))
        then
            availableMove = false
        end
        return not availableMove and -1
    end)
    return availableMove
end

function Tetris:hasLines()
    local lines = 0
    
    local j = self.grid.h
    while j > 0 do
        if self:hasLine(j) then
            self:deleteLine(j)
            self:scrollLines(j)

            lines = lines + 1
        else
            j = j - 1
        end
    end

    if lines > 0 then
        self.lines = self.lines + lines
        self.score = self.score + self.level * self:getValueFromIndex(self.pointsByLine, lines)

        -- T-Spin
        if self.lastMove == 'rotation' then
            self.score = self.score + 400 * self.level
        end

        self.level = floor(self.lines / 10) + 1        
        self.gravity = self:getValueFromIndex(self.gravityByLevel, self.level)
    end
end

function Tetris:hasLine(j)
    local n = 0
    for i in range(self.grid.w) do
        if self.grid:get(i, j) then
            n = n + 1
        end
    end
    return n == self.grid.w
end

function Tetris:deleteLine(j)
    for i in range(self.grid.w) do
        self.grid:set(i, j, nil)
    end
    self:drawSketch(true)
end

function Tetris:scrollLines(start)
    for j=start,1,-1 do
        for i in range(self.grid.w) do
            self.grid:set(i, j, self.grid:get(i, j-1))
        end
    end

    self:drawSketch(true)
end

function Tetris:update(dt)
    if self:isGameOver() then return end
    
    self.distance = self.distance + dt * self.gravity * 60 -- 60 fps

    if self.distance >= 1 then
        if not self:makeTranslation(self.current, moves.down) then
            self:playTetrimino()
        end
    end
end

function Tetris:draw()
    background(Color(167, 154, 151))

    pushMatrix()

    translate(2*cellSize, cellSize + (H - self.grid.h * cellSize) / 2)

    fill(colors.black)
    noStroke()
    rect(0, 0, self.grid.w*cellSize, self.grid.h*cellSize)

    self.grid:draw()

    if self:isGameOver() then
        self:drawGameOver()
    else
        self.current:draw()
        self.shadow:draw(true)

        pushMatrix()
        translate((self.grid.w + 0.25) * cellSize, cellSize)
        
        scale(1/2)
        for i,v in ipairs(self.stack) do
            v:draw(false, 0.2)
            translate(0, v.grid.h * cellSize)
        end

        scale(2)

        translate(0, cellSize)
        
        fontName('comic')
        fontSize(22)

        textMode(CENTER)

        textColor(colors.white)

        text('', 0, textPosition())
        text('Lines', cellSize, textPosition())
        text(self.lines, cellSize, textPosition())

        text('', 0, textPosition())
        text('Score', cellSize, textPosition())
        text(self.score, cellSize, textPosition())
                
        text('', 0, textPosition())
        text('Level', cellSize, textPosition())
        text(self.level, cellSize, textPosition())
                
        popMatrix()
    end

    popMatrix()

    self.scene:layout(0, H/2, 'right')
    self.scene:draw()
end

Tetrimino = class() : extends(Rect)

function Tetrimino:init(label, init, clr)
    Rect.init(self)

    self.label = label
    self.clr = clr

    local n = #init

    local x, y, w, h = 0, 0, 0, 1
    for i = 1, n do
        if init[i] == 0 then
            h = h + 1
        else
            x = abs(init[i])
            w = max(x, w)
        end
    end

    self.grid = TetrisGrid(w, h)

    x, y = 0, 1
    for i = 1, n do
        if init[i] == 0 then
            y = y + 1
        else
            x = init[i]
            if x > 0 then
                self.grid:set(x, y, clr)
            end
        end
    end

    for j = 1, self.grid.h, 1 do
        for i = 1, self.grid.w do
            if self.grid:get(i, j) then
                self.minY = j-1
                break
            end
        end
        if self.minY then break end
    end
end

function Tetrimino:rotate(clockwise)
    self.grid = self.grid:rotate(clockwise)
    return self
end

function Tetrimino:draw(...)
    pushMatrix()
    translate(self.position.x*cellSize, self.position.y*cellSize)

    self.grid:draw(...)

    popMatrix()
end

TetrisGrid = class() : extends(Grid)

function TetrisGrid:init(...)
    Grid.init(self, ...)
end

function TetrisGrid:draw(shadow, luminosity)
    self.size = cellSize
    Grid.draw(self, 0, 0, function(cell, i, j)
        if not cell.value then return end

        local function rect(marge, border)
            Graphics2d.rect(
                (i - 1) * cellSize - marge,
                (j - 1) * cellSize - marge,
                cellSize + 2 * marge,
                cellSize + 2 * marge,
                border)
        end

        local clr = cell.value

        if luminosity then
            noStroke()
            fill(colors.gray)
            rect(2, 5)
        end

        if shadow then
            stroke(clr)
            noFill()
        else
            noStroke()
            fill(clr)
        end

        rect(-1, 5)
    end)
end
