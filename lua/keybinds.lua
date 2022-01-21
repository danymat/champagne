local wrap = function(function_pointer, ...)
	local params = { ... }

	return function()
		return function_pointer(unpack(params))
	end
end

-- LOL STILL USING ARROWS?
vim.keymap.set({ "i", "n" }, "<Up>", "<Nop>")
vim.keymap.set({ "i", "n" }, "<Down>", "<Nop>")
vim.keymap.set({ "i", "n" }, "<Left>", "<Nop>")
vim.keymap.set({ "i", "n" }, "<Right>", "<Nop>")

-- Telescope Stuff
vim.keymap.set(
	"n",
	"<C-f>",
	wrap(require("telescope.builtin").find_files, { hidden = true, file_ignore_patterns = { "^.git/" } })
)
vim.keymap.set("n", "<Leader>ff", ":Telescope live_grep<CR>")
vim.keymap.set("n", "<Leader>fz", ":Telescope current_buffer_fuzzy_find<CR>")
vim.keymap.set("n", "<Leader>o", wrap(require("telescope.builtin").oldfiles))
vim.keymap.set("n", "<Leader>p", wrap(require("telescope").extensions.project.project, { display_type = "full" }))
vim.keymap.set("n", "<Leader>?", wrap(require("telescope.builtin").help_tags))

-- Zettelkasten
vim.keymap.set("n", "<Leader>§§", wrap(require("configs.telescope").open_starting_files))
vim.keymap.set("n", "<Leader>zi", wrap(require("configs.telescope").search_zettelkasten_in_files))
vim.keymap.set("n", "<Leader>zl", wrap(require("configs.telescope").find_link))
vim.keymap.set("n", "<Leader>zk", wrap(require("configs.telescope").search_zettelkasten))

-- Terminal
vim.keymap.set("n", "<Esc>", ":noh<CR>", { silent = true })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>")

-- Dotfiles
vim.keymap.set("n", "<Leader>ev", wrap(require("configs.telescope").search_dotfiles))
vim.keymap.set("n", "<Leader>sv", ":source ~/.config/nvim/init.lua<CR>")
vim.keymap.set("n", "<Leader>so", ":source %<CR>")

-- Window management
vim.keymap.set("n", "<Leader>j", ":wincmd j<CR>")
vim.keymap.set("n", "<Leader>k", ":wincmd k<CR>")
vim.keymap.set("n", "<Leader>l", ":wincmd l<CR>")
vim.keymap.set("n", "<Leader>h", ":wincmd h<CR>")
vim.keymap.set("n", "<Leader>r", "<C-w>r<CR>")
vim.keymap.set("n", "<Leader>vs", "<C-w>v")
vim.keymap.set("n", "<Leader>zz", "<cmd>MaximizerToggle<CR>")

-- Moving speed
vim.keymap.set("n", "÷", "<C-u>")
vim.keymap.set("n", "≠", "<C-d>")
vim.keymap.set("v", "÷", "<C-u>")
vim.keymap.set("v", "≠", "<C-d>")
vim.keymap.set("n", "÷", "<C-u>")
vim.keymap.set("n", "≠", "<C-d>")
vim.keymap.set("v", "÷", "<C-u>")
vim.keymap.set("v", "≠", "<C-d>")

-- thanks to theprimeagen for this (https://www.youtube.com/watch?v=Q5eDxR7bU2k)
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("i", ",", ",<c-g>u")
vim.keymap.set("i", "!", "!<c-g>u")
vim.keymap.set("i", ".", ".<c-g>u")
vim.keymap.set("i", "?", "?<c-g>u")
vim.keymap.set("n", "<C-u>", "<C-u>zzzv")
vim.keymap.set("n", "<C-d>", "<C-d>zzzv")
vim.keymap.set("v", "<Leader>p", '"_dP')
vim.keymap.set("n", "<C-j>", "i<CR><Esc>J") -- Inverse of join-line

-- Nerdtree
vim.keymap.set("n", "<Leader>t", ":NERDTreeFocus<CR>")

-- Neogen
vim.keymap.set("n", "<Leader>nf", wrap(require("neogen").generate))
vim.keymap.set("n", "<Leader>nc", wrap(require("neogen").generate, { type = "class" }))
vim.keymap.set("n", "<Leader>nt", wrap(require("neogen").generate, { type = "type" }))
vim.keymap.set("n", "<Leader>ez", wrap(R, "neogen", { setup = require("configs.neogen") }))

-- Keybinds for toggleterm.lua
vim.keymap.set("n", "<Leader>sf", function()
	require("toggleterm.terminal").Terminal:new({ direction = "float", count = 1 }):toggle()
end)
vim.keymap.set("n", "<Leader>sr", function()
	require("toggleterm.terminal").Terminal:new({ direction = "vertical", count = 2 }):toggle()
end)

vim.keymap.set("n", "<Leader>gs", function()
	require("toggleterm.terminal").Terminal:new({ cmd = "lazygit", hidden = true }):toggle()
end)

-- LSP
vim.keymap.set("n", "<Leader>aa", function()
	require("telescope.builtin").lsp_code_actions(require("telescope.themes").get_cursor({}))
end)

-- Zettelkasten
vim.cmd([[
    let g:zettelkasten = "/Users/danielmathiot/Documents/000 Meta/00.01 Brain/"
command! -nargs=1 NewZettel :execute ":e" zettelkasten . strftime("%Y%m%d%H%M") . " <args>.md"
]])

vim.keymap.set("n", "<Leader>zn", ":NewZettel ")
vim.keymap.set("n", "<Leader>@", wrap(require("configs.telescope").paste_file_name))
vim.keymap.set("n", "<Leader>z&", wrap(require("lspconfig").zk.index))

-- This is the greatest thing ever for azerty keyboards
-- https://superuser.com/questions/1044018/how-to-swap-the-numbers-row-on-azerty-keyboards-in-vim-only-while-being-in-norma
vim.keymap.set("n", "1", "&")
vim.keymap.set("n", "2", "é")
vim.keymap.set("n", "3", '"')
vim.keymap.set("n", "4", "'")
vim.keymap.set("n", "5", "(")
vim.keymap.set("n", "6", "§")
vim.keymap.set("n", "7", "è")
vim.keymap.set("n", "8", "!")
vim.keymap.set("n", "9", "ç")
vim.keymap.set("n", "0", "à")

vim.keymap.set("n", "&", "1")
vim.keymap.set("n", "é", "2")
vim.keymap.set("n", '"', "3")
vim.keymap.set("n", "'", "4")
vim.keymap.set("n", "(", "5")
vim.keymap.set("n", "§", "6")
vim.keymap.set("n", "è", "7")
vim.keymap.set("n", "!", "8")
vim.keymap.set("n", "ç", "9")
vim.keymap.set("n", "à", "0")

-- Quick copy to clipboard
vim.keymap.set("v", "<Leader>y", '"+y')
vim.keymap.set("n", "<Leader>y", '"+y')

-- BufferLine
vim.keymap.set("n", "<Leader>bn", ":BufferLineCycleNext<CR>")
vim.keymap.set("n", "<Leader>bb", ":BufferLineCyclePrev<CR>")
vim.keymap.set("n", "<Leader>bd", ":bd<CR>")
vim.keymap.set("n", "<Leader>b&", ":BufferLineGoToBuffer 1<CR>")
vim.keymap.set("n", "<Leader>bé", ":BufferLineGoToBuffer 2<CR>")
vim.keymap.set("n", '<Leader>b"', ":BufferLineGoToBuffer 3<CR>")
vim.keymap.set("n", "<Leader>b'", ":BufferLineGoToBuffer 4<CR>")
vim.keymap.set("n", "<Leader>b(", ":BufferLineGoToBuffer 5<CR>")
vim.keymap.set("n", "<Leader>b§", ":BufferLineGoToBuffer 6<CR>")
vim.keymap.set("n", "<Leader>bè", ":BufferLineGoToBuffer 7<CR>")
vim.keymap.set("n", "<Leader>b!", ":BufferLineGoToBuffer 8<CR>")
vim.keymap.set("n", "<Leader>bç", ":BufferLineGoToBuffer 9<CR>")
--[[ vim.keymap.set("n", "<Leader>bé", ":blast<CR>") ]]

-- A multiline tabout setup could look like this
vim.keymap.set('i', '<C-l>', "<Plug>(TaboutMulti)", {silent = true})
vim.keymap.set('i', '<C-h>', "<Plug>(TaboutBackMulti)", {silent = true})
