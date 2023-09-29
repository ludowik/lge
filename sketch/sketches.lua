function _G.openSketches()
    local process = processManager:current()
    if process.__className ~= 'sketches' then            
        processManager:setSketch('Sketches')
        self:setStateForAllGroups('close', true)
    else
        process.env.navigate()
    end
end

function setup()
    scene = Scene()
    navigate(getSettings('category'))
end

function navigate(category)
    setSettings('category', category)
    
    scene:clear()

    if category then
        local link = UIButton(category, function (self) navigate() end)
        link:attrib{
            styles = {
                fillColor = colors.gray,
                fontSize = 32
            }
        }

        scene:add(link)
    end

    local categories = {}
    environnementsList:foreach(function (env)
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
                        fontSize = 32
                    }
                }

                scene:add(categories[env.__category])
            end
            return
        end

        local link = UIButton(env.__className:gsub('_', ' '),
            function (self)
                processManager:setSketch(env.__className)
            end)

        scene:add(link)
        
        link:attrib{
            styles = {
                fillColor = colors.transparent,
                fontSize = 32
            }
        }
    end)
    scene.layoutMode = 'center'
end

local dy = 0

function draw()
    background()
    
    scene:layout()
    scene:layout(0, dy + H/2 - scene.size.y/2)
    scene:draw()
end

function mousepressed(mouse)
    if not scene:mousepressed(mouse) then
        navigate()
    end
end

function mousemoved(mouse)
    --dy = dy + mouse.deltaPos.y
end
