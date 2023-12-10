Model = class()

function Model:init()
end

function Model.box(w, h, d)
    w = w or 0.5
    h = h or 0.5
    d = d or 0.5

    local data = {
        vertices = Array(),
        texCoords = Array(),
        colors = Array(),        
    }

    function addFace(f, clr)
        data.texCoords:addArray{
            {0, 0},
            {1, 0},
            {1, 1},
            {0, 0},
            {1, 1},
            {0, 1},
        }

        -- f[1] = Array.addArray(Array.clone(f[1]), {0,0})
        -- f[2] = Array.addArray(Array.clone(f[2]), {1,0})
        -- f[3] = Array.addArray(Array.clone(f[3]), {1,1})
        -- f[4] = f[1]
        -- f[5] = f[3]
        -- f[6] = Array.addArray(Array.clone(f[6]), {0,1})
        
        for _,v in ipairs(f) do
            data.vertices:add(v)
            data.colors:add({clr:rgba()})
        end
    end
    
    local f1 = {-w, -h,  d}
    local f2 = { w, -h,  d}
    local f3 = { w,  h,  d}
    local f4 = {-w,  h,  d}
    
    local b1 = { w, -h, -d}
    local b2 = {-w, -h, -d}
    local b3 = {-w,  h, -d}
    local b4 = { w,  h, -d}
    
    addFace({f1, f2, f3, f1, f3, f4}, colors.blue) -- front
    addFace({b1, b2, b3, b1, b3, b4}, colors.green) -- back
    addFace({b2, f1, f4, b2, f4, b3}, colors.red) -- left
    addFace({f2, b1, b4, f2, b4, f3}, colors.orange) -- right
    addFace({f4, f3, b4, f4, b4, b3}, colors.white) -- up
    addFace({f2, f1, b2, f2, b2, b1}, colors.yellow) -- bottom

    return data
end
