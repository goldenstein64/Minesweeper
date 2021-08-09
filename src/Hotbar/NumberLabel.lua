local ReplicatedStorage = game:GetService("ReplicatedStorage")

local load = require(ReplicatedStorage.DepLoader)
local Roact = load("Roact")
local ImageAssets = load("ImageAssets")

local function NumberLabel(props)
	local labels = {}

	labels.UIGridLayout = Roact.createElement("UIGridLayout", {
		CellSize = UDim2.new(1 / props.places, 0, 1, 0),
		CellPadding = UDim2.new(0, 0, 0, 0),
		FillDirection = Enum.FillDirection.Horizontal,
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Center,
	})

	for i = 1, props.places do
		local name = string.format("Digit1%s", string.rep("0", i - 1))
		labels[name] = Roact.createElement("ImageButton", {
			BackgroundTransparency = 1,
			LayoutOrder = -i,
			Image = props.value:map(function(number)
				local digit = math.floor(number / 10 ^ (i - 1)) % 10
				return ImageAssets.Numbers[digit]
			end),
		})
	end

	return Roact.createFragment(labels)
end

return NumberLabel
