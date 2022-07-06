local ReplicatedStorage = game:GetService("ReplicatedStorage")

local load = require(ReplicatedStorage.DepLoader)
local Event = load("Event")
local Roact = load("Roact")

local offsets = {
	Vector2.new(1, 1),
	Vector2.new(1, 0),
	Vector2.new(1, -1),
	Vector2.new(0, -1),
	Vector2.new(-1, -1),
	Vector2.new(-1, 0),
	Vector2.new(-1, 1),
	Vector2.new(0, 1),
}

local function countNeighborsWithState(self, state)
	local stateCount = 0

	for _, neighbor in self:getNeighbors() do
		if neighbor.state:getValue() == state then
			stateCount += 1
		end
	end

	return stateCount
end

local DataCell = {}
DataCell.__index = DataCell

function DataCell.new(data, x, y)
	local self = {
		data = data,
		cells = data.cells,
		hasMine = false,
		surroundingMines = 0,
		position = Vector2.new(x, y),
		changed = Event.new(),
	}

	self.state, self.setRawState = Roact.createBinding("closed")
	self.pressed, self.setRawPressed = Roact.createBinding(false)

	setmetatable(self, DataCell)

	return self
end

function DataCell:setState(newState)
	self.setRawState(newState)
	self.changed:Fire(newState)
end

function DataCell:setPressed(isPressed)
	self.setRawPressed(isPressed)
end

function DataCell:openSafeCells()
	local closedCells = {}
	local openCells = {}

	local currentCell = self
	while currentCell ~= nil do
		closedCells[currentCell] = true
		openCells[currentCell] = nil

		for _, neighbor in currentCell:getNeighbors() do
			if closedCells[neighbor] or neighbor.state:getValue() == "open" then
				continue
			end

			neighbor:setState("open")

			if neighbor.surroundingMines == 0 then
				openCells[neighbor] = true
			end
		end

		currentCell = next(openCells)
	end
end

function DataCell:chord()
	local surroundingFlags = countNeighborsWithState(self, "flagged")

	if self.surroundingMines > surroundingFlags then
		return
	end

	local hitMine = false
	for _, neighbor in self:getNeighbors() do
		if neighbor.state:getValue() == "closed" then
			neighbor:setState("open")
			if neighbor.hasMine then
				hitMine = true
			end
		end
	end

	if not hitMine then
		for _, neighbor in self:getNeighbors() do
			if neighbor.surroundingMines == 0 then
				neighbor:openSafeCells()
			end
		end
	end
end

function DataCell:flagChord()
	local flaggedNeighborCount = countNeighborsWithState(self, "flagged")
	local closedNeighborCount = countNeighborsWithState(self, "closed")

	if self.surroundingMines ~= flaggedNeighborCount + closedNeighborCount then
		return
	end

	for _, neighbor in self:getNeighbors() do
		if neighbor.state:getValue() == "closed" then
			neighbor:setState("flagged")
		end
	end
end

function DataCell:getNeighbors()
	local neighbors = {}
	for _, offset in offsets do
		local newPosition = self.position + offset

		local cell = self.cells:Get(newPosition.X, newPosition.Y)
		if not cell then
			continue
		end

		table.insert(neighbors, cell)
	end

	return neighbors
end

return DataCell
