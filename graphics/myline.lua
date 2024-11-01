function myline(x1, y1, x2, y2)
    mylines{{x1, y1, x2, y2, stroke():rgba()}}
end

local mesh
function mylines(lines)
    mesh = mesh or Mesh(Model.line(0, 0, 1, 1))
    mesh.shader = Graphics3d.shaders.line

    local data = getResource('line', lines, function (lines)
        local data = Array()
        for _,line in ipairs(lines) do
            if type(line[5]) == 'number' then
                data:add{line[1], line[2], 0, line[3]-line[1], line[4]-line[2], 0, line[5], line[6], line[7], line[8]}

            elseif classnameof(line[5]) == 'Color' then
                data:add{line[1], line[2], 0, line[3]-line[1], line[4]-line[2], 0, line[5]:rgba()}

            else
                data:add{line[1], line[2], 0, line[3]-line[1], line[4]-line[2], 0, stroke():rgba()}
            end
        end
        return data
    end)

    mesh:drawInstanced(data)
end
