local dependencies = {
	Roact = script.Roact,
	GoodSignal = script.GoodSignal,
	Array2D = script.Array2D,
}

local function DepLoader(name)
	return require(dependencies[name])
end

return DepLoader
