local ok, comment = Prequire("Comment")

if not ok then
	return
end

comment.setup({
	toggler = {
		line = "<Leader>cc",
		block = "<Leader>bc",
	},
	opleader = {
		line = "<Leader>c",
		block = "<Leader>b",
	},
	extra = {
		eol = "<Leader>ca",
	},
})
