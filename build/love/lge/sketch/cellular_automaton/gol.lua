function setup()
    CELLS_SIZE = floor(W/60)
    CELLS_COUNT = vec2(
        floor(W/CELLS_SIZE),
        floor(H/CELLS_SIZE))

    delay = 0

    grid = GolGrid(CELLS_COUNT.x, CELLS_COUNT.y)
    gridTemp = GolGrid(CELLS_COUNT.x, CELLS_COUNT.y)

    grid:reset()

    state = 'paused'
    drawDelete = true

    sizeCell = vec2(CELLS_SIZE, CELLS_SIZE)

    parameter:link('What is...', 'https://beltoforion.de/en/game_of_life')

    parameter:watch('grid.status')

    parameter:action('draw life', function () grid:switchDrawMode() end)
    parameter:action('clear', function () grid:clear() end)
    parameter:action('reset', function () grid:reset() end)
    parameter:action('pause/resume', function () grid:switchState() end)
    parameter:action('next frame', function () grid:nextFrame() end)    
end

function update(dt)
    grid:update(dt)
end

function draw()
    background(colors.white)
    grid:draw()
end

function mousepressed(touch)
    mousemoved(touch)
    if grid.status == 'active' then
        grid.status = 'suspended'
    end
end

function mousereleased(touch)
    if grid.status == 'suspended' then
        grid.status = 'active'
    end
end

function mousemoved(touch)
    local cell, i,j = grid:cellFromPosition(touch.position.x, touch.position.y)
    if cell then
        if grid.status ~= 'paused' then
            grid:addLife(i, j)
        else
            grid:setLife(i, j)
        end
    end
end

class 'GolGrid' : extends(Grid)

function GolGrid:init(...)
    Grid.init(self, ...)
end

function GolGrid:switchDrawMode()
    drawDelete = not drawDelete
end

function GolGrid:reset()
    self:clear()

    self:loadSchema(schemas.repliqua)

    -- for i=1,CELLS_COUNT.x do
    --     self:addLife()
    -- end

    self.size = vec2()
    self.position = vec2()
end

function GolGrid:switchState()
    if state == 'active' then
        state = 'paused'
    else
        state = 'active'
    end
end

function GolGrid:nextFrame()
    state = 'frame'
end

function GolGrid:addLife(x, y)
    x = x or randomInt(CELLS_COUNT.x)
    y = y or randomInt(CELLS_COUNT.y)

    for i=1,6 do
        local dx = randomInt(-2, 2)
        local dy = randomInt(-2, 2)

        self:set(x+dx, y+dy, true)
    end
end

function GolGrid:setLife(x, y)
    x = x or random(CELLS_COUNT.x)
    y = y or random(CELLS_COUNT.y)

    self:set(x, y, not self:get(x, y))
end

function GolGrid:update(dt)
    if state ~= 'active' and state ~= 'frame' then return end

    if state == 'frame' then
        state = 'paused'
    end

    delay = delay + dt

    if delay >= 1/60 then
        delay = 0
        self:foreach(function (cell, i, j) 
            local adjacent = (
                (self:get(i-1, j-1) == true and 1 or 0) +
                (self:get(i  , j-1) == true and 1 or 0) +
                (self:get(i+1, j-1) == true and 1 or 0) +

                (self:get(i-1, j  ) == true and 1 or 0) +
                (self:get(i+1, j  ) == true and 1 or 0) +

                (self:get(i-1, j+1) == true and 1 or 0) +
                (self:get(i  , j+1) == true and 1 or 0) +
                (self:get(i+1, j+1) == true and 1 or 0))

            local value = cell.value
            if value then
                if adjacent ~= 2 and adjacent ~= 3 then
                    value = false
                end
            else
                if adjacent == 3 then
                    value = true
                end
            end

            local cellTemp = gridTemp:getCell(i, j)
            cellTemp.lastCreate = not cellTemp.value and value
            cellTemp.lastDelete = cellTemp.value and not value
            cellTemp.value = value            
        end)

        grid, gridTemp = gridTemp, grid
    end
end

function GolGrid:draw()
    local w, h = sizeCell.x, sizeCell.y

    self.scale = 1

    self.size = vec2(
        grid.w * w * self.scale,
        grid.h * h * self.scale)

    self.position = vec2(
        (W - self.size.x) / 2,
        (H - self.size.y) / 2)

    local x = self.position.x
    local y = self.position.y

    translate(x, y)
    scale(self.scale, self.scale)

    stroke(colors.gray)
    strokeSize(0.5)

    -- for i=0,grid.w do
    --     line(w*i, 0, w*i, h*grid.h)
    -- end

    -- for j=0,grid.h do
    --     line(0, h*j, w*grid.w, h*j)
    -- end

    rectMode(CORNER)

    self:foreach(function (cell, i, j)
        if cell.value or (cell.lastDelete and drawDelete) then
            if cell.lastDelete then
                fill(colors.red)

            elseif cell.lastCreate then
                fill(colors.blue)

            else
                fill(colors.black)
            end
            rect(w*(i-1), h*(j-1), w, h)
        end
    end)
end

function GolGrid:cellFromPosition(x, y)
    x = x - self.position.x
    y = y - self.position.y

    if x >= 0 and y >= 0 and x < self.size.x and y < self.size.y then
        local i = math.ceil(x / (sizeCell.x * self.scale))
        local j = math.ceil(y / (sizeCell.y * self.scale))
        return self:getCell(i, j), i, j
    end
end

function GolGrid:loadSchema(schema)
    local x, y = 10, 20
    for row=1,#schema do
        for col=1,#schema[row] do
            local cell = schema[row][col]
            if cell == 1 then
                self:set(x + col, y + row, true)
            end
        end
    end
end

schemas = {
    gun = {
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1},
        {1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1},
        {1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0, 1, 0, 1},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1},
    },
    glyder = {
        {0, 0, 0, 0, 0, 0},
        {0, 0, 0, 1, 0, 0},
        {0, 1, 0, 1, 0, 0},
        {0, 0, 1, 1, 0, 0},
        {0, 0, 0, 0, 0, 0},
    },
    repliqua = {
        {0, 1, 0, 0},
        {1, 1, 1, 0},
        {1, 0, 0, 0},
        {0, 0, 1, 1},
        {1, 1, 0, 0},
        {0, 1, 0, 0},
    }
}
