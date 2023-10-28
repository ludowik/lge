function setup()
    parameter:boolean('fixed / dynamic', 'fixed', false)
    parameter:integer('areaSize', 2, W, W/100)

    comparaison = 0
    parameter:watch('comparaison')

    autotest()
end

function autotest()
    node = Node()
    for i=1,150 do
        local object = Rect.random(W, H, 15)
        node:add(object)

        object.update = function (object, dt)
            object.position:add(vec2.randomAngle())
        end
    end
end

function update(dt)
    node:update(dt)
end

function draw()
    background()
    
    local quadtree = Quadtree(fixed and Quadtree.FIXED or Quadtree.DYNAMIC, Rect.intersect)
    
    quadtree:update(node)
    quadtree:cross(function (v1, v2)
        if v1:intersect(v2) then
            v1.clr = colors.red
            v2.clr = colors.red
        end
    end)

    comparaison = quadtree.node.comparaison

    quadtree:draw()
    node:draw()
end

Quadtree = class()

Quadtree.FIXED = 'fixed'
Quadtree.DYNAMIC = 'dynamic'

function Quadtree:init(mode, checkNode)
    self.mode = mode
    self.checkNode = checkNode
end

function Quadtree:update(items)
    local minx, miny = math.maxinteger, math.maxinteger
    local maxx, maxy = -math.maxinteger, -math.maxinteger

    for i,v in items:ipairs() do
        minx = min(minx, v.position.x)
        miny = min(miny, v.position.y)
        maxx = max(maxx, v.position.x + v.size.x)
        maxy = max(maxy, v.position.y + v.size.y)
    end

    self.areaSize = areaSize

    local left = min(minx, miny)
    local size = max(maxx - minx, maxy - miny)
    self.node = QuadtreeNode(self, x, x, size, size)

    for i,v in items:ipairs() do
        self.node:add(v)
    end
end

function Quadtree:cross(f)
    return self.node:cross(f)
end

function Quadtree:draw()
    return self.node:draw()
end

class 'QuadtreeNode' : extends(Rect)

function QuadtreeNode:init(root, x, y, w, h)
    Rect.init(self, x, y, w, h)
    self.root = root

    if root.mode == Quadtree.FIXED then
        if w <= root.areaSize then
            self.items = Array()
        end

    else -- if root.mode == Quadtree.DYNAMIC then
        self.items = Array()
    end
end

function QuadtreeNode:add(node)
    if not self.root.checkNode(self, node) then return end

    if self.items then
        self.items:add(node)

        if self.root.mode == Quadtree.DYNAMIC then
            if #self.items > self.root.areaSize then
                local items = self.items
                self.items = nil
                for i,v in ipairs(items) do
                    self:add(v)
                end
            end
        end

    else
        if not self.sw then
            local x = self.position.x
            local y = self.position.y
            local w = self.size.x / 2
            local h = self.size.y / 2
            self.sw = QuadtreeNode(self.root, x  , y  , w, h)
            self.se = QuadtreeNode(self.root, x+w, y  , w, h)
            self.nw = QuadtreeNode(self.root, x  , y+h, w, h)
            self.ne = QuadtreeNode(self.root, x+w, y+h, w, h)
        end

        self.sw:add(node)
        self.se:add(node)
        self.nw:add(node)
        self.ne:add(node)
    end
end

function QuadtreeNode:cross(f)
    self.comparaison = 0

    if self.items then
        if #self.items > 0 then
            self.items:cross(f)
            self.comparaison = self.items.comparaison
        end
        
    elseif self.sw then
        self.sw:cross(f)
        self.se:cross(f)
        self.nw:cross(f)
        self.ne:cross(f)
        self.comparaison = self.sw.comparaison + self.se.comparaison + self.nw.comparaison + self.ne.comparaison
    end
    return self
end

function QuadtreeNode:draw(level)
    level = level or 1

    if self.items then
        if #self.items > 0 then
            strokeSize(0.5)
            Rect.draw(self)
        end
        
    elseif self.sw then
        self.sw:draw(level)
        self.se:draw(level)
        self.nw:draw(level)
        self.ne:draw(level)
    end
end