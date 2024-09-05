
function pushMatrix()
    js.global:push()
end

function popMatrix()
    js.global:pop()
end

function resetMatrix()
    js.global:resetMatrix()
end

function resetStyle()
end

function translate(...)
    return js.global:translate(...)
end

function scale(...)
    return js.global:scale(...)
end

function rotate(...)
    return js.global:rotate(...)
end
