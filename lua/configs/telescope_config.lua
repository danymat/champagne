local actions = require("telescope.actions")
require("telescope").setup({
	defaults = require("telescope.themes").get_ivy({
		winblend = 10,
		mappings = {
			i = {
				-- Change keys to select previous and next
				["<Down>"] = false,
				["<Up>"] = false,
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,

				-- Use <C-a> to move all to qflist
				-- Use <C-q> to move selected to qflist
				["<M-q>"] = false,
				["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
				["<C-a>"] = actions.send_to_qflist + actions.open_qflist,
			},
			n = {
				["<M-q>"] = false,
				["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
				["<C-a>"] = actions.send_to_qflist + actions.open_qflist,
			},
		},
	}),
	extensions = {
		file_browser = {},
		["ui-select"] = require("telescope.themes").get_cursor(),
		project = {
			hidden_files = true,
		},
	},
})
