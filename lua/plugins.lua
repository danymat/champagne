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

Wrequire = function(module)
	require(module)
end

return require("packer").startup({
	function(use)
		use("wbthomason/packer.nvim")

		use("lewis6991/impatient.nvim")

		-- Themes and UI
		use({ "preservim/nerdtree", cmd = "NERDTreeFocus" })

		use({
			"szw/vim-maximizer",
			cmd = "MaximizerToggle",
		})
		use({
			"lukas-reineke/indent-blankline.nvim",
			config = Wrequire("configs.indent_blankline"),
		})

		use({
			"nacro90/numb.nvim",
			config = Wrequire("configs.numb"),
		})

		use({
			"rose-pine/neovim",
			as = "rose-pine",
			config = Wrequire("configs.rose-pine"),
		})
		use({
			"nvim-lualine/lualine.nvim",
			config = Wrequire("configs.lualine"),
			requires = { "kyazdani42/nvim-web-devicons", opt = true },
		})

		use({
			"folke/todo-comments.nvim",
			requires = "nvim-lua/plenary.nvim",
			config = Wrequire("configs.todo-comments"),
		})

		use({
			"akinsho/toggleterm.nvim",
			config = Wrequire("configs.toggleterm"),
		})

		use({
			"rcarriga/nvim-notify",
			config = Wrequire("configs.nvim-notify"),
		})

		use({
			"windwp/nvim-autopairs",
			config = Wrequire("configs.nvim-autopairs"),
		})

		use({
			"danymat/neogen",
			config = Wrequire("configs.neogen"),
			requires = "nvim-treesitter/nvim-treesitter",
		})

		use("tpope/vim-surround")
		use("tpope/vim-repeat")

		use({
			-- "Iron-E/nvim-cmp",
			-- branch = "feat/completion-menu-borders",
			"hrsh7th/nvim-cmp",
			event = { "InsertEnter", "CmdlineEnter" },
			config = Wrequire("configs.cmp"),
			module = "cmp",
			after = {
				"LuaSnip",
				"neogen",
				"lspkind-nvim",
			},
		})

		use({ "onsails/lspkind-nvim" })

		use({ "L3MON4D3/LuaSnip" })
		use({
			"petertriho/cmp-git",
			after = "nvim-cmp",
		})
		use({
			"hrsh7th/cmp-cmdline",
			after = "nvim-cmp",
		})
		use({
			"hrsh7th/cmp-path",
			after = "nvim-cmp",
		})
		use({
			"hrsh7th/cmp-nvim-lsp",
			after = "nvim-cmp",
		})
		use({
			"hrsh7th/cmp-buffer",
			after = "nvim-cmp",
		})
		use({
			"saadparwaiz1/cmp_luasnip",
			after = "nvim-cmp",
		})

		use({
			"neovim/nvim-lspconfig",
			config = Wrequire("configs.lsp"),
			after = "nvim-cmp",
		})

		use({
			"folke/lua-dev.nvim",
			"ray-x/lsp_signature.nvim",
			"jose-elias-alvarez/null-ls.nvim",
		})

		use({
			"themaxmarchuk/tailwindcss-colors.nvim",
			config = Wrequire("configs.tailwindcss-colors"),
		})


		use({
			"numToStr/Comment.nvim",
			config = function()
				require("configs.comment-nvim")
			end,
		})

		use({
			"lewis6991/gitsigns.nvim",
			config = Wrequire("configs.gitsigns"),
			requires = "nvim-lua/plenary.nvim",
		})

		use({
			"nvim-telescope/telescope.nvim",
			config = Wrequire("configs.telescope_config"),
			requires = {
				"nvim-lua/plenary.nvim",
				"nvim-lua/popup.nvim",
				"nvim-telescope/telescope-project.nvim",
				"nvim-telescope/telescope-file-browser.nvim",
				"nvim-telescope/telescope-ui-select.nvim",
				"dhruvmanila/telescope-bookmarks.nvim",
			},
		})
		use({
			"nvim-treesitter/nvim-treesitter",
			run = ":TSUpdate",
			config = Wrequire("configs.nvim-treesitter"),
		})

		use({
			"nvim-treesitter/playground",
			after = "nvim-treesitter",
		})
		use({
			"nvim-treesitter/nvim-treesitter-textobjects",
			after = "nvim-treesitter",
		})
		use({
			"JoosepAlviste/nvim-ts-context-commentstring",
			after = "nvim-treesitter",
		})

		use({
			"nvim-neorg/neorg",
			config = Wrequire("configs.neorg"),
			requires = {
				"nvim-lua/plenary.nvim",
				"nvim-neorg/neorg-telescope",
				"danymat/neorg-gtd-things",
			},
		})

		use({ "davidgranstrom/nvim-markdown-preview", ft = "markdown" })

		use({
			"abecodes/tabout.nvim",
			config = Wrequire("configs.tabout"),
			require = { "nvim-treesitter" },
		})

		use({
			"akinsho/bufferline.nvim",
			config = Wrequire("configs.bufferline"),
			after = "rose-pine",
		})

		if packer_bootstrap then
			require("packer").sync()
		end
	end,
})
