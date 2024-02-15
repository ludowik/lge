function setup()
    models = {
        {m=0, n=1, na=1, nb=1},
        {m=3, n=4.5, na=10, nb=10},
        {m=4, n=12, na=15, nb=15},
    }

    model = models[1]

    parameter:integer('shape_size', 0, 50, 50)

    parameter:number('a', 0, 25, 2)
    parameter:number('b', 0, 25, 2)

    parameter:number('m', 0, 30, model.m)

    parameter:number('na', 0, 20, model.na)
    parameter:number('nb', 0, 20, model.nb)

    parameter:number('n', 2, 15, model.n)

    array = Buffer('vec3')
    parameter:integer('parts', 2, 128, 16, function () array:reset() end)

    seed(time())
    parameter:randomizeParameter()
    
    parameter:boolean('scale_shape', true)

    parameter:boolean('_3d', false)

    camera(1000, 1000, 1000)
end

function draw()
    if not _3d then
        __draw2d()
    else
        -- ortho3D()
        __draw3d()
    end
end

function __draw2d()
    background(0)

    stroke(colors.white)
    strokeSize(5)

    translate(W/2, H/2)

    local len, maxLen = 0, 0
    local x, y

    local alpha_n = parts * 2
    local delta = TAU / alpha_n

    beginShape()
    for theta=0,TAU,delta do
        len = r(theta) * shape_size

        maxLen = max(maxLen, len)

        x = len * cos(theta)
        y = len * sin(theta)

        vertex(x, y)
    end

    if scale_shape then
        scaleShape((W/4)/maxLen)
    end

    endShape()
end

-- TODO : implement 3D functions
function __draw3d()
    background(51)

    perspective()

    light(true)

    stroke(colors.white)
    strokeSize(5)

    local index = 1
    local shape_size2 = shape_size * 2

    local r1, r2, cos_beta, cos_alpha, sin_alpha, sin_beta

    local alpha_n = parts * 2
    local beta_n = alpha_n / 2

    local delta = TAU / alpha_n

    local maxr = 0

    local alpha = -PI
    for i=0,alpha_n do
        if i == alpha_n then alpha = PI end
        r1 = r(alpha)

        maxr = max(maxr, r1)

        cos_alpha = r1 * cos(alpha)
        sin_alpha = r1 * sin(alpha)

        local beta = -PI/2
        for j=0,beta_n do
            if j == beta_n then beta = PI/2 end
            r2 = r(beta)

            maxr = max(maxr, r2)

            cos_beta = r2 * cos(beta) * shape_size
            sin_beta = r2 * sin(beta) * shape_size2

            x = cos_alpha * cos_beta
            y = sin_alpha * cos_beta 
            z = sin_beta

            array[index] = vec3(x,y,z)
            if i == 0 then
                array[(alpha_n+1)*(beta_n+1)*2+index+1-(beta_n+1)*2] = vec3(x,y,z)
            else
                array[index+1-(beta_n+1)*2] = vec3(x,y,z)
            end
            index = index + 2

            beta = beta + delta
        end
        alpha = alpha + delta
    end

    local ratio = (W/4)/(maxr*shape_size2)
    for i=1,#array do
        local v = array[i]
        v:mul(ratio)

        array[i] = {v:unpack()}
    end

    fill(colors.white)

    -- cullingMode(false)
    love.graphics.setMeshCullMode('none')

    mesh = Mesh(Model.centerVertices(array))
    mesh.drawMode = 'strip'
    -- TODO : BUG !!! computeNormals need to be modify to manage strip type
    --mesh.normals = Model.computeNormals(mesh.vertices, nil, false)

    mesh:draw()
end

function r(theta)
    local m_theta = m * theta / 4
    return pow(
        pow(abs(cos(m_theta)/a), na) +
        pow(abs(sin(m_theta)/b), nb),

        -1/n
    )
end
