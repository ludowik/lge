function setup()
    image = FrameBuffer(W, H)

    vertices = {}
    for i=1,50 do
        local v = vec2(
            randomInt(W),
            randomInt(H)
        )

        table.insert(vertices, v)
    end
end

function draw()
    background()

    local vertex

--        local pixels = image.surface.pixels

    local minDistance
    local maxDistance = (W/4)^2

    local n = #vertices

    local ratio = -255 / maxDistance
    
    local i = 0

    local dx, dy

    local w, h = image.width, image.height
    
    for y=1,h do
        for x=1,w do

            minDistance = maxDistance

            for j=1,n do
                vertex = vertices[j]

                dx = x - vertex.x
                dy = y - vertex.y

                dist = dx*dx + dy*dy

                if dist < minDistance then
                    minDistance = dist
                end
            end

            minDistance = 255 + minDistance * ratio

            image:setPixel(x-1, y-1, minDistance/255, minDistance/255, minDistance/255, 1)
            
--                    pixels[i  ] = minDistance
--                    pixels[i+1] = minDistance
--                    pixels[i+2] = minDistance

--                    pixels[i+3] = 255

            i = i + 4

        end
    end

--        image:makeTexture()

    spriteMode(CORNER)
    sprite(image, 0, 0)

    stroke(colors.red)

    for j=1,#vertices do
        vertex = vertices[j]
        circle(vertex.x, vertex.y, 5)
        vertex:add(vec2(
                random(-2, 2),
                random(-2, 2)))
    end
end
