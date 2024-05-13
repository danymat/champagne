require("nvim-tree").setup({ sync_root_with_cwd = true })

vim.keymap.set("n", "<Leader>t", function () require("nvim-tree.api").tree.toggle() end)
