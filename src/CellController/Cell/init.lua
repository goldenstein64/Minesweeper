local ReplicatedStorage = game:GetService("ReplicatedStorage")

local load = require(ReplicatedStorage.DepLoader)
local Roact = load("Roact")

local StartingCell = require(script.StartingCell)
local PlayingCell = require(script.PlayingCell)
local VictoryCell = require(script.VictoryCell)
local DefeatCell = require(script.DefeatCell)

local gameStateToCell = {
	starting = StartingCell,
	playing = PlayingCell,
	victory = VictoryCell,
	defeat = DefeatCell,
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
