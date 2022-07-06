local ReplicatedStorage = game:GetService("ReplicatedStorage")

local load = require(ReplicatedStorage.DepLoader)
local ImageAssets = load("ImageAssets")
local Roact = load("Roact")

local function Container(props)
	local children = {}

	children.UIGridLayout = Roact.createElement("UIGridLayout", {
		CellSize = UDim2.fromOffset(50, 50),
	})

	for k, assetId in props.images do
		children[k] = Roact.createElement("ImageLabel", {
			Image = assetId,
		})
	end

	return Roact.createElement("Frame", {
		Size = UDim2.new(1 / 3, 0, 1, 0),
	}, children)
end

local function TestAssets()
	local children = {}

	children.UIListLayout = Roact.createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
	})
	for k, namespace in ImageAssets do
		children[k] = Roact.createElement(Container, {
			images = namespace,
		})
	end

	return Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
	}, children)
end

return TestAssets
