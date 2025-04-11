Triomino = class() : extends(Sketch)

function Triomino:init()
    Sketch.init(self)

    N = 9

    self.anchor = Anchor(N+1)

    cellSize = self.anchor:size(1).x
    cellScale = 0.65

    self.minos = Array{
        Mino("1, 1"),
        Mino("1, 2"),
        Mino("1, 3"),
        Mino("1, 4"),
        Mino("1, 5"),
        Mino("1, 2, 1, 2"),
        Mino("1, 2, 1, 1"),
        Mino("1, 3, 1, 1"),
        Mino("1, 3, 2, 1"),
        Mino("1, 4, 2, 1"),
        Mino("1, 3, 1, 2"),
        Mino("1, 2, 2, 3"),
        Mino("1, 2, 1, 1, 1, 2"),
        Mino("2, 1, 1, 3, 2, 1"),
        Mino("1, 2, 2, 2, 3, 1"),
        Mino("2, 1, 1, 3, 1, 1"),
        Mino("1, 3, 2, 1, 2, 1"),
    }

    self:initGame()
    self:loadGame()

    self.parameter:action('new game', function () self:initGame() end)

    self.parameter:watch('Lines', Bind(self, 'lines'))
    self.parameter:watch('Score', Bind(self, 'score'))
end

function Triomino:initGame()
    self.grid = TriominoGrid(N, N)
    self.grid.position = self.anchor:pos(0.5, (self.anchor.nj-N)/2)
    
    self.stack = Node()
    self.stack:add(Node())
    self.stack:add(Node())
    self.stack:add(Node())

    for i,v in self.stack:ipairs() do
        v.position = self.anchor:pos(
            i*self.anchor.ni/4,
            N+3/4*(self.anchor.nj-N))
        v.oldPosition = v.position:clone()
    end

    self.lines = 0
    self.score = 0 

    self:completeStack()
end

function Triomino:loadGame()
    local status, result = xpcall(
        function ()
            return self:__loadGame()
        end, nilf)
        
    if status then
        return result
    end
end

function Triomino:__loadGame()
    self.grid:clear()
    
    -- load data
    local data = loadData('triomino')
    if not data or not data.cells then return false end

    -- use data to restore the game
    for k,value in pairs(data.cells) do
        local index = tonumber(k)
        local i, j = (index-1)%N+1, floor((index-1)/N)+1
        if value ~= 0 then
            self.grid:set(i, j, Color(value))
        end
    end

    self.lines = data.lines or 0
    self.score = data.score or 0

    return true
end

function Triomino:saveGame()
    -- generate data to save
    local data = {
        cells = Array(),
        lines = self.lines,
        score = self.score,
    }

    self.grid:foreach(function (cell, i, j)
        local k = self.grid:offset(i, j)
        data.cells[k] = cell.value or 0
    end)

    -- save data
    saveData('triomino', data)
end

function Triomino:completeStack()
    for i,v in self.stack:ipairs() do
        if v:count() == 0 then 
            local mino = self.minos:random():clone()
            mino.node = v

            v:add(mino)
        end
    end
end

function Triomino:click(mouse)
    local mino = self.mino or self.stack:contains(mouse.position)
    if mino then
        mino.grid = mino.grid:rotate(mouse.id == 1)
        mino.grid.rotation = (mouse.id == 1 and -1 or 1) * PI/2
        tween(mino.grid, {rotation = 0}, 1/6)
        self:updateShadow(mino)
    end
end

function Triomino:mousepressed(mouse)
    if self.mino then return end

    self.mino = self.stack:contains(mouse.position)
    if self.mino then
        self.mino.mouse_id = mouse.id
        
        self.mino.node.position:add(vec2(0, -self.mino.size.y))
        self.mino.grid.scale = 1
    end
end

function Triomino:mousemoved(mouse)
    if self.mino and self.mino.mouse_id == mouse.id then
        self.mino.node.position:add(mouse.deltaPos)
        self.mino.grid.scale = 1

        self:updateShadow(self.mino)
    end
end

function Triomino:mousereleased(mouse)
    if self.mino and self.mino.mouse_id == mouse.id then
        local cellPosition = self:getAvailableMove(self.mino)        
        if cellPosition then
            self:pushMino(self.mino, cellPosition)
            self:deleteLinesAndRows()

            self.mino.node:clear()
        end
        
        self.mino.node.position:set(self.mino.node.oldPosition)
        self.mino.grid.scale = cellScale
        self.mino.mouse_id = nil

        self.mino = nil
        self.shadow = nil

        self:completeStack()

        self:saveGame()
    end
end

function Triomino:getCellPosition(mino)
    local grid = mino.grid
    local position = mino.position

    local cellPosition = ((position + vec2(cellSize, cellSize)/2 - self.grid.position) / cellSize):ceil() - vec2(1, 1)

    return cellPosition
end

function Triomino:getAvailableMove(mino)
    local grid = mino.grid
    local position = mino.position

    local cellPosition = self:getCellPosition(mino)
    local x, y = cellPosition.x, cellPosition.y

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

    return availableMove and cellPosition
end

function Triomino:updateShadow(mino)
    local cellPosition = self:getAvailableMove(mino)
    if cellPosition then
        self.shadow = mino:clone()
        self.shadow.node = nil
        self.shadow.scale = 1
        self.shadow.rotation = 0
        self.shadow.position:set(self.grid.position + cellPosition*cellSize)
        self.shadow.grid.clr = colors.gray
    else
        self.shadow = nil
    end
end

function Triomino:pushMino(mino, cellPosition)
    local grid = mino.grid
    local position = mino.position

    -- local cellPosition = self:getCellPosition(mino)
    local x, y = cellPosition.x, cellPosition.y

    grid:foreach(function (block, i, j)
        if not block.value then return end
        self.grid:set(x+i, y+j, block.value)
    end)
end

function Triomino:deleteLinesAndRows()
    local lines = 0
    
    local j = self.grid.h
    while j > 0 do
        if self:hasLine(j) then
            self:deleteLine(j)
            lines = lines + 1
        else
            j = j - 1
        end
    end

    local i = self.grid.w
    while i > 0 do
        if self:hasRow(i) then
            self:deleteRow(i)
            lines = lines + 1
        else
            i = i - 1
        end
    end

    if lines > 0 then
        self.lines = self.lines + lines
        self.score = self.score + 1
    end
end

function Triomino:hasLine(j)
    local n = 0
    for i in range(self.grid.w) do
        if self.grid:get(i, j) then
            n = n + 1
        end
    end
    return n == self.grid.w
end

function Triomino:hasRow(i)
    local n = 0
    for j in range(self.grid.h) do
        if self.grid:get(i, j) then
            n = n + 1
        end
    end
    return n == self.grid.h
end

function Triomino:deleteLine(j)
    for i in range(self.grid.w) do
        self.grid:set(i, j, nil)
    end
end

function Triomino:deleteRow(i)
    for j in range(self.grid.h) do
        self.grid:set(i, j, nil)
    end
end

function Triomino:draw()
    background(colors.white)

    self.grid:draw(true, self.grid.position)

    if self.shadow then
        self.shadow:draw(false, self.shadow.position)
    end
    
    self.stack:draw()
end

Mino = class() : extends(Rect)

function Mino:init(init)
    Rect.init(self)

    local arg = string.split(init, ',')
    
    local n = #arg / 2
    local m = 0
    
    for i = 0, #arg-1, 2 do
        m = math.max(m, arg[i+1] + arg[i+2] - 1)
    end

    local r = 1
    
    self.grid = TriominoGrid(m, n)

    self.grid.scale = cellScale
    self.grid.rotation = 0
    
    self.clr = palette:random()

    for i = 0, #arg-1, 2 do
        local c = arg[i+1]
        local len = arg[i+2]
        for i = 1, len do
            self.grid:set(c+i-1, r, self.clr)
        end
        r = r + 1
    end
end

function Mino:draw()    
    if self.node then
        self.size = self.grid.size * (self.grid.scale or 1)
        self.position = self.node.position - self.size / 2
    end

    self.grid:draw(false, self.position, self.size)
    
    -- DEBUG
    -- if self.node then
    --     textColor(colors.black)
    --     text(self.mouse_id, self.position.x, self.position.y)
    -- end
end

TriominoGrid = class() : extends(Grid)

function TriominoGrid:init(...)
    Grid.init(self, ...)
    self.size = vec2(self.w*cellSize, self.h*cellSize)
end

function TriominoGrid:draw(border, position, size)
    pushMatrix()

    position = position or self.position
    size = size or self.size

    translate(position.x, position.y)
    translate(size.x/2, size.y/2)

    if self.scale then
        scale(self.scale)
    end

    if self.rotation then
        rotate(self.rotation)
    end
    
    local w, h, marge = self.w, self.h, 0

    Grid.draw(self, 0, 0, function (cell, i, j)
        if cell.value then
            noStroke()
            fill(self.clr or cell.value)

        else
            if not border then return end

            stroke(colors.gray)
            strokeSize(1)
            noFill()

            marge = 1
        end

        circleMode(CENTER)
        circle((i-(self.w+1)/2)*cellSize, (j-(self.h+1)/2)*cellSize, cellSize/2-marge)
    end)

    popMatrix()
end
