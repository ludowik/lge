function setup()
    setOrigin(BOTTOM_LEFT)
    
    parameter:watch('emitter.particles')

    emitter = Emitter()    

    scene = Scene()    
    scene:add(emitter)
end

function mousepressed(touch)
    emitter:mousepressed(touch)
end
