local Connection = require(script.Connection)

local Event = {}
Event.__index = Event

Event.Mock = {
	Listeners = {},
	Waiting = {},
	Fire = function() end,
	Connect = function()
		return Connection.Mock
	end,
	Wait = function() end
}

function Event.new()
	local self = {
		Listeners = {},
		Waiting = {}
	}
	
	return setmetatable(self, Event)
end

function Event:Fire(...)
	for _, fn in pairs(self.Listeners) do
		coroutine.wrap(fn)(...)
	end
	
	local oldWaiting = self.Waiting
	self.Waiting = {}
	for _, thread in ipairs(oldWaiting) do
		coroutine.resume(thread, ...)
	end
end

function Event:Connect(fn)
	local typeof_fn = typeof(fn)
	if typeof_fn == "nil" then
		return
	elseif typeof_fn ~= "function" then
		error(string.format("invalid argument #1 to 'Connect' (function expected, got %s)", typeof_fn))
	end
	local connection = Connection.new(self.Listeners)
	self.Listeners[connection] = fn
	return connection
end

function Event:Wait()
	local thread = coroutine.running()
	table.insert(self.Waiting, thread)
	
	return coroutine.yield()
end

return Event