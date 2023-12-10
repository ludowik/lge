function Model.load(fileName)
    local filePath = 'resources/models/'..fileName

    local content = io.read(filePath)

    if content then
        content = content:replace('  ', ' ')

        local indices = Buffer('unsigned short')
        local vertices, verticesTemp = Buffer('vec3'), Buffer('vec3')
        local normals, normalsTemp = Buffer('vec3'), Buffer('vec3')
        local texCoords, texCoordsTemp = Buffer('vec2'), Buffer('vec2')

        local v2, v3 = {}, {} -- vec2(), vec3()

        local function set2(v, x, y)
            v[1] = x
            v[2] = y
            -- v.x = x
            -- v.y = y
        end

        local function set3(v, x, y, z)
            v[1] = x
            v[2] = y
            v[3] = z
            -- v.x = x
            -- v.y = y
            -- v.z = z
        end

        local datas, typeofRecord

        local lines = content:split(NL)
        for line=1,#lines do
            datas = lines[line]:trim():split(' ')

            typeofRecord = datas[1]

            if typeofRecord == 'v' then
                -- vertex
                set3(v3,
                    tonumber(datas[2]),
                    tonumber(datas[3]),
                    tonumber(datas[4])
                )
                verticesTemp:insert(table.clone(v3))

            elseif typeofRecord == 'vn' then
                -- normals
                set3(v3,
                    tonumber(datas[2]),
                    tonumber(datas[3]),
                    tonumber(datas[4])
                )
                normalsTemp:insert(table.clone(v3))

            elseif typeofRecord == 'vt' then
                -- texture coordinates
                set2(v2,
                    tonumber(datas[2]),
                    tonumber(datas[3])
                )
                texCoordsTemp:insert(table.clone(v2))

            elseif typeofRecord == 'f' then
                -- faces
                local function vertex(i)
                    assert(tonumber(datas[i][1]), 'line '..line)

                    local n = #vertices+1
                    if #verticesTemp > 0 then
                        vertices[n] = verticesTemp[tonumber(datas[i][1])]
                    end
                    if #texCoordsTemp > 0 then
                        texCoords[n] = texCoordsTemp[tonumber(datas[i][2])]
                    end
                    if #normalsTemp > 0 then
                        normals[n] = normalsTemp[tonumber(datas[i][3])]
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

        local m = Mesh()
        m.indices = indices
        m.vertices = vertices
        m.normals = normals
        m.texCoords = texCoords

        return m
    end
end
