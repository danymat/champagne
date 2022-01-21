local ok, tabout = Prequire("tabout")

if not ok then
	return
end

tabout.setup({
	tabkey = "",
	backwards_tabkey = "",
	act_as_tab = false,
})
