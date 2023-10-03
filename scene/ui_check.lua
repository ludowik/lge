UICheck = class() : extends(UI)

function UICheck:init(label, object)
    UI.init(self, label)
    if classnameof(object) == 'Bind' then
        self.value = object
    else
        self.value = Bind(object)
    end
end

function UICheck:click()
    self.value:toggle()
end
