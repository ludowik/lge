function love.conf(t)
    t.audio.mixwithsystem = true
    love.filesystem.setRequirePath('?.lua;?/init.lua;?/__init.lua')
end
