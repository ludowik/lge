requireLib {
    'lexer',
    'parser'
}

function setup()
    local directoryItems = love.filesystem.getDirectoryItems('engine', '*.lua')
    for i,file in ipairs(directoryItems) do
        local filePath = 'engine/'..file
        local info = love.filesystem.getInfo(filePath)
        if info.type == 'file' then
            lexer(love.filesystem.read(filePath))
        end
    end
end
