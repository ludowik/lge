Layout = class()

function Layout:layout(x, y)
    x, y = x or 0, y or 0
    
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

        w = max(w, item.size.x)
        h = max(h, y)

        if self.state == 'close' then break end
    end
    self.size:set(w, h)
end
