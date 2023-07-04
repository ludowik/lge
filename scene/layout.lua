Layout = class()

function Layout:layout(x, y)
    x, y = x or 0, y or UI.innerMarge
    
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
        x = W - item.size.x - UI.innerMarge
        
        item.position:set(x, y)
        y = y + item.size.y + UI.innerMarge

        w = max(w, item.size.x)
        h = h + item.size.y + UI.innerMarge

        if self.state == 'close' then break end
    end
    self.size:set(w, h)
end
