Graphics3d = class()

function Graphics3d.setup()
    push2globals(Graphics3d)

    Graphics3d.shader = Shader('shader', 'graphics/shaders')
    Graphics3d.meshes = {}
end

function Graphics3d.getMesh(name, f)
    if not Graphics3d.meshes[name] then
        Graphics3d.meshes[name] = Graphics3d.meshes[name] or Mesh(f())
        Graphics3d.meshes[name].shader = Graphics3d.shader
    end
    return Graphics3d.meshes[name]
end

function Graphics3d.params(x, y, z, w, h, d)
    if not w then
        w = x or 1
        x, y, z = 0, 0, 0
    end
    
    h = h or w
    d = d or w

    return x, y, z, w, h, d
end

function Graphics3d.plane(x, y, z, w, h, d)
    x, y, z, w, h, d = Graphics3d.params(x, y, z, w, h, d)
    
    local mesh = Graphics3d.getMesh('plane', Model.plane)
    mesh.shader:update()

    mesh.uniforms.param1 = param1
    mesh.uniforms.useNormal = 0
    mesh.uniforms.useMaterial = 0

    mesh:draw(x, y, z, w, h, d)
end

function Graphics3d.ground(x, y, z, w, h, d)
    x, y, z, w, h, d = Graphics3d.params(x, y, z, w, h, d)
    
    local mesh = Graphics3d.getMesh('ground', Model.ground)
    mesh.shader:update()

    mesh.uniforms.useNormal = 0
    mesh.uniforms.useMaterial = 0

    mesh:draw(x, y, z, w, h, d)
end

function Graphics3d.box(x, y, z, w, h, d)
    x, y, z, w, h, d = Graphics3d.params(x, y, z, w, h, d)

    local mesh = Graphics3d.getMesh('plane', Model.box)
    mesh.shader:update()

    mesh.uniforms.border = 0
    mesh.clr = fill()

    mesh:draw(x, y, z, w, h, d)
end

function Graphics3d.boxBorder(x, y, z, w, h, d)
    x, y, z, w, h, d = Graphics3d.params(x, y, z, w, h, d)

    local mesh = Graphics3d.getMesh('plane', Model.box)    
    mesh.shader:update()

    mesh.colors = nil
    mesh.uniforms.border = 1
    mesh.clr = stroke()

    mesh:draw(x, y, z, w, h, d)
end

function Graphics3d.sphere(x, y, z, w, h, d)
    x, y, z, w, h, d = Graphics3d.params(x, y, z, w, h, d)

    local mesh = Graphics3d.getMesh('plane', Model.sphere)
    mesh.shader:update()

    mesh.colors.uniforms.border = 0
    mesh.clr = fill()

    mesh:draw(x, y, z, w, h, d)
end

function Graphics3d.teapot(x, y, z, w, h, d)
    x, y, z, w, h, d = Graphics3d.params(x, y, z, w, h, d)

    local mesh = Graphics3d.getMesh('plane', function () return Model.load('teapot.obj') end)
    mesh.shader:update()    

    mesh:draw(x, y, z, w, h, d)
end
