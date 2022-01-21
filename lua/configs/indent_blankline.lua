local ok, indent_blankline = Prequire("indent_blankline")

if not ok then
	return
end

indent_blankline.setup({
	show_current_context = true,
})
