Layout = class()

function Layout:layout(x, y)
    x, y = x or 0, y or Y
    local w, h = 0, 0
    for _,item in ipairs(self.items) do
        item.position:set()
        item.size:set()
    end
    for _,item in ipairs(self.items) do
        if item.layout then
            item:layout(x, y)
        else
            item:computeSize()
        end
        x = W - item.size.x
        
        item.position:set(x, y)
        y = y + item.size.y

        w = math.max(w, item.size.x)
        h = math.max(h, y)

        if self.state == 'close' then break end
    end
    self.size:set(w, h)
end

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
            item:draw()
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

Scene = class() : extends(Node)
