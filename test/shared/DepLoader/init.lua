local ModuleInstances = {
	Roact = script.Roact,
	Event = script.Event,
	Space = script.Space,
	ImageAssets = script.ImageAssets
}

local function DepLoader(name)
	return require(ModuleInstances[name])
end

return DepLoader