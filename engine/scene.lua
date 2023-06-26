Scene = class() : extends(UI)

function Scene:init()
    UI.init(self)
    self.items = Array()
end

function Scene:add(item)
    self.items:add(item)
    return self
end

function Scene:layout(x, y)
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

function Scene:update(dt)
    for _,item in ipairs(self.items) do
        if item.update then
            item:update(dt)
        end
        if self.state == 'close' then break end
    end
end

function Scene:draw()
    for _,item in ipairs(self.items) do
        if item.draw then
            item:draw()
        end
        if self.state == 'close' then break end
    end
end

function Scene:contains(position)
    for _,item in ipairs(self.items) do
        local result = item:contains(position)
        if result then
            return result
        end
    end
end

function Scene:mousepressed(mouse)
    for _,item in ipairs(self.items) do
        local result = item:contains(mouse.position)
        if result then
            result:click()
            return true
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
