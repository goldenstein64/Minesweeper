local ModuleInstances = {
	Roact = script.Roact,
	Event = script.Event,
	Array2D = script.Array2D,
	Minesweeper = script.Minesweeper,
}

local function DepLoader(name)
	return require(ModuleInstances[name])
end

return DepLoader
