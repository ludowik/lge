Layout = class()

function Layout:layout(_x, _y, _layoutMode)
    local x = _x or 0
    local y = _y or 0

    local layoutMode = (_layoutMode or self.layoutMode or 'left'):lower()

    local w, h = 0, 0

    for _,item in ipairs(self.items) do
        item.position:set()
        item.size:set()
    end

    for _,item in ipairs(self.items) do
        if item.visible ~= false then
            -- layout and/or compute size
            if item.layout then
                item:layout(x, y, layoutMode..';'..(item.layoutMode or ''))
            elseif item.computeSize then
                item:computeSize()
            elseif item.fixedSize then
                item.size:set(item.fixedSize)
            end

            -- alignment
            function align(x, y)
                if layoutMode:contains('right') then
                    x = W - item.size.x - LEFT
                elseif layoutMode:contains('center') then
                    x = CX - item.size.x/2
                end
                return x, y
            end
            x, y = align(x, y)

            -- set position
            if item.fixedPosition then
                x, y = item.fixedPosition.x, item.fixedPosition.y
            end
            item.position:set(x, y)

            -- compute next position
            function nextPosition(x, y)
                if layoutMode:contains('horizontal') then
                    x = x + item.size.x + UI.outerMarge
                else
                    y = y + item.size.y + UI.outerMarge
                end
                return x, y
            end
            x, y = nextPosition(x, y)

            -- compute node size
            w = max(w, item.size.x)
            h = h + item.size.y + UI.outerMarge
        end

        if self.state == 'close' then break end
    end

    self.size:set(w, h)
end
