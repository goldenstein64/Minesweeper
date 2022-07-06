local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local load = require(ReplicatedStorage.DepLoader)
local Space = load("Space")

local R = Random.new()

local GameLoop = {}

function GameLoop.start(data, startingCell)
	assert(data.timerConn == nil, "game has already started!")

	local i = 0
	data.timerConn = RunService.Heartbeat:Connect(function(dt)
		i += dt
		if i >= 1 then
			data.setTime(data.time:getValue() + 1)
			i -= 1
		end
	end)

	local size = data.size
	local openCellSet = Space.new()

	openCellSet:Set(startingCell.position.X, startingCell.position.Y, true)
	for _, neighbor in startingCell:getNeighbors() do
		local newPosition = neighbor.position
		openCellSet:Set(newPosition.X, newPosition.Y, true)
	end

	for _i = 1, data.mineCount do
		local x, y
		repeat
			x = R:NextInteger(1, size.X)
			y = R:NextInteger(1, size.Y)
		until not openCellSet:Get(x, y)
		local cell = data.cells:Get(x, y)
		cell.hasMine = true

		for _, neighbor in cell:getNeighbors() do
			neighbor.surroundingMines += 1
		end

		openCellSet:Set(x, y, true)
	end

	data.sideEffects = true
	startingCell:openSafeCells()
end

function GameLoop.finish(data, finalCell)
	assert(data.timerConn, "game is not started yet!")
	data.timerConn:Disconnect()
	data.timerConn = nil

	data.sideEffects = false

	if finalCell then
		finalCell:setState("mineHit")
		data.setFace("😵")
	else
		data.setFace("😎")
		data.setMinesLeft(0)
	end
end

function GameLoop.reset(data)
	for _, column in data.cells.Data do
		for _, cell in column do
			cell.hasMine = false
			cell.surroundingMines = 0
			cell:setState("closed")
		end
	end

	if data.timerConn then
		data.timerConn:Disconnect()
		data.timerConn = nil
	end

	data.sideEffects = false
	data.setTime(0)
	data.setMinesLeft(data.mineCount)
	data.cellsLeft = data.size.X * data.size.Y - data.mineCount
	data.setFace("🙂")
	data.reseted:Fire()
end

return GameLoop
