function resetMatrix()
    love.graphics.origin()
    love.graphics.translate(X, Y)
end

function push()
    love.graphics.push()
end

function pop()
    love.graphics.pop()
end

function translate(x, y, z)
    love.graphics.translate(x, y, z)
end

function rotate(angle)
    love.graphics.rotate(angle)
end

function scale(x, y, z)
    love.graphics.scale(x, y, z)
end
