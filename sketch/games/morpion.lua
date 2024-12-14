function setup()
    M = 3
    N = 3

    MODE = 'morpion'

    COUNT = 3
    
    createGame()
    createUI()
end

function createGame()
    players = {
        x = { type = 'player', depth = 5 },
        o = { type = 'ia', depth = M*N <= 9 and 5 or 3 }
    }

    scores = {
        x = 0,
        o = 0,
        draw = 0,
    }

    beginners = 'x'

    newGame()

    minimax = Minimax(cells)
end

function createUI()
    parameter:watch('x', "scores['x']")
    parameter:watch('o', "scores['o']")

    parameter:watch('draw', "scores['draw']")

    parameter:integer('depth', 1, 10, players.o.depth, function ()
        players.o.depth = depth
    end)
end

function newGame()
    cells = cells or Grid(M, N)
    cells:clear()

    cells.state = 'play'
    
    beginners = beginners == 'x' and 'o' or 'x'
    player = beginners
    
    cells.currentMove = 1
end

function update(dt)
    play()
end

function autotest()
end

function draw()
    if W < H then
        anchor = Anchor(M+1)
        cells.cellSize = anchor:size(1, 1).x
        cells.position = anchor:pos(1, N)
    else
        anchor = Anchor(nil, N+1)
        cells.cellSize = anchor:size(1, 1).y
        cells.position = anchor:pos(M/2, 1)
    end

    drawBoard()
end

function drawBoard()
    background(colors.black)
    cells:foreach(drawCell)
end

function drawCell(cell, i, j)
    local w = cells.cellSize / 3
    local value = cell.value

    pushMatrix()
    do
        local x = (i - 1) * cells.cellSize + cells.position.x
        local y = (j - 1) * cells.cellSize + cells.position.y

        translate(x, y)

        strokeSize(2)
        stroke(colors.gray)

        noFill()

        pushMatrix()
        do
            translate(-cells.cellSize / 2, -cells.cellSize / 2)
            if j ~= 1 and j~= cells.h then line(0, 0, cells.cellSize, 0) end
            if i ~= 1 and i~= cells.w then line(0, 0, 0, cells.cellSize) end
            if j ~= 1 and j~= cells.h then line(0, cells.cellSize, cells.cellSize, cells.cellSize) end
            if i ~= 1 and i~= cells.w then line(cells.cellSize, 0, cells.cellSize, cells.cellSize) end
        end
        popMatrix()

        drawPlayer(value, w)

        fontSize(15)
        text(cell.move or '', -cells.cellSize/2, -cells.cellSize/2)
    end
    popMatrix()
end

function drawPlayer(value, w)
    strokeSize(8)

    if value == 'x' then
        stroke(colors.red)
        line(-w, -w, w, w)
        line(-w, w, w, -w)

    elseif value == 'o' then
        stroke(colors.green)
        circleMode(CENTER)
        circle(0, 0, w)
    end
end

function mousereleased(touch)
    if touch.state ~= RELEASED then return end

    if cells.state == 'new game' then
        newGame()
        
    elseif players[player].type == 'player' then
        if cells.state == 'play' then
            local x = cells.position.x - cells.cellSize / 2
            local y = cells.position.y - cells.cellSize / 2

            local dx, dy = cells.cellSize, cells.cellSize

            local ix = math.floor((touch.position.x - x) / dx) + 1
            local iy = -1

            if MODE == 'morpion' then
                iy = math.floor((touch.position.y - y) / dy) + 1

            else
                for j = cells.h , 1, -1 do
                    local cell = cells:getCell(ix, j)
                    if cell and cell.value == nil then
                        iy = j
                        break
                    end
                end
            end

            local cell = cells:getCell(ix, iy)

            if cell and not cell.value then
                makeMove(cell)
            end
        end
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
                makeMove(cell)
            end
        end

    elseif cells.state == 'end' or cells.state == 'win' then
        cells.state = 'new game'
    
    elseif cells.state == 'new game' then
        if env.__autotest then
            newGame()
        end
    end
end

function makeMove(cell)
    cell.move = cells.currentMove
    cells.currentMove = cells.currentMove + 1

    cell.value = player

    player = minimax:nextPlayer(player)
end


class 'Minimax'

function Minimax:init(grid)
    self.WIN_VALUE = 100
end

function Minimax:nextPlayer(player)
    return player == 'x' and 'o' or 'x'
end

local MIN, MAX = math.mininteger, math.maxinteger

function Minimax:minimax(grid, depth, maximizingPlayer, currentPlayer, alpha, beta)
    local winner = self:gameWin(grid)
    if winner then
        local value = self.WIN_VALUE * (maximizingPlayer and -1 or 1)
        return value
    end

    local moves = self:gameMoves(grid)
    local n = #moves

    if depth == 0 or n == 0 then
        local value = random(self.WIN_VALUE / 10) * (maximizingPlayer and -1 or 1)
        return value
    end

    local move, op, bestValue
    if maximizingPlayer then
        bestValue = MIN
        op = math.max
    else
        bestValue = MAX
        op = math.min
    end

    for i = 1, n do
        move = moves[i]

        move.value = currentPlayer

        local value = self:minimax(grid, depth - 1, not maximizingPlayer, self:nextPlayer(currentPlayer), alpha, beta)

        if op(value, bestValue) == value then
            bestValue = value
        end

        if maximizingPlayer then
            alpha = op(alpha, bestValue)
        else
            beta = op(beta, bestValue)
        end

        move.value = nil

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
    for i = 1, n do
        move = moves[i]

        move.value = player

        local value = self:minimax(grid, players[player].depth, false, self:nextPlayer(player), MIN, MAX)
        if value > bestValue then
            bestValue = value
            bestMove = move
        end

        move.value = nil
    end

    return bestMove
end

function Minimax:gameMoves(grid)
    local moves = Array()

    if MODE == 'morpion' then    
        grid:foreach(function(cell, i, j)
            if not cell.value then
--                moves:add(cell)
                moves[#moves+1] = cell
            end
        end)

    else
        local cell
        for i = 1, cells.w do
            for j = cells.h, 1, -1 do
                cell = cells:getCell(i, j)
                if cell and cell.value == nil then
                    --moves:add(cell)
                    moves[#moves+1] = cell
                    break
                end
            end
        end
    
    end

    return moves
end

function Minimax:gameWin(grid)
    local winner

    local function checkGrid(cell, i, j)
        if not cell.value then return end

        local function checkLine(i, j, di, dj)
            local n = 1
            while true do
                i = i + di
                j = j + dj

                local neighbour = grid:getCell(i, j)
                if not neighbour or neighbour.value ~= cell.value then
                    return
                end
                
                n = n + 1
                if n == COUNT then
                    winner = cell.value
                    return winner
                end
            end 
        end

        local right = i <= cells.w-COUNT+1
        local down = j <= cells.h-COUNT+1 
        local up = j >= COUNT

        if (right and checkLine(i, j, 1, 0) or
            down  and checkLine(i, j, 0, 1) or
            right and down and checkLine(i, j, 1,  1) or
            right and up   and checkLine(i, j, 1, -1))
        then
            return -1
        end
    end

    grid:foreach(checkGrid)

    return winner
end

function Minimax:gameEnd(grid)
    if grid:countCellsWithNoValue() == 0 then
        return true
    end
end
