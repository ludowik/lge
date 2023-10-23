function setup()
    parameter:number('AREA_SIZE', 100, 20000, H)
    parameter:number('QUAD_SIZE', 1, 1000, 50)
    
    autotest()
end

function autotest()
    array = Array()
    for i=1,100 do
        array:add(Rect.random(W, H, 50))
    end
end

function _draw()
    background()
    
    q = Quadtree(AREA_SIZE, QUAD_SIZE)

    for i=1,#array do
        q:add(array[i])
    end
    
    q:draw()
end
