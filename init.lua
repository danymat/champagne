-- For help on configuration, check help on vim.g.*
-- Ex: vim.g.mapleader -> :help mapleader
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


local ok, builtin = pcall(require, "telescope.builtin")
if ok then
    map("n", "<C-f>", builtin.find_files, {})
    map("n", "<leader>ff", builtin.live_grep, {})
    map("n", "<leader>fb", builtin.buffers, {})
    map("n", "<leader>fh", builtin.help_tags, {})
    map("n", "<leader>gr", ":Telescope lsp_references<CR>")
    map("n", "<leader>gd", ":Telescope lsp_definitions<CR>")
    map("n", "<C-a>", ":Telescope lsp_document_symbols symbols=func,function,class<CR>")
    map("n", "<Leader>aa", ':lua vim.lsp.buf.code_action()<CR>')
end

ok, _ = pcall(require, "packer")
if ok then
    map("n", "<Leader>sc", ":so % | PackerCompile<CR>")
end

local _ok, _ = pcall(require, "zk.commands")
if _ok then
    map("n", "<Leader>--", function() require("zk.commands").get("ZkStartingPoint")() end)
    map("n", "<Leader>zk", function() require("zk.commands").get("ZkNotes")() end)
    map("n", "<Leader>zb", function() require("zk.commands").get("ZkBacklinks")() end)
    map("n", "<Leader>zi", function() require("zk.commands").get("ZkLinks")() end)
    map("n", "<Leader>zt", function()
        require("zk.commands").get("ZkTags") { sort = { "note-count" } }
    end)
    map("n", "<Leader>zn", function() require("zk.commands").get("ZkNew")({ title = vim.fn.input("Title: ") }) end)
end

local ok, nvim_tree = pcall(require, "nvim-tree.api")
if ok then
    map("n", "<Leader>t", nvim_tree.tree.toggle)
end

local ok, neogen = pcall(require, "neogen")
if ok then
    map("n", "<Leader>nf", function() neogen.generate() end)
end

vim.cmd([[packadd packer.nvim]])
require("packer").startup(function(use)
    --
    -- MANDATORY
    --
    use("wbthomason/packer.nvim")
    use("nvim-lua/plenary.nvim")
    use({ "rose-pine/neovim", as = "rose-pine" })
    use({
        "nvim-treesitter/nvim-treesitter",
        run = function()
            require("nvim-treesitter.install").update({ with_sync = true })()
        end,
    })
    use({ "nvim-telescope/telescope.nvim" })
    use({ "jose-elias-alvarez/null-ls.nvim" })
    use({ "jayp0521/mason-null-ls.nvim" })
    use("windwp/nvim-autopairs")

    use("kyazdani42/nvim-web-devicons")
    use("nvim-lualine/lualine.nvim")
    use("lukas-reineke/indent-blankline.nvim")
    use("sindrets/diffview.nvim")
    use("numToStr/Comment.nvim")
    use("nvim-tree/nvim-tree.lua")
    use("ray-x/lsp_signature.nvim")
    use("kylechui/nvim-surround")
    use("mickael-menu/zk-nvim")
    use("danymat/neogen")
    use("folke/todo-comments.nvim")
    use("tpope/vim-repeat")
    use("ggandor/leap.nvim")
    use("nvim-neorg/neorg")

    use {
  'VonHeikemen/lsp-zero.nvim',
  requires = {
    -- LSP Support
    {'neovim/nvim-lspconfig'},
    {'williamboman/mason.nvim'},
    {'williamboman/mason-lspconfig.nvim'},

    -- Autocompletion
    {'hrsh7th/nvim-cmp'},
    {'hrsh7th/cmp-buffer'},
    {'hrsh7th/cmp-path'},
    {'saadparwaiz1/cmp_luasnip'},
    {'hrsh7th/cmp-nvim-lsp'},
    {'hrsh7th/cmp-nvim-lua'},

    -- Snippets
    {'L3MON4D3/LuaSnip'},
    {'rafamadriz/friendly-snippets'},
  }
}


    local luasnip = require("luasnip")
    local cmp = require("cmp")
    cmp.setup({
        snippet = {
            -- REQUIRED - you must specify a snippet engine
            expand = function(args)
                require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
            end,
        },

        window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
        },

        mapping = cmp.mapping.preset.insert({
            ["<C-j>"] = cmp.mapping.select_next_item(),
            ["<C-k>"] = cmp.mapping.select_prev_item(),
            ["<Tab>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
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

    -- Set configuration for specific filetype.
    cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources({
            { name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
        }, {
            { name = "buffer" },
        }),
    })

    -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = "buffer" },
        },
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = "path" },
        }, {
            { name = "cmdline" },
        }),
    })

    -- Set up lspconfig.
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    local on_attach = function(_, bufnr)
        require("lsp_signature").on_attach({
            bind = true,
            handler_opts = { border = "rounded" },
            hint_prefix = "🧸 ",
        }, bufnr)
    end

    require("mason").setup()
    require("mason-lspconfig").setup()
    require("mason-lspconfig").setup_handlers({
        function(server_name)
            require("lspconfig")[server_name].setup({
                capabilities = capabilities,
                on_attach = on_attach,
            })
        end,
        ["zk"] = function()
        end,
        ["sumneko_lua"] = function()
            require("lspconfig").sumneko_lua.setup({
                on_attach = on_attach,
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" },
                        },
                    },
                },
            })
        end,
    })
    require("mason-null-ls").setup({ automatic_setup = true })
    require("mason-null-ls").setup_handlers()
    require("null-ls").setup()
    require("nvim-autopairs").setup({})
    require("rose-pine").setup({
        dark_variant = "moon",
    })
    vim.cmd("colorscheme rose-pine")
    require("lualine").setup()
    require("indent_blankline").setup({
        show_current_context = true,
    })
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
    require("nvim-tree").setup()
    require("lsp_signature").setup()
    require("zk").setup({
        picker = "telescope",
    })
    require("nvim-surround").setup()
    require("zk.commands").add("ZkStartingPoint", function(options)
        options = vim.tbl_extend("force", { match = "§§", matchStrategy = "exact" }, options or {})
        require("zk").edit(options, { title = "§§" })
    end)
    require('neogen').setup({ snippet_engine = "luasnip", languages = { lua = { annotation_convention = "ldoc"}}})
    require("todo-comments").setup {}
    require("leap").add_default_mappings()

end)
