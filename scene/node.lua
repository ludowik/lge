Node = class() : extends(UI, Layout)

function Node:init()
    UI.init(self)
    self.items = Array()
end

function Node:add(item)
    self.items:add(item)
    return self
end

function Node:update(dt)
    for _,item in ipairs(self.items) do
        if item.update then
            item:update(dt)
        end
        if self.state == 'close' then break end
    end
end

function Node:draw()
    for _,item in ipairs(self.items) do
        if item.draw then
            love.graphics.push()
--            love.graphics.translate(item.position.x, item.position.y)
            item:draw()
            love.graphics.pop()
        end
        if self.state == 'close' then break end
    end
end

function Node:contains(position)
    for _,item in ipairs(self.items) do
        local result = item:contains(position)
        if result then
            return result
        end
    end
end

function Node:mousepressed(mouse)
    local result = self:contains(mouse.position)
    if result then
        result:click()
        return true
    end
end

function Node:mousereleased(mouse)
    local result = self:contains(mouse.position)
    if result then
    end
end
