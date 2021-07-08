local nvim_lsp     = require('lspconfig')
local root_pattern = require('lspconfig/util').root_pattern

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
        'documentation',
        'detail',
        'additionalTextEdits',
    }
}

-- hrsh7th/nvim-compe
vim.api.nvim_set_keymap('i', '<CR>', 'compe#confirm(\'<CR>\')', { noremap = true, silent = true, expr = true })

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    -- local filetype = vim.api.nvim_buf_get_option(0, "filetype")

    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    -- Enable completion triggered by <C-x><C-o>
    -- not sure if i need this (or what it means)
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = { noremap=true, silent=true }
    buf_set_keymap('n', '<C-]>',      '<Cmd>lua vim.lsp.buf.definition()<CR>',     opts)
    buf_set_keymap('n', 'K',          '<Cmd>lua vim.lsp.buf.hover()<CR>',          opts)
    buf_set_keymap('n', '<Leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>',         opts)

    -- i already have <C-k> mapped to 'pane hopping', but I could later reuse this mapping.
    -- buf_set_keymap('n', '<C-k>',      '<Cmd>lua vim.lsp.buf.signature_help()<CR>', opts)

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    -- buf_set_keymap('n', 'gD',        '<Cmd>lua vim.lsp.buf.declaration()<CR>',                                opts)
    -- buf_set_keymap('n', 'gi',        '<Cmd>lua vim.lsp.buf.implementation()<CR>',                             opts)
    -- buf_set_keymap('n', '<space>wa', '<Cmd>lua vim.lsp.buf.add_workspace_folder()<CR>',                       opts)
    -- buf_set_keymap('n', '<space>wr', '<Cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>',                    opts)
    -- buf_set_keymap('n', '<space>wl', '<Cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    -- buf_set_keymap('n', '<space>D',  '<Cmd>lua vim.lsp.buf.type_definition()<CR>',                            opts)
    -- buf_set_keymap('n', '<space>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>',                                     opts)
    -- buf_set_keymap('n', '<space>ca', '<Cmd>lua vim.lsp.buf.code_action()<CR>',                                opts)
    -- buf_set_keymap('n', 'gr',        '<Cmd>lua vim.lsp.buf.references()<CR>',                                 opts)
    -- buf_set_keymap('n', '<space>e',  '<Cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>',               opts)
    -- buf_set_keymap('n', '[d',        '<Cmd>lua vim.lsp.diagnostic.goto_prev()<CR>',                           opts)
    -- buf_set_keymap('n', ']d',        '<Cmd>lua vim.lsp.diagnostic.goto_next()<CR>',                           opts)
    -- buf_set_keymap('n', '<space>q',  '<Cmd>lua vim.lsp.diagnostic.set_loclist()<CR>',                         opts)
    -- buf_set_keymap('n', '<space>f',  '<Cmd>lua vim.lsp.buf.formatting()<CR>',                                 opts)

    -- autoformat on save, only for rust since vim-go handles it for go
    -- if vim.tbl_contains({ "rust" }, filetype) then
    --     vim.cmd([[
    --         autocmd BufWritePre <buffer> :lua vim.lsp.buf.formatting_sync()
    --     ]])
    -- end
end

-- Go
nvim_lsp.gopls.setup {
    on_attach    = on_attach,
    capabilities = capabilities,

    -- overwrite default, otherwise lsp will only start when `go.mod` and `.git`
    -- are present.
    -- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#gopls
    root_dir     = root_pattern("*.go"),
}

-- TypeScript
nvim_lsp.tsserver.setup {
    on_attach    = on_attach,
    capabilities = capabilities,
}

-- CodeQL
nvim_lsp.codeqlls.setup {
    on_attach    = on_attach,
    capabilities = capabilities,
    cmd          = { "codeql", "execute", "language-server", "--check-errors", "ON_CHANGE", "-q" },
    settings     = {
        search_path = {
            vim.fn.expand('~/codeql-home/codeql-repo'),
            vim.fn.expand('~/codeql-home/codeql-go'),
            vim.fn.expand('~/codeql-home/codeql'),
        }
    },
}

-- Lua
local sumneko_root_path = vim.fn.expand('~/Code/github.com/sumneko/lua-language-server')
local sumneko_binary    = sumneko_root_path .. '/bin/macOS/lua-language-server'
nvim_lsp.sumneko_lua.setup {
    on_attach    = on_attach,
    capabilities = capabilities,
    cmd          = {
        sumneko_binary,
        '-E',
        sumneko_root_path .. '/main.lua',
    },
    settings = {
        Lua = {
            runtime = {
                version = '5.4',
                path    = { '/usr/local/bin/lua' },
            },
            -- Get the language server to recognize the `vim` global
            diagnostics = { globals = {'vim'} },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data
            telemetry = { enable = false },
        },
    }
}

require('compe').setup {
    enabled          = true,
    autocomplete     = true,
    debug            = false,
    min_length       = 1,
    preselect        = 'enable',
    throttle_time    = 80,
    source_timeout   = 200,
    incomplete_delay = 400,
    max_abbr_width   = 100,
    max_kind_width   = 100,
    max_menu_width   = 100,
    documentation    = true,
    source = {
        path       = true,
        nvim_lsp   = true,
        treesitter = true,
    },
}

local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

-- Use (s-)tab to:
-- move to prev/next item in completion menuone
-- jump to prev/next snippet's placeholder
_G.tab_complete = function()
    if vim.fn.pumvisible() == 1 then
        return t "<C-n>"
    elseif check_back_space() then
        return t "<Tab>"
    else
        return vim.fn['compe#complete']()
    end
end

_G.s_tab_complete = function()
    if vim.fn.pumvisible() == 1 then
        return t "<C-p>"
    else
        return t "<S-Tab>"
    end
end

vim.api.nvim_set_keymap("i", "<Tab>",   "v:lua.tab_complete()",   { expr = true })
vim.api.nvim_set_keymap("s", "<Tab>",   "v:lua.tab_complete()",   { expr = true })
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", { expr = true })
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", { expr = true })
