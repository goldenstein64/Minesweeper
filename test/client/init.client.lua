local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local playerGui = Players.LocalPlayer.PlayerGui

local load = require(ReplicatedStorage.DepLoader)
local Roact = load("Roact")
local Minesweeper = load("Minesweeper")

local presets = {
	easy = {
		size = Vector2.new(9, 9),
		mineCount = 10,
	},
	medium = {
		size = Vector2.new(16, 16),
		mineCount = 40,
	},
	hard = {
		size = Vector2.new(30, 16),
		mineCount = 99,
	},
	extreme = {
		size = Vector2.new(30, 24),
		mineCount = 180,
	},
}

local gameElement = Roact.createElement(Minesweeper, presets.easy)

local host = Roact.createElement("ScreenGui", nil, {
  ParentFrame = Roact.createElement("Frame", {
    Size = UDim2.new(1, 0, 1, 0),
  }, { Game = gameElement }),
})

Roact.mount(host, playerGui, "MinesweeperGui")
