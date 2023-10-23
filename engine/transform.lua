function resetMatrix()
    love.graphics.origin()
    love.graphics.translate(X, Y)
end

function pushMatrix()
    love.graphics.push()
end

function popMatrix()
    love.graphics.pop()
end

function translate(x, y, z)
    assert(not z)
    love.graphics.translate(x, y)
end

function rotate(angle)
    love.graphics.rotate(angle)
end

function scale(x, y, z)
    assert(not z)
    y = y or x
    love.graphics.scale(x, y)
end
