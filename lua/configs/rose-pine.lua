local ok, rose_pine = Prequire("rose-pine")

if not ok then
	return
end

vim.g.rose_pine_variant = "moon"
vim.g.rose_pine_bold_vertical_split_line = true
vim.g.rose_pine_disable_italics = false
vim.g.rose_pine_disable_background = false
vim.g.rose_pine_disable_float_background = true
vim.cmd([[ colorscheme rose-pine ]])
