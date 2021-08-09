local ReplicatedStorage = game:GetService("ReplicatedStorage")

local load = require(ReplicatedStorage.DepLoader)
local Roact = load("Roact")
local ImageAssets = load("ImageAssets")

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

	return Roact.createElement("ImageButton", {
		Image = props.data.state:map(function(state)
			if state == "flagged" then
				return ImageAssets.Cells.Flagged
			end

			return ImageAssets.Cells.Closed
		end),

		LayoutOrder = props.layoutOrder,

		BackgroundTransparency = 1,

		[Roact.Event.MouseButton1Click] = onOpen,
		[Roact.Event.MouseButton2Click] = onFlag,

		[Roact.Event.TouchTap] = onOpen,
		[Roact.Event.TouchLongPress] = onFlag,
	})
end

return StartingCell
