function setup()
    N = 15    
    reset()
    menu()
end

function menu()
    parameter:action('reset', reset)

    parameter:integer('d', 1, SIZE*2, SIZE)
    parameter:integer('n', 1, N)
    parameter:integer('N', 2, 100, N, reset)
end

function reset()
    img = FrameBuffer(W, H)

    pointList = Array():forn(N, function ()
       return vec3.randomInScreen() 
    end)
    
    shader = nil
end

function resize()
    reset()
end

function mapPixels(img, uniforms, pixelShader)
    shader = shader or Shader.fromString('worley', pixelShader)

    shader:sendUniforms(uniforms)

    local mesh = love.graphics.newMesh({
        {0, 0, 0, 0, 1, 1, 1, 1},
        {W, 0, 1, 0, 1, 0, 1, 1},
        {W, H, 1, 1, 1, 1, 0, 1},
        {0, H, 0, 1, 1, 1, 1, 1}
    }, 'fan')

    img:setContext()
    do
        background()
        setShader(shader.program)
        love.graphics.draw(mesh, 0, 0)
    end
    img:resetContext()
end

function update()
    pointList:foreach(function (v)
        local d = vec3(
            noise(deltaTime+v.x*2.23)*4-2,
            noise(deltaTime+v.y*5.23)*4-2,
            0
        )
        v:add(d) -- vec3.randomAngle())
    end)

    local uniforms = {
        points = pointList,
        d = d,
        n = n-1,
        frameCount = frameCount,
    }

    local pixelShader = [[
        #define MAX_N {MAX_N}

        uniform highp vec3 points[MAX_N];

        uniform highp float d;
        uniform highp int frameCount;
        uniform highp int n;

        highp float distances2D[MAX_N];
        highp float distances3D[MAX_N];
        highp float distances4D[MAX_N];
        
        void sort(inout float distances[MAX_N]) {
            for (int i=0; i<MAX_N-1; i++) {
                int min_idx = i;
                for (int j=i+1; j<MAX_N; j++) {
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
            for (int i=0; i<MAX_N; ++i) {
                vec3 v = vec3(screen_coords, sin(float(frameCount)/360.)*d);

                distances2D[i] = distance(screen_coords, points[i].xy*2.);
                distances3D[i] = distance(v, points[i]*2.);
                distances4D[i] = distance(screen_coords, points[i].zz*2.);
            }

            sort(distances2D);
            sort(distances3D);
            sort(distances4D);
            
            float r = map(distances2D[n], 0., d, 0. , 1.);
            float g = map(distances3D[n], 0., d, 1. , 0.);
            float b = map(distances4D[n], 0., d, 0.2, 0.8);
            
            return vec4(r, g, g, 1.);
        }
    ]]

    mapPixels(img, uniforms, pixelShader:replace(
        '{MAX_N}', #pointList
    ))
end

function draw()    
    sprite(img)
end
