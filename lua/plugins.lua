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

        use({ "lewis6991/impatient.nvim" })
        use("nvim-lua/plenary.nvim")

        use({
            "kyazdani42/nvim-tree.lua",
            config = function()
                require("nvim-tree").setup({
                    update_cwd = true,
                })
            end,
            tag = "nightly",
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
                require("numb").setup({
                    centered_peeking = true,
                })
            end,
        })

        use({
            "rose-pine/neovim",
            as = "rose-pine",
            config = function()
                require("rose-pine").setup({
                    dark_variant = "moon",
                    bold_vert_split = true,
                    disable_float_background = true,
                })
                vim.cmd([[ colorscheme rose-pine ]])
            end,
        })

        use({
            "mvllow/modes.nvim",
            config = function()
                vim.opt.cursorline = true
                require("modes").setup()
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
            -- "danymat/neogen",
            "~/Developer/neogen/",
            config = function()
                require("neogen").setup({
                    snippet_engine = "luasnip",
                    languages = { python = { template = { annotation_convention = "reST" } } },
                })
            end,
            requires = "nvim-treesitter/nvim-treesitter",
        })

        use({ "tpope/vim-surround", event = "BufRead" })

        use({ "tpope/vim-repeat", event = "BufRead" })

        use({
            "hrsh7th/nvim-cmp",
            event = { "InsertEnter", "CmdlineEnter" },
            config = function()
                local cmp = require("cmp")
                local luasnip = Prequire("luasnip")
                local lspkind = Prequire("lspkind")

                local t = function(str)
                    return vim.api.nvim_replace_termcodes(str, true, true, true)
                end

                local mappings = {
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-n>"] = cmp.mapping.scroll_docs(4),
                    ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
                    ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
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
                    end, { "i", "n" }),
                    ["<C-l>"] = cmp.mapping(function(fallback)
                        if luasnip and luasnip.expand_or_jumpable() then
                            vim.fn.feedkeys(t("<Plug>luasnip-expand-or-jump"), "")
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<C-h>"] = cmp.mapping(function(fallback)
                        if luasnip and luasnip.jumpable(-1) then
                            vim.fn.feedkeys(t("<Plug>luasnip-jump-prev"), "")
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }

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

                    mapping = mappings,

                    sources = {
                        { name = "path" },
                        { name = "luasnip" },
                        { name = "nvim_lsp" },
                        { name = "buffer", keyword_length = 5, max_item_count = 5 },
                        { name = "neorg" },
                    },

                    experimental = {
                        ghost_text = true,
                    },
                }, { "i", "c", "s" })

                cmp.setup.filetype("gitcommit", {
                    sources = cmp.config.sources({
                        { name = "git" },
                    }, {
                        { name = "buffer" },
                    }),
                })

                cmp.setup.cmdline(":", {
                    mapping = cmp.mapping.preset.cmdline(),
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
                local zk = Prequire("zk")

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
                    buf_set_keymap("n", "<Leader>fs", ":lua vim.lsp.buf.format()<CR>", opts)

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
                    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
                end
                capabilities.offsetEncoding = { "utf-16" }
                local config = { on_attach = on_attach, capabilities = capabilities }

                local extend = function(lhs, rhs)
                    return vim.tbl_deep_extend("force", lhs, rhs)
                end

                if zk then
                    require("zk").setup({
                        picker = "telescope",
                        lsp = {
                            config = {
                                on_attach = function(_, bufnr)
                                    local zk_lsp_client = require("zk.lsp").client()
                                    on_attach(_, bufnr)
                                    if zk_lsp_client then
                                        local zk_diagnostic_namespace =
                                        vim.lsp.diagnostic.get_namespace(zk_lsp_client.id)
                                        vim.diagnostic.config({ virtual_text = false }, zk_diagnostic_namespace)
                                    end
                                end,
                            },
                        },
                    })
                end

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

                        return _config
                    end)()
                ))
                -- lspconfig.tailwindcss.setup(extend(config, {
                -- 	on_attach = function(_, bufnr)
                -- 		if tailwindcss_colors then
                -- 			tailwindcss_colors.buf_attach(bufnr)
                -- 		end
                -- 		on_attach(_, bufnr)
                -- 	end,
                -- }))
                lspconfig.pyright.setup(config)
            end,
            after = { "nvim-cmp", "neodev.nvim", "mason.nvim", "mason-lspconfig.nvim" },
            requires = {
                "ray-x/lsp_signature.nvim",
                "jose-elias-alvarez/null-ls.nvim",
                "mickael-menu/zk-nvim",
            },
        })

        use({
            "folke/neodev.nvim",
            config = function()
                require("neodev").setup({
                    library = {
                        types = true,
                        plugins = false, -- NOTE: if you wanna have completion for your plugins
                    },
                })
            end,
        })

        use({
            "jose-elias-alvarez/null-ls.nvim",
            config = function()
                require("null-ls").setup({
                    sources = {
                        require("null-ls").builtins.formatting.stylua,
                        require("null-ls").builtins.formatting.prettier,
                        require("null-ls").builtins.formatting.black,
                        require("null-ls").builtins.diagnostics.pylint,
                        -- require("null-ls").builtins.formatting.rustfmt
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
                        workspaces = {
                            keep_insert = true,
                        },
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
            "~/Developer/neorg",
            config = function()
                require("neorg").setup({
                    load = {
                        ["core.defaults"] = {},
                        -- ["core.gtd.base"] = { config = { workspace = "test" } },
                        ["core.keybinds"] = { config = { neorg_leader = "<Leader>o" } },
                        ["core.norg.concealer"] = { config = { icon_preset = "diamond" } },
                        ["core.norg.dirman"] = {
                            config = {
                                workspaces = {
                                    main = "~/Documents/000 Meta/00.03 neorg/",
                                },
                            },
                        },
                        -- ["external.integrations.gtd-things"] = {
                        -- 	config = {
                        -- 		things_db_path = "/Users/danielmathiot/Library/Group Containers/JLMPQHK86H.com.culturedcode.ThingsMac.beta/Things Database.thingsdatabase/main.sqlite",
                        -- 		waiting_for_tag = "En attente",
                        -- 	},
                        -- },
                        ["core.presenter"] = {
                            config = { zen_mode = "truezen", slide_count = { position = "bottom" } },
                        },
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
                require("zk.commands").add("ZkStartingPoint", function(options)
                    options = vim.tbl_extend("force", { match = "§§", matchStrategy = "exact" }, options or {})
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

        use({
            "ZhiyuanLck/smart-pairs",
            event = "InsertEnter",
            config = function()
                require("pairs"):setup({
                    mapping = {
                        jump_left_out_any = "<C-h>",
                        jump_right_out_any = "<C-l>",
                    },
                })
            end,
        })

        use({
            "folke/zen-mode.nvim",
            config = function()
                require("zen-mode").setup({})
            end,
        })

        use({
            "tamton-aquib/duck.nvim",
            config = function()
                vim.api.nvim_set_keymap("n", "<leader>dd", ':lua require("duck").hatch()<CR>', { noremap = true })
                vim.api.nvim_set_keymap("n", "<leader>dk", ':lua require("duck").cook()<CR>', { noremap = true })
            end,
        })

        use("Pocco81/TrueZen.nvim")

        use({
            "anuvyklack/windows.nvim",
            requires = {
                "anuvyklack/middleclass",
                "anuvyklack/animation.nvim",
            },
            config = function()
                vim.o.winwidth = 10
                vim.o.winminwidth = 10
                vim.o.equalalways = false
                require("windows").setup()
            end,
        })

        use({
            "folke/noice.nvim",
            event = "VimEnter",
            config = function()
                require("noice").setup({
                    cmdline = {
                        view = "cmdline",
                    },
                    notify = {
                        enabled = true,
                    },
                    lsp = {
                        signature = {
                            enabled = false,
                        },
                    },
                })
            end,
            requires = {
                -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
                "MunifTanjim/nui.nvim",
                "rcarriga/nvim-notify",
                "neovim/nvim-lspconfig",
            },
        })

        use({
            "williamboman/mason.nvim",
            config = function()
                require("mason").setup()
            end,
        })

        use({
            "williamboman/mason-lspconfig.nvim",
            config = function()
                require("mason-lspconfig").setup()
            end,
            after = {
                "mason.nvim",
            },
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
