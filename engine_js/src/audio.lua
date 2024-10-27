Sound = class ()

function Sound:play()
end

function Sound:stop()
end

function Sound:loadBuffer(amplitude, hz, sampleRate)    
end

function Sound:getSampleRate()
    return 100
end

function Sound:getSampleCount()
    return 100
end

function Sound:getSample(i)
    return 1
end


function sound()
    return Sound()
end