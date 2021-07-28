local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact: Roact = require(ReplicatedStorage.Roact)

local Cell = Roact.Component:extend("Cell")

Cell.defaultProps = {
	hasMine = false,
	surroundingMines = 0,
	location = nil
}

function Cell:render()
	return Roact.createElement("TextButton", {
		Text = self.props.userState:map(function(userState)
			if userState == "open" then
				if self.props.hasMine then
					return "💣"
				elseif self.props.surroundingMines > 0 then
					return tostring(self.props.surroundingMines)
				else
					return ""
				end
			elseif userState == "flagged" then
				return "🚩"
			else
				return ""
			end
		end),
		TextScaled = true,

		LayoutOrder = self.props.layoutOrder,

		BackgroundColor3 = self.props.userState:map(function(userState)
			if userState == "open" then
				return Color3.fromRGB(150, 150, 150)
			else
				return Color3.fromRGB(230, 230, 230)
			end
		end),
		BorderSizePixel = 1,
		BorderMode = Enum.BorderMode.Middle,
		BorderColor3 = Color3.fromRGB(0, 0, 0),

		[Roact.Event.MouseButton1Click] = function(_rbxButton)
			local userState = self.props.userState:getValue()
			if userState == "closed" then
				self.props:open()
			elseif userState == "open" then
				self.props:revealOpenCells()
			end
		end,

		[Roact.Event.MouseButton2Click] = function(_rbxButton)
			local userState = self.props.userState:getValue()
			if userState == "closed" then
				self.props.setUserState("flagged")
			elseif userState == "flagged" then
				self.props.setUserState("closed")
			end
		end
	})
end

return Cell