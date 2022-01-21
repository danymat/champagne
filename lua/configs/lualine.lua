local ok, lualine = Prequire("lualine")

if not ok then
	return
end

lualine.setup({
	options = { theme = "rose-pine" },
	-- options = { theme = "catppuccin" },
})
