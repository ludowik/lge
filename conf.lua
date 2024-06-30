function love.conf(t)
    t.console = false
    
    t.modules.audio = true
    if t.audio then
        t.audio.mixwithsystem = true
    end

    if true then
        if t.highdpi ~= nil then t.highdpi = true end
        if t.window.highdpi ~= nil then t.window.highdpi = true end
    end

    if love._os == "iOS" then
		t.window.borderless = true
        t.window.resizable = true
	end

    
    love.filesystem.setRequirePath('?.lua;?/init.lua;?/__init.lua')
end
