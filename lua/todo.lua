function scanTODO()
    local function scan(todos)
        local todoLists = {}
        for _,todoName in ipairs(todos) do
            todoLists[todoName] = Array()
        end

        local list = dir('')
        for i,file in ipairs(list) do
            goto continue
            if isLuaFile(file) then
            
                local content = io.read(file)
                if content then

                    local lines = content:split(NL)
                    if lines then
                        for iline,line in ipairs(lines) do

                            for _,todoName in ipairs(todos) do
                                local i,j,v = line:find('([ -]'..todoName..'[ :]*.*)')
                                if i then
                                    local ref = file
                                    todoLists[todoName]:insert(ref..':'..iline..': '..v)
                                end
                            end

                        end
                    end
                end

            end
            ::continue::
        end
        
        for _,todoName in ipairs(todos) do
            if #todoLists[todoName] > 0 then
                local data = todoLists[todoName]:concat(NL)

                print(todoName)
                print(data)

                io.write('todo', data, 'at')
            end
        end
    end

    io.write('todo', '', 'wt')

    scan{
        'TODO',
        'TODEL',
        'TOFIX',
        'TOTEST'
    }

    exit()
end
