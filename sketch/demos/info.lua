function setup()
    scene = Scene()

    fb = FrameBuffer(W, H)
    imageData = fb:getImageData()

    scene:add(UIExpression('version', 'version'))
    
    scene:add(UI())
    scene:add(UIExpression('fps', 'getFPS()'))
    scene:add(UIExpression('delta time', 'string.format("%.3f", DeltaTime)'))
    scene:add(UIExpression('elapsed time', 'string.format("%.1f", ElapsedTime)'))

    scene:add(UI())
    scene:add(UIExpression('position', 'X..","..Y'))
    scene:add(UIExpression('size', 'W..","..H'))
    scene:add(UIExpression('data', 'imageData:getWidth()..","..imageData:getHeight()'))
    scene:add(UIExpression('data', 'imageData:getWidth()/(W)'))

    scene:add(UI())
    scene:add(UIExpression('startPosition', 'mouse.startPosition'))
    scene:add(UIExpression('position', 'mouse.position'))
    scene:add(UIExpression('previousPosition', 'mouse.previousPosition'))
    scene:add(UIExpression('move', 'mouse.move'))
    scene:add(UIExpression('delay', 'mouse.elapsedTime'))

    scene:add(UI())
    scene:add(UIExpression('time', 'love.timer.getTime()'))
end
