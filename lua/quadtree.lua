Quadtree = class()

Quadtree.FIXED = 'fixed'
Quadtree.DYNAMIC = 'dynamic'

function Quadtree:init(mode, checkNode, areaSize)
    self.mode = mode
    self.checkNode = checkNode
    self.maxObject = 3
    self.areaSize = areaSize

    self.level = 0
    self.addNode = 0
end

function Quadtree:update(items)
    local minx, miny =  math.maxinteger,  math.maxinteger
    local maxx, maxy = -math.maxinteger, -math.maxinteger

    for i,v in items:ipairs() do        
        minx = min(minx, v.position.x)
        miny = min(miny, v.position.y)

        maxx = max(maxx, v.position.x + v.size.x)
        maxy = max(maxy, v.position.y + v.size.y)
    end

    local size = max(maxx - minx, maxy - miny)
    
    self.node = QuadtreeNode(self, minx, miny, size, size)

    self.level = 0
    self.addNode = 0

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
    self.root.addNode = self.root.addNode + 1

    if not self.root.checkNode(self, node) then return end

    if self.items then
        self.items:add(node)

        if self.root.mode == Quadtree.DYNAMIC then
            if #self.items > self.root.maxObject then
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

            self.root.level = self.root.level + 1
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

function QuadtreeNode:draw()
    if self.items then
        if #self.items > 0 then
            Rect.draw(self)
        end
        
    elseif self.sw then
        self.sw:draw()
        self.se:draw()
        self.nw:draw()
        self.ne:draw()
    end
end
