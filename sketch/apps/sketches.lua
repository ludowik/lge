function setup()
    scene = Scene()
    navigate(getSetting('category'))

    uiFontSize = DEFAULT_FONT_SIZE
    menu()
end

function menu()
    parameter:integer('font size', 'uiFontSize', 18, 42, uiFontSize, function ()
        DEFAULT_FONT_SIZE = uiFontSize
        setSetting('DEFAULT_FONT_SIZE', uiFontSize)
        UI.styles.fontSize = uiFontSize
        navigate(getSetting('category'))
        
        env.sketch:initMenu()
        menu()
    end)
end

function navigate(category)
    setSetting('category', category)
    
    scene:clear()

    if category then
        local link = UIButton(category, function (self) navigate() end)
        link:attrib{
            styles = {
                fillColor = colors.blue,
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
                        fillColor = colors.blue,
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
            end)

        scene:add(link)
        
        link:attrib{
            styles = {
                fillColor = colors.transparent,
                textColor = colors.white,
                fontSize = uiFontSize
            }
        }
    end)
    scene.layoutMode = 'center'
end

local dy = 0

function draw()
    background(51)
    
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
