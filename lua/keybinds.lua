local map = function(mode, lhs, rhs, opts)
	if type(mode) == "table" then
		for _, m in ipairs(mode) do
			vim.api.nvim_set_keymap(m, lhs, rhs, opts or { silent = true, noremap = true })
		end
	else
		vim.api.nvim_set_keymap(mode, lhs, rhs, opts or { silent = true, noremap = true })
	end
end
-- LOL STILL USING ARROWS?
map({ "i", "n" }, "<Up>", "<Nop>")
map({ "i", "n" }, "<Down>", "<Nop>")
map({ "i", "n" }, "<Left>", "<Nop>")
map({ "i", "n" }, "<Right>", "<Nop>")

-- Telescope Stuff
local ok, _ = Prequire("telescope")

if ok then
	map(
		"n",
		"<C-f>",
		':lua require("telescope.builtin").find_files { hidden = true, file_ignore_patterns = { "^.git/" } }<CR>'
	)
	map("n", "<Leader>ff", ":Telescope live_grep<CR>")
	map("n", "<Leader>fz", ":Telescope current_buffer_fuzzy_find<CR>")
	map("n", "<Leader>o", ':lua require("telescope.builtin").oldfiles()<CR>')
	map("n", "<Leader>p", ':lua require("telescope").extensions.project.project { display_type = "full" }<CR>')
	map("n", "<Leader>?", ':lua require("telescope.builtin").help_tags()<CR>')

	-- Zettelkasten
	local _ok, _ = Prequire("zk.commands")
	if _ok then
		map("n", "<Leader>§§", ':lua require("zk.commands").get("ZkStartingPoint")()<CR>')
		map("n", "<Leader>zk", ':lua require("zk.commands").get("ZkNotes")()<CR>')
		map("n", "<Leader>zb", ':lua require("zk.commands").get("ZkBacklinks")()<CR>')
		map("n", "<Leader>zi", ':lua require("zk.commands").get("ZkLinks")()<CR>')
		map("n", "<Leader>zt", ':lua require("zk.commands").get("ZkTags")({ sort = { "note-count" }})<CR>')
		map("n", "<Leader>zn", ':lua require("zk.commands").get("ZkNew")({ title = vim.fn.input("Title: ") })<CR>')
	end

	map("n", "<Leader>ev", ':lua require("telescope.builtin").find_files { prompt_title = "nvim", cwd = "~/.config/nvim" } <CR>')
	map(
		"n",
		"<Leader>aa",
		':lua require("telescope.builtin").lsp_code_actions(require("telescope.themes").get_cursor({}))<CR>'
	)
	map("n", "<C-a>", ":Telescope lsp_document_symbols symbols=function,class<CR>")
end

-- Terminal
map("n", "<Esc>", ":noh<CR>", { silent = true })
map("t", "<Esc><Esc>", "<C-\\><C-n>")

-- Dotfiles
map("n", "<Leader>sv", ":source ~/.config/nvim/init.lua<CR>")
map("n", "<Leader>so", ":source %<CR>", {})

-- Window management
map("n", "<Leader>j", ":wincmd j<CR>")
map("n", "<Leader>k", ":wincmd k<CR>")
map("n", "<Leader>l", ":wincmd l<CR>")
map("n", "<Leader>h", ":wincmd h<CR>")
map("n", "<Leader>r", "<C-w>r<CR>")
map("n", "<Leader>vs", "<C-w>v")
map("n", "<Leader>zz", "<cmd>MaximizerToggle<CR>")

-- Moving speed
map("n", "÷", "<C-u>")
map("n", "≠", "<C-d>")
map("v", "÷", "<C-u>")
map("v", "≠", "<C-d>")
map("n", "÷", "<C-u>")
map("n", "≠", "<C-d>")
map("v", "÷", "<C-u>")
map("v", "≠", "<C-d>")

-- thanks to theprimeagen for this (https://www.youtube.com/watch?v=Q5eDxR7bU2k)
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map("n", "J", "mzJ`z")
map("i", ",", ",<c-g>u")
map("i", "!", "!<c-g>u")
map("i", ".", ".<c-g>u")
map("i", "?", "?<c-g>u")
map("n", "<C-u>", "<C-u>zzzv")
map("n", "<C-d>", "<C-d>zzzv")
map("v", "<Leader>p", '"_dP')
map("n", "<C-j>", "i<CR ><Esc>J") -- Inverse of join-line

map("n", "<Leader>t", ":NvimTreeFocus<CR>")


-- Neogen
ok, _ = Prequire("neogen")
if ok then
	map("n", "<Leader>nf", ':lua require("neogen").generate()<CR>')
	map("n", "<Leader>nc", ':lua require("neogen").generate { type = "class" }<CR>')
	map("n", "<Leader>nt", ':lua require("neogen").generate { type = "type" }<CR>')
	map("n", "<Leader>ez", ':lua R("neogen",{ setup = require("configs.neogen") })<CR>')
end

ok, _ = Prequire("toggleterm")
if ok then
	map(
		"n",
		"<Leader>sf",
		':lua require("toggleterm.terminal").Terminal:new({ direction = "float", count = 1 }):toggle()<CR>'
	)
	map(
		"n",
		"<Leader>sr",
		':lua require("toggleterm.terminal").Terminal:new({ direction = "vertical", count = 2 }):toggle()<CR>'
	)

	map(
		"n",
		"<Leader>gs",
		':lua require("toggleterm.terminal").Terminal:new({ cmd = "lazygit", hidden = true }):toggle()<CR>'
	)
end

-- Zettelkasten
-- vim.cmd([[
--     let g:zettelkasten = "/Users/danielmathiot/Documents/000 Meta/00.01 Brain/"
-- command! -nargs=1 NewZettel :execute ":e" zettelkasten . strftime("%Y%m%d%H%M") . " <args>.md"
-- ]])
--
-- map("n", "<Leader>zn", ":NewZettel ")
-- map("n", "<Leader>@", Wrap(require("configs.telescope").paste_file_name))
-- map("n", "<Leader>z&", Wrap(require("lspconfig").zk.index))

-- This is the greatest thing ever for azerty keyboards
-- https://superuser.com/questions/1044018/how-to-swap-the-numbers-row-on-azerty-keyboards-in-vim-only-while-being-in-norma
map("n", "1", "&")
map("n", "2", "é")
map("n", "3", '"')
map("n", "4", "'")
map("n", "5", "(")
map("n", "6", "§")
map("n", "7", "è")
map("n", "8", "!")
map("n", "9", "ç")
map("n", "0", "à")

map("n", "&", "1")
map("n", "é", "2")
map("n", '"', "3")
map("n", "'", "4")
map("n", "(", "5")
map("n", "§", "6")
map("n", "è", "7")
map("n", "!", "8")
map("n", "ç", "9")
map("n", "à", "0")

-- Quick copy to clipboard
map("v", "<Leader>y", '"+y')
map("n", "<Leader>y", '"+y')

-- BufferLine
map("n", "<Leader>bn", ":BufferLineCycleNext<CR>")
map("n", "<Leader>bb", ":BufferLineCyclePrev<CR>")
map("n", "<Leader>bd", ":bd<CR>")
map("n", "<Leader>bx", ":BufferLineCloseLeft<CR>:BufferLineCloseRight<CR>")
map("n", "<Leader>&", ":BufferLineGoToBuffer 1<CR>")
map("n", "<Leader>é", ":BufferLineGoToBuffer 2<CR>")
map("n", '<Leader>"', ":BufferLineGoToBuffer 3<CR>")
map("n", "<Leader>'", ":BufferLineGoToBuffer 4<CR>")
map("n", "<Leader>(", ":BufferLineGoToBuffer 5<CR>")
map("n", "<Leader>§", ":BufferLineGoToBuffer 6<CR>")
map("n", "<Leader>è", ":BufferLineGoToBuffer 7<CR>")
map("n", "<Leader>!", ":BufferLineGoToBuffer 8<CR>")
map("n", "<Leader>ç", ":BufferLineGoToBuffer 9<CR>")
