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
			event = "BufRead",
			config = Wrequire("configs.numb"),
		})

		use({
			"~/Developer/neovim",
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
			event = "BufRead",
			requires = "nvim-lua/plenary.nvim",
			config = Wrequire("configs.todo-comments"),
		})

		use({
			"akinsho/toggleterm.nvim",
			config = Wrequire("configs.toggleterm"),
		})

		use({ "Pocco81/TrueZen.nvim", event = "BufRead" })

		use({
			"rcarriga/nvim-notify",
			config = Wrequire("configs.nvim-notify"),
		})

		-- Mappings
		use({
			"windwp/nvim-autopairs",
			event = "BufRead",
			config = Wrequire("configs.nvim-autopairs"),
			after = "nvim-cmp",
		})
		use({
			"~/Developer/neogen",
			event = "BufRead",
			module = "neogen",
			config = Wrequire("configs.neogen"),
			requires = "nvim-treesitter/nvim-treesitter",
		})

		use("tpope/vim-surround")
		use("tpope/vim-repeat")

		-- Completion
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

        use({ "onsails/lspkind-nvim"})

        use({ "L3MON4D3/LuaSnip"})
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
			--config = Wrequire("configs.tailwindcss-colors")
		})

		-- Misc
		use("lewis6991/impatient.nvim")
		use({
			"numToStr/Comment.nvim",
			event = "BufRead",
			config = Wrequire("configs.comment-nvim"),
		})

		use({
			"lewis6991/gitsigns.nvim",
			config = Wrequire("configs.gitsigns"),
			requires = "nvim-lua/plenary.nvim",
			event = "BufRead",
		})

		use({
			"nvim-telescope/telescope.nvim",
			config = Wrequire("configs.telescope_config"),
			requires = {
				{ "nvim-lua/plenary.nvim", after = "telescope.nvim" },
				{ "nvim-lua/popup.nvim", after = "telescope.nvim" },
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
            after = "nvim-treesitter"
        })
        use({
            "nvim-treesitter/nvim-treesitter-textobjects",
            after = "nvim-treesitter"
        })
        use({
            "JoosepAlviste/nvim-ts-context-commentstring",
            after = "nvim-treesitter"
        })

		use({
			"~/Developer/neorg",
			config = Wrequire("configs.neorg"),
			requires = {
				"nvim-lua/plenary.nvim",
				"nvim-neorg/neorg-telescope",
				"~/Developer/neorg-gtd-things",
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
			requires = "rose-pine",
		})

		if packer_bootstrap then
			require("packer").sync()
		end
	end,
})
