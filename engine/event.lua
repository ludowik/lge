function love.keypressed(key)
    if key == 'r' then
        updateScripts()
        love.event.quit('restart')
    end
    if key == 'escape' then
        love.event.quit()
    end
end
