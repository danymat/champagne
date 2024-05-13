require("neogen").setup({
    --snippet_engine = "luasnip",
    languages = {
        python = { template = { annotation_convention = "reST" } },
    }
})

vim.keymap.set("n", "<Leader>nf", ":Neogen func<CR>")
vim.keymap.set("n", "<Leader>nc", ":Neogen class<CR>")
