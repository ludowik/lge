Layout = class()

function Layout:layout(_x, _y, align)
    local x = _x or 0
    local y = _y or 0

    align = (align or self.layoutMode or 'left'):lower()

    local w, h = 0, 0

    for _,item in ipairs(self.items) do
        item.position:set()
        item.size:set()
    end

    for _,item in ipairs(self.items) do
        if item.visible then
            if item.layout then
                item:layout(x, y, align)
            else
                item:computeSize()
            end

            -- alignment
            if align == 'right' then
                x = W - item.size.x - LEFT/2
            elseif align == 'center' then
                x = CX - item.size.x/2
            end

            -- set position
            if item.fixedPosition then
                item.position:set(item.fixedPosition.x, item.fixedPosition.y)
            else
                item.position:set(x, y)
            end

            -- compute next y
            y = y + item.size.y + UI.outerMarge

            -- compute node size
            w = max(w, item.size.x)
            h = h + item.size.y + UI.outerMarge
        end

        if self.state == 'close' then break end
    end

    self.size:set(w, h)
end
