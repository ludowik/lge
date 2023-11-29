function setup()
    scene = Scene()

    fb = FrameBuffer(W, H)
    imageData = fb:getImageData()

    scene:add(UIExpression('version', 'version'))
    scene:add(UIExpression('date', 'Date():asDate()'))
    scene:add(UIExpression('time', 'Date():asTime()'))

    scene:add(UI('State'):attrib{styles={fillColor=colors.red}})
    scene:add(UIExpression('power', 'getPowerInfo()'))
    scene:add(UIExpression('memory', 'getMemoryInfo()'))
    
    scene:add(UI('Frame'):attrib{styles={fillColor=colors.red}})
    scene:add(UIExpression('fps', 'string.format("%d fps", getFPS())'))
    scene:add(UIExpression('dt', 'string.format("%d ms", floor(DeltaTime*1000))'))
    scene:add(UIExpression('elapsed', 'string.format("%d s", ElapsedTime)'))

    scene:add(UI('Screen'):attrib{styles={fillColor=colors.red}})
    scene:add(UIExpression('position', 'X..","..Y'))
    scene:add(UIExpression('size', 'W..","..H'))
    scene:add(UIExpression('data', 'imageData:getWidth()..","..imageData:getHeight()'))
    scene:add(UIExpression('pixel ratio', 'love.window.getDPIScale()'))
    scene:add(UIExpression('screen ratio', '(H+2*Y)/(W+2*X)'))

    scene:add(UI('Mouse'):attrib{styles={fillColor=colors.red}})
    scene:add(UIExpression('startPosition', 'mouse.startPosition'))
    scene:add(UIExpression('position', 'mouse.position'))
    scene:add(UIExpression('previousPosition', 'mouse.previousPosition'))
    scene:add(UIExpression('deltaPos', 'mouse.deltaPos'))
    scene:add(UIExpression('previousPosition', 'mouse.previousPosition'))
    scene:add(UIExpression('move', 'mouse.move'))
    scene:add(UIExpression('delay', 'mouse.elapsedTime'))
end
