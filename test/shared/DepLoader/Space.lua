local Space = {}
Space.__index = Space

local function pairs2d(self)
	return coroutine.wrap(function(innerSelf)
		for x, column in innerSelf do
			for y, value in column do
				coroutine.yield(x, y, value)
			end
		end

		return nil
	end), self
end

function Space:__iter()
	return pairs2d(self.Data)
end

function Space.new()
	local self = {
		Data = {},
	}

	setmetatable(self, Space)

	return self
end

function Space:Get(x, y)
	local column = self.Data[x]
	if not column then
		return nil
	else
		return column[y]
	end
end

function Space:Set(x, y, v)
	local column = self.Data[x]
	if not column then
		self.Data[x] = { [y] = v }
	else
		column[y] = v
	end
end

return Space
