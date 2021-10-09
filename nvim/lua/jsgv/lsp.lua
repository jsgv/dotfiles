local nvim_lsp = require('lspconfig')
local luasnip  = require('luasnip')
-- local lspkind  = require('lspkind')

vim.opt.completeopt = { 'menuone', 'noselect' }

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.documentationFormat = { 'markdown', 'plaintext' }
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.preselectSupport = true
capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
capabilities.textDocument.completion.completionItem.deprecatedSupport = true
capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
        'documentation',
        'detail',
        'additionalTextEdits',
    }
}

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = {
        prefix  = "»",
        spacing = 4,
    },
    signs            = true,
    update_in_insert = false,
}
)

-- loads friendly-snippets libraries
require('luasnip/loaders/from_vscode').load({
    paths = {
        vim.fn.stdpath('data') .. '/site/pack/packer/start/friendly-snippets'
    }
})

require('lspkind').init({
    with_test = true,
})

local cmp = require('cmp')
cmp.setup {
    preselect = cmp.PreselectMode.None,
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    mapping = {
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select   = true,
        },
        ['<Tab>'] = function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            else
                fallback()
            end
        end,
        ['<S-Tab>'] = function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            else
                fallback()
            end
        end,
    },
    formatting = {
        format = function (entry, vim_item)
            vim_item.kind = require('lspkind').presets.default[vim_item.kind] .. ' ' .. vim_item.kind

            vim_item.menu= ({
                nvim_lsp = '[LSP]',
                luasnip  = '[LuaSnip]',

                buffer   = '[Buffer]',
                nvim_lua = '[NvimLua]',
                path     = '[Path]',
            })[entry.source.name]

            return vim_item
        end,
    },
    sources = {
        { name = 'nvim_lsp' },
        -- { name = 'luasnip' },

        { name = 'buffer '},
        { name = 'nvim_lua '},
        { name = 'path '},
    },

}

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
    local filetype = vim.api.nvim_buf_get_option(0, "filetype")

    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    -- Enable completion triggered by <C-x><C-o>
    -- not sure if i need this (or what it means)
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = { noremap=true, silent=true }
    buf_set_keymap('n', '<C-]>',      '<Cmd>lua vim.lsp.buf.definition()<CR>',                   opts)
    buf_set_keymap('n', 'K',          '<Cmd>lua vim.lsp.buf.hover()<CR>',                        opts)
    buf_set_keymap('n', '<Leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>',                       opts)
    buf_set_keymap('n', '[d',         '<Cmd>lua vim.lsp.diagnostic.goto_prev()<CR>',             opts)
    buf_set_keymap('n', ']d',         '<Cmd>lua vim.lsp.diagnostic.goto_next()<CR>',             opts)
    buf_set_keymap('n', 'E',          '<Cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', 'gr',         '<Cmd>lua vim.lsp.buf.references()<CR>',                   opts)
    buf_set_keymap('n', 'gh',         '<Cmd>lua vim.lsp.buf.document_highlight()<CR>',           opts)
    buf_set_keymap('n', 'gc',         '<Cmd>lua vim.lsp.buf.clear_references()<CR>',             opts)
    buf_set_keymap('n', 'ge',         '<Cmd>lua vim.lsp.diagnostic.set_loclist()<CR>',           opts)

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
    -- buf_set_keymap('n', '<space>q',  '<Cmd>lua vim.lsp.diagnostic.set_loclist()<CR>',                         opts)
    -- buf_set_keymap('n', '<space>f',  '<Cmd>lua vim.lsp.buf.formatting()<CR>',                                 opts)

    -- autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()
    -- autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
    -- autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
    vim.cmd([[
    highlight LspReference guifg=NONE guibg=#665c54 guisp=NONE gui=NONE cterm=NONE ctermfg=NONE ctermbg=59
    highlight! link LspReferenceText  LspReference
    highlight! link LspReferenceRead  LspReference
    highlight! link LspReferenceWrite LspReference
    ]])

    if filetype == "rust" then
        vim.cmd([[
        augroup lsp_buf_format
        au! BufWritePre <buffer>
        autocmd BufWritePre <buffer> :lua vim.lsp.buf.formatting(nil, 5000)
        augroup END
        ]])
    elseif filetype == "typescriptreact" then
        vim.api.nvim_exec([[
        augroup LspAutocommands
        autocmd! * <buffer>
        autocmd BufWritePost <buffer> :lua vim.lsp.buf.formatting()
        augroup END
        ]], true)
    end
end

-- Go
nvim_lsp.gopls.setup {
    on_attach    = on_attach,
    capabilities = capabilities,
    flags        = {
        debounce_text_changes = 200,
    },

    -- overwrite default, otherwise lsp will only start when `go.mod` and `.git`
    -- are present.
    -- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#gopls
    -- root_dir     = root_pattern("*.go"),
    -- settings     = {
    --     gopls    = {
    --         -- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
    --         analyses = {
    --             unusedparams = true,
    --             shadow       = true,
    --         },
    --         -- https://staticcheck.io
    --         staticcheck = true,
    --     },
    -- },
}

-- nvim_lsp.ccls.setup{
--     on_attach    = on_attach,
--     capabilities = capabilities,
-- }

nvim_lsp.clangd.setup{
    on_attach    = on_attach,
    capabilities = capabilities,
    cmd       = { "clangd", "--background-index", "--clang-tidy" },
    root_dir  = function() return vim.loop.cwd() end
}

-- Rust
nvim_lsp.rust_analyzer.setup{
    on_attach    = on_attach,
    capabilities = capabilities,
}

-- TypeScript
nvim_lsp.tsserver.setup {
    on_attach    = on_attach,
    capabilities = capabilities,
    handlers = {
        ["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
            -- disable certain diagnostics from appearing
            -- https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
            if result.diagnostics ~= nil then
                for i = 1, #result.diagnostics do
                    local k  = result.diagnostics[i]
                    if k.code == 80001 then
                        table.remove(result.diagnostics, i)
                    else
                        i = i + 1
                    end
                end
            end

            vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
        end,
    },
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

-- local t = function(str)
--     return vim.api.nvim_replace_termcodes(str, true, true, true)
-- end

-- local check_back_space = function()
--     local col = vim.fn.col('.') - 1
--     if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
--         return true
--     else
--         return false
--     end
-- end

-- Use (s-)tab to:
-- move to prev/next item in completion menuone
-- jump to prev/next snippet's placeholder
-- _G.tab_complete = function()
--     if vim.fn.pumvisible() == 1 then
--         return t "<C-n>"
--     elseif check_back_space() then
--         return t "<Tab>"
--     else
--         return vim.fn['compe#complete']()
--     end
-- end

-- _G.s_tab_complete = function()
--     if vim.fn.pumvisible() == 1 then
--         return t "<C-p>"
--     else
--         return t "<S-Tab>"
--     end
-- end

-- -- https://elianiva.my.id/post/my-nvim-lsp-setup#tsserver
-- local opts_tab_complete = { expr = true, silent = true }
-- vim.api.nvim_set_keymap("i", "<Tab>",   "v:lua.tab_complete()",   opts_tab_complete)
-- vim.api.nvim_set_keymap("s", "<Tab>",   "v:lua.tab_complete()",   opts_tab_complete)
-- vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", opts_tab_complete)
-- vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", opts_tab_complete)
