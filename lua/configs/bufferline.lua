local ok, bufferline = Prequire("bufferline")

if not ok then
	return
end

local p = require("rose-pine.palette")
bufferline.setup({
	options = {
		diagnostics = "nvim_lsp",
		numbers = function(opts)
			return string.format("%s.", opts.ordinal)
		end,
		show_buffer_close_icons = false,
		show_close_icon = false,
		offsets = {
			{
				filetype = "nerdtree",
				text = function()
					return vim.fn.getcwd()
				end,
				highlight = "Directory",
				text_align = "left",
			},
		},
	},
	highlights = {
		fill = { guibg = p.base },
		background = { guibg = p.base, guifg = p.inactive },
	},
})
