local ReplicatedStorage = game:GetService("ReplicatedStorage")

local load = require(ReplicatedStorage.DepLoader)
	local Roact = load("Roact")

local function StartingCell(props)
	return Roact.createElement("TextButton", {
		Text = props.state:map(function(state)
			if state == "flagged" then
				return "🚩"
			end

			return ""
		end),
		TextScaled = true,
		TextColor3 = Color3.fromRGB(0, 0, 0),

		LayoutOrder = props.layoutOrder,

		BackgroundColor3 = Color3.fromRGB(150, 150, 150),
		BorderSizePixel = 1,
		BorderMode = Enum.BorderMode.Middle,
		BorderColor3 = Color3.fromRGB(0, 0, 0),

		[Roact.Event.MouseButton1Click] = function(_rbxButton)
			props.data:setState("open")
		end,

		[Roact.Event.MouseButton2Click] = function(_rbxButton)
			local state = props.state:getValue()

			if state == "closed" then
				props.data:setState("flagged")
			elseif state == "flagged" then
				props.data:setState("closed")
			end
		end
	})
end

return StartingCell