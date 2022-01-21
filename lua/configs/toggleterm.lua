local ok, toggleterm = Prequire("toggleterm")

if not ok then
	return
end

toggleterm.setup({
	direction = "float",
	size = 90,
	persists = true,
	float_opts = {
		-- The border key is *almost* the same as 'nvim_win_open'
		-- see :h nvim_win_open for details on borders however
		-- the 'curved' border is a custom border type
		-- not natively supported but implemented in this plugin.
		border = "rounded",
		winblend = 3,
		highlights = {
			border = "Normal",
			background = "Normal",
		},
	},
})
