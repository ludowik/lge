function setup()
    m = Mesh(Model.box())

    m.instances = Array()

    local size = 25
    for x=-size,size do
        for y=-size,size do
            for z=-size,size do
                m.instances:add({x, y, z, 0.5, 0.5, 0.5, 1, 1, 1, 1})
            end
        end
    end

    m.instancesBuffer = m:instancedBuffer(m.instances)

    local distance = 50
    camera(vec3(distance, distance, distance))
end

function draw()
    background()
    perspective()

    m:drawInstanced(m.instances, m.instancesBuffer)
end
