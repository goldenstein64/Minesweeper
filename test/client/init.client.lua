local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

local Roact: Roact = require(ReplicatedStorage.Roact)

local App = require(ReplicatedStorage.App)

local appElem = Roact.createElement(App)

Roact.mount(appElem, player.PlayerGui)