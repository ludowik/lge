function setup()
    obj = {
        name = 'env',
        ref = env
    }
    
    deltaY = 0
    
    margin = 5    

    wmax = 0
    hmax = 0

    overItem = nil

    stack = Array()
    
    populateRef()    
end

function populateRef()
    ref = Array()
    
    if obj.ref.__ordered then
        for k,v in ipairs(obj.ref.__ordered) do
            local item = Rect()
            ref:add(item)
            item.name = v
            item.ref = obj.ref[v]
        end
    else
        for k,v in pairs(obj.ref) do
            local item = Rect()
            ref:add(item)
            item.name = k
            item.ref = v
        end
    end
end

function draw()
    background()

    fontSize(15)

    local x = W/2 - wmax
    local y = deltaY + 24

    textPosition(y)

    local path = ''
    for _,item in ipairs(stack) do
        path = path..'/'..item.name
    end

    path = path..'/'..obj.name

    text(path, x, y)

    mousemoved(mouse)

    wmax, hmax = 0, 0
    for _,item in pairs(ref) do
        local w, h = textSize(item.name)
        wmax = max(w, wmax)
        hmax = max(h, hmax)
    end

    for _,item in pairs(ref) do
        local w, h = textSize(item.name)
        y = textPosition()        

        if item == overItem then
            textColor(colors.red)
        else
            textColor(colors.white)
        end

        text(item.name, x+wmax-w-margin, y)
        text(item.ref, x+wmax+margin, y)

        item:init(x+wmax+margin, y, w, h)        
    end
end

function getItem(mouse)
    for _,item in ipairs(ref) do
        if item:contains(mouse.position) then
            return item
        end
    end
end

function mousemoved(mouse)
    local item = getItem(mouse)
    overItem = item

    deltaY = deltaY + mouse.deltaPos.y
end

function mousereleased(mouse)
    local item = getItem(mouse)
    if item then
        if type(item.ref) == 'table' and item.ref ~= obj.ref then
            stack:push(obj)
            obj = item
            populateRef()
        end
        return
    end

    if #stack > 0 then
        obj = stack:pop()
        populateRef()
    end
end

function wheelmoved(dx, dy)
    deltaY = deltaY + dy * hmax
end
