local ReplicatedStorage = game:GetService("ReplicatedStorage")

local load = require(ReplicatedStorage.DepLoader)
local Roact = load("Roact")
local ImageAssets = load("ImageAssets")

local parent = script.Parent
local FinishedCell = require(parent.FinishedCell)

local function VictoryCell(props)
	local newProps = table.clone(props)
	newProps.exposedMine = ImageAssets.Cells.Flagged
	return Roact.createElement(FinishedCell, newProps)
end

return VictoryCell
