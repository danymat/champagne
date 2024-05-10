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
