local function positionAndSize(...)
    local args = {...}
    local x, y, z, w, h, d = 0, 0, 0, 1, 1, 1

    if #args == 1 then
        w = ...
        h, d = w, w

    elseif #args == 3 then
        w, h, d = ...

    elseif #args == 5 then
        x, y, z, w = ...
        h, d = w, w

    elseif #args == 6 then
        x, y, z, w, h, d = ...
    end

    return x, y, z, w, h, d
end

function Graphics2d.box(...)
    local x, y, z, w, h, d = positionAndSize(...)

    if not Graphics2d.boxMesh then
        local x, y, z, w, h, d = 0, 0, 0, 0.5, 0.5, 0.5
        local format = {
            {"VertexPosition", "float", 3}, -- The x,y position of each vertex.
            {"VertexTexCoord", "float", 2}, -- The u,v texture coordinates of each vertex.
            {"VertexColor", "byte", 4} -- The r,g,b,a color of each vertex.
        }

        Graphics2d.boxMesh = Model.box(x, y, z, w, h, d)
    end

    Graphics2d.boxMesh:draw(x, y, z, w, h, d)
end
