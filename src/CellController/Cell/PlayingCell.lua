local ReplicatedStorage = game:GetService("ReplicatedStorage")

local load = require(ReplicatedStorage.DepLoader)
local Roact = load("Roact")

local function PlayingCell(props)
	local function onOpen(_rbxButton)
		local state = props.data.state:getValue()
		if state == "closed" then
			props.data:setState("open")
			if props.data.surroundingMines == 0 then
				props.data:openSafeCells()
			end
		elseif state == "open" then
			props.data:attemptOpenUnflaggedNeighbors()
		end
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
			if state == "open" then
				if props.data.hasMine then
					return "💣"
				elseif props.data.surroundingMines > 0 then
					return tostring(props.data.surroundingMines)
				end
			elseif state == "flagged" then
				return "🚩"
			end

			return ""
		end),
		TextScaled = true,
		TextColor3 = Color3.fromRGB(0, 0, 0),

		LayoutOrder = props.layoutOrder,

		BackgroundColor3 = props.data.state:map(function(state)
			if state == "open" then
				return Color3.fromRGB(230, 230, 230)
			else
				return Color3.fromRGB(150, 150, 150)
			end
		end),
		BorderSizePixel = 1,
		BorderMode = Enum.BorderMode.Middle,
		BorderColor3 = Color3.fromRGB(0, 0, 0),

		[Roact.Event.MouseButton1Click] = onOpen,
		[Roact.Event.MouseButton2Click] = onFlag,

		[Roact.Event.TouchTap] = onOpen,
		[Roact.Event.TouchLongPress] = onFlag,
	})
end

return PlayingCell
