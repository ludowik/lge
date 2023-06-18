Index = class()
Index.index = 0

function Index:init()
    Index.index = Index.index + 1
    self.index = Index.index
end
