Graphics3d = class()

function Graphics3d.setup()
    push2globals(Graphics3d)

    Graphics3d.shader = Shader('shader', 'engine/3d')
end

local boxModel, boxMesh
function Graphics3d.box(x, y, z, w, h, d)
    boxModel = boxModel or Model.box()
    boxMesh = boxMesh or Mesh(boxModel)

    x = x or 0
    y = y or 0
    z = z or 0

    w = w or 1
    h = h or w
    d = d or w

    Graphics3d.shader:update()
    
    boxMesh.shader = Graphics3d.shader
    boxMesh:draw(x, y, z, w, h, d)
end
