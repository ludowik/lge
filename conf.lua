function love.conf(t)
    t.console = false
    
    t.modules.audio = true
    if t.audio then
        t.audio.mixwithsystem = true
    end

    local highdpi = false
    if t.highdpi ~= nil then t.highdpi = highdpi end
    if t.window.highdpi ~= nil then t.window.highdpi = highdpi end

    if love._os == "iOS" then
		t.window.borderless = true
        t.window.resizable = true
	end

    t.window.width = 375
    t.window.height = 812
    
    love.filesystem.setRequirePath('?.lua;?/init.lua;?/__init.lua;')
end
