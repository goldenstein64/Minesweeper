local ReplicatedStorage = game:GetService("ReplicatedStorage")

local load = require(ReplicatedStorage.DepLoader)
local Roact = load("Roact")

local StartingCell = require(script.StartingCell)
local PlayingCell = require(script.PlayingCell)
local FinishedCell = require(script.FinishedCell)

local gameStateToCell = {
	starting = StartingCell,
	playing = PlayingCell,
	finished = FinishedCell,
}

local function Cell(props)
	local size = props.size
	local position = props.data.position

	local newProps = {
		layoutOrder = size.X * position.Y + position.X,
	}
	for k, v in props do
		newProps[k] = v
	end

	local derivedCell = gameStateToCell[props.game]
	return Roact.createElement(derivedCell, newProps)
end

return Cell
