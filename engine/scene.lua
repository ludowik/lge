Scene = class()

function Scene:init()
    self.items = Array()
end

function Scene:add(item)
    self.items:add(item)
end

function Scene:update(dt)
    for _,item in ipairs(self.items) do
        if item.update then
            item:update(dt)
        end
    end
end

function Scene:draw()
    for _,item in ipairs(self.items) do
        if item.draw then
            item:draw()
        end
    end
end

function Scene:mousepressed(mouse)
    for _,item in ipairs(self.items) do
        if item:contains(mouse.position) then
            return item:click()
        end
    end
end

function Scene:mousereleased(mouse)
    for _,item in ipairs(self.items) do
        if item:contains(mouse.position) then
            return item
        end
    end
end
