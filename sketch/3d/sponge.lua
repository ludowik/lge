function draw()
    isometric(5)

    scene = Scene()

    cubes = Array{{
            position = vec3(0, 0, 0),
            size = 50
        }
    }

    for _,cube in ipairs(cubes) do
        scene:add(box(cube.position.x*10, cube.position.y*10, cube.position.z*10, cube.size))
    end

    -- for x=-1,1 do
    --     for y=-1,1 do
    --         for z=-1,1 do
    --             if abs(x) + abs(y) + abs(z) > 1 then
    --                 scene:add(box(x*10, y*10, z*10, 10))
    --             end
    --         end
    --     end
    -- end
end
