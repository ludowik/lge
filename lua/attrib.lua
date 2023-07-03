function attrib(self, attribs)
    for k,v in pairs(attribs) do
        if self[k] and type(self[k]) == 'table' and type(v) == 'table' then
            attrib(self[k], v)
        else
            self[k] = v
        end
    end
    return self
end
