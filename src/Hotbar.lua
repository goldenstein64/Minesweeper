local ReplicatedStorage = game:GetService("ReplicatedStorage")

local load = require(ReplicatedStorage.DepLoader)
	local Roact = load("Roact")

local app = script.Parent
	local GameLoop = require(app.GameLoop)

local Hotbar = Roact.Component:extend("Hotbar")

Hotbar.defaultProps = {
	layoutOrder = 2
}

function Hotbar:render()
	local data = self.props.data

	return Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 0.1, 0),
		Position = UDim2.new(0.5, 0, 1, 0),
		AnchorPoint = Vector2.new(0.5, 1),

		LayoutOrder = self.props.layoutOrder
	}, {
		UIListLayout = Roact.createElement("UIListLayout", {
			Padding = UDim.new(0.1, 0),
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),

		MinesLeft = Roact.createElement("TextLabel", {
			Size = UDim2.new(0.1, 0, 0.8, 0),
			LayoutOrder = 1,

			Text = data.minesLeft:map(function(minesLeft)
				return string.format("%03d", minesLeft)
			end),
			Font = Enum.Font.Michroma,
			TextScaled = true,
		}),
		
		Face = Roact.createElement("TextButton", {
			Size = UDim2.new(0.1, 0, 0.8, 0),
			LayoutOrder = 2,

			Text = data.face,
			TextScaled = true,

			[Roact.Event.MouseButton1Click] = function(_rbxButton)
				GameLoop.reset(data)
			end
		}, {
			UIAspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
				AspectRatio = 1,
				AspectType = Enum.AspectType.FitWithinMaxSize
			})
		}),

		Time = Roact.createElement("TextLabel", {
			Size = UDim2.new(0.1, 0, 0.8, 0),
			LayoutOrder = 3,

			Text = data.time:map(function(time)
				return string.format("%03d", time)
			end),
			Font = Enum.Font.Michroma,
			TextScaled = true
		})
	})
end

return Hotbar