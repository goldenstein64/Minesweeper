local Connection = {}
Connection.__index = Connection

Connection.Mock = {
	Connected = false,
	Listeners = {},
	Disconnect = function() end
}

function Connection.new(listeners)
	local self = {
		Connected = true,
		Listeners = listeners
	}
	
	return setmetatable(self, Connection)
end

function Connection:Disconnect()
	self.Connected = false
	self.Listeners[self] = nil
end

return Connection