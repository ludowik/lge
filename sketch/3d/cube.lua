function setup()
    parameter:boolean('rotate', 'rotateScene', false)
    parameter:boolean('isometric/perspective', 'isometricMode', false)
    parameter:boolean('border', 'border', false)

    cube = Mesh(Model.box())
    cube.image = createTexture()
    cube.colors = nil

    camera(vec3(4, 4, 4))
end

function update(dt)
    if rotateScene then
        sketch.cam.angleX = sketch.cam.angleX + dt
        sketch.cam.angleY = sketch.cam.angleY + dt
    end
end

function draw()
    background(51)

    if isometricMode then
        isometric(50)
    else
        perspective()
    end

    fill(colors.white)

    cube:draw()

    if border then
        stroke(colors.red)
        boxBorder()
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
                seed(x)

                for x=0,size-tileSize,tileSize do
                    for y=0,size-tileSize,tileSize do
                        fill(Color.random(clr))
                        rect(x, y, tileSize, tileSize)
                    end
                end
                popMatrix()
            end

            face(size*0, size, colors.brown)
            face(size*1, size, colors.brown)
            face(size*2, size, colors.brown)
            face(size*3, size, colors.brown)
            face(size*1, size*2, Color(58, 157, 35))
            face(size*1, size*0, colors.brown)
        end)
        
    return image
end
