local ModuleInstances = {
	Roact = script.Roact,
	Event = script.Event
}

local function DepLoader(name)
	return require(ModuleInstances[name])
end

return DepLoader