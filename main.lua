require 'lua.debug'
require 'lua.require'
require 'lua.string'
require 'class'
require 'index'
require 'event'
require 'rect'
require 'graphics2d'
require 'state'
require 'sketch'
require 'engine'
require 'lua.package'

makezip()

MySketch = class():extends(Sketch)

function MySketch:init()
    Sketch.init(self)
end

function MySketch:draw()
    love.graphics.clear(255, 0, 0)
    love.graphics.setFont(font)
    text("hello "..self.index, 100 + 100 * self.index, 100)
end

sketches = {
    MySketch(),
    MySketch(),
    MySketch(),
    MySketch(),
    MySketch(),
    MySketch()
}

local socket_http = require 'socket.http'

http = class()

function http.request(url, success, fail, parameterTable)
    local result, code, headers = socket_http.request(url)

    if result then
        local tempFile = getImagePath()
        local data = love.filesystem.write(tempFile, result)

        if headers['content-type'] and headers['content-type']:startWith('image') then
            data = image('data')
        end

        if success then 
            success(data, code, headers)
        end
        
    else        
        if fail then
            fail(result, code, headers)
        end
    end

end

local url = 'https://raw.githubusercontent.com/ludowik/lca/main/lca.love'
http.request(url, function ()
        exit()
    end,
    function (result, code, headers)
        print(headers)
    end)
