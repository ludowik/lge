Graphics3d = class()

function Graphics3d.setup()
    push2globals(Graphics3d)
end

local boxModel, boxMesh
function Graphics2d.box(x, y, z, w, h, d)
    boxModel = boxModel or Model.box()
    boxMesh = boxMesh or Mesh(boxModel)

    x = x or 0
    y = y or 0
    z = z or 0

    w = w or 1
    h = h or w
    d = d or w

    boxMesh:draw(x, y, z, w, h, d)
end

Model = class()

function Model:init()
end

function Model.box(w, h, d)
    w = w or 0.5
    h = h or 0.5
    d = d or 0.5

    local vertices = Array()

    function addFace(f, clr)
        for _,v in ipairs(f) do
            v = Array.addArray(Array.clone(v), {clr:rgba()})
            vertices:add(v)
        end
    end

    local b1 = { w, -h, -d}
    local b2 = {-w, -h, -d}
    local b3 = {-w,  h, -d}
    local b4 = { w,  h, -d}

    local f1 = {-w, -h,  d}
    local f2 = { w, -h,  d}
    local f3 = { w,  h,  d}
    local f4 = {-w,  h,  d}
    
    addFace({f1, f2, f3, f1, f3, f4}, colors.blue) -- front
    addFace({b1, b2, b3, b1, b3, b4}, colors.green) -- back
    addFace({b2, f1, f4, b2, f4, b3}, colors.red) -- left
    addFace({f2, b1, b4, f2, b4, f3}, colors.orange) -- right
    addFace({f4, f3, b4, f4, b4, b3}, colors.white) -- up
    addFace({f2, f1, b2, f2, b2, b1}, colors.yellow) -- bottom

    return vertices
end
