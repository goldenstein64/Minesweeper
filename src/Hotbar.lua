local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact: Roact = require(ReplicatedStorage.Roact)

local Hotbar = Roact.Component:extend("Hotbar")

-- TODO: implement this

function Hotbar:init()

end

function Hotbar:render()
	return Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 0.1, 0),
		Position = UDim2.new(0, 0, 1, 0),
		AnchorPoint = Vector2.new(0, 1),
	}, {

		-- reset board
		-- score
		-- time
	})
end

return Hotbar