local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--single-branch",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end
vim.opt.runtimepath:prepend(lazypath)

vim.g.mapleader = " "
vim.o.relativenumber = true
vim.o.number = true
vim.o.undofile = true
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.completeopt = "menu,menuone,noselect"
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.o.termguicolors = true
vim.o.conceallevel = 2
vim.o.cmdheight = 0
vim.o.foldenable = false

local map = vim.keymap.set
map("n", "<Leader>so", ":so %<CR>")
map("n", "<Leader>h", ":wincmd h<CR>")
map("n", "<Leader>j", ":wincmd j<CR>")
map("n", "<Leader>k", ":wincmd k<CR>")
map("n", "<Leader>l", ":wincmd l<CR>")
map("n", "<Leader>fs", vim.lsp.buf.format)
map("n", "K", vim.lsp.buf.hover)
map("n", "<leader>r", vim.lsp.buf.rename)
map("n", "<C-n>", vim.diagnostic.goto_next)
map("n", "<C-b>", vim.diagnostic.goto_prev)
map("n", "<C-j>", "<C-d>zz")
map("n", "<C-k>", "<C-u>zz")
map("t", "<Esc>", "<C-\\><C-n>")
map("n", "<Leader>=", "<C-^>")
map("n", "<Leader>gs", function()
    require("lazy.util").open_cmd({ "lazygit" }, {
        -- cwd = plugin.dir,
        terminal = true,
        close_on_exit = true,
        enter = true,
    })
end)

require("lazy").setup({
    "nvim-lua/plenary.nvim",
    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = { dark_variant = "moon" },
        init = function()
            vim.cmd("colorscheme rose-pine")
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = function()
            require("nvim-treesitter.install").update({ with_sync = true })()
        end,
        config = function()
            require("nvim-treesitter.configs").setup({
                highlight = { enable = true },
            })
        end,
    },
    "nvim-treesitter/playground",
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        keys = {
            { "<C-f>", ":Telescope find_files<CR>" },
            { "<Leader>ff", ":Telescope live_grep<CR>" },
            { "<Leader>fb", ":Telescope buffers<CR>" },
            { "<Leader>fh", ":Telescope help_tags<CR>" },
            { "<leader>gr", ":Telescope lsp_references<CR>" },
            { "<leader>gd", ":Telescope lsp_definitions<CR>" },
            { "<C-a>", ":Telescope lsp_document_symbols symbols=func,function,class<CR>" },
            { "<Leader>aa", ":lua vim.lsp.buf.code_action()<CR>" },
            { "<Leader>p", ":Telescope workspaces<CR>" },
        },
        dependencies = "natecraddock/workspaces.nvim",
        config = function()
            local telescope = require("telescope")
            telescope.load_extension("workspaces")
            telescope.setup({
                extensions = {
                    workspaces = {
                        -- keep insert mode after selection in the picker, default is false
                        keep_insert = true,
                    },
                },
            })
        end,
    },
    { "windwp/nvim-autopairs", config = true },
    "kyazdani42/nvim-web-devicons",
    { "nvim-lualine/lualine.nvim", config = true },
    { "lukas-reineke/indent-blankline.nvim", config = { show_current_context = true } },
    "sindrets/diffview.nvim",
    {
        "numToStr/Comment.nvim",
        config = {
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
        },
    },
    {
        "nvim-tree/nvim-tree.lua",
        config = true,
        keys = {
            {
                "<Leader>t",
                function()
                    require("nvim-tree.api").tree.toggle()
                end,
            },
        },
    },
    { "ray-x/lsp_signature.nvim", config = { hint_prefix = "🧸 " } },
    { "kylechui/nvim-surround", config = true },
    {
        "mickael-menu/zk-nvim",
        name = "zk",
        config = function()
            require("zk").setup({ picker = "telescope" })
            require("zk.commands").add("ZkStartingPoint", function(options)
                options = vim.tbl_extend("force", { match = "§§", matchStrategy = "exact" }, options or {})
                require("zk").edit(options, { title = "§§" })
            end)
        end,
        keys = {
            {
                "<Leader>--",
                function()
                    require("zk.commands").get("ZkStartingPoint")()
                end,
            },
            {
                "<Leader>zk",
                function()
                    require("zk.commands").get("ZkNotes")()
                end,
            },
            {
                "<Leader>zb",
                function()
                    require("zk.commands").get("ZkBacklinks")()
                end,
            },
            {
                "<Leader>zi",
                function()
                    require("zk.commands").get("ZkLinks")()
                end,
            },
            {
                "<Leader>zt",
                function()
                    require("zk.commands").get("ZkTags")({ sort = { "note-count" } })
                end,
            },
            {
                "<Leader>zn",
                function()
                    require("zk.commands").get("ZkNew")({ title = vim.fn.input("Title: ") })
                end,
            },
        },
    },
    {
        "danymat/neogen",
        config = { snippet_engine = "luasnip", languages = { lua = { annotation_convention = "ldoc" } } },
        keys = {
            { "<Leader>nf", ":Neogen func<CR>" },
        },
        dev = true,
    },
    { "folke/todo-comments.nvim", config = true },
    { "tpope/vim-repeat" },
    {
        "nvim-neorg/neorg",
        config = {
            load = {
                ["core.defaults"] = {},
                ["core.norg.concealer"] = {},
            },
        },
        dev = true,
    },
    {
        "shortcuts/no-neck-pain.nvim",
        version = "*",
        config = {
            buffers = {
                background = { colorCode = "rose-pine-moon" },
            },
        },
        keys = {
            { "<Leader>zz", ":NoNeckPain<CR>" },
        },
    },
    {
        "VonHeikemen/lsp-zero.nvim",
        config = function()
            local lsp = require("lsp-zero")
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            lsp.preset("recommended")
            lsp.nvim_workspace()
            lsp.setup()

            local cmp_config = lsp.defaults.cmp_config({
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },

                mapping = cmp.mapping.preset.insert({
                    ["<C-j>"] = cmp.mapping.select_next_item(),
                    ["<C-k>"] = cmp.mapping.select_prev_item(),
                    ["<Tab>"] = cmp.mapping.confirm({ select = true }),
                    ["<C-l>"] = cmp.mapping(function(fallback)
                        if luasnip and luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<C-h>"] = cmp.mapping(function(fallback)
                        if luasnip and luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),

                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" }, -- For luasnip users.
                }, {
                    { name = "buffer" },
                }),
            })
            cmp.setup(cmp_config)

            require("mason-null-ls").setup({ automatic_setup = true })
            require("mason-null-ls").setup_handlers()
        end,
        dependencies = {
            -- LSP Support
            "neovim/nvim-lspconfig",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",

            -- Autocompletion
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lua",

            -- Snippets
            "L3MON4D3/LuaSnip",
            "rafamadriz/friendly-snippets",

            --null-ls
            "jose-elias-alvarez/null-ls.nvim",
            "jayp0521/mason-null-ls.nvim",
        },
    },
    {
        "natecraddock/workspaces.nvim",
        config = {
            hooks = {
                open = { "Telescope find_files" },
            },
        },
    },
    { "j-hui/fidget.nvim", config = true },
    { "AckslD/nvim-neoclip.lua", dependencies = "nvim-telescope/telescope.nvim", config = true },
},
    {
        dev = { path = "~/Developer" },
    }
)
