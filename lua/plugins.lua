-- Install packer if not found
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	print("Installing packer...")
	fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
	print("Installed packer!")
end
vim.cmd("packadd packer.nvim")
local packer = require("packer")

packer.startup({
	function(use)
		use({
			"wbthomason/packer.nvim",
			opt = true,
		})

		use("lewis6991/impatient.nvim")

		use({
			"preservim/nerdtree",
			cmd = "NERDTreeFocus",
		})

		use({
			"tpope/vim-surround",
			event = "BufRead",
		})

		use({
			"terrortylor/nvim-comment",
			config = [[require('nvim_comment').setup({line_mapping = "<Leader>cc", operator_mapping = "<Leader>c" })]],
			keys = { "<Leader>cc", "<Leader>c" },
		})

		use({
			"lewis6991/gitsigns.nvim",
			config = function()
				require("gitsigns").setup({
					signcolumn = false,
					numhl = true,
					current_line_blame = true,
				})
			end,
			requires = {
				"nvim-lua/plenary.nvim",
			},
			event = "BufRead",
		})

		use({
			"nvim-telescope/telescope.nvim",
			config = function()
				local actions = require("telescope.actions")
				require("telescope").setup({
					defaults = require("telescope.themes").get_ivy({
						winblend = 10,
						mappings = {
							i = {
								["<Down>"] = false,
								["<Up>"] = false,
								["<C-j>"] = actions.move_selection_next,
								["<C-k>"] = actions.move_selection_previous,
							},
						},
					}),
					extensions = {},
				})
			end,
			requires = {
				{ "nvim-lua/plenary.nvim", after = "telescope.nvim" },
				{ "nvim-lua/popup.nvim", after = "telescope.nvim" },
				{
					"ahmedkhalf/project.nvim",
					after = "telescope.nvim",
					config = function()
						require("project_nvim").setup({})
						require("telescope").load_extension("projects")
					end,
				},
			},
		})

		use({
			"nvim-treesitter/nvim-treesitter",
			run = ":TSUpdate",
			config = function()
				local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()

				parser_configs.norg = {
					install_info = {
						url = "https://github.com/vhyrro/tree-sitter-norg",
						files = { "src/parser.c", "src/scanner.cc" },
						branch = "main",
					},
				}

				require("nvim-treesitter.configs").setup({
					context_commentstring = {
						enable = true,
					},
					ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
					highlight = { enable = true },
					indent = { enable = true },
					incremental_selection = {
						enable = true,
						keymaps = {
							init_selection = "gcc",
							scope_incremental = "gcc",
							node_incremental = "gcc",
							node_decremental = "gcr",
						},
					},
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
			end,
			requires = {
				"nvim-treesitter/playground",
				"nvim-treesitter/nvim-treesitter-textobjects",
				"JoosepAlviste/nvim-ts-context-commentstring",
			},
		})

		use({
			"szw/vim-maximizer",
			cmd = "MaximizerToggle",
		})

		use({
			"lukas-reineke/indent-blankline.nvim",
			event = "BufRead",
			config = function()
				require("indent_blankline").setup({
					show_current_context = true,
				})
			end,
		})

		use({
			"windwp/nvim-autopairs",
			event = "BufRead",
			config = function()
				require("nvim-autopairs").setup({
					fast_wrap = { map = "€" },
				})
				local cmp_autopairs = require("nvim-autopairs.completion.cmp")
				local cmp = require("cmp")
				cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
			end,
			after = "nvim-cmp",
		})

		use({
			"nacro90/numb.nvim",
			config = [[ require("numb").setup() ]],
		})

		use({
			"~/Developer/neorg",
			config = [[ require("configs.neorg") ]],
			requires = {
				"nvim-lua/plenary.nvim",
				"nvim-neorg/neorg-telescope",
			},
			branch = "gtd_base",
		})

		use({
			"rose-pine/neovim",
			as = "rose-pine",
			config = function()
				vim.g.rose_pine_variant = "moon"
				vim.g.rose_pine_enable_italics = true
				vim.g.rose_pine_disable_background = false
				vim.cmd([[ colorscheme rose-pine ]])
			end,
		})

		use({
			"nvim-lualine/lualine.nvim",
			config = function()
				require("lualine").setup({
					options = { theme = "rose-pine" },
				})
			end,
			requires = { "kyazdani42/nvim-web-devicons", opt = true },
		})

		use({
			"andweeb/presence.nvim",
			event = "BufRead",
			config = function()
				require("presence"):setup({
					main_image = "file",
				})
			end,
		})

		use({
			"~/Developer/neogen",
			event = "BufRead",
			module = "neogen",
			config = function()
				local setup = require("configs.neogen")
				require("neogen").setup(setup)
			end,
			requires = "nvim-treesitter/nvim-treesitter",
		})

		use({
			"folke/todo-comments.nvim",
			requires = "nvim-lua/plenary.nvim",
			config = [[ require("todo-comments").setup {} ]],
		})

		use({
			"hrsh7th/nvim-cmp",
			event = "InsertEnter",
			config = function()
				require("configs.cmp")
			end,
			module = "cmp",
			requires = {
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-cmdline",
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-path",
				"saadparwaiz1/cmp_luasnip",
				"L3MON4D3/LuaSnip",
				"onsails/lspkind-nvim",
			},
			after = "neogen",
		})

		use({
			"akinsho/toggleterm.nvim",
			config = function()
				require("toggleterm").setup({
					direction = "float",
					size = 90,
					persists = true,
					float_opts = {
						-- The border key is *almost* the same as 'nvim_win_open'
						-- see :h nvim_win_open for details on borders however
						-- the 'curved' border is a custom border type
						-- not natively supported but implemented in this plugin.
						border = "double",
						winblend = 3,
						highlights = {
							border = "Normal",
							background = "Normal",
						},
					},
				})
			end,
		})

		use({
			"MordechaiHadad/nvim-lspmanager",
			config = function()
				require("lspmanager").setup()
				require("telescope").load_extension("lspmanager")
				require("configs.lsp")
			end,
			requires = {
				"neovim/nvim-lspconfig",
				"folke/lua-dev.nvim",
				"ray-x/lsp_signature.nvim",
				"jose-elias-alvarez/null-ls.nvim",
			},
		})

		use({
			"ray-x/lsp_signature.nvim",
			config = function()
				require("lsp_signature").setup({
					bind = true,
					hint_prefix = "🧸 ",
					handler_opts = { border = "double" },
				})
			end,
			after = "nvim-lspmanager",
		})

		use({ "jbyuki/venn.nvim" })

		use({
			"weilbith/nvim-code-action-menu",
			event = "BufRead",
		})


		-- use({
		-- 	"narutoxy/themer.lua",
		-- 	branch = "dev",
		-- 	config = function()
		-- 		require("themer").setup({
		-- 			transparency = true,
		-- 			integrations = {
		-- 				cmp = true,
		-- 				gitsigns = true,
		-- 				telescope = true,
		-- 				indent_blankline = {
		-- 					enabled = true,
		-- 				},
		-- 			},
		-- 			extra_integrations = {
		-- 				lualine = true,
		-- 			},
		-- 		})
		-- 		require("themer").load("rose_pine_moon")
		-- 	end,
		-- })
	end,
	config = { compile_path = vim.fn.stdpath("config") .. "/lua/packer_compiled.lua" },
})
