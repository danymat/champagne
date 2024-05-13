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
