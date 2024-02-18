function setup()
    initMesh()

    parameter:action('pause', noLoop)
    parameter:action('resume', loop)

    parameter:number('frequence1',  1,   5,  4)
    parameter:number('frequence2', 10,  50, 20)
    parameter:number('frequence3', 50, 150, 50)

    parameter:number('octave1', 0, 1, 0.8)
    parameter:number('octave2', 0, 1, 0.5)
    parameter:number('octave3', 0, 1, 0.25)
end

function initMesh()
    local size = 50
    local n = 15
    
    env.ground = Mesh(Model.ground(size, 1, size, 50))
    env.ground.uniforms.computeHeight = true

    env.instances = Array()

    clr = colors.white

    for x=-n,n do
        for z=-n,n do
            env.instances:add{x*size, 0, z*size, 1, 1, 1, clr:unpack()}
        end
    end
    
    direction = vec3(0, -10, size)
    
    position = vec3(0, size, -n*size) + vec3(333, 0, 222)
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
    
    env.ground.uniforms.useRelief = true

    env.ground.uniforms.frequence1 = frequence1
    env.ground.uniforms.frequence2 = frequence2
    env.ground.uniforms.frequence3 = frequence3

    env.ground.uniforms.octave1 = octave1
    env.ground.uniforms.octave2 = octave2
    env.ground.uniforms.octave3 = octave3

    env.ground:drawInstanced(env.instances)
end
