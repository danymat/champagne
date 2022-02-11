function P(...)
	local objects = vim.tbl_map(vim.inspect, { ... })
	print(unpack(objects))
	return ...
end

RELOAD = function(...)
	return require("plenary.reload").reload_module(...)
end

R = function(name, opts)
	opts = opts or {}
	RELOAD(name)
	if opts.setup then
		return require(name).setup(opts.setup)
	end

	return require(name)
end

Prequire = function(module)
	local ok, mod = pcall(require, module)
	if ok then
		return mod
	end
end

Wrap = function(function_pointer, ...)
	local params = { ... }

	return function()
		return function_pointer(unpack(params))
	end
end
