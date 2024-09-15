
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
    return js.global:translate(xyz(...))
end

function scale(...)
    return js.global:scale(xyz(...))
end

function rotate(...)
    return js.global:rotate(...)
end
