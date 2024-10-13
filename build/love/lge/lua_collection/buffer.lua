local __max = math.max

-- TODO : reconnecter buffer ffi

if true then
    class 'Buffer' : extends(table)

    function Buffer.setup()
        Buffer.initializer = {
            vec2 = vec2,
            vec3 = vec3,
            vec4 = vec4,
            color = Color,
            float = function () return 0 end
        }
    end

    function Buffer:init(dataType, buf, inline, ...)
        self.dataType = dataType
        if buf then
            if inline then buf = {buf, inline, ...} end
            for i,v in ipairs(buf) do
                self[i] = v
            end
        end
    end

    function Buffer:alloc(n)
        for i=1,n do
            self[i] = self[i] or Buffer.initializer[self.dataType]()
        end
        return self
    end

    function Buffer:resize(n)
        for i=1,n do
            self[i] = self[i] or Buffer.initializer[self.dataType]()
        end
        return self
    end

    return 
end

ffi = require 'ffi'

ffi.cdef [[
    void* malloc(size_t num);
    void* realloc(void *ptr, size_t num);
    
    void* memset(void *ptr, int value, size_t num);
    
    void* memmove(void *destination, const void *source, size_t num);
    void* memcpy(void *destination, const void *source, size_t num);

    void free(void *ptr);
]]

__buffer = {}

function __buffer.__init(buffer, buffer_class, data, ...)
    buffer.ct = buffer_class.ct

    buffer.id = id('buffer')

    buffer.available = 4

    buffer.sizeof_ctype = buffer_class.sizeof_ctype
    buffer.size = buffer_class.sizeof_ctype * buffer.available

    buffer.idBuffer = 0

    buffer.data = ffi.cast(buffer_class.ctype, ffi.C.malloc(buffer.size))

    ffi.C.memset(buffer.data, 0, buffer.size)

    buffer.n = 0
    buffer.version = 0

    if data then
        buffer:set(data, ...)
    end

    return buffer
end

function __buffer:set(data, ...)
    if data then
        if type(data) == 'number' or type(data) == 'cdata' then
            data = {data, ...}
        end

        for i,v in ipairs(data) do
            self[i] = v
        end
    end
end

function __buffer.clone(buffer)
    local buf2 = Buffer(ffi.string(buffer.ct))
    buf2:resize(buffer.n)
    ffi.C.memcpy(buf2:addr(), buffer:addr(), buffer.sizeof_ctype * buffer.n)
    buf2.n = buffer.n
    return buf2
end

function __buffer.__tostring(buffer)
    return "buffer("..ffi.string(buffer.ct)..", "..buffer.n..", "..buffer.available..")"
end

function __buffer.__len(buffer)
    return buffer.n
end

function __buffer.__gc(buffer)
    ffi.C.free(buffer.data)
end

function __buffer.alloc(buffer, n)
    __buffer.resize(buffer, n)

    buffer.n = __max(buffer.n, n)
    buffer.version = buffer.version + 1
end

function __buffer.resize(buffer, n)
    if buffer.available < n then
        local previousAvailable = buffer.available
        local previousSize = buffer.size

        buffer.available = n
        buffer.size = buffer.available * buffer.sizeof_ctype

        buffer.data = ffi.cast(ffi.typeof(buffer.data),
            ffi.C.realloc(
                buffer.data,
                buffer.size))

        ffi.C.memset(buffer.data+previousAvailable, 0, buffer.size-previousSize)

        assert(buffer.data ~= ffi.NULL)
    end
    return buffer
end

function __buffer.__newindex(buffer, key, value)
    if type(key) == 'number' then
        if key <= 0 then return end

        if buffer.available < key then
            buffer:resize(max(buffer.available * 2, key))
        end

        buffer.data[key-1] = value

        buffer.n = __max(buffer.n, key)
        buffer.version = buffer.version + 1

    else
        rawset(buffer, key, value)
    end
end

function __buffer.__index(buffer, key)
    if type(key) == 'number' then
        return buffer.data[key-1]

    else
        return rawget(__buffer, key)
    end
end

function __buffer.insert(buffer, value)
    buffer[buffer.n+1] = value
end
__buffer.add = __buffer.insert

function __buffer.addItems(buffer, buf2)
    local n = buffer.n + buf2.n

    if buffer.available < n then
        buffer:resize(max(buffer.available * 2, n))
    end

    ffi.C.memcpy(buffer:addr(buffer.n), buf2:addr(0), buf2.sizeof_ctype * buf2.n)

    buffer.n = n
    buffer.version = buffer.version +1
end

function __buffer.remove(buffer, i)
    if i > 0 and i <= buffer.n then
        if i < buffer.n then
            ffi.C.memmove(buffer:addr(i-1), buffer:addr(i), buffer.sizeof_ctype * (buffer.n-i))
        end
        buffer.n = buffer.n - 1
        buffer.version = buffer.version +1
    end
end

function __buffer.reset(buffer)
    buffer.n = 0
    buffer.version = buffer.version +1
end

function __buffer.sizeof(buffer)
    return buffer.sizeof_ctype * buffer.n
end

function __buffer.addr(buffer, i)
    return buffer.data + (i or 0)
end

function __buffer.tobytes(buffer)
    return buffer.data
end

function __buffer.__ipairs(buffer)
    local i = 0
    local f = function ()
        if i < buffer.n then
            i = i + 1
            return i, buffer[i]
        end
    end
    return f, v, nil
end

function __buffer.cast(buffer, ct)
    local buffer2 = Buffer(ct)
    buffer2.data = ffi.cast(ffi.typeof(buffer2.data), buffer.data)

    if buffer.sizeof_ctype > buffer2.sizeof_ctype then
        local coef = buffer.sizeof_ctype / buffer2.sizeof_ctype
        buffer2.available = buffer.available * coef
        buffer2.n = buffer.n * coef
    else
        local coef = buffer2.sizeof_ctype / buffer.sizeof_ctype
        buffer2.available = buffer.available / coef
        buffer2.n = buffer.n / coef
    end

    return buffer2
end

local buffer_classes = {}

function Buffer(ct, data, ...)
    ct = ct or 'float'

    local buffer_class = buffer_classes[ct]

    if buffer_classes[ct] == nil then

        buffer_class = {
            ct = ct,
            ctAsType = 'buffer_'..ct:gsub(' ', '_'),

            ctype = ffi.typeof(ct..'*'),
            sizeof_ctype = ffi.sizeof(ct),

            struct = [[
            typedef struct {ctAsType} {
                const char* ct;
                int id;
                int available;
                int sizeof_ctype;
                int size;
                int n;
                int version;
                unsigned int idBuffer;
                {ct}* data;
                } {ctAsType};
            ]]
        }

        buffer_class.typed_struct = buffer_class.struct:format({
                ct = buffer_class.ct,
                ctAsType = buffer_class.ctAsType
            })

        ffi.cdef(buffer_class.typed_struct)

        buffer_class.meta = ffi.metatype(buffer_class.ctAsType, __buffer)

        buffer_classes[ct] = buffer_class

    end

    return buffer_class.meta():__init(buffer_class, data, ...)
end
