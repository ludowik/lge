Grid = class() : extends(Array)

function Grid:init(w, h, initValueOrCreateCell, borders)
    assert(w, h)

    self.w = floor(w)
    self.h = floor(h)
    
    self:clear(initValueOrCreateCell)
    
    self.size = vec2(SIZE, SIZE)
    self.position = vec2()

    self.borders = borders
end

function Grid:clear(initValueOrCreateCell)
    if type(initValueOrCreateCell) == 'table' then
        self.createCell = initValueOrCreateCell
        initValueOrCreateCell = nil
    end

    self.items = Array()

    if initValueOrCreateCell == nil then return end

    for i=1,self.w do
        for j=1,self.h do
            if type(initValueOrCreateCell) == 'function' then
                self:set(i, j, initValueOrCreateCell(i, j))
            else
                self:set(i, j, initValueOrCreateCell)
            end
        end
    end
end

function Grid:newCell(i, j)
    if self.createCell then 
        return self.createCell(i, j)
    end

    return {
        i = i,
        j = j,
        value = nil
    }
end

function Grid:offset(x, y)
    if (1 <= x and x <= self.w and
        1 <= y and y <= self.h)
    then
        return x + (y - 1) * self.w
    else
        return -1
    end
end

function Grid:setCell(i, j, cell)
    local offset = self:offset(i, j)
    if offset == -1 then
        return
    end
    self.items[offset] = cell
end

function Grid:getCellFromOffset(offset)
    if offset < 1 or offset > self.w*self.h then
        return
    end
    if self.items[offset] == nil then
        self.items[offset] = self:newCell(offset%self.w, floor(offset/self.h))
    end
    return self.items[offset]
end

function Grid:getCell(i, j)
    local offset = self:offset(i, j)
    if offset == -1 then
        return
    end
    if self.items[offset] == nil then
        self.items[offset] = self:newCell(i, j)
    end
    return self.items[offset]
end

function Grid:set(x, y, value)
    local offset = self:offset(x, y)
    if offset == -1 then
        return
    end
    self:getCell(x, y).value = value
end

function Grid:get(x, y)
    local offset = self:offset(x, y)
    if offset == -1 then
        return
    end
    return self:getCell(x, y).value
end

function Grid:foreach(f)
    for j=1,self.h do
        for i=1,self.w do
            local cell = self:getCell(i, j)
            if f(cell, i, j) == -1 then
                return
            end
        end
    end
end

function Grid:countCellsWithNoValue()
    local count = 0
    for x=1,self.w do
        for y=1,self.h do
            local value = self:get(x, y)
            if value == nil then
                count = count + 1
            end
        end
    end
    return count
end

function Grid:rotate(clockwise)
    clockwise = argument(clockwise, true)

    local grid = getmetatable(getmetatable(self)):__call(self.h, self.w)
    for i=1,grid.w do
        for j=1,grid.h do
            if clockwise then
                grid:set(i, j, self:get(j, self.h-i+1))
            else
                grid:set(i, j, self:get(self.w-j+1, i))
            end
        end
    end
    return grid
end

function Grid:getCellSize()
    local cellSize =
        (type(self.cellSize) == 'number' and self.cellSize) or
        (type(self.cellSize) == 'table' and self.cellSize.x) or
        (Anchor(self.w + 2):size(1, 1).x)
    return cellSize
end

function Grid:draw(x, y, drawCellFunction)
    local cellSize = self:getCellSize()
    
    x = x or self.position and self.position.x or 0
    y = y or self.position and self.position.y or 0

    strokeSize(0.2)
    stroke((getBackgroundColor() or colors.black):contrast())

    noFill()
    
    if self.borders then
        for i=1,self.w do
            for j=1,self.h do
                local cell = self:getCell(i, j)
                rect(x + (i-1) * cellSize, y + (j-1) * cellSize, cellSize, cellSize)
            end
        end
    end

    for i=1,self.w do
        for j=1,self.h do
            local cell = self:getCell(i, j)
            local cellPosition = vec2(x + (i-1) * cellSize, y + (j-1) * cellSize)

            drawCellFunction = drawCellFunction or
                cell.draw or
                cell.value and type(cell.value) == 'table' and cell.value.draw        
                    
            drawCellFunction(cell, i, j, cellPosition, cellSize)
        end
    end
end
