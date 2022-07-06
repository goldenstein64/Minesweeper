local ReplicatedStorage = game:GetService("ReplicatedStorage")

local load = require(ReplicatedStorage.DepLoader)
local Roact = load("Roact")
local ImageAssets = load("ImageAssets")

local function FinishedCell(props)
	return Roact.createElement("ImageButton", {
		Image = props.data.state:map(function(state)
			if state == "open" then
				if props.data.hasMine then
					return ImageAssets.Cells.RevealedMine
				else
					return ImageAssets.Cells[props.data.surroundingMines]
				end
			elseif state == "flagged" then
				if props.data.hasMine then
					return ImageAssets.Cells.Flagged
				else
					return ImageAssets.Cells.Misflagged
				end
			elseif state == "closed" then
				if props.data.hasMine then
					return ImageAssets.Cells.Flagged
				else
					return ImageAssets.Cells.Closed
				end
			else
				return ""
			end
		end),

		LayoutOrder = props.layoutOrder,

		BackgroundTransparency = 1,
	})
end

return FinishedCell
