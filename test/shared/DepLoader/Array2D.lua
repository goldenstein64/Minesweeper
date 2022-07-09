local Array2D = {}
Array2D.__index = Array2D

local function next2d(self)
	for x, column in self do
		for y, value in column do
			coroutine.yield(x, y, value)
		end
	end

	return nil
end

function Array2D:__iter()
	return coroutine.wrap(next2d), self.Data
end

function Array2D.new()
	return setmetatable({
		Data = {},
	}, Array2D)
end

function Array2D:get(x, y)
	local column = self.Data[x]
	if column then
		return column[y]
	else
		return nil
	end
end

function Array2D:set(x, y, v)
	local column = self.Data[x]
	if column then
		column[y] = v
	else
		self.Data[x] = { [y] = v }
	end
end

return Array2D
