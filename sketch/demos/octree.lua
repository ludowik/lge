function setup()
    parameter:boolean('dynamic / fixed', 'dynamic', true)
    parameter:integer('areaSize', 5, W, W/8)

    comparaison = 0
    parameter:watch('comparaison')

    autotest()

    camera(H, H, H, CY, CY, CY)
end

function autotest()
    node = Node()
    for i=1,150 do
        local object = Box.random(W, H, W, 15)
        node:add(object)

        object.update = function (object, dt)
            object.position:add(vec3.randomAngle())
            object.clr = colors.white
        end
    end
end

function update(dt)
    node:update(dt)
end

function draw()
    background()

    perspective()
    
    local octree = Octree(dynamic and Octree.DYNAMIC or Octree.FIXED, Box.intersect, areaSize)
    
    node:update()
    octree:update(node)

    octree:cross(function (v1, v2)
        if v1:intersect(v2) then
            v1.clr = colors.red
            v2.clr = colors.red
        end
    end)

    octree:draw()
    node:draw()

    comparaison = octree.node.comparaison
end
