local ffi = try_require 'ffi'

function setup()
    size = even(CX)
    img = FrameBuffer(size, size)

    if ffi then
        sandpiles = ffi.new('int[1024][1024]')
        nextpiles = ffi.new('int[1024][1024]')
    else
        sandpiles = {}
        nextpiles = {}
        for i=1,size do
            sandpiles[i] = {}
            nextpiles[i] = {}
        end
    end
    
    for i=1,size do
        for j=1,size do
            sandpiles[i][j] = 0
            nextpiles[i][j] = 0
        end
    end

    sandpiles[size/2][size/2] = 1000000

    parameter:linksearch('sandpile')
end

function update()
    for i=1,50 do
        updatePiles()
    end
end

function updatePiles()
    if frameCount % 2 == 0 then return end
    local num
    
    for x=1,size do
        for y=1,size do
            num = sandpiles[x][y]
            if num <= 3 then
                nextpiles[x][y] = num
            else
                nextpiles[x][y] = num - 4
            end
        end
    end

    for x=2,size-1 do
        for y=2,size-1 do
            num = sandpiles[x][y]
            if num > 3 then
                --nextpiles[x][y] = nextpiles[x][y] + num - 4

                nextpiles[x+1][y] = nextpiles[x+1][y] + 1
                nextpiles[x-1][y] = nextpiles[x-1][y] + 1
                nextpiles[x][y+1] = nextpiles[x][y+1] + 1
                nextpiles[x][y-1] = nextpiles[x][y-1] + 1
            end
        end
    end

    nextpiles, sandpiles = sandpiles, nextpiles
end

function draw()
    background(colors.white)

    local column, num, clr

    img:mapPixel(function (x, y, r, g, b, a)            
            column = sandpiles[x+1]
            num = column[y+1]

            clr = colors.white
            if num == 1 then
                clr = colors.red
            elseif num == 2 then
                clr = colors.green
            elseif num == 3 then
                clr = colors.blue
            elseif num > 3 then
                clr = colors.gray
            end

            return clr.r, clr.g, clr.b, 1
        end)

    translate(CX, CY)

    spriteMode(CENTER)
    sprite(img)
end
