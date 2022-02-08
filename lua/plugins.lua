-- Install packer if not found
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local packer_bootstrap
if fn.empty(fn.glob(install_path)) > 0 then
	packer_bootstrap = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
end
vim.cmd([[packadd packer.nvim]])

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

Wrequire = function(module)
	require(module)
end

return require("packer").startup({
	function(use)
		use("~/Developer/packer.nvim")

		use({ "lewis6991/impatient.nvim" })
		use("nvim-lua/plenary.nvim")

		use({
			"kyazdani42/nvim-tree.lua",
			cmd = "NvimTreeFocus",
			config = function()
				require("nvim-tree").setup({
					update_cwd = true,
				})
			end,
		})

		use({
			"lukas-reineke/indent-blankline.nvim",
			config = function()
				require("indent_blankline").setup({
					show_current_context = true,
				})
			end,
		})

		use({
			"nacro90/numb.nvim",
			config = function()
				require("numb").setup()
			end,
		})

		use({
			"rose-pine/neovim",
            -- "~/Developer/neovim/",
			as = "rose-pine",
			config = function()
				vim.g.rose_pine_variant = "moon"
				vim.g.rose_pine_bold_vertical_split_line = true
				vim.g.rose_pine_disable_float_background = true
				vim.cmd([[ colorscheme rose-pine ]])
			end,
		})

		use({
			"nvim-lualine/lualine.nvim",
			config = function()
				require("lualine").setup({
					options = { theme = "rose-pine-alt" },
				})
			end,
			requires = { "kyazdani42/nvim-web-devicons", opt = true },
		})

		use({
			"akinsho/toggleterm.nvim",
			config = function()
				require("toggleterm").setup({
					direction = "float",
					size = 90,
					float_opts = {
						border = "rounded",
					},
				})
			end,
		})

		use({
			"rcarriga/nvim-notify",
			config = function()
				vim.notify = require("notify")
			end,
		})

		use({
			"windwp/nvim-autopairs",
			event = "BufRead",
			config = function()
				require("nvim-autopairs").setup({
					fast_wrap = { map = "€" },
					map_cr = true,
				})
			end,
		})

		use({
			"~/Developer/neogen",
			config = function()
				require("neogen").setup({})
			end,
			requires = "nvim-treesitter/nvim-treesitter",
		})

		use({ "tpope/vim-surround", event = "BufRead" })

		use({ "tpope/vim-repeat", event = "BufRead" })

		use({
			"Iron-E/nvim-cmp",
			-- "hrsh7th/nvim-cmp",
			branch = "feat/completion-menu-borders",
			event = { "InsertEnter", "CmdlineEnter" },
			config = Wrequire("configs.cmp"),
			after = {
				"LuaSnip",
				"neogen",
				"lspkind-nvim",
			},
		})

		use({ "onsails/lspkind-nvim" })
		use({ "L3MON4D3/LuaSnip" })

		use({ "petertriho/cmp-git", after = "nvim-cmp" })
		use({ "hrsh7th/cmp-cmdline", after = "nvim-cmp" })
		use({ "hrsh7th/cmp-path", after = "nvim-cmp" })
		use({ "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" })
		use({ "hrsh7th/cmp-buffer", after = "nvim-cmp" })
		use({ "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" })

		use({
			"neovim/nvim-lspconfig",
			config = Wrequire("configs.lsp"),
			after = "nvim-cmp",
			requires = {
				"folke/lua-dev.nvim",
				"ray-x/lsp_signature.nvim",
				"jose-elias-alvarez/null-ls.nvim",
				"b0o/schemastore.nvim",
			},
		})

		use({
			"themaxmarchuk/tailwindcss-colors.nvim",
			config = function()
				require("tailwindcss-colors").setup()
			end,
		})

		use({
			"numToStr/Comment.nvim",
			config = function()
				require("Comment").setup({
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
			end,
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
								["<C-j>"] = actions.move_selection_next,
								["<C-k>"] = actions.move_selection_previous,

								["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
								["<C-a>"] = actions.send_to_qflist + actions.open_qflist,
							},
							n = {
								["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
								["<C-a>"] = actions.send_to_qflist + actions.open_qflist,
							},
						},
					}),
					extensions = {
						["ui-select"] = require("telescope.themes").get_cursor(),
					},
				})

				require("telescope").load_extension("ui-select")
				require("telescope").load_extension("project")
			end,
			requires = {
				"nvim-lua/popup.nvim",
				"nvim-telescope/telescope-project.nvim",
				"nvim-telescope/telescope-ui-select.nvim",
			},
		})

		use({
			"nvim-treesitter/nvim-treesitter",
			run = ":TSUpdate",
			config = function()
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

				require("nvim-treesitter.configs").setup({
					playground = { enable = true },
					-- ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
					ensure_installed = { "lua", "vim" },
					highlight = { enable = true, additional_vim_regex_highlighting = { "markdown" } },
					indent = { enable = true },
				})
			end,
		})

		use({ "nvim-treesitter/playground", after = "nvim-treesitter" })

		use({
			"~/Developer/neorg",
			-- "nvim-neorg/neorg",
			config = function()
				require("neorg").setup({
					load = {
						["core.defaults"] = {},
						["core.keybinds"] = { config = { neorg_leader = "<Leader>o" } },
						["core.norg.concealer"] = { config = { icon_preset = "diamond" } },
						["core.norg.dirman"] = {
							config = { workspaces = { main = "~/Documents/000 Meta/00.03 neorg/" } },
						},
						["core.gtd.base"] = { config = { workspace = "main", exclude = {} } },
						["external.integrations.gtd-things"] = {
							config = {
								things_db_path = "/Users/danielmathiot/Library/Group Containers/JLMPQHK86H.com.culturedcode.ThingsMac.beta/Things Database.thingsdatabase/main.sqlite",
								waiting_for_tag = "En attente",
							},
						},
						["core.presenter"] = { config = { zen_mode = "truezen" } },
						["core.integrations.telescope"] = {},
						["core.norg.completion"] = { config = { engine = "nvim-cmp" } },
					},
				})
			end,
			requires = {
				"nvim-neorg/neorg-telescope",
				"danymat/neorg-gtd-things",
			},
		})

		use({ "davidgranstrom/nvim-markdown-preview", ft = "markdown" })

		use({ "sindrets/diffview.nvim", cmd = "DiffviewOpen" })
		-- TODO: see if it's useful

		use({ "ggandor/lightspeed.nvim", event = "BufRead", after = "vim-repeat" })

		use({
			"echasnovski/mini.nvim",
			config = function()
				require("mini.doc").setup({})
			end,
		})

		use({
			"mickael-menu/zk-nvim",
			config = function()
				require("zk").setup({
					picker = "telescope",
					lsp = {
						config = {
							on_attach = function()
								local zk_lsp_client = require("zk.lsp").client()
								if zk_lsp_client then
									local zk_diagnostic_namespace = vim.lsp.diagnostic.get_namespace(zk_lsp_client.id)
									vim.diagnostic.config({ virtual_text = false }, zk_diagnostic_namespace)
								end
							end,
						},
					},
				})

				require("zk.commands").add("ZkStartingPoint", function(options)
					options = vim.tbl_extend("force", { match = "§§", exactMatch = true }, options or {})
					require("zk").edit(options, { title = "§§" })
				end)
			end,
		})

		use({
			"folke/todo-comments.nvim",
			cmd = "TodoTelescope",
			config = function()
				require("todo-comments").setup({})
			end,
		})

		if packer_bootstrap then
			require("packer").sync()
		end
	end,
	config = {
		display = {
			open_fn = function()
				return require("packer.util").float({ border = "rounded" })
			end,
		},
	},
})
