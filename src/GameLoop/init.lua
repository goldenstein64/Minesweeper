local RunService = game:GetService("RunService")

local GenerateBoard = require(script.BoardGenerator)

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

	GenerateBoard(data, startingCell)

	startingCell:openSafeCells()
end

function GameLoop.finish(data, finalCell)
	assert(data.timerConn, "game is not started yet!")
	data.timerConn:Disconnect()
	data.timerConn = nil

	if finalCell then
		finalCell:setState("mineHit")
		data.setFace("😵")
	else
		data.setFace("😎")
		data.setMinesLeft(0)
	end
end

function GameLoop.reset(data)
	for _, _, cell in data.cells do
		cell.hasMine = false
		cell.surroundingMines = 0
		cell:setState("closed")
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
