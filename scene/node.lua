Node = class() : extends(UI, Layout)

function Node:init()
    UI.init(self)
    self:clear()
end

function Node:clear()
    self.items = Array()
end

function Node:add(item)
    self.items:add(item)
    return self
end

function Node:count()
    return  #self.items
end

function Node:foreach(f)
    return self.items:foreach(f)
end

function Node:removeIfTrue(f)
    return self.items:removeIfTrue(f)
end

function Node:update(dt)
    for _,item in ipairs(self.items) do
        if item.visible ~= false then
            if item.update then
                item:update(dt)
            end
        end

        if self.state == 'close' then break end
    end
end

function Node:draw()
    for _,item in ipairs(self.items) do
        if item.visible ~= false then
            if item.draw then
                push()
                item:draw()
                pop()
            end
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
