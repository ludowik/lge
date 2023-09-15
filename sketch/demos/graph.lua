function setup()
    scene = Scene()

    local list = {}
    for k,v in pairs(_G) do
        if type(v) == 'table' and v.__className then
            local item = scene:ui(v.__className)
            if item == nil and not list[v] then
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

    parameter:action('restart', reset)
    parameter:number('pivot', 'pivot', 1, 1000, 75)
    parameter:number('attraction', 'attraction', 1, 2500, 1250)
    parameter:number('damping', 'damping', 0, 1, 0.9)
    
    parameter:number('dt_ratio', 'dt_ratio', 1, 10, 1)
end

function update(dt)
    local n = 2
    local dtn = dt/n
    for i=1,n do
        constraints(dtn)
    end
    rebase()
end

function draw()
    background()
    scene:draw()
end

function keyboard(key)
    if key == 'return' then
        reset()
    end
end

function reset()
    for _,item in scene:ipairs() do
        item:reset()
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

    local basesRef = self.basesRef

    self.level = 0
    while basesRef and #basesRef > 0 do
        self.level = self.level + 1
        basesRef = attributeof('__inheritsFrom', basesRef[1])
    end

    self:reset()

    self.fontName = DEFAULT_FONT_NAME
    self.fontSize = 12
end

function ClassItem:reset()
    self.position = vec2.random(1, 1) + vec2(W/2, H/2)
    self.force = vec2()
    self.velocity = vec2()
end

function ClassItem:draw()
    pushMatrix()

    translate(self.position.x, self.position.y)

    zLevel(-1)

    fontName(self.fontName)
    fontSize(self.fontSize)

    local w, h = textSize(self.description)

    for i,v in ipairs(self.basesRef) do
        local base = scene:ui(v.__className)
        if base then
            local a = self.position
            local b = base.position

            local direction = b - a

            local start = vec2(0, h/2)
            local to = direction - vec2(0, h/2)

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

    zLevel(0)

    textColor(colors.cyan)

    textMode(CENTER)
    text(self.description, 0, 0)

    popMatrix()
end

function constraints(dt)
    dt = dt * dt_ratio
    
    local nodes = scene.items
    local n = #nodes

    for i=1,n do
        nodes[i].force:set()
    end

    local a, b, v, direction, dist
    for i=1,n do
        a = nodes[i]

        for j=i+1,n do
            b = nodes[j]

            v = b.position - a.position
            dist = v:len()

            direction = v:normalize()

            if a.childs[b] or b.childs[a] then
                if dist > pivot then
                    local speed = (1 - 0.99^dist) * attraction

                    a.force:add( speed*direction)
                    b.force:add(-speed*direction)
                end

            end

            if dist < pivot then
                local speed = (0.99^dist) * attraction

                a.force:add(-speed*direction)
                b.force:add( speed*direction)
            end

        end
    end

    for i=1,n do
        a = nodes[i]

        a.velocity:add(a.force:mul(dt))
        a.position:add(a.velocity:mul(dt))

        a.velocity:mul(math.pow(damping, dt))
    end
end

function rebase()
    local xmin, ymin, xmax, ymax = math.maxinteger, math.maxinteger, -math.maxinteger, -math.maxinteger

    for _,item in scene:ipairs() do
        local position = item.position
        xmin = min(xmin, position.x)
        ymin = min(ymin, position.y)
        xmax = max(xmax, position.x)
        ymax = max(ymax, position.y)
    end

    local w = xmax - xmin
    local h = ymax - ymin

    local wb = W 
    local hb = H

    local rx = 0.9 * wb/w
    local ry = 0.9 * hb/h

    for _,item in scene:ipairs() do
        local position = item.position
        position.x = (position.x - xmin) * rx + 0.05 * wb
        position.y = (position.y - ymin) * ry + 0.05 * hb
    end
end
