function setup()
    scene = Scene()

    scene:add(UIExpression('version', 'version'))
    scene:add(UIExpression('date', 'Date():asDate()'))
    scene:add(UIExpression('time', 'Date():asTime()'))

    scene:add(UI('State'):attrib{styles={fillColor=colors.red}})
    scene:add(UIExpression('power', 'getPowerInfo()'))
    scene:add(UIExpression('memory', 'getMemoryInfo()'))
    
    scene:add(UI('Frame'):attrib{styles={fillColor=colors.red}})
    scene:add(UIExpression('fps', 'string.format("%d fps", getFPS())'))
    scene:add(UIExpression('dt', 'string.format("%d ms", floor(deltaTime*1000))'))
    scene:add(UIExpression('elapsed', 'string.format("%d s", elapsedTime)'))

    local w, h = love.window.getDesktopDimensions(1)

    scene:add(UI('Screen'):attrib{styles={fillColor=colors.red}})
    scene:add(UIExpression('desktop dimension', 'string.format("%d , %d", love.window.getDesktopDimensions())'))
    scene:add(UIExpression('safe area', 'string.format("%d , %d , %d , %d", love.window.getSafeArea())'))
    scene:add(UIExpression('position', 'LEFT.." , "..TOP'))
    scene:add(UIExpression('size', 'W.." , "..H'))
    scene:add(UIExpression('ratio', 'getScreenRatio()'))
    scene:add(UIExpression('data', 'getFbSize()'))
    scene:add(UIExpression('pixel ratio', 'love.window.getDPIScale()'))

    scene:add(UI('Mouse'):attrib{styles={fillColor=colors.red}})
    scene:add(UIExpression('startPosition', 'mouse.startPosition'))
    scene:add(UIExpression('position', 'mouse.position'))
    scene:add(UIExpression('previousPosition', 'mouse.previousPosition'))
    scene:add(UIExpression('deltaPos', 'mouse.deltaPos'))
    scene:add(UIExpression('previousPosition', 'mouse.previousPosition'))
    scene:add(UIExpression('move', 'mouse.move'))
    scene:add(UIExpression('move len', 'mouse.move:len()'))
    scene:add(UIExpression('delay', 'mouse.elapsedTime'))
end

function getScreenRatio()
    local w, h = love.window.getMode()
    return tofraction(w/h)
end

function getFbSize()
    if sketch.fb then
        imageData = imageData or sketch.fb:getImageData()
        return imageData:getWidth()..' , '..imageData:getHeight()
    end 
end