Node = class() : extends(UI, Layout)

function Node:init()
    UI.init(self)
    self:clear()
end

function Node:clear()
    self.items = Array()
end

function Node:__tostring()
    return tostring(#self.items)
end

function Node:add(item)
    self.items = self.items or Array()
    self.items:add(item)
    return self
end

function Node:shift()
    return self.items:shift()
end

function Node:count()
    return #self.items
end

function Node:ipairs()
    return ipairs(self.items)
end

function Node:foreach(f)
    return self.items:foreach(f)
end

function Node:cross(f)
    return self.items:cross(f)
end

function Node:removeIfTrue(f)
    return self.items:removeIfTrue(f)
end

function Node:update(dt)
    if self.visible == false then return end

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
    if self.visible == false then return end

    for _,item in ipairs(self.items) do
        if item.visible ~= false then
            if item.draw then
                pushMatrix()
                item:draw()
                popMatrix()
            end
        end
        
        if self.state == 'close' then break end
    end
end

function Node:contains(position)
    if self.visible == false then return end
    if #self.items == 0 and Rect.contains(self, position) then
        return self
    end

    for _,item in ipairs(self.items, self.reverseSearch) do
        if item.visible ~= false and item.contains then
            local result = item:contains(position)
            if result then
                return result
            end
        end

        if self.state == 'close' then break end
    end
end

function Node:mousepressed(mouse)
    local result = self:contains(mouse.position)
    if result then
        return true
    end
end

function Node:mousereleased(mouse)
    local result = self:contains(mouse.position)
    if result and result.click then
        result:click(mouse)
        return true
    end
end
