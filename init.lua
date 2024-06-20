local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- User options
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
vim.o.foldenable = true
vim.o.mouse = ""

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
-- map("i", "<Tab>", function() if vim.snippet.active() then vim.snippet.expand() end end)
map('i', '<C-Space>', '<C-x><C-o>') -- Force Trigger completion
map('i', '<C-j>', [[pumvisible() ? "\<C-n>" : "\<C-j>"]], { expr = true })
map('i', '<C-k>', [[pumvisible() ? "\<C-p>" : "\<C-k>"]], { expr = true })
map({ "n", "v" }, "≠", "<C-d>zz")
map({ "n", "v" }, "÷", "<C-u>zz")
map({ "n", "v" }, "<C-j>", "<C-d>zz")
map({ "n", "v" }, "<C-k>", "<C-u>zz")
map("t", "<Esc>", "<C-\\><C-n>")


-- export NVIM_WORK=1 at work and it will apply custom keybinds
local at_work = vim.env.NVIM_WORK and true

if at_work then
    map("n", "<Leader>=", "<C-^>")
end

require("lazy").setup({
    {
        "stevearc/oil.nvim",
        config = function()
            require("oil").setup({
                view_options = {
                    show_hidden = true,
                },
                natural_order = true,

            })
            vim.keymap.set("n", at_work and "=" or "-", "<CMD>Oil --float<CR>", { desc = "Open parent directory" })
        end
    },

    {
        "danymat/neogen",
        dev = true,
        config = function()
            require("neogen").setup({
                --snippet_engine = "luasnip",
                languages = {
                    python = { template = { annotation_convention = "reST" } },
                }
            })

            vim.keymap.set("n", "<Leader>nf", ":Neogen func<CR>")
            vim.keymap.set("n", "<Leader>nc", ":Neogen class<CR>")
        end
    },
    {
        "nvim-neorg/neorg",
        dev = true
    },
    {
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
        end
    },
    {
        "ThePrimeagen/harpoon",
        config = function()
            vim.keymap.set("n", "<Leader>a", function() require("harpoon.mark").add_file() end)
            vim.keymap.set("n", "<Leader>o", function() require("harpoon.ui").toggle_quick_menu() end)
            vim.keymap.set("n", "<Leader>&", function() require("harpoon.ui").nav_file(1) end)
            vim.keymap.set("n", "<Leader>é", function() require("harpoon.ui").nav_file(2) end)
            vim.keymap.set("n", "<Leader>\"", function() require("harpoon.ui").nav_file(3) end)
            vim.keymap.set("n", "<Leader>'", function() require("harpoon.ui").nav_file(4) end)
        end
    },
    {
        "ggandor/leap.nvim",
        config = function()
            require('leap').add_default_mappings()
        end
    },
    {
        "nvim-lualine/lualine.nvim",
        config = function()
            require('lualine').setup {
                options = {
                    icons_enabled = true,
                    theme = 'auto',
                },
            }
        end
    },
    { "williamboman/mason.nvim" },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup()

            require("mason-lspconfig").setup_handlers({
                -- The first entry (without a key) will be the default handler
                -- and will be called for each installed server that doesn't have
                -- a dedicated handler.
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {}
                end,
                ["lua_ls"] = function()
                    require("lspconfig").lua_ls.setup {
                        settings = {
                            Lua = {
                                diagnostics = {
                                    globals = { "vim" }
                                }
                            }
                        }
                    }
                end
            })
        end
    },
    { "neovim/nvim-lspconfig" },
    {
        "echasnovski/mini.nvim",
        config = function()
            --- Completion
            require("mini.completion").setup({
                window = {
                    info = { border = "single" },
                    signature = { border = "single" },
                },
            })

            require("mini.pairs").setup()
        end
    },
    { 'kylechui/nvim-surround', config = true },
    {
        "nvim-treesitter/nvim-treesitter",
        config = function()
            local configs = require("nvim-treesitter.configs")

            configs.setup({
                highlight = {
                    ensure_installed = { "c", "lua", "python", "vim", "vimdoc", "html" },
                    enable = true,
                    additional_vim_regex_highlighting = { "markdown" },
                    indent = { enable = true },
                },
                playground = {
                    enable = true,
                }
            })
        end
    },
    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            require("rose-pine").setup({
                dark_variant = "moon",
                disable_background = true,
                --extend_background_behind_borders = true,
                styles = { transparency = true },
            })
            vim.cmd("colorscheme rose-pine-moon")
        end
    },
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' },
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

            vim.keymap.set("n", "<C-f>", ":Telescope find_files<CR>")
            vim.keymap.set("n", "<Leader>ff", ":Telescope live_grep<CR>")
            vim.keymap.set("n", "<Leader>fb", ":Telescope buffers<CR>")
            vim.keymap.set("n", "<Leader>fh", ":Telescope help_tags<CR>")
            vim.keymap.set("n", "<Leader>gr", ":Telescope lsp_references<CR>")
            vim.keymap.set("n", "<Leader>gd", ":Telescope lsp_definitions<CR>")
            vim.keymap.set("n", "<Leader>ds", ":Telescope lsp_document_symbols symbols=func,function,class<CR>")
            vim.keymap.set("n", "<C-a>", ":lua vim.lsp.buf.code-action()<CR>")
            vim.keymap.set("n", "<Leader>p", ":Telescope workspaces<CR>")
        end
    },
    "natecraddock/workspaces.nvim",
    {
        "zk-org/zk-nvim",
        config = function()
            local zk = require("zk")
            local commands = require("zk.commands")

            zk.setup({
                picker = "telescope",
            })

            commands.add("ZkStart", function()
                zk.edit({ matchStrategy = "re", match = { "§§" } }, { title = "Starting Points" })
            end)

            vim.keymap.set("n", "<Leader>za", "<CMD>:ZkStart<CR>", { desc = "Open Starting Point Notes" })
            vim.keymap.set("n", "<Leader>zf", "<CMD>ZkNotes {sort = {'modified'}}<CR>", { desc = "Open Zk Notes" })
            vim.keymap.set("n", "<Leader>zt", "<CMD>:ZkTags {sort= {'note-count'} }<CR>", { desc = "Open Zk Notes" })
            vim.keymap.set("n", "<leader>zn",
                "<Cmd>ZkNew { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>")
        end
    },
}, {
    dev = {
        path = "~/Developer/",
        fallback = true
    }
})
