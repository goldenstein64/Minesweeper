local ReplicatedStorage = game:GetService("ReplicatedStorage")

local load = require(ReplicatedStorage.DepLoader)
	local Roact = load("Roact")

local function FinishedCell(props)
	return Roact.createElement("TextButton", {
		Text = props.data.state:map(function(state)
			if state == "open" then
				if props.data.hasMine then
					return "💣"
				elseif props.data.surroundingMines > 0 then
					return tostring(props.data.surroundingMines)
				end
			elseif state == "flagged" then
				if props.data.hasMine then
					return "🚩"
				else
					return "❌"
				end
			elseif state == "closed" and props.data.hasMine then
				return "💣"
			elseif state == "mineHit" then
				return "💣"
			end

			return ""
		end),
		TextScaled = true,
		TextColor3 = Color3.fromRGB(0, 0, 0),

		LayoutOrder = props.layoutOrder,

		BackgroundColor3 = props.data.state:map(function(state)
			if state == "open" then
				return Color3.fromRGB(235, 225, 171)
			elseif state == "mineHit" then
				return Color3.fromRGB(201, 46, 46)
			end

			return Color3.fromRGB(150, 150, 150)
		end),
		BorderSizePixel = 1,
		BorderMode = Enum.BorderMode.Middle,
		BorderColor3 = Color3.fromRGB(0, 0, 0)
	})
end

return FinishedCell