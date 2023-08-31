function setup()
    scene = Scene()
    navigate(getSettings('category'))
end

function navigate(category)
    setSettings('category', category)
    
    scene:clear()

    if category then
        scene:add(UIButton('..', function (self) navigate() end))
    end

    local categories = {}
    environnementsList:foreach(function (env)
        if env.__category ~= category then
            if category == nil and env.__category and categories[env.__category] == nil then
                categories[env.__category] = UIButton(env.__category,
                    function (self)
                        navigate(env.__category)
                    end)
                scene:add(categories[env.__category])
            end
            return
        end

        scene:add(UIButton(env.__category and (env.__category..' : '..env.__className) or env.__className,
            function (self)
                processManager:setSketch(env.__className)
            end):attrib{
                styles = {
                    fillColor = colors.transparent,
                },
                draw = function (self)
                    UIButton.draw(self)
                    local process = processManager:getSketch(env.__className)
                    if process and env.__className ~= 'sketches' then
                        love.graphics.draw(process.canvas,
                            self.position.x + self.size.x,
                            self.position.y, 0,
                            self.size.y / H,
                            self.size.y / H)
                    end
                end
            })
    end)
    scene.layoutMode = 'center'
end

local dy = 0

function draw()
    background()
    
    scene:layout(0, dy + H/2 - scene.size.y/2)
    scene:draw()
end

function mousemoved(mouse)
    dy = dy + mouse.deltaPos.y
end
