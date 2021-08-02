local ReplicatedStorage = game:GetService("ReplicatedStorage")

local load = require(ReplicatedStorage.DepLoader)
	local Roact = load("Roact")

local StartingCell = require(script.StartingCell)
local PlayingCell = require(script.PlayingCell)
local FinishedCell = require(script.FinishedCell)

local Cell = Roact.Component:extend("Cell")

function Cell:init(props)
	local setState
	self.cellState, setState = Roact.createBinding(props.data.state)

	props.data.setStateCallback = setState
end

local gameStateToCell = {
	starting = StartingCell,
	playing = PlayingCell,
	finished = FinishedCell
}

function Cell:render()
	local props = self.props

	local size = props.size
	local position = props.data.position
	
	local newProps = {
		layoutOrder = size.X * position.Y + position.X,
		state = self.cellState
	}
	for k, v in pairs(props) do
		newProps[k] = v
	end

	local derivedCell = gameStateToCell[props.game]
	return Roact.createElement(derivedCell, newProps)
end

return Cell