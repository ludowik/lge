function setup()
    size = floor(W/4)

    fb = FrameBuffer(W, H)
    parameter:number('ratio', 1, 100, 50)

    local eye = vec3(size/2, 75, size/2)
    camera(eye, eye + vec3(0, -2, 10))
    cameraMode(CAMERA)
end

block = class()

function block.setup()
    block.mesh = Mesh(Model.box())
    block.mesh.image = createTexture()
    block.mesh.colors = nil
end

function block.position(x, y, z)
    return x/ratio, y/ratio, z/ratio
end

function block.random(x, y,z)
    x, y, z = block.position(x, y, z)
    return random()
end

function block.simplex(x, y,z)
    x, y, z = block.position(x, y, z)
    return simplexNoise(x, y, z)
end

function block.perlin(x, y,z)
    x, y, z = block.position(x, y, z)
    return perlinNoise(x, y, z)
end

function block.terrain(x, y,z)
    x, y, z = block.position(x, y, z)
    return 
        0.98 * perlinNoise(   x,    y,    z) + 
        0.5  * perlinNoise( 2*x,  2*y,  2*z) + 
        0.25 * perlinNoise( 4*x,  4*y,  4*z) + 
        0.13 * perlinNoise( 8*x,  8*y,  8*z) + 
        0.06 * perlinNoise(16*x, 16*y, 16*z)
end

function draw()
    background()

    function getUnivers(getBlock, size)
        return getResource(getBlock, function ()
            return createUnivers(getBlock, size)
        end)
    end

    function createUnivers(getBlock, size)
        seed(51)

        local positions = Array()
        local blocks = Array()

        for x=0,size-1 do
            for z=0,size-1 do
                local height, type = getBlock(x, 0, z)
                height = (height+1)/2
                positions:add({x, z, height, height, height, 1})
                blocks:add({x, floor(height*50), z, 1, 1, 1, height, height, height, 1})
            end
        end

        return positions, blocks
    end

    local i, j = 0, 1
    local function getPosition(_, _, size)
        i = i + 1
        return (i-1)*size, (j-1)*size, size, size
    end

    function univers(getBlock, i, j)
        pushMatrix()

        translate(getPosition(i, j, size))

        local positions, blocks = getUnivers(getBlock, size)
        points(positions)

        setContext(fb, true)
        resetMatrix()
        perspective()
        
        -- light(true)

        block.mesh:drawInstanced(blocks)
        resetContext()

        translate(0, 400)

        love.graphics.draw(fb.canvas, 0, 0, 0, size/W, size/H)

        popMatrix()
    end

    univers(block.random)
    univers(block.simplex)
    univers(block.perlin)
    univers(block.terrain)
end

function createTexture()
    local size = 64
    local tileSize = 8

    local image = FrameBuffer(size*4, size*3)

    render2context(image,
        function ()
            noStroke()
            rectMode(CORNER)

            local function face(x, y, clr)
                pushMatrix()
                translate(x, y)
                seed(x)

                for x=0,size-tileSize,tileSize do
                    for y=0,size-tileSize,tileSize do
                        fill(Color.random(clr))
                        rect(x, y, tileSize, tileSize)
                    end
                end
                popMatrix()
            end

            face(size*0, size, colors.green)
            face(size*1, size, colors.green)
            face(size*2, size, colors.green)
            face(size*3, size, colors.green)
            face(size*1, size*2, colors.green)
            face(size*1, size*0, colors.green)
        end)
        
    return image
end
