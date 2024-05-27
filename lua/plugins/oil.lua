require("oil").setup({
    view_options = {
        show_hidden = true,
    },
    natural_order = true,

})

vim.keymap.set("n", "-", "<CMD>Oil --float<CR>", { desc = "Open parent directory" })
