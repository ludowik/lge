function love.conf(t)
    t.console = false
    t.modules.physics = false

    love.filesystem.setRequirePath('?.lua;?/init.lua;?/__init.lua')
end
