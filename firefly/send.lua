local send = {}

function send:to4bit(num)
    r = ""
    bs = bit:_rshift(bit:_and(0xff000000, num), 24)
    r = r .. string.char(bs);
    bs = bit:_rshift(bit:_and(0xff0000, num), 16)
    r = r .. string.char(bs);
    bs = bit:_rshift(bit:_and(0xff00, num), 8)
    r = r .. string.char(bs);
    bs = bit:_and(0xff, num)
    r = r .. string.char(bs);
    return r
end

function send:bit2int(str)
    bs = bit:_and(string.byte(str, 4), 0xFF)
    bs = bit:_or(bs, bit:_and(bit:_lshift(string.byte(str, 3), 8), 0xFF00))
    bs = bit:_or(bs, bit:_and(bit:_lshift(string.byte(str, 2), 16), 0xFF0000))
    bs = bit:_or(bs, bit:_and(bit:_lshift(string.byte(str, 1), 24), 0xFF000000))
    return bs
end


function send:sendData(text, id, config)
    HEAD_0 = string.char(config.HEAD_0)
    HEAD_1 = string.char(config.HEAD_1)
    HEAD_2 = string.char(config.HEAD_2)
    HEAD_3 = string.char(config.HEAD_3)
    ProtoVersion = string.char(config.ProtoVersion)
    ServerVersion = self:to4bit(config.ServerVersion)
    length = self:to4bit(string.len(text) + 4)
    id = self:to4bit(id)
    str = HEAD_0 .. HEAD_1 .. HEAD_2 .. HEAD_3 .. ProtoVersion .. ServerVersion .. length .. id .. text
    return str
end

return send