local M = {}

M.search_dotfiles = function()
	require("telescope.builtin").find_files({
		prompt_title = "< VimRC >",
		cwd = "~/.config/nvim",
	})
end

local function link_zettel(prompt_bufnr, map)
	local entry = require("telescope.actions.state").get_selected_entry(prompt_bufnr)
	print(entry.filename)
	require("telescope.actions").close(prompt_bufnr)
	-- ensure that the buffer can be written to
	if vim.api.nvim_buf_get_option(vim.api.nvim_get_current_buf(), "modifiable") then
		print("Paste!")
		-- substitute "^V" for "b"
		local reg_type = vim.fn.getregtype(entry.value)
		if reg_type:byte(1, 1) == 0x16 then
			reg_type = "b" .. reg_type:sub(2, -1)
		end
		local file_name = entry.filename:gsub(".md", "")
		vim.api.nvim_put({ "[[" .. file_name .. "]]" }, reg_type, true, true)
	end
end

local opts = {
	cwd = "/Users/danielmathiot/Documents/000 Meta/00.01 Brain/",
	attach_mappings = function(_, map)
		-- Will map <C-p> to paste current file as ZK link
		map("i", "<C-p>", link_zettel)
		return true
	end,
}

--- Search files in ZK dir
M.search_zettelkasten = function()
	local options = vim.deepcopy(opts)
	options.prompt_title = "< Zettels: files >"
	require("telescope.builtin").find_files(options)
end

--- Open starting files in a telescope picker
M.open_starting_files = function()
	local options = vim.deepcopy(opts)
	options.prompt_title = "< Zettels: §§ >"
	options.default_text = "§§"
	require("telescope.builtin").live_grep(options)
end

--- Search zettelkasten note inside files
M.search_zettelkasten_in_files = function()
	local options = vim.deepcopy(opts)
	options.prompt_title = "< Zettels: in files >"
	require("telescope.builtin").live_grep(options)
end

-- Find highlighted link (ZK prefixer) in all files
M.find_link = function()
	local options = vim.deepcopy(opts)
	options.prompt_title = "< Zettels: links >"
	require("telescope.builtin").grep_string(options)
end

M.paste_file_name = function()
	local file = vim.fn.expand("%:t")
	if file == "" then
		return
	end
	local text = "# " .. file:sub(1, -4)
	local cursor = vim.api.nvim_win_get_cursor(0)
	vim.api.nvim_buf_set_lines(0, cursor[1] -1 , cursor[1]-1, false, { text })
    vim.api.nvim_feedkeys("i", "n", false)
end
return M
