local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact: Roact = require(ReplicatedStorage.Roact)

local CellController = require(script.CellController)
local Hotbar = require(script.Hotbar)
local PopUp = require(script.PopUp)

local App = Roact.Component:extend("App")

App.defaultProps = {
	size = Vector2.new(30, 16),
	mineCount = 99
}

function App:init(props)
	self.startVisible, self.setStartVisible = Roact.createBinding(true)
	self:setState({
		appState = "settingUp",
		size = props.size,
		mineCount = props.mineCount
	})

	self.size, self.changeSize = Roact.createBinding(props.size)
	self.mineCount, self.setMineCount = Roact.createBinding(props.mineCount)
end

function App:render()
	local cellController, startWindow
	if self.state.appState == "inGame" then
		cellController = Roact.createElement(CellController, {
			size = self.size,
			mineCount = self.mineCount
		})
	elseif self.state.appState == "settingUp" then
		startWindow = Roact.createElement(PopUp, {
			windowType = "start",
			visible = self.startVisible,

			startGame = function()
				self:setState({
					appState = "inGame"
				})
			end,

			size = self.size,
			changeSize = self.changeSize,

			mineCount = self.mineCount,
			setMineCount = self.setMineCount
		})
	end

	return Roact.createElement("ScreenGui", {}, {
		MainWindow = Roact.createElement("Frame", {
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0.8, 0, 0.8, 0),
			AnchorPoint = Vector2.new(0.5, 0.5)
		}, {
			Hotbar = Roact.createElement(Hotbar, {
				-- attach callbacks here
			}),
	
			Cells = cellController,
			Start = startWindow
		})
	})
end

return App