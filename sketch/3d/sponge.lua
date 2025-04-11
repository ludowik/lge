function setup()
    mesh = Mesh(Model.box())
    
    cubes = Array()
    cubes:add({0, 0, 0, 50, 50, 50, 1, 1, 1, 1})

    parameter:watch('cubes:count()')
    parameter:action('level', addLevel)
end

function draw()
    isometric(5)    
    mesh:drawInstanced(cubes)
end

function addLevel()
    local newCubes = Array()
    cubes:foreach(function (cube)
        for x=-1,1 do
            for y=-1,1 do
                for z=-1,1 do
                    if abs(x) + abs(y) + abs(z) > 1 then
                        local size = cube[4] / 3
                        newCubes:add{
                            cube[1] + x * size,
                            cube[2] + y * size,
                            cube[3] + z * size,
                            size,
                            size,
                            size,
                            1, 1, 1, 1
                        }
                    end
                end
            end
        end
    end)
    cubes = newCubes
end

function keypressed(key)
    if key == 'return' then
        addLevel()
    end
end
