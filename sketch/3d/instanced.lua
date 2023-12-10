function setup()
    m = Mesh(Model.box())

    m.instances = Array()

    local size = 30
    for x=-size,size do
        for y=-size,size do
            for z=-size,size do
                m.instances:add({x, y, z, 0.25, 0.25, 0.25})
            end
        end
    end

    m.instancesBuffer = m:instancedBuffer(m.instances)

    camera(100, 100, 100)
end

function draw()
    background()
    perspective()

    m:drawInstanced(m.instances, m.instancesBuffer)
end
