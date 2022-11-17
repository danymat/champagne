-- For help on configuration, check help on vim.g.*
-- Ex: vim.g.mapleader -> :help mapleader
vim.g.mapleader = " "
vim.o.relativenumber = true
vim.o.number = true
vim.o.undofile = true
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.completeopt = 'menu,menuone,noselect'

vim.keymap.set("n", "<Leader>so", ":so %<CR>")
vim.keymap.set("n", "<Leader>h", ":wincmd h<CR>")
vim.keymap.set("n", "<Leader>j", ":wincmd j<CR>")
vim.keymap.set("n", "<Leader>k", ":wincmd k<CR>")
vim.keymap.set("n", "<Leader>l", ":wincmd l<CR>")
vim.keymap.set("n", "<Leader>fs", vim.lsp.buf.format)
vim.keymap.set("n", "K", vim.lsp.buf.hover)
vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename)
vim.keymap.set("n", "<C-n>", vim.diagnostic.goto_next)
vim.keymap.set("n", "<C-b>", vim.diagnostic.goto_prev)

local ok, builtin = pcall(require, "telescope.builtin")
if ok then
    vim.keymap.set("n", "<C-f>", builtin.find_files, {})
    vim.keymap.set("n", "<leader>ff", builtin.live_grep, {})
    vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
    vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
    vim.keymap.set("n", "<leader>gr", ":Telescope lsp_references<CR>")
    vim.keymap.set("n", "<leader>gd", ":Telescope lsp_definitions<CR>")
    vim.keymap.set("n", "<C-a>", ":Telescope lsp_document_symbols symbols=func,class<CR>")
end

ok, _ = pcall(require, "packer")
if ok then
    vim.keymap.set("n", "<Leader>sc", ":so % | PackerCompile<CR>")
end

ok, _ = pcall(require, "rose-pine")
if ok then
    vim.cmd("colorscheme rose-pine")
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
    use({ "williamboman/mason.nvim" })
    use({ "williamboman/mason-lspconfig.nvim" })
    use({ "neovim/nvim-lspconfig" })
    use({ "jayp0521/mason-null-ls.nvim" })
    use "windwp/nvim-autopairs"
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/nvim-cmp'

    --
    -- NICE TO HAVE
    --
    use 'L3MON4D3/LuaSnip'
    use 'saadparwaiz1/cmp_luasnip'

    local luasnip = require("luasnip")
    local cmp = require 'cmp'
    cmp.setup({
        snippet = {
            -- REQUIRED - you must specify a snippet engine
            expand = function(args)
                require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            end,
        },

        window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
        },

        mapping = cmp.mapping.preset.insert({
            ['<C-j>'] = cmp.mapping.select_next_item(),
            ['<C-k>'] = cmp.mapping.select_prev_item(),
            ['<Tab>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
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
            { name = 'nvim_lsp' },
            { name = 'luasnip' }, -- For luasnip users.
        }, {
            { name = 'buffer' },
        })
    })

    -- Set configuration for specific filetype.
    cmp.setup.filetype('gitcommit', {
        sources = cmp.config.sources({
            { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
        }, {
            { name = 'buffer' },
        })
    })

    -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = 'buffer' }
        }
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = 'path' }
        }, {
            { name = 'cmdline' }
        })
    })

    -- Set up lspconfig.
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    require("mason").setup()
    require("mason-lspconfig").setup()
    require("mason-lspconfig").setup_handlers({
        function(server_name)
            require("lspconfig")[server_name].setup({ capabilities = capabilities })
        end,
        ["sumneko_lua"] = function()
            require("lspconfig").sumneko_lua.setup {
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" }
                        }
                    }
                }
            }
        end,
    })
    require("mason-null-ls").setup({ automatic_setup = true })
    require("mason-null-ls").setup_handlers()
    require("null-ls").setup()
    require("nvim-autopairs").setup {}

end)
