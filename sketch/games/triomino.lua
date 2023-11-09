Triomino = class() : extends(Sketch)

function Triomino:init()
    Sketch.init(self)

    self.anchor = Anchor(14)
    SIZE = self.anchor:size(1).x

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
end

function Triomino:initGame()
    self.grid = TriominoGrid(10, 10)
    self.grid.position = self.anchor:pos(2, 2)
    
    self.stack = Node()
    self.stack:add(Node())
    self.stack:add(Node())
    self.stack:add(Node())

    for i,v in self.stack:ipairs() do
        v.position = self.anchor:pos(2+(i-1)*10/3, self.anchor.nj-(self.anchor.nj-10)/4)
    end

    self:completeStack()
end

function Triomino:completeStack()
    for i,v in self.stack:ipairs() do
        if v:count() == 0 then 
            local mino = self.minos:random():clone()
            v:add(mino)

            mino.grid.size = mino.size
        end
    end
end

function Triomino:keypressed()
end

function Triomino:click(mouse)
    local mino = self.stack:contains(mouse.position)
    if mino then
        mino.grid = mino.grid:rotate()
    end
end

function Triomino:mousepressed(mouse)
    self.mino = self.stack:contains(mouse.position)
    if self.mino then
        self.mino.oldPosition = self.mino.position:clone()
    end
end

function Triomino:mousemoved(mouse)
    if self.mino then
        self.mino.position:add(mouse.deltaPos)

        local cellPosition = self:getAvailableMove(self.mino)
        if cellPosition then
            self.shadow = self.mino:clone()
            self.shadow.position:set(cellPosition*SIZE + (self.grid.position - vec2(5*SIZE)))
        else
            self.shadow = nil
        end
    end
end

function Triomino:mousereleased(mouse)
    if self.mino then
        self.mino.position = self.mino.oldPosition
        self.shadow = nil
    end
end

function Triomino:getAvailableMove(mino)
    mino = mino or self.current

    local grid = mino.grid
    local position = mino.position

    local cellPosition = ((position - self.grid.position) / SIZE):ceil()
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

function Triomino:draw()
    background()

    self.grid:draw(true)

    self.stack:draw()

    if self.shadow then
        self.shadow:draw()
    end

    axes2d()
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
    
    self.clr = Color.random()

    for i = 0, #arg-1, 2 do
        local c = arg[i+1]
        local len = arg[i+2]
        for i = 1, len do
            self.grid:set(c+i-1, r, self.clr)
        end
        r = r + 1
    end

    self.size:set(3*SIZE, 3*SIZE)
end

function Mino:draw()
    pushMatrix()
    translate(self.position.x, self.position.y)

    self.grid:draw()

    popMatrix()
end

TriominoGrid = class() : extends(Grid)

function TriominoGrid:init(...)
    Grid.init(self, ...)

    self.size = vec2(3*SIZE, 3*SIZE)
end

function TriominoGrid:draw(border, position)
    pushMatrix()
    if position then
        translate(self.position.x, self.position.y)
    end

    -- if self.size then
    --     local n = max(self.w, self.h)
    --     translate(n*SIZE/2, n*SIZE/2)
    -- end

    Grid.draw(self, 0, 0, function(cell, i, j)
        if cell.value then
            noStroke()
            fill(cell.value)
        else
            if not border then return end

            stroke(colors.gray)
            strokeSize(1)
            noFill()
        end

        circleMode(CENTER)
        circle((i-0.5-self.w/2)*SIZE, (j-0.5-self.h/2)*SIZE, SIZE/2-1)
    end)

    popMatrix()
end
