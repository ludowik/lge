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
            object.clr = colors.white
        end
    end
end

function update(dt)
    node:update(dt)
end

function draw()
    background()
    
    local quadtree = Quadtree(fixed and Quadtree.FIXED or Quadtree.DYNAMIC, Rect.intersect, areaSize)
    
    node:update()
    quadtree:update(node)

    quadtree:cross(function (v1, v2)
        if v1:intersect(v2) then
            v1.clr = colors.red
            v2.clr = colors.red
        end
    end)

    quadtree:draw()
    node:draw()

    comparaison = quadtree.node.comparaison
end

