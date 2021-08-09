local ReplicatedStorage = game:GetService("ReplicatedStorage")

local load = require(ReplicatedStorage.DepLoader)
local Roact = load("Roact")
local ImageAssets = load("ImageAssets")

local app = script.Parent
local GameLoop = require(app.GameLoop)

local NumberLabel = require(script.NumberLabel)

local PLACES = 3

local Hotbar = Roact.Component:extend("Hotbar")

Hotbar.defaultProps = {
	layoutOrder = 1,
}

function Hotbar:render()
	local data = self.props.data

	return Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 0.1, 0),
		Position = UDim2.new(0.5, 0, 1, 0),
		AnchorPoint = Vector2.new(0.5, 1),

		BackgroundTransparency = 1,

		LayoutOrder = self.props.layoutOrder,
	}, {
		UIListLayout = Roact.createElement("UIListLayout", {
			Padding = UDim.new(0.05, 0),
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),

		MinesLeft = Roact.createElement("Frame", {
			Size = UDim2.new(0.3, 0, 0.8, 0),
			LayoutOrder = 1,
			BackgroundTransparency = 1,
		}, {
			UIAspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
				AspectRatio = PLACES * 13 / 23,
			}),
			Label = Roact.createElement(NumberLabel, {
				value = data.minesLeft,
				places = PLACES,
			}),
		}),

		Face = Roact.createElement("ImageButton", {
			Size = UDim2.new(0.3, 0, 0.8, 0),
			LayoutOrder = 2,

			Image = data.face,
			PressedImage = ImageAssets.Faces.Pressed,

			BackgroundTransparency = 1,

			[Roact.Event.MouseButton1Click] = function(_rbxButton)
				GameLoop.reset(data)
			end,
		}, {
			UIAspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
				AspectRatio = 1,
				AspectType = Enum.AspectType.FitWithinMaxSize,
			}),
		}),

		Time = Roact.createElement("Frame", {
			Size = UDim2.new(0.3, 0, 0.8, 0),
			LayoutOrder = 3,
			BackgroundTransparency = 1,
		}, {
			UIAspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
				AspectRatio = PLACES * 13 / 23,
			}),
			Label = Roact.createElement(NumberLabel, {
				value = data.time,
				places = PLACES,
			}),
		}),
	})
end

return Hotbar
