function love.keypressed(key)
    if key == 'r' then
        updateScripts()
        if lldebugger then 
            lldebugger.stop()
            lldebugger.finish()
        end
        love.event.quit('restart')
    end
    if key == 'escape' then
        love.event.quit()
    end
end
