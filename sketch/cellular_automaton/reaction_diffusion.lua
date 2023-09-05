ReactionDiffusion = class() : extends(Sketch)

local gridIn
local gridOut

local m, n

function ReactionDiffusion:init()
    Sketch.init(self)

    self.url = "http://www.karlsims.com/rd.html"

    n = 100
    m = n

    gridIn = createGrid(n, m)
    gridOut = createGrid(n, m)

    local size = .05

    local xc = n/2
    local yc = m/2

    local ns = n * size
    local ms = m * size

    for i = xc-ns, xc+ns do
        for j = yc-ms, yc+ms do
            if vec2(xc, yc):dist(vec2(i, j)) < ns then
                gridIn[i][j].b = 1
            end
        end
    end

    renderImage = FrameBuffer(n, m)

    da = 1.0
    db = .5

    -- base
    f = .055
    k = .062

    -- mitosis
    f = .0367
    k = .0649

    -- coral growth
    f = .0545
    k = .062

    dt = 1
end

function ReactionDiffusion:update(dt)
    for i=1,50 do
        self:updateImage(0.05)
    end
end

function ReactionDiffusion:updateImage(dt)
    local a, b, abb
    local cellIn, cellOut

    for i=2,n-1 do
        for j=2,m-1 do
            cellIn = gridIn[i][j]

            a = cellIn.a
            b = cellIn.b

            abb = a*b*b

            cellOut = gridOut[i][j]

            cellOut.a = a + (da * laplace(i,j,'a') - abb + f*(1-a)) * dt
            cellOut.b = b + (db * laplace(i,j,'b') + abb - b*(k+f)) * dt
        end
    end

    gridIn, gridOut = gridOut, gridIn
end

function ReactionDiffusion:draw()
    background(51)

    renderImage:getImageData()
    renderImage.imageData:mapPixel(function (x, y, r, g, b, a)
        local cellIn = gridIn[x+1][y+1]
        local c = cellIn.a - cellIn.b
        return c, c, c, 1
    end)

    spriteMode(CENTER)
    sprite(renderImage, W/2, H/2)
end

function createGrid(n, m)
    local grid = {}
    for i=1,n do
        grid[i] = {}
        for j=1,m do
            grid[i][j] = {a=1, b=0}
        end
    end

    return grid
end

function laplace(x,y,v)
    return -gridIn[x][y  ][v]
    + (gridIn[x+1][y  ][v]
        + gridIn[x-1][y  ][v]
        + gridIn[x  ][y+1][v]
        + gridIn[x  ][y-1][v]) * 0.2
    + (gridIn[x+1][y+1][v]
        + gridIn[x+1][y-1][v]
        + gridIn[x-1][y+1][v]
        + gridIn[x-1][y-1][v]) * 0.05
end
