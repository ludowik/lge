function setup()
    supportedOrientations(LANDSCAPE_ANY)

    baseImageList = {
        'resources/images/joconde.png',
        'resources/images/marsu.jpeg',
        'resources/images/wikipedia.png',
    }

    baseImageList = love.filesystem.getDirectoryItems('resources/images')

    local function getSource()
        local baseImage = Image('resources/images/'..baseImageList[baseImageIndex])

        local size, ratio, ws, hs
        if W < H then
            size = even(W/2)
            ratio = baseImage.width / baseImage.height
            hs = size
            ws = hs * ratio
        else
            size = even(H/2)
            ratio = baseImage.height / baseImage.width
            ws = size
            hs = ws * ratio
        end

        local source = FrameBuffer(size, size)

        render2context(source,
            function ()
                background(colors.white)
                spriteMode(CENTER)
                scale(1/devicePixelRatio)
                sprite(baseImage, size/2, size/2, ws, hs)
            end)

        return source
    end

    local function setSource()
        img = getSource()
    end

    parameter:watch('characters')
    parameter:integer('baseImageIndex', 1, #baseImageList, 1, setSource)
    parameter:integer('tileSize', 0, 5, 1)
    parameter:boolean('standardCharactersSet', false,
        function ()
            characters = defineCharactersSet()
        end)
    parameter:boolean('grayScale', true,
        function ()
            characters = defineCharactersSet()
        end)
end

function defineCharactersSet()
    fontName('arial')
    fontSize(20)

    local sw, sh = 0, 0

    local from = ''
    if standardCharactersSet then
        from = ' .:-=+_?*#%@'
    else
        from = ' -+0#%@'

--        for i=32,127 do
--            from = from..string.char(i)
--        end
    end

    for i=1,from:len() do
        local character = from:sub(i,i)
        local w, h = textSize(character)
        sw = max(w, sw)
        sh = max(h, sh)
    end

    local img = FrameBuffer(sw, sh)
    local cx, cy = floor(sw/2), floor(sh/2)

    textMode(CENTER)
    textColor(colors.white)

    local characters = Array()
    for i=1,from:len() do
        local character = from:sub(i,i)

        setContext(img)
        do
            background(colors.black)
            text(character, cx, cy)
        end
        setContext()

        img:getImageData()

        local npixels = 0
        for x=0,sw-1 do
            for y=0,sh-1 do
                local r, g, b = img:get(x, y)
                if grayScale then
                    if r > 0 then
                        npixels = npixels + 1
                    end
                else
                    npixels = npixels + r
                end
            end
        end

        characters:add({
                character = character,
                npixels = npixels
            })
    end

    characters:sort(function (a, b)
            return a.npixels < b.npixels
        end)

    characters = characters:map(function (c, i) return c.character end)
    characters = characters:concat()

    assert(characters:sub(1,1) == ' ')
    print(characters)

    img:release()

    return characters
end

function draw()
    local w, h = img.width, img.height

    background(colors.black)

    translate(W/2, H/2)

    spriteMode(CORNER)
    sprite(img, -w, -h)

    drawImage(vec2( 0, -h), ascii, false)
    drawImage(vec2(-w,  0), ascii, true)
    drawImage(vec2( 0,  0), pixel)
end

function drawImage(position, f, reverse)
    local w = 2^(tileSize)
    local h = 2^(tileSize+1)

    fontSize(h)

    pushMatrix()
    translate(position.x, position.y)

    if not reverse then
        fill(colors.white)
    else
        fill(colors.black)
    end

    noStroke()
    rectMode(CORNER)
    rect(0, 0, img.width, img.height)

    rectMode(CENTER)
    textMode(CENTER)

    img:getImageData()

    for x=0,img.width,w do

        for y=0,img.height,h do

            local r, g, b, a, n = 0, 0, 0, 0, 0, n
            for dx=0,w-1 do
                if x+dx >= img.width then break end

                for dy=0,w-1 do
                    if y+dy >= img.height then break end

                    local r1, g1, b1, a1 = img:get(x+dx, y+dy)
                    r = r + r1
                    g = g + g1
                    b = b + b1
                    a = a + a1

                    n = n + 3
                end
            end

            local light = (r + g + b)/(n)
            f(position, light, reverse, x+w/2, y+h/2, w, h)
        end
    end
    popMatrix()
end

function ascii(position, light, reverse, x, y, w, h)
    local i = floor(map(light, 0, 1, 1, characters:len()))

    if not reverse then
        i = characters:len() -  i + 1
        textColor(colors.black)
    else
        textColor(colors.white)
    end
    text(characters:sub(i, i), x, y)
end

function pixel(position, light, reverse, x, y, w, h)
    fill(light)
    noStroke()
    rect(x, y, w, h)
end
