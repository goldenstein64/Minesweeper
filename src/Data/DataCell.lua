local offsets = {
	Vector2.new(1, 1),
	Vector2.new(1, 0),
	Vector2.new(1, -1),
	Vector2.new(0, -1),
	Vector2.new(-1, -1),
	Vector2.new(-1, 0),
	Vector2.new(-1, 1),
	Vector2.new(0, 1)
}

local function getSurroundingFlags(self)
	local flaggedCount = 0

	for _, neighbor in ipairs(self:getNeighbors()) do
		if neighbor.state == "flagged" then
			flaggedCount += 1
		end
	end

	return flaggedCount
end

local DataCell = {}
DataCell.__index = DataCell

function DataCell.new(data, x, y)
	local self = {
		data = data,
		cells = data.cells,
		hasMine = false,
		state = "closed",
		surroundingMines = -1,
		position = Vector2.new(x, y)
	}

	setmetatable(self, DataCell)

	return self
end

function DataCell:setState(newState)
	self.state = newState
	if newState == "open" and self.surroundingMines == 0 then
		self:openSafeCells()
	end
	self.setStateCallback(newState)
	self.data:onStateChanged(self, newState)
end

function DataCell:openSafeCells()
	local closedCells = {}
	local openCells = {}

	local currentCell = self
	while currentCell ~= nil do
		closedCells[currentCell] = true
		openCells[currentCell] = nil

		for _, neighbor in ipairs(currentCell:getNeighbors()) do
			if closedCells[neighbor] or neighbor.state == "open" then continue end

			neighbor:setState("open")

			if neighbor.surroundingMines == 0 then
				openCells[neighbor] = true
			end
		end
		
		currentCell = next(openCells)
	end
end

function DataCell:attemptOpenUnflaggedNeighbors()
	local surroundingFlags = getSurroundingFlags(self)

	if self.surroundingMines ~= surroundingFlags then return end

	for _, neighbor in ipairs(self:getNeighbors()) do
		if neighbor.state == "closed" then
			neighbor:setState("open")
		end
	end
end

function DataCell:getNeighbors()
	local neighbors = {}
	for _, offset in ipairs(offsets) do
		local newPosition = self.position + offset

		local cell = self.cells:Get(newPosition.X, newPosition.Y)
		if not cell then continue end

		table.insert(neighbors, cell)
	end

	return neighbors
end

return DataCell