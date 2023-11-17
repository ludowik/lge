Graphics3d = class()

function Graphics3d.setup()
    push2globals(Graphics3d)
end

function Graphics2d.box(x, y, z, w, h, d)
    x = x or 0
    y = y or 0
    z = z or 0
    w = w or 1
    h = h or w
    d = d or w

    local model = Mesh(Model.box(w, h, d))
    model:draw(x, y, z)
end

Model = class()

function Model:init()
end

function Model.box(w, h, d)
    return {
        {0, 0, 0},
        {0, 0, 0},
        {0, 0, 0},
        {0, 0, 0},
    }
end
