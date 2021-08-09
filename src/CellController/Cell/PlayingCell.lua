local ReplicatedStorage = game:GetService("ReplicatedStorage")

local load = require(ReplicatedStorage.DepLoader)
local Roact = load("Roact")
local ImageAssets = load("ImageAssets")

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

	return Roact.createElement("ImageButton", {
		Image = props.data.state:map(function(state)
			if state == "open" then
				if props.data.hasMine then
					return ImageAssets.Cells.RevealedMine
				else
					return ImageAssets.Cells[props.data.surroundingMines]
				end
			elseif state == "flagged" then
				return ImageAssets.Cells.Flagged
			elseif state == "closed" then
				return ImageAssets.Cells.Closed
			else
				return ""
			end
		end),

		LayoutOrder = props.layoutOrder,

		BackgroundTransparency = 1,

		[Roact.Event.MouseButton1Click] = onOpen,
		[Roact.Event.MouseButton2Click] = onFlag,

		[Roact.Event.TouchTap] = onOpen,
		[Roact.Event.TouchLongPress] = onFlag,
	})
end

return PlayingCell
