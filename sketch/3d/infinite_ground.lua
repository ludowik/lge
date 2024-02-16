function setup()
    initMesh()

    parameter:number('param1', 0, 15, 0)
end

function initMesh()
    local size = 50
    local n = 10
    
    env.ground = Mesh(Model.ground(size, 1, size, 20))
    env.ground.uniforms.computeHeight = true

    env.instances = Array()

    clr = colors.white

    for x=-n,n do
        for z=-n,n do
            env.instances:add{x*size, 0, z*size, 1, 1, 1, clr:unpack()}
        end
    end
    
    direction = vec3(0, -10, size)
    
    position = vec3(0, size, -n*size)
    at = position + direction
    
    camera(position, at)
end

function update(dt)
    position:add(vec3(direction.x, 0, direction.z) * dt)
    at = position + direction
    
    camera(position, at)
end

function draw()
    background(51)
    perspective()
    
    light(true)

    fill(colors.white)

    translate(position.x, 0, position.z)
    
    env.ground.uniforms.translation = position / 2
    
    env.ground.uniforms.useRelief = 1
    env.ground.uniforms.param1 = param1

    env.ground:drawInstanced(env.instances)
end
