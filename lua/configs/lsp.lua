local nvim_lsp = require('lspconfig')

local on_attach = function(_, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local opts = { noremap=true, silent=true }
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<leader>r', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<C-b>', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', '<C-n>', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
        'documentation',
        'detail',
        'additionalTextEdits',
    }
}

-- See https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md for more lsp servers
local configs = require'lspconfig/configs'

if not nvim_lsp.zettelkastenlsp then
    configs.zettelkastenlsp = {
        default_config = {
            cmd = {'node',  '/Users/danielmathiot/Developer/lsp-zettelkasten/server/out/server.js', '--stdio'};
            filetypes = {'markdown'};
            root_dir = function(fname)
                return nvim_lsp.util.find_git_ancestor(fname) or vim.loop.os_homedir()
            end;
            settings = {};
        };
    }
end
local servers = { 'pyright', 'vimls', 'bashls', 'html', 'flow', 'tsserver', 'vuels', 'intelephense', 'zettelkastenlsp', 'dockerls', 'jdtls'}
local config = { on_attach = on_attach, capabilities = capabilities}

for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup(config)
end

servers = require'lspmanager'.installed_servers()

-- Configure lua language server for neovim development
local lua_settings = {
    Lua = {
        runtime = {
            -- LuaJIT in the case of Neovim
            version = 'LuaJIT',
            path = vim.split(package.path, ';'),
        },
        diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = {'vim', 'P', 'G'},
        },
        telemetry = { enable = false },
        workspace = {
            preloadFileSize = 180,
            -- Make the server aware of Neovim runtime files
            library = {
                [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
            },
        },
    }
}

for _, server in pairs(servers) do
    if server == "sumneko_lua" then
        local luadev = require("lua-dev").setup({
            library = {
                vimruntime = true,
                types = true,
                plugins = false
            },
            lspconfig = lua_settings
        })
        config = vim.tbl_extend("keep", config, luadev)
    end
    require'lspconfig'[server].setup(config)
end

-- Null-ls
local null_ls = require("null-ls")
local b = null_ls.builtins

local sources = {
    b.formatting.stylua,
    b.formatting.prettier,
    b.code_actions.gitsigns
}

null_ls.config({
    debug = true,
    sources = sources,
})

require("lspconfig")["null-ls"].setup({ on_attach = on_attach })

local signs = { Error = "", Warn = "", Info = "כֿ", Hint = "" }
for sign, icon in pairs(signs) do
	vim.fn.sign_define(
		"DiagnosticSign" .. sign,
		{ text = icon, texthl = "Diagnostic" .. sign, linehl = false, numhl = "Diagnostic" .. sign }
	)
end
