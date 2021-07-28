local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact: Roact = require(ReplicatedStorage.Roact)

local StartWindow = require(script.StartWindow)
local ResultWindow = require(script.ResultWindow)

local PopUp = Roact.Component:extend("PopUp")

function PopUp:render()
	local windowContents
	if self.props.windowType == "start" then
		windowContents = Roact.createElement(StartWindow, self.props)
	elseif self.props.windowType == "result" then
		windowContents = Roact.createElement(ResultWindow, self.props)
	end

	return Roact.createFragment({
		Darken = Roact.createElement("Frame", {
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(1, 0, 1, 0),
			AnchorPoint = Vector2.new(0, 0),
			
			Visible = self.props.visible,
			BackgroundTransparency = 0.5,
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0
		}),

		Window = Roact.createElement("Frame", {
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0.4, 0, 0.4, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			
			Visible = self.props.visible,
			BackgroundTransparency = 0.5,
			BackgroundColor3 = Color3.fromRGB(200, 200, 200),
			BorderSizePixel = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0)
		}, {
			Contents = windowContents
		})
	})
end

return PopUp