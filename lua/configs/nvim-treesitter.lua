local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()
parser_configs.norg_table = {
	install_info = {
		url = "https://github.com/nvim-neorg/tree-sitter-norg-table",
		files = { "src/parser.c" },
		branch = "main",
	},
}
parser_configs.norg_meta = {
	install_info = {
		url = "https://github.com/nvim-neorg/tree-sitter-norg-meta",
		files = { "src/parser.c" },
		branch = "main",
	},
}

parser_configs.norg = {
	install_info = {
		url = "https://github.com/nvim-neorg/tree-sitter-norg",
		files = { "src/parser.c", "src/scanner.cc" },
		branch = "main",
	},
}

require("nvim-treesitter.configs").setup({
	playground = {
		enable = true,
	},
	context_commentstring = {
		enable = true,
	},
	ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
	highlight = { enable = true },
	indent = { enable = true },
	textobjects = {
		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
			},
		},
		swap = {
			enable = true,
			swap_next = {
				["<leader>sn"] = "@parameter.inner",
			},
			swap_previous = {
				["<leader>sp"] = "@parameter.inner",
			},
		},
		move = {
			enable = true,
			set_jumps = true, -- Whether to set jumps in the jumplist
			goto_next_start = {
				["gnf"] = "@function.outer",
				["gnif"] = "@function.inner",
				["gnp"] = "@parameter.inner",
				["gnc"] = "@call.outer",
				["gnic"] = "@call.inner",
			},
			goto_next_end = {
				["gnF"] = "@function.outer",
				["gniF"] = "@function.inner",
				["gnP"] = "@parameter.inner",
				["gnC"] = "@call.outer",
				["gniC"] = "@call.inner",
			},
			goto_previous_start = {
				["gpf"] = "@function.outer",
				["gpif"] = "@function.inner",
				["gpp"] = "@parameter.inner",
				["gpc"] = "@call.outer",
				["gpic"] = "@call.inner",
			},
			goto_previous_end = {
				["gpF"] = "@function.outer",
				["gpiF"] = "@function.inner",
				["gpP"] = "@parameter.inner",
				["gpC"] = "@call.outer",
				["gpiC"] = "@call.inner",
			},
		},
	},
})
