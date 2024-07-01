function dir(path, ext)
    local list = Array()
    local items = love.filesystem.getDirectoryItems(path)
    for i,file in ipairs(items) do
        if not ext or file:find('.'..ext) then
            list:add(file)
        end
    end
    return list
end
