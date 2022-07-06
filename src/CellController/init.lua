local ReplicatedStorage = game:GetService("ReplicatedStorage")

local load = require(ReplicatedStorage.DepLoader)
local Roact = load("Roact")
local ImageAssets = load("ImageAssets")

local app = script.Parent
local GameLoop = require(app.GameLoop)

local Cell = require(script.Cell)

local gameStateMap = {}

function gameStateMap.starting(self)
	local data = self.props.data

	self.cellChangedConn = data.cellChanged:Connect(function(cell)
		if cell.state:getValue() == "open" then
			self.cellChangedConn:Disconnect()
			GameLoop.start(data, cell)
			if data.cellsLeft == 0 then
				GameLoop.finish(data, nil)
				self:setState({
					game = "victory",
				})
			else
				self:setState({
					game = "playing",
				})
			end
		end
	end)

	return true
end

function gameStateMap.playing(self)
	local data = self.props.data
	self.cellChangedConn = data.cellChanged:Connect(function(cell, state)
		if state == "open" then
			if cell.hasMine then
				self.cellChangedConn:Disconnect()
				self.resetedConn:Disconnect()
				GameLoop.finish(data, cell)
				self:setState({
					game = "defeat",
				})
			elseif data.cellsLeft == 0 then
				self.cellChangedConn:Disconnect()
				self.resetedConn:Disconnect()
				GameLoop.finish(data, nil)
				self:setState({
					game = "victory",
				})
			end
		end
	end)

	self.resetedConn = data.reseted:Connect(function()
		self.cellChangedConn:Disconnect()
		self.resetedConn:Disconnect()
		self:setState({
			game = "starting",
		})
	end)

	return true
end

function gameStateMap.victory(self)
	local data = self.props.data

	self.resetedConn = data.reseted:Connect(function()
		self.resetedConn:Disconnect()
		self:setState({
			game = "starting",
		})
	end)

	return false
end
gameStateMap.defeat = gameStateMap.victory

local CellController = Roact.Component:extend("CellController")

CellController.defaultProps = {
	layoutOrder = 2,
}

function CellController:init()
	self:setState({
		game = "starting",
	})
end

function CellController:render()
	local data = self.props.data

	local size = data.size

	local cellCollection = {}

	for x, y, cell in data.cells do
		local name = string.format("Cell_%02d_%02d", y, x)
		cellCollection[name] = Roact.createElement(Cell, {
			size = size,
			game = self.state.game,
			data = cell,
		})
	end

	local gameStateHandler = gameStateMap[self.state.game]
	if gameStateHandler == nil then
		error(string.format("game state handler not found for %q", self.state.game))
	end

	local shouldConnectInput = gameStateHandler(self)
	local onInputBegan, onInputEnded
	if shouldConnectInput then
		onInputBegan = function(_rbxFrame, input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				data.setFace(ImageAssets.Faces.Tension)
			end
		end

		onInputEnded = function(_rbxFrame, input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				data.setFace(ImageAssets.Faces.Default)
			end
		end
	end

	return Roact.createElement("Frame", {
		Position = UDim2.new(0.5, 0, 0.45, 0),
		Size = UDim2.new(1, 0, 0.9, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),

		LayoutOrder = self.props.layoutOrder,

		BackgroundTransparency = 1,
		ZIndex = 3,

		[Roact.Event.InputBegan] = onInputBegan,
		[Roact.Event.InputEnded] = onInputEnded,
	}, {
		UIAspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
			AspectRatio = size.X / size.Y,
			AspectType = Enum.AspectType.FitWithinMaxSize,
		}),

		UIGridLayout = Roact.createElement("UIGridLayout", {
			StartCorner = Enum.StartCorner.TopLeft,
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			FillDirectionMaxCells = size.X,

			CellSize = UDim2.new(1 / size.X, 0, 1 / size.Y, 0),
			CellPadding = UDim2.new(0, 0, 0, 0),
		}),

		UIPadding = Roact.createElement("UIPadding", {
			PaddingTop = UDim.new(0.025, 0),
			PaddingBottom = UDim.new(0.025, 0),
			PaddingLeft = UDim.new(0.025, 0),
			PaddingRight = UDim.new(0.025, 0),
		}),

		Cells = Roact.createFragment(cellCollection),
	})
end

return CellController
