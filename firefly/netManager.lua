local socket = require("socket")

local manager = {}

local client = {
    sendQueue = {},
    conn = nil,
    config = {},
}

-- 关闭连接操作
function client:close()
    if self.conn ~= nil then
        self.conn:close()
        self.conn = nil
    end
end

-- 获取tcp数据包
function client:_recv(pattern)
    if self.conn ~= nil then
        local rec = self.conn:receive(pattern)
        return rec
    end
    return nil
end

-- 分析头部
function client:_getHeader()
    local header = {
        HEAD_0 = 0,
        HEAD_1 = 0,
        HEAD_2 = 0,
        HEAD_3 = 0,
        ProtoVersion = 0,
        ServerVersion = 0,
        Length = 0,
        Event = 0,
    }
    str = self:_recv(17)
    if str == nil then
        return nil
    end
    header.HEAD_0 = string.byte(str, 1)
    header.HEAD_1 = string.byte(str, 2)
    header.HEAD_2 = string.byte(str, 3)
    header.HEAD_3 = string.byte(str, 4)
    header.ProtoVersion = string.byte(str, 5)
    header.ServerVersion = send:bit2int(string.sub(str, 6, 9))
    header.Length = send:bit2int(string.sub(str, 10, 13)) - 4
    header.Event = send:bit2int(string.sub(str, 14, 17))
    return header
end

-- 获取服务器的数据
function client:recv()
    header = self:_getHeader()
    if header == nil then
        return nil
    end
    length = header.Length
    return self:_recv(length)
end

-- 发送tcp数据包
function client:send(msg, event)
    if self.conn == nil then
        return nil
    end
    local pack = send:sendData(msg, event, self.config)
    return self.conn:send(pack)
end

-- manager 获取链接操作
function manager:getConnect(host, port, config)
    local tcp = assert(socket.tcp())
    -- tcp:settimeout(0)
    local stat = tcp:connect(host, port)
    client.conn = tcp
    client.config = config
    return client
end

-- manager 查看是否链接成功
function manager:checkConnect()
    if client.conn then
        return 1
    else
        return 0
    end
end


return manager