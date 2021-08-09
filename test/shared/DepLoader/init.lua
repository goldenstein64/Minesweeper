local ModuleInstances = {
	Roact = script.Roact,
	Event = script.Event,
	Space = script.Space,
	ImageAssets = script.ImageAssets,
}

local function DepLoader(name)
	local module = ModuleInstances[name]
	if not module then
		error(string.format("Module %q does not exist!", name))
	end

	return require(module)
end

return DepLoader
