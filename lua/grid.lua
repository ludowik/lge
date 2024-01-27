Grid = class() : extends(Array)

function Grid:init(w, h, initValue)
    assert(w, h)

    self.w = floor(w)
    self.h = floor(h)

    self:clear(initValue)
end

function Grid:clear(initValue)
    self.items = Array()
    if initValue then
        for i in range(self.w) do
            for j in range(self.h) do
                if type(initValue) == 'function' then
                    self:set(i, j, initValue(i, j))
                else
                    self:set(i, j, initValue)
                end
            end
        end
    end
end

function Grid:newCell()
    return {
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

function Grid:setCell(x, y, cell)
    local offset = self:offset(x, y)
    if offset == -1 then
        return
    end
    self.items[offset] = cell
end

function Grid:getCell(x, y)
    local offset = self:offset(x, y)
    if offset == -1 then
        return
    end
    if self.items[offset] == nil then
        self.items[offset] = self:newCell()
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
    for x in range(self.w) do
        for y in range(self.h) do
            local cell = self:getCell(x, y)
            if not cell then return end
            local result = f(cell, x, y)
            if result == -1 then return end
        end
    end
end

function Grid:countCellsWithNoValue()
    local count = 0
    for x in range(self.w) do
        for y in range(self.h) do
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

function Grid:draw(x, y, drawCellFunction)    
    local size =
        (type(self.size) == 'number' and self.size) or
        (type(self.size) == 'table' and self.size.x) or
        (Anchor(self.w + 2):size(1, 1).x)
    
    x = x or 0
    y = y or 0

    strokeSize(0.2)
    stroke(Color(1, 1, 1, 0.25))
    noFill()
    
    if not drawCellFunction then
        for i in range(self.w) do
            for j in range(self.h) do
                local cell = self:getCell(i, j)
                rect(x + (i-1) * size, y + (j-1) * size, size, size)
            end
        end
    end

    for i in range(self.w) do
        for j in range(self.h) do
            local cell = self:getCell(i, j)
            if cell then
                if cell.draw then
                    cell:draw(i, j)
                elseif cell.value and type(cell.value) == 'table' and cell.value.draw then
                    cell.value:draw(i, j)
                elseif drawCellFunction then
                    drawCellFunction(cell, i, j)
                end
            end
        end
    end
end
