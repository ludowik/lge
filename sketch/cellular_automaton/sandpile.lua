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
    local n = getOS() == 'web' and 20 or 50
    for i=1,n do
        updatePiles()
    end
end

function updatePiles()
    for x=1,size do
        local column = sandpiles[x]
        local nextColumn = nextpiles[x]
        for y=1,size do
            local num = column[y]
            if num <= 3 then
                nextColumn[y] = num
            else
                nextColumn[y] = num - 4
            end
        end
    end

    for x=2,size-1 do
        local column = sandpiles[x]
        local nextColumn = nextpiles[x]
        for y=2,size-1 do
            local num = column[y]
            if num > 3 then
                nextpiles[x+1][y] = nextpiles[x+1][y] + 1
                nextpiles[x-1][y] = nextpiles[x-1][y] + 1
                nextColumn[y+1] = nextColumn[y+1] + 1
                nextColumn[y-1] = nextColumn[y-1] + 1
            end
        end
    end

    nextpiles, sandpiles = sandpiles, nextpiles
end

function draw()
    background(colors.white)

    img:mapPixel(
        function (x, y)
            local num, clr
            num = sandpiles[x+1][y+1]

            if num == 1 then
                clr = colors.red
            elseif num == 2 then
                clr = colors.green
            elseif num == 3 then
                clr = colors.blue
            elseif num > 3 then
                clr = colors.gray
            else
                clr = colors.white
            end

            return clr.r, clr.g, clr.b, 1
        end)

    translate(CX, CY)

    scale(4)

    spriteMode(CENTER)
    sprite(img)
end
