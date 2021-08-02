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
	local mineSet = Space.new()

	openCellSet:Set(startingCell.position.X, startingCell.position.Y, true)
	for _, neighbor in ipairs(startingCell:getNeighbors()) do
		local location = neighbor.position
		openCellSet:Set(location.X, location.Y, true)
	end

	for _i = 1, data.mineCount do
		local x, y
		repeat
			x = R:NextInteger(1, size.X)
			y = R:NextInteger(1, size.Y)
		until not openCellSet:Get(x, y) and not mineSet:Get(x, y)
		local cell = data.cells:Get(x, y)
		cell.hasMine = true
		mineSet:Set(x, y, true)
	end

	for _, column in pairs(data.cells.Data) do
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

function GameLoop.finish(data, finalCell)
	assert(data.timerConn, "game is not started yet!")
	data.timerConn:Disconnect()
	data.timerConn = nil

	if finalCell then
		finalCell:setState("mineHit")
		data.setFace("💀")
	else
		data.setFace("😎")
	end
	data.setMinesLeft(0)
end

function GameLoop.reset(data)
	for _, column in pairs(data.cells.Data) do
		for _, cell in pairs(column) do
			cell.hasMine = false
			cell.surroundingMines = -1
			cell:setState("closed")
		end
	end

	if data.timerConn then
		data.timerConn:Disconnect()
		data.timerConn = nil
	end
	
	data.setTime(0)
	data.setMinesLeft(data.mineCount)
	data.cellsLeft = data.size.X * data.size.Y - data.mineCount
	data.setFace("🙂")
	data.reseted:Fire()
end

return GameLoop