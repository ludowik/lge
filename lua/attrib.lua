function attrib(self, attribs)
    for k,v in pairs(attribs) do
        self[k] = v
    end
    return self
end
