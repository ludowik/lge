function love.keypressed(key)
    if key == 'r' then
        updateScripts()
    end
    if key == 'escape' then
        love.event.quit()
    end
end
