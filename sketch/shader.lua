function setup()
    local vertexShader = [[
        #pragma language glsl3
        uniform Image MainTex;
        vec4 position(mat4 transform_projection, vec4 vertex_position) {
            return transform_projection * vec4(texelFetch(MainTex, ivec2(vertex_position.xy), 0).xy*love_ScreenSize.xy, 0., 1.);
            //return transform_projection * vertex_position;
        }
    ]]
    local pixelShader = [[
        #pragma language glsl3
        vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
            return texelFetch(MainTex, ivec2(screen_coords), 0);
            //return Texel(MainTex, texture_coords);
        }
    ]]
    shader = love.graphics.newShader(pixelShader, vertexShader)

    local vertices = Array()

    for x in range(W) do
        for y in range(H) do
            vertices:add{
                x, y,
                x/W, y/H,
                x/W, y/H, 0, 1,
            }
        end
    end
    
    mesh = love.graphics.newMesh(vertices, 'points')

    prepare()
end

function prepare()
    imageData = love.image.newImageData(W, H, 'rgba16')
    pointer = require("ffi").cast("uint16_t*", imageData:getFFIPointer()) -- imageData has one byte per channel per pixel.    

    local pointer, i = pointer, 0    
    local r, g, b, a = 0, 0, 0, 0

    for y in index(imageData:getHeight()) do
        for x in index(imageData:getWidth()) do
            pointer[i  ] = x/W
            pointer[i+1] = y/H
            pointer[i+2] = y/H
            pointer[i+3] = 1

            i = i + 4
        end
	end

    image = love.graphics.newImage(imageData)
    image:setFilter('nearest', 'nearest', 0)

    -- local w, h = env.sketch.canvas:getWidth(), env.sketch.canvas:getHeight()
    -- canvas = love.graphics.newCanvas(w, h)
    -- canvas:setFilter('nearest', 'nearest', 0)

    -- local currentCanvas = love.graphics.getCanvas()
    -- love.graphics.setCanvas(canvas)
    -- love.graphics.setShader(shader)

    -- love.graphics.origin()
    -- love.graphics.clear(0, 0, 0, 1)

    -- love.graphics.draw(mesh, 0, 0)

    -- love.graphics.setCanvas(currentCanvas)
    -- love.graphics.setShader()
end

function draw()
    love.graphics.setShader(shader)

    mesh:setTexture(image)
    love.graphics.draw(mesh, 0, 0)

    love.graphics.setShader()
    --love.graphics.draw(canvas, 0, 0)
end
