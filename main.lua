require 'engine'

function drawQuad()
    local vertices = {
        {
            -- top-left corner (red-tinted)
            0, 0, -- position of the vertex
            0, 0, -- texture coordinate at the vertex position
            1, 0, 0, -- color of the vertex
        },
        {
            -- top-right corner (green-tinted)
            100, 0,
            1, 0, -- texture coordinates are in the range of [0, 1]
            0, 1, 0
        },
        {
            -- bottom-right corner (blue-tinted)
            100, 100,
            1, 1,
            0, 0, 1
        },
        {
            -- bottom-left corner (yellow-tinted)
            0, 100,
            0, 1,
            1, 1, 0
        },
    }

    -- the Mesh DrawMode "fan" works well for 4-vertex Meshes.
    mesh = love.graphics.newMesh(vertices, "fan")

    love.graphics.draw(mesh, 0, 0)
end

if false then
    function love.load()
    end

    function love.update(dt)
    end

    function love.draw()
        drawQuad()
    end

    function love.keypressed(key, scancode, isrepeat)
        quit()
    end
end
