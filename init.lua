vim.o.number = true
vim.o.rnu = true
vim.g.mapleader = " "
vim.o.winborder = "rounded"
vim.o.tabstop = 4
vim.o.completeopt = "menuone,noselect,fuzzy,nosort"
vim.o.conceallevel = 1
vim.o.ignorecase = true
vim.o.smartcase = true

vim.pack.add({
	{ src = "https://github.com/rose-pine/neovim", name = "rosepine" },
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/nvim-mini/mini.nvim",
	"https://github.com/ThePrimeagen/harpoon",
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/danymat/neogen",
	"https://github.com/zk-org/zk-nvim",
	"https://github.com/saghen/blink.cmp"
})

-- Plugins

require("rose-pine").setup({
	variant = "moon",
	disable_background = true,
	styles = { transparency = true }
})
require("oil").setup({
	view_options = { show_hidden = true },
	natural_order = true

})
require('mini.pick').setup()
--require('mini.completion').setup()
require('mini.snippets').setup()
require('mini.keymap').setup({})
require('mini.pairs').setup()
require('mini.icons').setup()
require('mini.comment').setup()
require("mason").setup()
require("blink.cmp").setup({
	keymap = {
		preset = 'none',
		['<C-k>'] = { 'select_prev', 'fallback' },
		['<C-j>'] = { 'select_next', 'fallback' },
		['<Tab>'] = { 'select_and_accept', 'fallback' },
		['<C-l>'] = { 'snippet_forward', 'fallback' },
		['<C-h>'] = { 'snippet_backward', 'fallback' },
		['<C-s>'] = { 'show_signature', 'hide_signature', 'fallback' },

	},
	fuzzy = { implementation = "lua" }

})

require("nvim-treesitter.configs").setup({
	ensure_installed = { "lua" },
	highlight = { enable = true, additional_vim_regex_highlighting = { "markdown" }
	}
})

require("neogen").setup({
	snippet_engine = "luasnip",
	-- languages = {
	--     python = { template = { annotation_convention = "reST" } },
	-- }
})
local zk = require("zk")
zk.setup({ picker = "minipick" })
require("zk.commands").add("ZkFocus", function()
	zk.edit({ matchStrategy = "re", match = { "#focus" } }, { title = "Currently in focus" })
end)
require("zk.commands").add("ZkStart", function()
	zk.edit({ matchStrategy = "re", match = { "§§" } }, { title = "Starting Points" })
end)
require("zk.commands").add("ZkGrep", function()
	require("mini.pick").builtin.grep_live(nil,
		{ tool = "rg", source = { cwd = os.getenv("ZK_NOTEBOOK_DIR"), name = "dotfiles" } })
end)

vim.lsp.enable({ "lua_ls", "pyright", "marksman" })
vim.lsp.config("lua_ls", {
	settings = {
		-- Lua = {
		-- 	workspace = {
		-- 		library = vim.api.nvim_get_runtime_file("", true)
		-- 	}
		-- }
	}
})

-- vim.api.nvim_create_autocmd('LspAttach', {
-- 	callback = function(ev)
-- 		local client = vim.lsp.get_client_by_id(ev.data.client_id)
-- 		if client and client:supports_method('textDocument/completion') then
-- 			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
-- 		end
-- 	end,
-- })


vim.diagnostic.config({
	virtual_text = { current_line = true }
})

local map = vim.keymap.set

map("n", "<leader>so", ":w<CR> :source<CR>")
map("n", "<leader>fs", vim.lsp.buf.format)
map("n", "<leader>r", vim.lsp.buf.rename)
map("n", "<leader>gd", vim.lsp.buf.definition)
map("n", "<C-n>", function() vim.diagnostic.jump({ count = 1 }) end)
map("n", "<C-b>", function() vim.diagnostic.jump({ count = -1 }) end)
map({ "n", "v" }, "≠", "<C-d>zz")
map({ "n", "v" }, "÷", "<C-u>zz")
map({ "n", "v" }, "µ", "{")
map({ "n", "v" }, "Ù", "}")
map({ "n", "v" }, "<C-j>", "<C-d>zz")
map({ "n", "v" }, "<C-k>", "<C-u>zz")
map({ "n", "v", "x" }, "<Leader>y", '"+y<CR>')
map({ "n", "v", "x" }, "<Leader>d", '"+d<CR>')
map("n", "<C-f>", ":Pick files<CR>")
map("n", "<C-h>", ":Pick help<CR>")
map("n", "<Leader>ff", ":Pick grep_live<CR>")
map("n", "-", ":Oil --float<CR>")
map("n", "<Leader>a", function() require("harpoon.mark").add_file() end)
map("n", "<Leader>o", function() require("harpoon.ui").toggle_quick_menu() end)
map("n", "<Leader>&", function() require("harpoon.ui").nav_file(1) end)
map("n", "<Leader>é", function() require("harpoon.ui").nav_file(2) end)
map("n", "<Leader>\"", function() require("harpoon.ui").nav_file(3) end)
map("n", "<Leader>'", function() require("harpoon.ui").nav_file(4) end)
map('i', '<C-j>', [[pumvisible() ? "\<C-n>" : "\<C-j>"]], { expr = true })
map('i', '<C-k>', [[pumvisible() ? "\<C-p>" : "\<C-k>"]], { expr = true })
map("n", "<Leader>zz", "<CMD>:ZkFocus<CR>", { desc = "Open Focus notes" })
map("n", "<Leader>za", "<CMD>:ZkStart<CR>", { desc = "Open Starting Point Notes" })
map("n", "<Leader>zf", "<CMD>ZkNotes {sort = {'modified'}}<CR>", { desc = "Open Zk Notes" })
map("n", "<Leader>zt", "<CMD>:ZkTags {sort= {'note-count'} }<CR>", { desc = "Open Zk Notes" })
map("n", "<leader>zn",
	"<Cmd>ZkNew { }<CR>")
map("n", "<Leader>nf", ":Neogen func<CR>")
map("n", "<Leader>nc", ":Neogen class<CR>")
map("n", "<Leader>fz", "<CMD>:ZkGrep<CR>")

vim.cmd("colorscheme rose-pine")
