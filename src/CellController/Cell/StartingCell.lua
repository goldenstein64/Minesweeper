local ReplicatedStorage = game:GetService("ReplicatedStorage")

local load = require(ReplicatedStorage.DepLoader)
local Roact = load("Roact")

local function StartingCell(props)
	local function onOpen(_rbxButton)
		props.data:setState("open")
	end

	local function onFlag(_rbxButton)
		local state = props.data.state:getValue()

		if state == "closed" then
			props.data:setState("flagged")
		elseif state == "flagged" then
			props.data:setState("closed")
		end
	end

	return Roact.createElement("TextButton", {
		Text = props.data.state:map(function(state)
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

		[Roact.Event.MouseButton1Click] = onOpen,
		[Roact.Event.MouseButton2Click] = onFlag,

		[Roact.Event.TouchTap] = onOpen,
		[Roact.Event.TouchLongPress] = onFlag,
	})
end

return StartingCell
