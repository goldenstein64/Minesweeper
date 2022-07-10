local ReplicatedStorage = game:GetService("ReplicatedStorage")

local load = require(ReplicatedStorage.DepLoader)
local Array2D = load("Array2D")

local R = Random.new()

local function getRequiredOpenCells(startingPos, size)
	local onXEdge = startingPos.X == 1 or startingPos.X == size.X
	local onYEdge = startingPos.Y == 1 or startingPos.Y == size.Y
	return if onXEdge and onYEdge then 3
		else if onXEdge or onYEdge then 5
		else 8
end

local function fillAllCells(data)
	for x = 1, data.size.X do
		for y = 1, data.size.Y do
			local cell = data.cells:get(x, y)
			cell.hasMine = true
			cell.surroundingMines = 8
		end
	end
end

local function generateMines(data, startingCell)
	local size = data.size
	local openCellSet = Array2D.new()

	openCellSet:set(startingCell.position.X, startingCell.position.Y, true)
	for _, neighbor in startingCell:getNeighbors() do
		local newPosition = neighbor.position
		openCellSet:set(newPosition.X, newPosition.Y, true)
	end

	for _ = 1, data.mineCount do
		local x, y
		repeat
			x = R:NextInteger(1, size.X)
			y = R:NextInteger(1, size.Y)
		until not openCellSet:get(x, y)
		local cell = data.cells:get(x, y)
		cell.hasMine = true

		for _, neighbor in cell:getNeighbors() do
			neighbor.surroundingMines += 1
		end

		openCellSet:set(x, y, true)
	end
end

local function generateSpaces(data, closedCells, startingCell)
	local size = data.size
	local startingPos = startingCell.position

	fillAllCells(data)

	local openCellSet = Array2D.new()
	startingCell.hasMine = false
	openCellSet:set(startingPos.X, startingPos.Y, true)
	for _, neighbor in startingCell:getNeighbors() do
		neighbor.hasMine = false
		neighbor.surroundingMines -= 1
		local position = neighbor.position
		openCellSet:set(position.X, position.Y, true)
		for _, neighbor2 in neighbor:getNeighbors() do
			neighbor2.surroundingMines -= 1
		end
	end

	for _ = 1, closedCells - data.mineCount do
		local x, y
		repeat
			x = R:NextInteger(1, size.X)
			y = R:NextInteger(1, size.Y)
		until not openCellSet:get(x, y)

		local cell = data.cells:get(x, y)
		cell.hasMine = false
		for _, neighbor in cell:getNeighbors() do
			neighbor.surroundingMines -= 1
		end
		openCellSet:set(x, y, true)
	end
end

local function generateLastSpaces(data, startingCell)
	local size = data.size
	local totalCells = size.X * size.Y

	-- fill everything with mines
	fillAllCells(data)

	-- unfill the starting cell
	local openNeighbors = startingCell:getNeighbors()
	startingCell.hasMine = false
	for _, neighbor in openNeighbors do
		neighbor.surroundingMines -= 1
	end

	-- unfill the 8 spaces near the starting cell as needed
	for _ = 1, totalCells - data.mineCount - 1 do
		local neighbor = table.remove(openNeighbors, R:NextInteger(1, #openNeighbors))
		neighbor.hasMine = false
		for _, neighbor2 in neighbor:getNeighbors() do
			neighbor2.surroundingMines -= 1
		end
	end
end

local function generateBoard(data, startingCell)
	local size = data.size
	local requiredOpenCells = getRequiredOpenCells(startingCell.position, size)

	local totalCells = size.X * size.Y
	local closedCells = totalCells - requiredOpenCells - 1

	-- each of these functions are a different method of generating mines
	-- higher mine counts would mean falling back to a different algorithm
	if data.mineCount < closedCells / 2 then
		generateMines(data, startingCell)
	elseif data.mineCount <= closedCells then
		generateSpaces(data, closedCells, startingCell)
	elseif data.mineCount < totalCells then
		generateLastSpaces(data, startingCell)
	else
		error(string.format("Expected a mine count (%d) less than total cells (%d)", data.mineCount, totalCells))
	end
end

return generateBoard