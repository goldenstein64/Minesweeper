local ModuleInstances = {
	Roact = script.Roact,
	Event = script.Event,
	Space = script.Space,
	Minesweeper = script.Minesweeper,
}

local function DepLoader(name)
	return require(ModuleInstances[name])
end

return DepLoader
