local ReplicatedStorage = game:GetService("ReplicatedStorage")

local load = require(ReplicatedStorage.DepLoader)
	local Roact = load("Roact")

local CellController = require(script.CellController)
local Hotbar = require(script.Hotbar)
local Data = require(script.Data)

local App = Roact.Component:extend("App")

App.defaultProps = {
	size = Vector2.new(10, 10),
	mineCount = 10
}

function App:init()
	self:setState({
		data = Data.new(self)
	})
end

function App:render()
	return Roact.createElement("Frame", {
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(1, 0, 1, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
	}, {
		UIListLayout = Roact.createElement("UIListLayout", {
			Padding = UDim.new(0, 0),
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
		}),
		
		Cells = Roact.createElement(CellController, {
			data = self.state.data
		}),
		Hotbar = Roact.createElement(Hotbar, {
			data = self.state.data
		})
	})
end

return App