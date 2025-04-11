function setup()
    scene = Scene()

    local list = {}
    for k,v in pairs(_G) do
        if isclass(v) then
            local item = scene:ui(v.__className)            
            if item == nil and not list[v] and not isSketch(v) then
                list[v] = v
                item = ClassItem(k, v)
                scene:add(item)
            end
        end
    end

    for _,item in scene:ipairs() do
        for i,base in ipairs(item.basesRef) do
            local node = scene:ui(base.__className)
            if node then
                node.childs[item] = true
                item.parents[node] = true
            end
        end
    end

    -- local parent = ClassItem(-1, 'parent')
    -- scene:add(parent)
    -- for i=1,10 do
    --     local child = ClassItem(i, ''..i)
    --     scene:add(child)
    --     parent.childs[child] = true
    --     child.parents[parent] = true
    -- end

    parameter:action('restart', reset)
    parameter:number('pivot', 1, SIZE, 75, function () reset() end)
    parameter:number('attraction', 1, SIZE*4, SIZE)
    parameter:number('damping', 0, 1, 0.9)
    
    parameter:number('dt_ratio', 1, 10, 5)
end

function reset()
    for _,item in scene:ipairs() do
        item:reset()
    end
end

function update(dt)
    local n = 10
    local dtn = dt/n
    for i=1,n do
        constraints(dtn)
    end
    --rebase()
end

function draw()
    background()
    scene:draw()
end

function keypressed(key)
    if key == 'return' then
        reset()
    end
end

function constraints(dt)
    dt = dt * dt_ratio
    
    local nodes = scene.items
    local n = #nodes

    for i=1,n do
        nodes[i].force:set()
    end

    local a, b, v, direction, dist, speed
    for i=1,n-1 do
        a = nodes[i]

        for j=i+1,n do
            b = nodes[j]

            v = b.position - a.position
            
            dist = v:len()
            direction = v:normalize()

            speed = 0

            if a.childs[b] or b.childs[a] then
                if dist > pivot then
                    -- a.position:add(direction*.5)
                    -- b.position:sub(direction*.5)
                    speed = -attraction
                else
                    -- a.position:add(-direction*.5)
                    -- b.position:sub(-direction*.5)
                    speed = attraction
                end

            else
                if dist < pivot then
                    speed = attraction
                end
            end

            a.force:add(-speed*direction)
            b.force:add( speed*direction)
        end
    end

    for i=1,n do
        a = nodes[i]

        a.velocity:add(a.force:mul(dt))
        a.position:add(a.velocity:mul(dt))

        a.velocity:mul(math.pow(damping, dt))
    end
end

class 'ClassItem' : extends(UI)

function ClassItem:init(className, classRef)
    UI.init(self, classRef.__className or className)

    self.id = id('ClassItem')
    self.description = className
    self.label = className

    self.classRef = classRef

    self.basesRef = attributeof('__inheritsFrom', classRef) or Array()

    self.childs = Array()
    self.parents = Array()

    self:reset()
end

function ClassItem:reset()
    self.position = vec2(CX, CY) + vec2.randomAngle()
    self.force = vec2()
    self.velocity = vec2()
end

function ClassItem:draw()
    pushMatrix()

    local function align(position)
        return (position - vec2(CX, CY)):scale(vec2(.5, 1)) + vec2(CX, CY)
    end

    local w, h = textSize(self.description)

    local a = align(self.position)

    translate(
        round(a.x),
        round(a.y))

        for k,v in pairs(self.childs) do
        local base = scene:ui(k.label)
        if base then
            local b = align(base.position)

            local direction = b - a

            local start = vec2(0, 0) + direction * 0.15
            local to = direction *  0.85

            stroke(colors.red)
            strokeSize(1)
            line(-w/2, h/2, w/2, h/2)

            stroke(colors.gray)
            line(start.x, start.y, to.x, to.y)

            stroke(colors.green)
            strokeSize(5)
            point(to.x, to.y)
        end
    end

    textColor(colors.cyan)

    textMode(CENTER)
    text(self.description, 0, 0)

    popMatrix()
end

-- function getArea()
--     local xmin, ymin, xmax, ymax = math.maxinteger, math.maxinteger, -math.maxinteger, -math.maxinteger

--     for _,item in scene:ipairs() do
--         local position = item.position
--         xmin = min(xmin, position.x)
--         ymin = min(ymin, position.y)
--         xmax = max(xmax, position.x)
--         ymax = max(ymax, position.y)
--     end

--     local w = xmax - xmin
--     local h = ymax - ymin

--     return xmin, ymin, w, h
-- end

-- function rebase()
--     if true then return end
--     local x, y, w, h = getArea()

--     local wb = W 
--     local hb = H

--     local rx = 0.9 * wb/w
--     local ry = 0.9 * hb/h

--     for _,item in scene:ipairs() do
--         item.position:set(
--             (item.position.x - x) * rx + 0.05 * wb,
--             (item.position.y - y) * ry + 0.05 * hb)

--         item.velocity.x = item.velocity.x * rx
--         item.velocity.y = item.velocity.y * ry
--     end
-- end
