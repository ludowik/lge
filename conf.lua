function love.conf(t)
    if t.audio then
        t.audio.mixwithsystem = true
    end

    t.highdpi = true
    
    love.filesystem.setRequirePath('?.lua;?/init.lua;?/__init.lua')
end
