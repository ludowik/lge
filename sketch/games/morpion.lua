function setup()    
    cells = Grid(3, 3)

    cells.state = 'play'

    anchor = Anchor(4)

    if W < H then
        cells.cellSize = anchor:size(1, 1).x
        cells.position = anchor:pos(1, 3)
    else
        cells.cellSize = anchor:size(1, 1).x
        cells.position = vec2(cells.cellSize, cells.cellSize)
    end

    player = 'x'

    players = {
        x = {type='player'},
        o = {type='ia'}
    }

    scores = {
        x = 0,
        o = 0,
        draw = 0,
    }

    parameter:watch('x', "scores['x']")
    parameter:watch('o', "scores['o']")

    parameter:watch('draw', "scores['draw']")

    parameter:boolean('auto test', '__autotest', false)

    depth = 5 -- enough to win
    parameter:integer('depth', 'depth', 1, 10, depth)

    minimax = Minimax(cells)
end

function draw()
    background(54)

    cells:foreach(drawCell)
end

function update(dt)
    if env.__autotest then
        repeat
            play()
        until cells.state == 'new game'
    else
        play()
    end
end

function play()
    players['x'].type = env.__autotest and 'ia' or 'player'

    if cells.state == 'play' then
        local winner = minimax:gameWin(cells)
        if winner then
            cells.state = 'win'
            scores[winner] = scores[winner] + 1

        else
            if minimax:gameEnd(cells) then
                cells.state = 'end'
                scores['draw'] = scores['draw'] + 1

            elseif players[player].type == 'ia' then
                local cell = minimax:gamePlay(cells, player)
                cell.value = player
                player = minimax:nextPlayer(player)
            end
        end

    elseif cells.state == 'end' or cells.state == 'win' then
        cells.state = 'new game'
    
    elseif cells.state == 'new game' then
        if env.__autotest then
            cells:clear()
            cells.state = 'play'
        end
    end
end

function drawCell(cell, i, j)
    local w = cells.cellSize / 3
    local value = cell.value

    pushMatrix()
    do
        local x = (i - 1) * cells.cellSize + cells.position.x
        local y = (j - 1) * cells.cellSize + cells.position.y

        translate(x, y)

        strokeSize(1)
        stroke(colors.white)

        noFill()

        --rectMode(CENTER)
        --rect(0, 0, cells.cellSize, cells.cellSize)
        pushMatrix()
        do
            translate(-cells.cellSize/2, -cells.cellSize/2)
            if j == 2 then line(0, 0, cells.cellSize, 0) end
            if i == 2 then line(0, 0, 0, cells.cellSize) end
            if j == 2 then line(0, cells.cellSize, cells.cellSize, cells.cellSize) end
            if i == 2 then line(cells.cellSize, 0, cells.cellSize, cells.cellSize) end
        end
        popMatrix()

        strokeSize(8)

        if value == 'x' then
            stroke(colors.red)
            line(-w, -w,  w,  w)
            line(-w,  w,  w, -w)

        elseif value == 'o' then
            stroke(colors.green)
            circleMode(CENTER)
            circle(0, 0, w)
        end
    end
    popMatrix()
end

function mousereleased(touch)
    if touch.state ~= RELEASED then return end

    if cells.state == 'new game' then
        cells:clear()
        cells.state = 'play'

    elseif players[player].type == 'player' then
        if cells.state == 'play' then
            local x = cells.position.x - cells.cellSize / 2
            local y = cells.position.y - cells.cellSize / 2

            local dx, dy = cells.cellSize, cells.cellSize

            local ix = math.floor((touch.position.x - x) / dx) + 1
            local iy = math.floor((touch.position.y - y) / dy) + 1

            local cell = cells:getCell(ix, iy)

            if cell and not cell.value then
                cell.value = player
                player = minimax:nextPlayer(player)
            end
        end
    end
end

class 'Minimax'

function Minimax:init(grid)
    self.WIN_VALUE = 100

    self.lines = Array()

    for i=1,grid.w do
        self.lines:add({i, 1, 0, 1})
    end

    for i=1,grid.h do
        self.lines:add({1, i, 1, 0})
    end

    self.lines:add({1, 1, 1, 1})
    self.lines:add({1, grid.w, 1, -1})
end

function Minimax:nextPlayer(player)
    return player == 'x' and 'o' or 'x'
end

local MIN, MAX = math.mininteger, math.maxinteger

function Minimax:minimax(grid, depth, maximizingPlayer, currentPlayer, alpha, beta)
    local winner = self:gameWin(grid)
    if winner then
        return self.WIN_VALUE * (maximizingPlayer and -1 or 1)
    end

    local moves = self:gameMoves(grid)
    local n = #moves

    if depth == 0 or n == 0 then
        return random(self.WIN_VALUE/10) * (maximizingPlayer and -1 or 1)
    end

    local move, op, bestValue
    if maximizingPlayer then
        bestValue = MIN
        op = math.max
    else
        bestValue = MAX
        op = math.min
    end

    for i=1,n do
        move = moves[i]

        grid:set(move.x, move.y, currentPlayer)

        local value = self:minimax(grid, depth-1, not maximizingPlayer, self:nextPlayer(currentPlayer), alpha, beta)

        if op(value, bestValue) == value then
            bestValue = value
        end

        if maximizingPlayer then
            alpha = op(alpha, bestValue)
        else
            beta = op(beta, bestValue)
        end

        grid:set(move.x, move.y)

        if beta <= alpha then
            break
        end
    end

    return bestValue
end

function Minimax:gamePlay(grid, player)
    local moves = self:gameMoves(grid)
    local n = #moves

    local bestMove

    local bestValue = MIN
    for i=1,n do
        move = moves[i]

        grid:set(move.x, move.y, player)

        local value = self:minimax(grid, depth, false, self:nextPlayer(player), MIN, MAX)
        if value > bestValue then
            bestValue = value
            bestMove = move
        end

        grid:set(move.x, move.y)
    end

    return grid:getCell(bestMove.x, bestMove.y)
end

function Minimax:gameMoves(grid)
    local moves = Array()
    grid:foreach(function (cell, x, y)
            if not cell.value then 
                moves:add({x=x, y=y})
            end
        end)
    return moves
end

local function testLine(grid, line)
    local x, y, dx, dy = unpack(line)

    local cell = grid:getCell(x, y)

    local value = cell and cell.value
    if not value then
        return false
    end

    while cell do
        x = x + dx
        y = y + dy

        cell = grid:getCell(x, y)

        if cell and (
            cell.value == nil or
            cell.value ~= value
        )
        then
            return false
        end
    end

    return value
end

function Minimax:gameWin(grid)    
    for _,line in ipairs(self.lines) do
        local winner = testLine(grid, line)
        if winner then
            return winner
        end
    end
end

function Minimax:gameEnd(grid)
    if grid:countCellsWithNoValue() == 0 then
        return true
    end
end
