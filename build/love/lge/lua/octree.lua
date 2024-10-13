Octree = class()

Octree.FIXED = 'fixed'
Octree.DYNAMIC = 'dynamic'

function Octree:init(mode, checkNode, areaSize)
    self.mode = mode
    self.checkNode = checkNode
    self.maxObject = 3
    self.areaSize = areaSize
end

function Octree:update(items)
    local minx, miny, minz =  math.maxinteger,  math.maxinteger,  math.maxinteger
    local maxx, maxy, maxz = -math.maxinteger, -math.maxinteger, -math.maxinteger

    for i,v in items:ipairs() do
        minx = min(minx, v.position.x - v.size.x/2)
        miny = min(miny, v.position.y - v.size.y/2)
        minz = min(minz, v.position.z - v.size.z/2)

        maxx = max(maxx, v.position.x + v.size.x/2)
        maxy = max(maxy, v.position.y + v.size.y/2)
        maxz = max(maxz, v.position.z + v.size.z/2)
    end

    local size = max(maxx - minx, maxy - miny, maxz - minz)
    self.node = OctreeNode(self, minx, miny, minz, size, size, size)

    for i,v in items:ipairs() do
        self.node:add(v)
    end
end

function Octree:cross(f)
    return self.node:cross(f)
end

function Octree:draw()
    return self.node:draw()
end

class 'OctreeNode' : extends(Box)

function OctreeNode:init(root, x, y, z, w, h, d)
    Box.init(self, vec3(x, y, z), vec3(w, h, d))
    self.root = root

    if root.mode == Octree.FIXED then
        if w <= root.areaSize then
            self.items = Array()
        end

    else -- if root.mode == Octree.DYNAMIC then
        self.items = Array()
    end
end

function OctreeNode:add(node)
    if not self.root.checkNode(self, node) then return end

    if self.items then
        self.items:add(node)

        if self.root.mode == Octree.DYNAMIC then
            if #self.items > self.root.maxObject then
                local items = self.items
                self.items = nil
                for i,v in ipairs(items) do
                    self:add(v)
                end
            end
        end

    else
        if not self.swf then
            local x = self.position.x
            local y = self.position.y
            local z = self.position.z
            
            local w = self.size.x / 2
            local h = self.size.y / 2
            local d = self.size.z / 2

            self.swf = OctreeNode(self.root, x  , y  , z, w, h, d)
            self.sef = OctreeNode(self.root, x+w, y  , z, w, h, d)
            self.nwf = OctreeNode(self.root, x  , y+h, z, w, h, d)
            self.nef = OctreeNode(self.root, x+w, y+h, z, w, h, d)

            self.swb = OctreeNode(self.root, x  , y  , z+d, w, h, d)
            self.seb = OctreeNode(self.root, x+w, y  , z+d, w, h, d)
            self.nwb = OctreeNode(self.root, x  , y+h, z+d, w, h, d)
            self.neb = OctreeNode(self.root, x+w, y+h, z+d, w, h, d)
        end

        self.swf:add(node)
        self.sef:add(node)
        self.nwf:add(node)
        self.nef:add(node)

        self.swb:add(node)
        self.seb:add(node)
        self.nwb:add(node)
        self.neb:add(node)
    end
end

function OctreeNode:cross(f)
    self.comparaison = 0

    if self.items then
        if #self.items > 0 then
            self.items:cross(f)
            self.comparaison = self.items.comparaison
        end
        
    elseif self.swf then
        self.swf:cross(f)
        self.sef:cross(f)
        self.nwf:cross(f)
        self.nef:cross(f)

        self.swb:cross(f)
        self.seb:cross(f)
        self.nwb:cross(f)
        self.neb:cross(f)

        self.comparaison = self.swf.comparaison +
            self.sef.comparaison +
            self.nwf.comparaison +
            self.nef.comparaison +
            self.swb.comparaison +
            self.seb.comparaison +
            self.nwb.comparaison +
            self.neb.comparaison
    end
    return self
end

function OctreeNode:draw(level)
    level = level or 1

    if self.items then
        if #self.items > 0 then
            strokeSize(0.5)
            Box.drawBorder(self)
        end
        
    elseif self.swf then
        self.swf:draw(level)
        self.sef:draw(level)
        self.nwf:draw(level)
        self.nef:draw(level)
        self.swb:draw(level)
        self.seb:draw(level)
        self.nwb:draw(level)
        self.neb:draw(level)
    end
end
