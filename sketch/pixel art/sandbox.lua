function setup()
    grid = Grid(160, 100)
    particles = Array()
end

function update(dt)
    particles:update()
end

function draw()
    background()

    translate(CX, CY)
    
    scaleFactor = 8
    scale(scaleFactor)
    translate(-grid.w/2, -grid.h/2)

    rect(1, 1, grid.w, grid.h)
    
    particles:draw()
end

function mousemoved(mouse)
    local position = ((mouse.position - vec2(W, H)/2)/scaleFactor + vec2(grid.w, grid.h)/2):floor()
    if Rect(0, 0, grid.w, grid.h):contains(position) then
        particles:add(Water(position.x, position.y))
    end
end

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

function Particle:isAvailableMove(move)
    local dx, dy = move[1], move[2]
    local cell = grid:getCell(self.x + dx, self.y + dy)
    if cell and cell.value == nil then
        return {dx = self.x + dx, dy = self.y + dy}
    end
end

function Particle:isAvailableMoves(moves)
    local availableMoves = Array()
    for _,move in ipairs(moves) do
        move = self:isAvailableMove(move)
        if move then 
            availableMoves:add(move)
        end
    end

    if #availableMoves == #moves then
        return {moves = availableMoves}
    end
end

function Particle:getAvailableMove()
    return
        self:isAvailableMove({0, 1}) or 
        self:isAvailableMoves({-1, 1}, {1, 1}) or 
        self:isAvailableMove({-1, 1}) or 
        self:isAvailableMove({1, 1})
end

function Particle:update()
    local move = self:getAvailableMove()
    if move then
        move = move.moves and move.moves:random() or move
        if Rect(0, 0, grid.w, grid.h):contains(vec2(move.dx, move.dy)) then
            self:set(move.dx, move.dy)
        end
    end
end

function Particle:draw()
    strokeSize(1)
    point(self.x-1, self.y-1)
end

Water = class() : extends(Particle)

function Water:getAvailableMove()
    return
        self:isAvailableMove({0, 1}) or
        self:isAvailableMoves({{-1, 1}, {1, 1}}) or
        self:isAvailableMove({-1, 1}) or
        self:isAvailableMove({1, 1})
end
