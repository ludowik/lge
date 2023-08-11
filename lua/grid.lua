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
        return x + (y-1) * self.w
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
            if cell then
                f(cell, x, y)
            end
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
