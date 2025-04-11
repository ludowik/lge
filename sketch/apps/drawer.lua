function setup()
    scale = 1
    fb = Image('data/note.png', scale*W, scale*H)

    fromPoint = vec2()
    toPoint = vec2()

    needRedraw = 5
    needSave = false
    delaySinceLastChange = 0
    
    parameter:action('erase', function()
        fb = FrameBuffer(scale*W, scale*H)
        fb:setContext()
        background(0, 0, 0, 0)
        fb:resetContext()   
        needSave = true
        needRedraw = 1
    end)

    showGrid = false
    parameter:action('grid', function()
        showGrid = not showGrid
        needRedraw = 1
    end)

    parameter:number('penSize', 1, 10, 7)
    parameter:color('penColor', colors.blue)
end

function release()
    saveImage(true)
end

function saveImage(force)
    if not force and (not needSave or delaySinceLastChange < 1) then return end

    love.graphics.readbackTexture(fb.canvas):encode('png', 'data/note.png')

    needSave = false
    delaySinceLastChange = 0
end

function update(dt)
    delaySinceLastChange = delaySinceLastChange + dt
    saveImage()
end

function draw()
    if needRedraw <= 0 then return end
    needRedraw = needRedraw - 1

    background()
    if showGrid then
        Anchor(32):draw()
    end
    sprite(fb, 0, 0, scale * fb:getWidth(), scale * fb:getHeight())
end

function mousepressed(mouse)
    local touches = love.touch.getTouches()
    if #touches > 1 then return end

    fromPoint = vec2(mouse.position) / scale
end

function mousemoved(mouse)    
    mousereleased(mouse)
end

function mousereleased(mouse)
    local touches = love.touch.getTouches()
    if #touches > 1 then return end

    fb:setContext()
    blendMode(ALPHA)

    toPoint = vec2(mouse.position) / scale

    stroke(penColor:alpha(0.2))
    strokeSize(penSize)

    local dir = toPoint - fromPoint
    local len = dir:len()
    local unit = dir:normalize(0.5)
    local delta = max(0.1, unit:len())
    local x, y = fromPoint.x, fromPoint.y
    for l=0,len,delta do
        point(x, y)
        x = x + unit.x
        y = y + unit.y
    end
    point(x, y)

    -- Geometry.bresenhamLine(
    --     round(fromPoint.x),
    --     round(fromPoint.y),
    --     round(toPoint.x),
    --     round(toPoint.y))

    fromPoint = toPoint

    fb:resetContext()

    needSave = true
    needRedraw = 1

    delaySinceLastChange = 0
end
