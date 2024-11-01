function setup()
    local size = 320
    fb = FrameBuffer(size, size)
    
    parameter:number('ratio', 1, 100, 50, function ()
        releaseResource('univers')
    end)

    sizeUnivers = 400

    local eye = vec3(100, 40, 100)
    camera(eye, eye + vec3(10, -5, 10))
    cameraMode(CAMERA)
end

block = class()

function block.setup()
    block.mesh = Mesh(Model.box())
    block.mesh.image = createTexture()
    --block.mesh.colors = nil
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

function getUnivers(getBlock, size)
    return getResource('univers', getBlock, function ()
        return createUnivers(getBlock, size)
    end)
end

function createUnivers(getBlock, size)
    seed(time())

    local positions = Array()
    local blocks = Array()

    for x=0,size-1 do
        for z=0,size-1 do
            local height = getBlock(x, 0, z)
            height = (height + 1) / 2

            positions:add({x, z, height, height, height, 1})
            blocks:add({x, floor(height*20), z, 1, 1, 1, height, height, height, 1})
        end
    end

    return positions, blocks
end

function getPosition(i, j, size)
    return (i-1)*size, (j-1)*2*size, size, size
end

function draw()
    background()

    local size
    if deviceOrientation == PORTRAIT then
        size = min(W/2, H/4)
    else
        size = min(W/4, H/2)
    end

    function univers(i, j, getBlock)
        local positions, blocks = getUnivers(getBlock, sizeUnivers)

        -- draw direct 2d
        pushMatrix()
        translate(getPosition(i, j, size))
        scale(size/sizeUnivers)
        points(positions)
        popMatrix()

        -- draw 3d in fb
        setContext(fb, true)
        resetMatrixContext()
        light(true)
        perspective()        
        love.graphics.clear(0, 0, 0, 1, true, false, 1)
        block.mesh:drawInstanced(blocks)
        resetContext()

        -- draw fb
        pushMatrix()
        translate(getPosition(i, j, size))
        love.graphics.draw(fb.canvas, 0, size, 0, size/fb.width, size/fb.height)
        popMatrix()
    end

    if deviceOrientation == PORTRAIT then
        translate((W-size*2)/2, (H-size*4)/2)
        univers(1, 1, block.random)
        univers(2, 1, block.simplex)
        univers(1, 2, block.perlin)
        univers(2, 2, block.terrain)

    else
        translate((W-size*4)/2, (H-size*2)/2)
        univers(1, 1, block.random)
        univers(2, 1, block.simplex)
        univers(3, 1, block.perlin)
        univers(4, 1, block.terrain)
    end
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
    
    image:getImageData()
        
    return image
end
