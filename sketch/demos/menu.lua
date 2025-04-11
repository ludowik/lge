

function setup()
    parameter:watch('_G')

    bar:action('@play', Graphics.loop)
    bar:action('@pause', Graphics.noLoop)
    bar:action('@loop', function () processManager:loopProcesses() end)
end

function draw()
    background()
    bar:draw(LEFT, H-TOP-bar.size.y)
end
