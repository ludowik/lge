Graphics3d = class()

function Graphics3d.setup()
    push2globals(Graphics3d)
end

local boxModel
function Graphics2d.box(x, y, z, w, h, d)
    boxModel = boxModel or Model.box()

    x = x or 0
    y = y or 0
    z = z or 0

    w = w or 1
    h = h or w
    d = d or w

    local m = Mesh(boxModel)
    m:draw(x, y, z, w, h, d)
end

Model = class()

function Model:init()
end

function Model.box(w, h, d)
    w = w or 1
    h = h or 1
    d = d or 1

    local vertices = Array()

    function addFace(f, clr)
        for _,v in ipairs(f) do
            Array.concat(v, {clr:rgba()})
        end
        vertices:concat(f)
    end

    -- front
    addFace({
        { w, -h, -d},
        {-w, -h, -d},
        {-w,  h, -d},
        { w, -h, -d},
        {-w,  h, -d},
        { w,  h, -d},
    }, colors.blue)

    -- back
    addFace({
        {-w, -h,  d},
        { w, -h,  d},
        { w,  h,  d},
        {-w, -h,  d},
        { w,  h,  d},
        {-w,  h,  d},
    }, colors.green)

    -- left
    addFace({
        {-w, -h, -d},
        {-w, -h,  d},
        {-w,  h,  d},
        {-w, -h, -d},
        {-w,  h,  d},
        {-w,  h, -d},
    }, colors.red)

    -- right
    addFace({
        { w, -h,  d},
        { w, -h, -d},
        { w,  h, -d},
        { w, -h,  d},
        { w,  h, -d},
        { w,  h,  d},
    }, colors.orange)
        
    -- up
    addFace({
        {-w,  h,  d},
        { w,  h,  d},
        { w,  h, -d},
        {-w,  h,  d},
        { w,  h, -d},
        {-w,  h, -d},
    }, colors.white)

    -- bottom
    addFace({
        { w,  -h,  d},
        {-w,  -h,  d},
        {-w,  -h, -d},
        { w,  -h,  d},
        {-w,  -h, -d},
        { w,  -h, -d},
    }, colors.yellow)

    return vertices
end
