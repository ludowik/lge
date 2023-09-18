function love.conf(t)
    if t.audio then
        t.audio.mixwithsystem = true
    end

    if t.highdpi ~= nil then t.highdpi = true end
    if t.window.highdpi ~= nil then t.window.highdpi = true end
    
    love.filesystem.setRequirePath('?.lua;?/init.lua;?/__init.lua')
end
