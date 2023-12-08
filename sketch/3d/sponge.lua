function setup()
    scene = Scene()
    scene:add(Cube(vec3(0, 0, 0), 50))
end

Cube = class()

function Cube:init(position, size)
    self.position = position
    self.size = size
end

function Cube:draw()
    box(self.position.x, self.position.y, self.position.z, self.size)
end

function draw()
    isometric(5)
    scene:draw()
end

function keypressed(key)
    if key == 'return' then
        local newScene = Scene()
        scene:foreach(function (cube)
            for x=-1,1 do
                for y=-1,1 do
                    for z=-1,1 do
                        if abs(x) + abs(y) + abs(z) > 1 then
                            newScene:add(Cube(
                                cube.position + vec3(x, y, z) * (cube.size / 3),
                                cube.size / 3))
                        end
                    end
                end
            end
        end)
        scene = newScene
    end
end
