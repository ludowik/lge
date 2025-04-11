function setup()
    source = image('einstein.png')
    source:filter(GRAY)

    canvasSize = SIZE
    source = source:resize(canvasSize, canvasSize)

    target = FrameBuffer(canvasSize, canvasSize)

    nails = Array()
    local nailCount = 256
    local r, margin = canvasSize/2, 5
    for i=1,nailCount do
        local angle = TAU/nailCount*i
        nails:add(vec2(
            r + (r-margin)*cos(angle),
            r + (r-margin)*sin(angle)))
    end
    
    linesIndex = Array()
    maxLines = 10000
    linesIndex:add({index=1, contrast=0})
    linesIndex:add({index=1, contrast=0})

    target:render(function ()
        fill(colors.gray)
        for i,nail in ipairs(nails) do
            ellipse(nail.x, nail.y, 0.5)
        end
    end)

    FRAME_COUNT = 10
end

function back()
    background(colors.white)

    translate(DX, DY)
    
    spriteMode(CORNER)
    sprite(source, 0, 0, SIZE, SIZE)
end

function keypressed(key)
    if key == 'return' then 
        maxLines = maxLines + 250
        loop()
    end
end

function frame()
    back()

    resetMatrix()

    target:render(function ()
        stroke(0, 0.05)
        strokeSize(0.5)
        local i = #linesIndex
        --for i=2,#linesIndex do
            local n1 = nails[linesIndex[i-1].index]
            local n2 = nails[linesIndex[i  ].index]
            line(n1.x, n1.y, n2.x, n2.y)
        --end
    end)

    if deviceOrientation == PORTRAIT then
        translate(DX, CY)
    else
        translate(CX, DY)
    end

    sprite(target, 0, 0, SIZE, SIZE)

    next()
end

function next()
    if (#linesIndex < maxLines) then
        local currentNailIndex = linesIndex[#linesIndex].index
        local nextNail = findNextNail(currentNailIndex)

        if nextNail then
            linesIndex:add(nextNail)
            updateImage(currentNailIndex, nextNail.index)
        else
            print("No valid nail found. Stopping")
            noLoop()
        end
    else
        print("Max Lines Reached")
        noLoop()
    end
end

function findNextNail(currentNailIndex)
    local nextIndex = nil
    local highestContrast = -1

    for i=1,#nails do
        if i ~= currentNailIndex then
            local contrast = evaluateContrast(currentNailIndex, i)
            if contrast > highestContrast then
                highestContrast = contrast
                nextIndex = i
            end
        end
    end

    if nextIndex == nil then
        nextIndex = randomInd(#nails)
        print("Finding random next index")
    end

    return {
        index = nextIndex,
        contrast = highestContrast
    }
end

function evaluateContrast(i1, i2)
    local totalContrast = 0

    local nail1 = nails[i1]
    local nail2 = nails[i2]

    local steps = canvasSize

    local x, y, brightness
    for i=0,1,1/steps do
        x = round(lerp(nail1.x, nail2.x, i))
        y = round(lerp(nail1.y, nail2.y, i))
        
        -- if x >= 0 and x < canvasSize and y >= 0 and y < canvasSize then
            brightness = source:getPixel(x, y)
            totalContrast = totalContrast + (1 - brightness)
        -- end
    end
    
    return totalContrast / steps
end

function updateImage(i1, i2)
    local bright = 0.035

    local nail1 = nails[i1]
    local nail2 = nails[i2]

    local steps = canvasSize
    
    local x, y, brightness, a
    for i=0,1,1/steps do
        x = round(lerp(nail1.x, nail2.x, i))
        y = round(lerp(nail1.y, nail2.y, i))
        
        -- if x >= 0 and x < canvasSize and y >= 0 and y < canvasSize then
            brightness, _, _, a = source:getPixel(x, y)
            if brightness < 1 - bright then
                brightness = brightness + bright
                source:setPixel(x, y, brightness, brightness, brightness, a)
            end
        -- end
    end
    
    source:update()
end
