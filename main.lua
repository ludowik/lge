-- require 'system.os'
-- require 'system.package'

-- function love.load()
--     _, _, W, H = love.window.getSafeArea()

--     if getOS() == 'ios' then
--         love.window.setMode(H, W)
--     end
-- end

-- function love.update()
-- end

-- function love.draw()
--     love.graphics.print(getOS(), 200, 200)
-- end

-- function love.keypressed(key)
--     if key == 'escape' then
--         love.event.quit()
--     end
-- end



require 'engine.lge'

function load()
    process = {}

    MySketch = class() : extends(Sketch)

    function MySketch:init()
        Sketch.init(self)
        table.insert(process, self)

        self:randomize()

        self.clr = Color.random()

        Image.init(self, self.size.x, self.size.y)
    end

    function MySketch:randomize()
        Rect.randomize(self)
        self.clr = Color.random()
    end

    function MySketch:draw()
        background(51)
        fill(self.clr)
        love.graphics.setFont(font)
        text("hello "..self.index)
    end

    MySketch()
    MySketch()
    MySketch()
    MySketch()
    MySketch()
end

print(love.filesystem.getSaveDirectory())

function updateScripts()
    --if getOS():inList{'osx', 'ios'} then
        local url = 'https://ludowik.github.io/Lge/build/lca.love'
        request(url, function (result, code, headers)
                local data = love.filesystem.write('lca.love', result)
            end,
            function (result, code, headers)
                print(headers)
            end)
    --end
end

--request('https://www.shutterstock.com/image-photo/surreal-image-african-elephant-wearing-260nw-1365289022.jpg')
