local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContentProvider = game:GetService("ContentProvider")

local player = Players.LocalPlayer
local playerGui = player.PlayerGui

local load = require(ReplicatedStorage.DepLoader)
local Roact = load("Roact")
local ImageAssets = load("ImageAssets")

local debugMode = script:GetAttribute("DebugMode")
if debugMode then
	local testAssets = require(script.TestAssets)
	local testElement = Roact.createElement(testAssets)
	local hostElement = Roact.createElement("ScreenGui", nil, {
		Contents = testElement,
	})
	Roact.mount(hostElement, playerGui)
	return
end

local Minesweeper = require(ReplicatedStorage.Minesweeper) -- ./src

local assets = {}
for _, namespace in ImageAssets do
	for _, assetId in namespace do
		table.insert(assets, assetId)
	end
end

local loadingScreen = Roact.createElement("ScreenGui", nil, {
	LoadingLabel = Roact.createElement("TextLabel", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 0.25,

		TextScaled = true,
		Text = "Loading...",
	}),
})

local loadingTree = Roact.mount(loadingScreen, playerGui)

ContentProvider:PreloadAsync(assets)

Roact.unmount(loadingTree)

local presets = {
	easy = { size = Vector2.new(9, 9), mineCount = 10 },
	medium = { size = Vector2.new(16, 16), mineCount = 40 },
	hard = { size = Vector2.new(30, 16), mineCount = 99 },
	extreme = { size = Vector2.new(30, 24), mineCount = 180 },
}

local gameElement = Roact.createElement(Minesweeper, presets.easy)

local hostElement = Roact.createElement("ScreenGui", nil, {
	ParentFrame = Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(160, 160, 160),
	}, {
		Minesweeper = gameElement,
	}),
})

Roact.mount(hostElement, playerGui)
