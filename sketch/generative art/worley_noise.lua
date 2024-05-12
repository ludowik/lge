function setup()
    N = 20
    reset()
end

function reset()
    parameter:clear()
    parameter:action('reset', reset)

    parameter:integer('d', 1, SIZE*2, SIZE)
    parameter:integer('n', 1, N)
    parameter:integer('N', 2, 100, N, reset)

    img = FrameBuffer(W, H)

    pointList = Array():forn(N, vec3.randomInScreen)
    shader = nil
end

function resize()
    reset()
end

function mapPixels(img, uniforms, pixelShader)
    shader = shader or Shader.fromString('worley', pixelShader)

    shader:sendUniforms(uniforms)

    love.graphics.clear(0, 0, 0, 1)
    love.graphics.setShader(shader.program)

    local mesh = love.graphics.newMesh({
        {0, 0, 0, 0, 1, 1, 1, 1},
        {img.width, 0, 1, 0, 1, 0, 1, 1},
        {img.width, img.height, 1, 1, 1, 1, 0, 1},
        {0, img.height, 0, 1, 1, 1, 1, 1}
    }, 'fan')

    img:setContext()
    love.graphics.draw(mesh, 0, 0)
    img:resetContext()

    love.graphics.setShader()
end

function update()
    -- pointList:foreach(function (v)
    --     v:add(vec3.randomAngle())
    -- end)

    local uniforms = {
        points = pointList,
        d = d,
        n = n-1,
        frameCount = frameCount,
    }

    local pixelShader = [[
        #define MAX_N {MAX_N}

        uniform int pointsCount;
        uniform vec3 points[MAX_N];

        uniform float d;
        uniform int frameCount;
        uniform int n;

        float distances2D[MAX_N];
        float distances3D[MAX_N];
        float distances4D[MAX_N];
        
        void sort(inout float distances[MAX_N], int pointsCount) {
            for (int i=0; i<(pointsCount-1); i++) {
                int min_idx = i;
                for (int j=i+1; j<(pointsCount); j++) {
                    if (distances[j] < distances[min_idx]) {
                        min_idx = j;
                    }
                }

                if (min_idx != i) {
                    float v = distances[i];
                    distances[i] = distances[min_idx];
                    distances[min_idx] = v;
                }
            }
        }

        vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
            for (int i=0; i<pointsCount; ++i) {
                vec3 v = vec3(screen_coords, sin(frameCount/360.)*d);

                distances2D[i] = distance(screen_coords, points[i].xy*2.);
                distances3D[i] = distance(v, points[i]*2.);
                distances2D[i] = distance(screen_coords, points[i].zz*2.);
            }

            sort(distances2D, pointsCount);
            sort(distances3D, pointsCount);
            sort(distances4D, pointsCount);
            
            float r = map(distances2D[n], 0., d, 0. , 1.);
            float g = map(distances3D[n], 0., d, 1. , 0.);
            float b = map(distances4D[n], 0., d, 0.2, 0.8);
            
            return vec4(r, g, b, 1.);
        }
    ]]

    mapPixels(img, uniforms, pixelShader:replace(
        '{MAX_N}', #pointList
    ))
end

function draw()    
    sprite(img)
end
