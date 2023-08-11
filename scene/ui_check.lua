UICheck = class() : extends(UI)

function UICheck:init(label, object)
    UI.init(self, label)
    self.value = Bind(object)
end

function UICheck:click()
    self.value:toggle()
end
