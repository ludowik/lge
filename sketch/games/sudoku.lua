function setup()
    createGrid()
    createUI()

    local puzzle = getSetting('puzzle')
    loadPuzzle(puzzle)
end

local catalog = {
    '...2...633....54.1..1..398........9....538....3........263..5..5.37....847...1...',
}

function createGrid()
    n = 3
    N = n^2

    if grid then
        grid:clear(Cell)
    else
        grid = Grid(N, N, Cell)
    end

    grid.contains = Node.contains

    grid.cellSize = vec2(SIZE/(N+0.5), SIZE/(N+0.5)):even()
    
    grid.fixedSize = grid.cellSize * N
    grid.fixedPosition = vec2(CX, CY) - grid.fixedSize/2
    
    updateAvailableValue(grid)
end

function createUI()
    currentNumber = 0
    currentCell = nil

    scene = Scene()
    scene:add(grid)

    local numbers = Node():attrib{layoutMode = 'horizontal'}

    scene:add(numbers)
    local function number(number)
        currentNumber = tonumber(number:getLabel())
    end
    for i in range(N) do
        numbers:add(UIButton(i, number):attrib{
            fixedSize = grid.cellSize * 0.925,
            styles = {
                mode = CENTER
            }
        })
    end

    scene:layout()

    parameter:action('create', create)
    parameter:action('resolve', resolve)
    parameter:action('@refresh', reset)
end

function create()
    if true or getOS() == 'ios' then
        createSudoku(grid)
    else
        routine = coroutine.create(function ()
            createSudoku(grid)
        end)
    end
end

function resolve()
    routine = coroutine.create(function ()
        generateSudoku(grid, 1, 'resolve')
    end)
end

function reset()
    grid:foreach(function(cell, i, j)
        if not cell.fixed then
            cell.value = 0
        end
    end)
end

function update()
    if routine and coroutine.status(routine) ~= 'dead' then
        local res, error = coroutine.resume(routine)
        if res ~= true then log(res, error) end
    end
end

function draw()
    background(colors.white)

    scene:draw()
end


class 'Cell' : extends(Rect)

function Cell:init(i, j)
    Rect.init(self)

    self.i = i
    self.j = j

    self.block_index = block_index(i, j)
    
    self.value = 0
    self.fixed = false
    self.availableValues = createArrayOfValues()
end

function createArrayOfValues()
    return Array():forn(N, true)
end

function Cell:draw(i, j, cellPosition, cellSize)
    self.position:set(cellPosition)
    self.size:set(cellSize, cellSize)

    if currentCell and (currentCell.i == i or currentCell.j == j or currentCell.block_index == block_index(i, j)) then
        fill(Color(0.9))
        noStroke()
        rect(cellPosition.x+3, cellPosition.y+3, cellSize-6, cellSize-6)
    end

    noFill()

    if self.value > 0 then
        fontName('arial')
        fontSize(cellSize*3/5)
        local clr = switch {
            {self.fixed, colors.green},
            {self.availableValues[self.value], colors.black},
            {true, colors.red},
        }
        
        textColor(clr)
        textMode(CENTER)
        text(
            self.value,
            cellPosition.x + cellSize/2,
            cellPosition.y + cellSize/2 - 2)

        if currentNumber == self.value then
            stroke(colors.gray)
            strokeSize(3)
            circle(
                cellPosition.x + cellSize/2,
                cellPosition.y + cellSize/2,
                cellSize*2/5)
        end
    end

    fontName('arial')
    fontSize(8)
    textColor(colors.gray)
    textMode(CORNER)
    for i,v in ipairs(self.availableValues) do
        if v ~= false then
            text(i,
                cellPosition.x + (i-1)*cellSize/N,
                cellPosition.y)
        end
    end
    
    stroke(colors.gray)
    strokeSize(0.1)
    noFill()
    rect(cellPosition.x, cellPosition.y, cellSize, cellSize)

    stroke(colors.black)
    strokeSize(3)

    if i%n == 0 and i ~=N then
        line(cellPosition.x+cellSize, cellPosition.y, cellPosition.x+cellSize, cellPosition.y+cellSize)
    end
    if j%n == 0 and j ~=N then
        line(cellPosition.x, cellPosition.y+cellSize, cellPosition.x+cellSize, cellPosition.y+cellSize)
    end
end

function Cell:click()
    currentCell = self

    if self.fixed then
        currentNumber = self.value
        return
    end

    if self.value == currentNumber then
        self.value = 0
    else
        self.value = currentNumber
    end

    updateAvailableValue(grid)

    savePuzzle(grid)
end

function block(i, j)
    local block_i = floor((i-1)/n) * n + 1
    local block_j = floor((j-1)/n) * n + 1

    return block_i, block_j
end

function block_index(i, j)
    i, j = block(i, j)
    return i + j*n
end

function updateAvailableValue(grid)
    grid:foreach(function(cell, i, j)
        cell.availableValues = createArrayOfValues()
        for k in range(N) do
            if k ~= i then 
                local neighbour = grid:getCell(k, j)
                cell.availableValues[neighbour.value] = false
            end
        end
        for k in range(N) do
            if k ~= j then 
                local neighbour = grid:getCell(i, k)
                cell.availableValues[neighbour.value] = false
            end
        end
        
        local block_i, block_j = block(i, j)
        for i2=block_i,block_i+(n-1) do
            for j2=block_j,block_j+(n-1) do
                if i2 ~= i and j2 ~= j then
                    local neighbour = grid:getCell(i2, j2)
                    cell.availableValues[neighbour.value] = false
                end
            end
        end
    end)

    for j=1,N do
        for i=1,N do
        end
    end
end

function createSudoku(grid)
    createGrid()

    local values = Array():forn(N)
    local j = floor(N/2+1)
    for i=1,N do
        local cell = grid:getCell(i, j)
        cell.value = values:removeRandom()
    end
    updateAvailableValue(grid)
    
    local result, solutions = generateSudoku(grid, 1, 'generate')
    if result then
        local deleteValues
        local deleteValuesTarget = ceil(0.65*N^2)
        repeat
            deleteValues = Array()
            deleteValuesTarget = deleteValuesTarget - 1
            repeat
                deleteValues:add(randomInt(N^2))
                for _,v in ipairs(deleteValues) do
                    grid:getCellFromOffset(v).value = 0
                end
                updateAvailableValue(grid)
                result, solutions = generateSudoku(grid, 1, 'check solutions')
            until solutions > 1
            if solutions > 1 then
                deleteValues:pop()
            end
        until #deleteValues > deleteValuesTarget

        for _,v in ipairs(deleteValues) do
            grid:getCellFromOffset(v).value = 0
        end
        grid:foreach(function(cell, i , j)
            cell.fixed = cell.value > 0
        end)
        updateAvailableValue(grid)
    end

    savePuzzle(grid)
end

function generateSudoku(grid, offset, mode, solutions)
    assert(grid)
    
    local result

    offset = offset or 1
    solutions = solutions or 0

    if offset <= N^2 then
        local cell = grid:getCellFromOffset(offset)        
        if cell.fixed or cell.value > 0 then
            result, solutions = generateSudoku(grid, offset+1, mode, solutions)
            if result and (mode == 'generate' or mode == 'resolve' or solutions > 1) then
                return result, solutions
            end

        else
            if routine then
               coroutine.yield()
            end
            
            local list = Array()
            for i=1,#cell.availableValues do
                if cell.availableValues[i] then
                    list:add(i)
                end
            end

            list:shuffle()
    
            for _,v in pairs(list) do
                cell.value = v
                updateAvailableValue(grid)

                result, solutions = generateSudoku(grid, offset+1, mode, solutions)
                if result and (mode == 'generate' or mode == 'resolve' or solutions > 1) then
                    return result, solutions
                end

                cell.value = 0
                updateAvailableValue(grid)
            end
        end
    else
        updateAvailableValue(grid)

        local count = 0
        grid:foreach(function(cell, i, j)
            local total = 0
            for i=1,#cell.availableValues do
                if cell.availableValues[i] then
                    total = total + 1
                end
            end
            if total == 1 then
                count = count + 1
            end
        end)

        if count == N^2 then
            solutions = solutions + 1
            return grid, solutions
        end
    end

    return nil, solutions
end

function loadPuzzle(puzzle)
    if not puzzle then return end

    if puzzle:len() == N^2 then
        for offset=1,N^2 do
            local cell = grid:getCellFromOffset(offset)
            cell.value = tonumber(puzzle:mid(offset, 1)) or 0
            cell.fixed = cell.value ~= 0
        end

    else
        for offset=1,N^2 do
            local cell = grid:getCellFromOffset(offset)
            cell.value = tonumber(puzzle:mid((offset-1)*2+1, 1)) or 0
            cell.fixed = puzzle:mid((offset-1)*2+2, 1) == 'f'
        end
    end
    updateAvailableValue(grid)
end

function savePuzzle(grid)
    local puzzle = ''
    grid:foreach(function(cell)
        puzzle = puzzle..(cell.value > 0 and cell.value or '.')
        puzzle = puzzle..(cell.fixed and 'f' or '.')
    end)
    setSetting('puzzle', puzzle)
end

function fixedAvailableValue(grid)
    for offset=1,N^2 do
        local cell = grid:getCellFromOffset(offset)
        if not cell.fixed then
            local n = #cell.availableValues
            local total = 0
            local value = nil
            for i=1,n do
                if cell.availableValues[i] then
                    total = total + 1
                    value = i
                end
            end
            if total == 1 then
                cell.value = value
                updateAvailableValue(grid)
            end 
        end
    end
end
