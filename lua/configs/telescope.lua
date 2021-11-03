
local M = {}
M.search_dotfiles = function()
    require("telescope.builtin").find_files({
            prompt_title = "< VimRC >",
            cwd = "~/.config/nvim"
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
        local file_name = entry.filename:gsub(".md","")
        vim.api.nvim_put({"[[" .. file_name .. "]]"}, reg_type, true, true)
    end
end

-- Dropdown list theme using a builtin theme definitions :
local center_list = require'telescope.themes'.get_dropdown({
        winblend = 10,
        width = 0.5,
        prompt = " ",
        results_height = 15
    })
local opts = vim.deepcopy(center_list)
opts.cwd = "/Users/danielmathiot/Documents/000 Meta/00.01 NewBrain"
opts.attach_mappings = function(prompt_bufnr, map)
    map('i','<C-p>', link_zettel)
    return true
end


M.search_zettelkasten = function()
    opts.prompt_title = "< Zettels: files >"
    require("telescope.builtin").find_files(opts)
end

M.open_starting_files = function()
    opts.prompt_title =  "< Zettels: §§ >"
    opts.default_text = "§§"
    require("telescope.builtin").live_grep(opts)
end

M.search_zettelkasten_in_files = function()
    opts.prompt_title =  "< Zettels: in files >"
    require("telescope.builtin").live_grep(opts)
end

M.find_link = function()
    opts.prompt_title =  "< Zettels: links >"
    require("telescope.builtin").grep_string(opts)
end


return M


