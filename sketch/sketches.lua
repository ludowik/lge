function _G.openSketches()
    local sketch = processManager:current()
    if sketch.__className ~= 'sketches' then            
        processManager:setSketch('Sketches')
        engine.parameter.visible = false
    else
        sketch.env.navigate()
    end
end

function setup()
    scene = Scene()
    navigate(getSetting('category'))

    uiFontSize = 24

    parameter:watch('version')
    parameter:integer('font size', 'uiFontSize', 12, 32, uiFontSize, function ()
        navigate(getSetting('category'))
    end)
end

function navigate(category)
    setSetting('category', category)
    
    scene:clear()

    if category then
        local link = UIButton(category, function (self) navigate() end)
        link:attrib{
            styles = {
                fillColor = colors.gray,
                fontSize = uiFontSize
            }
        }

        scene:add(link)
    end

    local categories = {}
    environmentsList:foreach(function (env)
        if env == _G.env then return end
        
        if env.__category ~= category then
            if category == nil and env.__category and categories[env.__category] == nil then
                categories[env.__category] = UIButton(env.__category,
                    function (self)
                        navigate(env.__category)
                    end)

                categories[env.__category]:attrib{
                    styles = {
                        fillColor = colors.gray,
                        fontSize = uiFontSize
                    }
                }

                scene:add(categories[env.__category])
            end
            return
        end

        local link = UIButton(env.__className,
            function (self)
                processManager:setSketch(env.__className)
                engine.parameter.visible = true
            end)

        scene:add(link)
        
        link:attrib{
            styles = {
                fillColor = colors.transparent,
                fontSize = uiFontSize
            }
        }
    end)
    scene.layoutMode = 'center'
end

local dy = 0

function draw()
    background()
    
    scene:layout()
    scene:layout(0, dy + CY - scene.size.y/2)
    
    scene:draw()
end

function mousereleased(mouse)
    if not scene:mousereleased(mouse) then
        navigate()
    end
end

function mousemoved(mouse)
    --dy = dy + mouse.deltaPos.y
end
