local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact: Roact = require(ReplicatedStorage.Roact)

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
	return Roact.createElement("ScreenGui", nil, {
		MainWindow = Roact.createElement("Frame", {
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0.8, 0, 0.8, 0),
			AnchorPoint = Vector2.new(0.5, 0.5)
		}, {
			Data = Roact.createElement(Data.Provider, {
				value = self.state.data
			}, {
				Cells = Roact.createElement(CellController),
				Hotbar = Roact.createElement(Hotbar)
			})
		})
	})
end

return App