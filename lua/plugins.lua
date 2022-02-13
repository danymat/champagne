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
		use("wbthomason/packer.nvim")

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
			"danymat/neogen",
			config = function()
				require("neogen").setup({})
				require("neogen").get_template("python"):config({ annotation_convention = "numpydoc" })
			end,
			requires = "nvim-treesitter/nvim-treesitter",
			--tag = "*"
		})

		use({ "tpope/vim-surround", event = "BufRead" })

		use({ "tpope/vim-repeat", event = "BufRead" })

		use({
			"Iron-E/nvim-cmp",
			-- "hrsh7th/nvim-cmp",
			branch = "feat/completion-menu-borders",
			event = { "InsertEnter", "CmdlineEnter" },
			config = function()
				local cmp = require("cmp")
				local luasnip = Prequire("luasnip")
				local lspkind = Prequire("lspkind")
				local neogen = Prequire("neogen")

				local t = function(str)
					return vim.api.nvim_replace_termcodes(str, true, true, true)
				end

				cmp.setup({
					completion = {
						border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
						scrollbar = "║",
					},
					window = {
						documentation = { border = "rounded", scrollbar = "║" },
						completion = { border = "rounded", scrollbar = "║" },
					},
					formatting = {
						fields = { cmp.ItemField.Kind, cmp.ItemField.Abbr, cmp.ItemField.Menu },
						format = lspkind.cmp_format({ with_text = false }),
					},
					snippet = {
						expand = function(args)
							if luasnip then
								require("luasnip").lsp_expand(args.body)
							end
						end,
					},

					mapping = {
						["<C-j>"] = cmp.mapping(
							cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
							{ "i", "s", "c" }
						),
						["<C-k>"] = cmp.mapping(
							cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
							{ "i", "s", "c" }
						),
						["<Tab>"] = cmp.mapping(function(fallback)
							-- This little snippet will confirm with tab, and if no entry is selected, will confirm the first item
							if cmp.visible() then
								local entry = cmp.get_selected_entry()
								if not entry then
									cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
								end
								cmp.confirm()
							else
								fallback()
							end
						end, {
							"i",
							"s",
							"c",
						}),
						["<C-l>"] = cmp.mapping(function(fallback)
							if luasnip and luasnip.expand_or_jumpable() then
								vim.fn.feedkeys(t("<Plug>luasnip-expand-or-jump"), "")
							elseif neogen and neogen.jumpable() then
								neogen.jump_next()
							else
								fallback()
							end
						end, {
							"i",
							"s",
						}),
						["<C-h>"] = cmp.mapping(function(fallback)
							if luasnip and luasnip.jumpable(-1) then
								vim.fn.feedkeys(t("<Plug>luasnip-jump-prev"), "")
							elseif neogen and neogen.jumpable(-1) then
								neogen.jump_prev()
							else
								fallback()
							end
						end, {
							"i",
							"s",
						}),
					},

					-- You should specify your *installed* sources.
					sources = {
						{ name = "cmp_git" },
						{ name = "path" },
						{ name = "luasnip" },
						{ name = "nvim_lsp" },
						{ name = "buffer", keyword_length = 5, max_item_count = 5 },
						{ name = "neorg" },
					},

					experimental = {
						ghost_text = true,
					},
				})

				cmp.setup.cmdline(":", {
					sources = {
						{ name = "cmdline", keyword_length = 2 },
					},
				})
			end,
			after = {
				"LuaSnip",
				"neogen",
				"lspkind-nvim",
			},
		})

		use({ "onsails/lspkind-nvim" })
		use({
			"L3MON4D3/LuaSnip",
			config = function()
				-- Do not jump to snippet if i'm outside of it
				-- https://github.com/L3MON4D3/LuaSnip/issues/78
				require("luasnip").config.setup({
					region_check_events = "CursorMoved",
					delete_check_events = "TextChanged",
				})
			end,
		})

		use({
			"petertriho/cmp-git",
			after = "nvim-cmp",
			config = function()
				require("cmp_git").setup()
			end,
		})
		use({ "hrsh7th/cmp-cmdline", after = "nvim-cmp" })
		use({ "hrsh7th/cmp-path", after = "nvim-cmp" })
		use({ "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" })
		use({ "hrsh7th/cmp-buffer", after = "nvim-cmp" })
		use({ "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" })

		use({
			"neovim/nvim-lspconfig",
			config = function()
				local lspconfig = require("lspconfig")
				local lsp_signature = Prequire("lsp_signature")
				local cmp_nvim_lsp = Prequire("cmp_nvim_lsp")
				local tailwindcss_colors = Prequire("tailwindcss-colors")
				local schemastore = Prequire("schemastore")
				local luadev = Prequire("lua-dev")

				local on_attach = function(_, bufnr)
					local function buf_set_keymap(...)
						vim.api.nvim_buf_set_keymap(bufnr, ...)
					end
					local opts = { noremap = true, silent = true }
					-- See `:help vim.lsp.*` for documentation on any of the below functions
					buf_set_keymap("n", "<leader>gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
					buf_set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
					buf_set_keymap("n", "<Leaser>gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
					buf_set_keymap("n", "<leader>gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
					buf_set_keymap("n", "<leader>r", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
					buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
					buf_set_keymap("n", "<C-b>", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
					buf_set_keymap("n", "<C-n>", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
					buf_set_keymap("n", "<Leader>fs", ":lua vim.lsp.buf.formatting_sync()<CR>", opts)

					if lsp_signature then
						lsp_signature.on_attach({
							bind = true,
							hint_prefix = "🧸 ",
							handler_opts = { border = "rounded" },
						}, bufnr)
					end
				end

				-- Add completion capabilities (completion, snippets)
				local capabilities = vim.lsp.protocol.make_client_capabilities()
				if cmp_nvim_lsp then
					capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
				end
				capabilities.offsetEncoding = { "utf-16" }
				local config = { on_attach = on_attach, capabilities = capabilities }

				local extend = function(lhs, rhs)
					return vim.tbl_deep_extend("force", lhs, rhs)
				end

				-- See https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md for more lsp servers
				lspconfig.bashls.setup(config)
				lspconfig.pyright.setup(config)
				lspconfig.vuels.setup(config)
				lspconfig.tsserver.setup(config)
				lspconfig.phpactor.setup(config)
				lspconfig.clangd.setup(config)
				lspconfig.yamlls.setup(extend(config, {
					settings = {
						yaml = {
							schemas = {
								["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "/docker-compose.yml",
							},
						},
					},
				}))
				lspconfig.jsonls.setup(extend(config, {
					settings = {
						json = {
							schemas = schemastore and schemastore.json.schemas(),
						},
					},
				}))
				lspconfig.sumneko_lua.setup(extend(
					config,
					(function()
						-- Local config for lua development
						local _config = {}

						-- Configure lua language server for neovim development
						local runtime_path = vim.split(package.path, ";")
						table.insert(runtime_path, "lua/?.lua")
						table.insert(runtime_path, "lua/?/init.lua")

						local lua_settings = {
							Lua = {
								runtime = {
									-- LuaJIT in the case of Neovim
									version = "LuaJIT",
									path = runtime_path,
								},
								diagnostics = {
									-- Get the language server to recognize the `vim` global
									globals = { "vim", "P", "G" },
								},
								telemetry = { enable = false },
								workspace = {
									preloadFileSize = 180,
									-- Make the server aware of Neovim runtime files
									library = vim.api.nvim_get_runtime_file("", true),
								},
							},
						}
						if luadev then
							local _luadev_config = luadev.setup({
								library = {
									vimruntime = true,
									types = true,
									plugins = false,
								},
								lspconfig = lua_settings,
							})
							_config = vim.tbl_deep_extend("force", _config, _luadev_config)
						else
							_config = vim.tbl_deep_extend("force", _config, lua_settings)
						end

						return _config
					end)()
				))
				lspconfig.tailwindcss.setup(extend(config, {
					on_attach = function(_, bufnr)
						if tailwindcss_colors then
							tailwindcss_colors.buf_attach(bufnr)
						end
						on_attach(_, bufnr)
					end,
				}))
			end,
			after = "nvim-cmp",
			requires = {
				"folke/lua-dev.nvim",
				"ray-x/lsp_signature.nvim",
				"jose-elias-alvarez/null-ls.nvim",
				"b0o/schemastore.nvim",
			},
		})

		use({
			"jose-elias-alvarez/null-ls.nvim",
			config = function()
				require("null-ls").setup({
					debug = true,
					sources = {
						require("null-ls").builtins.formatting.stylua,
						require("null-ls").builtins.formatting.prettier,
						require("null-ls").builtins.code_actions.gitsigns,
					},
				})
			end,
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
				require("telescope").load_extension("fzf")
				require("telescope").load_extension("workspaces")
			end,
			requires = {
				"nvim-lua/popup.nvim",
				"nvim-telescope/telescope-ui-select.nvim",
				"nvim-telescope/telescope-fzf-native.nvim",
				"natecraddock/workspaces.nvim",
			},
		})

		use({
			"natecraddock/workspaces.nvim",
			config = function()
				require("workspaces").setup({
					hooks = {
						open = { "Telescope find_files" },
					},
				})
			end,
		})

		use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })

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
			"nvim-neorg/neorg",
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
							on_attach = function(_, buffer)
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
