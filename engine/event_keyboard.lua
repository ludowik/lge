class().setup = function ()
    love.keyboard.setKeyRepeat(true)
end

function love.keypressed(key, scancode, isrepeat)
    if key == 'r' then
        reload(true)

    elseif key == 'z' then
        makezip()
    
    elseif key == 'i' then
        processManager:setSketch('info')

    elseif key == 's' then
        processManager:setSketch('sketches')

    elseif key == 'l' then
        processManager:loop()
    
    elseif key == 'f' then
        toggleFused()
    
    elseif key == 'escape' then
        quit()
    
    elseif key == 'pageup' then
        processManager:previous()
    
    elseif key == 'pagedown' then
        processManager:next()
    
    elseif key == 'kpenter' then
        processManager:loop()
    end

    processManager:current():keypressed(key, scancode, isrepeat)
end
