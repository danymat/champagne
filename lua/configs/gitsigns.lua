local ok, gitsigns = Prequire("gitsigns")

if not ok then
	return
end

gitsigns.setup({
	signcolumn = false,
	numhl = true,
	current_line_blame = true,
	keymaps = {},
})
