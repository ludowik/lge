function Model.load(fileName)
    local filePath = 'resources/models/'..fileName

    local info = love.filesystem.getInfo(filePath)
    if info and info.type == 'directory' then
        local model = Model.load(fileName..'/'..fileName..'.obj')
        model.fileName = fileName
        if love.filesystem.getInfo(filePath..'/'..fileName..'.png') then
            model.image = Image(filePath..'/'..fileName..'.png')
        end
        return model
    end

    if not fileName:find('obj') then
        return
    end
    
    local content = love.filesystem.read(filePath)
    if not content then return end

    content = content:replace('  ', ' ')

    local indices = Buffer('unsigned short')
    local vertices, verticesTemp = Buffer('vec3'), Buffer('vec3')
    local normals, normalsTemp = Buffer('vec3'), Buffer('vec3')
    local texCoords, texCoordsTemp = Buffer('vec2'), Buffer('vec2')

    local v2, v3 = {}, {} -- vec2(), vec3()

    local datas, typeofRecord

    local lines = content:split(NL)
    for line=1,#lines do
        datas = lines[line]:trim():split(' ')

        typeofRecord = datas[1]

        if typeofRecord == 'mtllib' then
            local name = datas[2]
            
        elseif typeofRecord == 'v' then
            -- vertex
            verticesTemp:insert{
                tonumber(datas[2]),
                tonumber(datas[3]),
                tonumber(datas[4])}

        elseif typeofRecord == 'vn' then
            -- normals
            normalsTemp:insert{
                tonumber(datas[2]),
                tonumber(datas[3]),
                tonumber(datas[4])}

        elseif typeofRecord == 'vt' then
            -- texture coordinates
            texCoordsTemp:insert{
                tonumber(datas[2]),
                1-tonumber(datas[3])}

        elseif typeofRecord == 'f' then
            -- faces
            local function vertex(i)
                assert(tonumber(datas[i][1]), 'line '..line)

                local n = #vertices+1
                if #verticesTemp > 0 then
                    vertices[n] = table.clone(verticesTemp[tonumber(datas[i][1])])
                end
                if #texCoordsTemp > 0 then
                    texCoords[n] = table.clone(texCoordsTemp[tonumber(datas[i][2])])
                end
                if #normalsTemp > 0 then
                    normals[n] = table.clone(normalsTemp[tonumber(datas[i][3])])
                end
            end

            local function face(a, b, c)
                vertex(a)
                vertex(b)
                vertex(c)
            end

            -- f v1/vt1/vn1 v2/vt2/vn2 v3/vt3/vn3 ...
            for i=2,#datas do
                datas[i] = datas[i]:trim():split('/')
            end

            if #datas <= 5 then
                face(3, 4, 2)
                if #datas == 5 then
                    face(2, 4, 5)
                end
            else
                for i=3,#datas-1 do
                    face(i, i+1, 2)
                end
            end

        elseif typeofRecord == 'o' then
            -- object name

        elseif typeofRecord == 'g' then
            -- group name

        elseif typeofRecord == 'usemtl' then
            -- material name

        end
    end

    local model = Mesh()
    model.indices = indices
    model.texCoords = texCoords
    model.vertices = vertices

    
    model.fileName = fileName
    
    return model
end
