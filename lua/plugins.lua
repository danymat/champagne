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

return require("packer").startup({
	function(use)
		use("wbthomason/packer.nvim")

		-- Themes and UI
		use({ "preservim/nerdtree", cmd = "NERDTreeFocus" })
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
			"nacro90/numb.nvim",
			event = "BufRead",
			config = [[ require("numb").setup() ]],
		})
		use({
			"~/Developer/neovim",
			as = "rose-pine",
			config = [[ require('configs.rose-pine') ]],
		})
		use({
			"nvim-lualine/lualine.nvim",
			config = function()
				require("lualine").setup({
					options = { theme = "rose-pine" },
					-- options = { theme = "catppuccin" },
				})
			end,
			requires = { "kyazdani42/nvim-web-devicons", opt = true },
		})
		use({
			"folke/todo-comments.nvim",
			event = "BufRead",
			requires = "nvim-lua/plenary.nvim",
			config = [[ require("todo-comments").setup {} ]],
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
						border = "rounded",
						winblend = 3,
						highlights = {
							border = "Normal",
							background = "Normal",
						},
					},
				})
			end,
		})
		use({ "Pocco81/TrueZen.nvim", event = "BufRead" })
		use({
			"rcarriga/nvim-notify",
			config = function()
				vim.notify = require("notify")
			end,
		})

		-- Mappings
		use({
			"windwp/nvim-autopairs",
			event = "BufRead",
			config = [[ require('configs.nvim-autopairs') ]],
			after = "nvim-cmp",
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
		use("tpope/vim-surround")
		use("tpope/vim-repeat")

		-- Completion
		use({
			-- "Iron-E/nvim-cmp",
			"hrsh7th/nvim-cmp",
			event = { "InsertEnter", "CmdlineEnter" },
			-- branch = "feat/completion-menu-borders",
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
				{ "petertriho/cmp-git", requires = "nvim-lua/plenary.nvim" },
			},
			after = "neogen",
		})

		-- LSP
		use({
			"neovim/nvim-lspconfig",
			config = function()
				require("configs.lsp")
			end,
		})
		use({
			"folke/lua-dev.nvim",
			"ray-x/lsp_signature.nvim",
			"jose-elias-alvarez/null-ls.nvim",
		})

		use({
			"themaxmarchuk/tailwindcss-colors.nvim",
			config = function()
				-- pass config options here (or nothing to use defaults)
				require("tailwindcss-colors").setup()
			end,
		})

		-- Misc
		use("lewis6991/impatient.nvim")
		use({ "numToStr/Comment.nvim", event = "BufRead", config = [[ require('configs.comment-nvim')]] })
		use({
			"lewis6991/gitsigns.nvim",
			config = [[ require('configs.gitsigns') ]],
			requires = "nvim-lua/plenary.nvim",
			event = "BufRead",
		})

		-- TreeSitter, Telescope, Neorg
		use({
			"nvim-telescope/telescope.nvim",
			config = [[ require('configs.telescope_config') ]],
			requires = {
				{ "nvim-lua/plenary.nvim", after = "telescope.nvim" },
				{ "nvim-lua/popup.nvim", after = "telescope.nvim" },
				{
					"nvim-telescope/telescope-project.nvim",
					after = "telescope.nvim",
					config = function()
						require("telescope").load_extension("project")
					end,
				},
				{
					"nvim-telescope/telescope-file-browser.nvim",
					after = "telescope.nvim",
					config = function()
						require("telescope").load_extension("file_browser")
					end,
				},
				{
					"nvim-telescope/telescope-ui-select.nvim",
					after = "telescope.nvim",
					config = function()
						require("telescope").load_extension("ui-select")
					end,
				},
				{
					"dhruvmanila/telescope-bookmarks.nvim",
					after = "telescope.nvim",
					config = function()
						require("telescope").setup({
							extensions = {
								bookmarks = {
									selected_browser = "safari",

									-- Or provide the plugin name which is already installed
									-- Available: 'vim_external', 'open_browser'
									url_open_plugin = nil,

									-- Show the full path to the bookmark instead of just the bookmark name
									full_path = true,
								},
							},
						})
						require("telescope").load_extension("bookmarks")
					end,
				},
			},
		})
		use({
			"nvim-treesitter/nvim-treesitter",
			run = ":TSUpdate",
			config = [[ require('configs.nvim-treesitter') ]],
			requires = {
				"nvim-treesitter/playground",
				"nvim-treesitter/nvim-treesitter-textobjects",
				"JoosepAlviste/nvim-ts-context-commentstring",
			},
		})
		use({
			"~/Developer/neorg",
			config = [[ require("configs.neorg") ]],
			requires = {
				"nvim-lua/plenary.nvim",
				"nvim-neorg/neorg-telescope",
				"~/Developer/neorg-gtd-things",
			},
		})

		use({
			"catppuccin/nvim",
			as = "catppuccin",
			branch = "experiments",
			config = function()
				local catppuccin = require("catppuccin")

				-- configure it
				catppuccin.setup({
					transparent_background = false,
					term_colors = true,
					styles = {
						comments = "italic",
						functions = "italic",
						keywords = "italic",
						strings = "NONE",
						variables = "NONE",
					},
					integrations = {
						treesitter = true,
						native_lsp = {
							enabled = true,
							virtual_text = {
								errors = "italic",
								hints = "italic",
								warnings = "italic",
								information = "italic",
							},
							underlines = {
								errors = "underline",
								hints = "underline",
								warnings = "underline",
								information = "underline",
							},
						},
						gitsigns = true,
						telescope = true,
						indent_blankline = {
							enabled = true,
							colored_indent_levels = false,
						},
						markdown = true,
					},
				})
			end,
		})

		use({ "davidgranstrom/nvim-markdown-preview", ft = "markdown" })

		use({
			"abecodes/tabout.nvim",
			config = function()
				require("tabout").setup({
					tabkey = "",
					backwards_tabkey = "",
					act_as_tab = false,
				})
			end,
			wants = { "nvim-treesitter" }, -- or require if not used so far
			after = { "nvim-cmp" }, -- if a completion plugin is using tabs load it before
		})

		use({
			"akinsho/bufferline.nvim",
			config = function()
				local p = require("rose-pine.palette")
				require("bufferline").setup({
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
			end,
		})

		if packer_bootstrap then
			require("packer").sync()
		end
	end,
})
