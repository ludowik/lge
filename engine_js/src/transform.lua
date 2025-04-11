
function pushMatrix()
    pg:push()
end

function popMatrix()
    pg:pop()
end

function resetMatrix()
    pg:resetMatrix()
end

function resetMatrixContext()
    pg:resetMatrix()
end

function translate(...)
    pg:translate(...)
end

function scale(...)
    pg:scale(...)
end

function rotate(...)
    pg:rotate(...)
end

function inverseTransformPoint(x, y)
    return x, y
end

function perspective()
end

function camera()
end
