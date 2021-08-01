local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local load = require(ReplicatedStorage.DepLoader)
	local Roact = load("Roact")
	local Event = load("Event")

local Space = require(script.Space)
local DataCell = require(script.DataCell)

local R = Random.new()

local Data = {}
Data.__index = Data

function Data.new(app)
	local self = {
		game = "starting",

		size = app.props.size,
		mineCount = app.props.mineCount
	}

	self.cellsLeft = self.size.X * self.size.Y - self.mineCount
	self.minesLeft, self.setMinesLeft = Roact.createBinding(self.mineCount)
	self.time, self.setTime = Roact.createBinding(0)
	self.face, self.setFace = Roact.createBinding("🙂")

	self.cellChanged = Event.new()
	self.reseted = Event.new()

	local cells = Space.new()
	for x = 1, self.size.X do
		for y = 1, self.size.Y do
			local cell = DataCell.new(self)
			cell.cells = cells
			cell.location = Vector2.new(x, y)
			cells:Set(x, y, cell)
		end
	end

	self.cells = cells

	setmetatable(self, Data)

	return self
end

function Data:startGame(startingCell)
	assert(self.timerConn == nil, "game has already started!")

	local i = 0
	self.timerConn = RunService.Heartbeat:Connect(function(dt)
		i += dt
		if i >= 1 then
			self.setTime(self.time:getValue() + 1)
			i -= 1
		end
	end)

	local size = self.size
	local openCellSet = Space.new()
	local mineSet = Space.new()

	openCellSet:Set(startingCell.location.X, startingCell.location.Y, true)
	for _, neighbor in ipairs(startingCell:getNeighbors()) do
		local location = neighbor.location
		openCellSet:Set(location.X, location.Y, true)
	end

	for _i = 1, self.mineCount do
		local x, y
		repeat
			x = R:NextInteger(1, size.X)
			y = R:NextInteger(1, size.Y)
		until not openCellSet:Get(x, y) and not mineSet:Get(x, y)
		local cell = self.cells:Get(x, y)
		cell.hasMine = true
		mineSet:Set(x, y, true)
	end

	for _, column in pairs(self.cells.Data) do
		for _, cell in pairs(column) do
			local surroundingMineCount = 0
			for _, neighbor in ipairs(cell:getNeighbors()) do
				if neighbor.hasMine then
					surroundingMineCount += 1
				end
			end

			cell.surroundingMines = surroundingMineCount
		end
	end

	startingCell:openSafeCells()
end

function Data:endGame(finalCell)
	assert(self.timerConn, "game is not started yet!")
	self.timerConn:Disconnect()
	self.timerConn = nil

	self.game = "finished"
	if finalCell then
		finalCell:setState("mineHit")
		self.setFace("💀")
	else
		self.setFace("😎")
	end
	self.setMinesLeft(0)
end

function Data:resetGame()
	for _, column in pairs(self.cells.Data) do
		for _, cell in pairs(column) do
			cell.hasMine = false
			cell.surroundingMines = -1
			cell:setState("closed")
		end
	end

	if self.timerConn then
		self.timerConn:Disconnect()
		self.timerConn = nil
	end
	self.game = "starting"
	self.setTime(0)
	self.setMinesLeft(self.mineCount)
	self.cellsLeft = self.size.X * self.size.Y - self.mineCount
	self.setFace("🙂")
	self.reseted:Fire()
end

return Data