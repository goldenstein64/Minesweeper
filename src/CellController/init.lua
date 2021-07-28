local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact: Roact = require(ReplicatedStorage.Roact)

local Cell = require(script.Cell)

local R = Random.new()

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

local function getCellLocation(size, base, offset)
	base -= 1
	local rowSize = size.X
	local baseX = base % rowSize
	local baseY = math.floor(base / rowSize)
	local newX, newY = baseX + offset.X, baseY + offset.Y
	if 
		newX >= 0 and newX < rowSize
		and newY >= 0 and newY < size.Y 
	then
		return (baseY + offset.Y) * rowSize + baseX + offset.X + 1
	else
		return nil
	end
end

local function getNeighbors(size, location)
	local neighbors = {}
	for _, offset in ipairs(offsets) do
		local adjacentLocation = getCellLocation(size, location, offset)
		if not adjacentLocation then continue end

		table.insert(neighbors, adjacentLocation)
	end

	return neighbors
end

local function openSafeCells(size, cellMap, at)
	local closedCells = {}
	local openCells = {}

	local currentCell = at
	while currentCell ~= nil do
		closedCells[currentCell] = true
		openCells[currentCell] = nil

		for _, location in ipairs(getNeighbors(size, currentCell)) do
			if closedCells[location] then continue end

			local cell = cellMap[location]
			cell.setUserState("open")

			if cell.surroundingMines == 0 then
				openCells[location] = true
			end
		end
		
		currentCell = next(openCells)
	end
end

local CellController = Roact.Component:extend("CellController")

function CellController:render()
	local size = self.props.size:getValue()
	local mineCount = self.props.mineCount:getValue()

	local cellCount = size.X * size.Y
	local cellCollection = {}

	local startingLocation = self.state.startingLocation
	if startingLocation == nil then
		local closedBinding = {
			map = function(_self, callback)
				return callback("closed")
			end,
			getValue = function()
				return "closed"
			end
		}
		for i = 1, cellCount do
			local name = string.format("Cell%04d", i)
			cellCollection[name] = Roact.createElement(Cell, {
				hasMine = false,
				userState = closedBinding,
				layoutOrder = i,
				location = i,
				open = function()
					self:setState({
						startingLocation = i
					})
				end
			})
		end
	else
		local openCellSet = {}
		local mineSet = {}

		openCellSet[startingLocation] = true
		for _, location in ipairs(getNeighbors(size, startingLocation)) do
			openCellSet[location] = true
		end

		for _i = 1, mineCount do
			local mineLocation
			repeat
				mineLocation = R:NextInteger(1, cellCount)
			until not openCellSet[mineLocation] and not mineSet[mineLocation]
			mineSet[mineLocation] = true
		end

		local cellMap = {}

		local function openState(stateSelf)
			stateSelf.setUserState("open")
			if stateSelf.hasMine then
				-- TODO: implement when to end the game
			else
				if stateSelf.surroundingMines == 0 then
					openSafeCells(size, cellMap, stateSelf.location)
				end
			end
		end

		local function revealOpenCells(stateSelf)
			local surroundingFlags = 0
			for _, location in ipairs(getNeighbors(size, stateSelf.location)) do
				local cell = cellMap[location]
				local userState = cell.userState:getValue()
				if 
					userState == "flagged"
					or userState == "open" and cell.hasMine
				then
					surroundingFlags += 1
				end
			end

			if surroundingFlags ~= stateSelf.surroundingMines then return end

			for _, location in ipairs(getNeighbors(size, stateSelf.location)) do
				local cell = cellMap[location]
				local userState = cell.userState:getValue()
				if userState == "closed" then
					cell:open()
				end
			end
		end

		for i = 1, cellCount do
			local surroundingMines = 0
			for _, location in ipairs(getNeighbors(size, i)) do
				if mineSet[location] then
					surroundingMines += 1
				end
			end

			local cellProps = {
				hasMine = mineSet[i] and true or false,
				surroundingMines = surroundingMines,
				layoutOrder = i,
				location = i,
				open = openState,
				revealOpenCells = revealOpenCells
			}
			cellProps.userState, cellProps.setUserState = Roact.createBinding(openCellSet[i] and "open" or "closed")

			cellMap[i] = cellProps

			local name = string.format("Cell%04d", i)
			cellCollection[name] = Roact.createElement(Cell, cellProps)
		end

		openSafeCells(size, cellMap, startingLocation)
	end

	return Roact.createElement("Frame", {
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, 0, 0.9, 0),
		AnchorPoint = Vector2.new(0, 0)
	}, {
		UIGridLayout = Roact.createElement("UIGridLayout", {
			StartCorner = Enum.StartCorner.TopLeft,
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			FillDirectionMaxCells = size.X,

			CellSize = UDim2.new(1/(size.X + 1), 0, 1/size.Y, 0),
			CellPadding = UDim2.new(0, 0, 0, 0)
		}),
		Cells = Roact.createFragment(cellCollection)
	})
end

return CellController