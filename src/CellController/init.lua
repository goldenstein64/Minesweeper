local ReplicatedStorage = game:GetService("ReplicatedStorage")

local load = require(ReplicatedStorage.DepLoader)
	local Roact = load("Roact")

local app = script.Parent
	local GameLoop = require(app.GameLoop)

local Cell = require(script.Cell)

local CellController = Roact.Component:extend("CellController")

CellController.defaultProps = {
	layoutOrder = 2
}

function CellController:init()
	self:setState({
		game = "starting"
	})
end

function CellController:render()
	local data = self.props.data

	local size = data.size
	
	local cellCollection = {}
	
	for x, column in pairs(data.cells.Data) do
		for y, cell in pairs(column) do
			local name = string.format("Cell_%02d_%02d", y, x)
			cellCollection[name] = Roact.createElement(Cell, {
				size = size,
				game = self.state.game,
				data = cell,
			})
		end
	end

	local function onInputBegan(_rbxFrame, input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			data.setFace("😮")
		end
	end

	local function onInputEnded(_rbxFrame, input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			data.setFace("🙂")
		end
	end

	if self.state.game == "starting" then
		self.cellChangedConn = data.cellChanged:Connect(function(cell)
			if cell.state == "open" then
				self.cellChangedConn:Disconnect()
				GameLoop.start(data, cell)
				self:setState({
					game = "playing"
				})
			end
		end)
	elseif self.state.game == "playing" then
		self.cellChangedConn = data.cellChanged:Connect(function(cell)
			if cell.state == "open" then
				if cell.hasMine or data.cellsLeft == 0 then
					self.cellChangedConn:Disconnect()
					self.resetedConn:Disconnect()
					GameLoop.finish(data, cell.hasMine and cell or nil)
					self:setState({
						game = "finished"
					})
				end
			end
		end)

		self.resetedConn = data.reseted:Connect(function()
			self.cellChangedConn:Disconnect()
			self.resetedConn:Disconnect()
			self:setState({
				game = "starting"
			})
		end)
	elseif self.state.game == "finished" then
		self.resetedConn = data.reseted:Connect(function()
			self.resetedConn:Disconnect()
			self:setState({
				game = "starting"
			})
		end)

		onInputBegan = nil
		onInputEnded = nil
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
			AspectRatio = size.X/size.Y,
			AspectType = Enum.AspectType.FitWithinMaxSize
		}),

		UIGridLayout = Roact.createElement("UIGridLayout", {
			StartCorner = Enum.StartCorner.TopLeft,
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			FillDirectionMaxCells = size.X,

			CellSize = UDim2.new(1/size.X, 0, 1/size.Y, 0),
			CellPadding = UDim2.new(0, 0, 0, 0)
		}),

		Cells = Roact.createFragment(cellCollection),
	})
end

return CellController