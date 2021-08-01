local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact: Roact = require(ReplicatedStorage.Roact)

local StartingCell = require(script.StartingCell)
local PlayingCell = require(script.PlayingCell)
local FinishedCell = require(script.FinishedCell)

local Cell = Roact.Component:extend("Cell")

function Cell:init(props)
	local setState
	self.cellState, setState = Roact.createBinding(props.data.state)

	props.data.setStateCallback = setState
end

function Cell:render()
	local props = self.props

	local size = props.size
	local location = props.data.location
	
	local newProps = {
		layoutOrder = size.X * location.Y + location.X,
		state = self.cellState
	}
	for k, v in pairs(props) do
		newProps[k] = v
	end

	local gameState = props.game
	if gameState == "starting" then
		return Roact.createElement(StartingCell, newProps)
	elseif gameState == "playing" then
		return Roact.createElement(PlayingCell, newProps)
	elseif gameState == "finished" then
		return Roact.createElement(FinishedCell, newProps)
	end
end

return Cell