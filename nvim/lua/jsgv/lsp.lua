local nvim_lsp = require('lspconfig')
local lspkind = require('lspkind')

lspkind.init({
    with_test = true,
})

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

vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = {
            prefix  = '»',
            spacing = 4,
        },
        signs            = true,
        update_in_insert = false,
    }
)


local cmp = require('cmp')
cmp.setup {
    preselect = cmp.PreselectMode.None,
    snippet = {
        expand = function(args)
            vim.fn['vsnip#anonymous'](args.body)
        end,
    },
    mapping = {
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
            vim_item.kind = lspkind.presets.default[vim_item.kind] .. ' ' .. vim_item.kind

            vim_item.menu= ({
                nvim_lsp = '[LSP]',
                vsnip    = 'Vsnip',
                buffer   = '[Buffer]',
                nvim_lua = '[NvimLua]',
                path     = '[Path]',
            })[entry.source.name]

            return vim_item
        end,
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
        { name = 'buffer '},
        { name = 'nvim_lua '},
        { name = 'path '},
    },

}

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
    local filetype = vim.api.nvim_buf_get_option(0, 'filetype')

    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

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

    vim.cmd([[
        highlight LspReference guifg=NONE guibg=#665c54 guisp=NONE gui=NONE cterm=NONE ctermfg=NONE ctermbg=59
        highlight! link LspReferenceText  LspReference
        highlight! link LspReferenceRead  LspReference
        highlight! link LspReferenceWrite LspReference
    ]])

    -- if filetype == 'rust' then
    --     vim.cmd([[
    --     augroup lsp_buf_format
    --     au! BufWritePre <buffer>
    --     autocmd BufWritePre <buffer> :lua vim.lsp.buf.formatting(nil, 5000)
    --     augroup END
    --     ]])
    -- end

    local web = {
        ['javascript']      = true,
        ['typescript']      = true,
        ['javascriptreact'] = true,
        ['typescriptreact'] = true,
        ['vue']             = true,
    }

    if web[filetype] then
        vim.cmd([[
            augroup LspAutocommands
                au!     BufWritePre <buffer>
                autocmd BufWritePre <buffer> :lua vim.lsp.buf.formatting()
            augroup END
        ]])
    end
end

nvim_lsp.diagnosticls.setup {
    on_attach = function (client)
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.document_range_formatting = false
    end,
    filetypes = {
        'typescriptreact',
    },
    init_options = {
        filetypes = {
            typescriptreact = 'eslint',
        },
        linters = {
            eslint = {
                sourceName = 'eslint',
                -- command = './node_modules/.bin/eslint',
                command = 'npx',
                rootPatterns = {
                    'package.json',
                },
                args = {
                    'eslint',
                    '--stdin',
                    '--stdin-filename=%filepath',
                    '--format=json',
                },
                parseJson = {
                    errorsRoot = '[0].messages',
                    line = 'line',
                    column = 'column',
                    endLine = 'endLine',
                    endColumn = 'endColumn',
                    message = '${message} [${ruleId}]',
                    security = 'severity',
                },
                securities = {
                    [2] = 'error',
                    [1] = 'warning',
                },
            },
        },
    },
}

-- Go
nvim_lsp.gopls.setup {
    on_attach    = on_attach,
    capabilities = capabilities,
    flags        = {
        debounce_text_changes = 200,
    },
}

nvim_lsp.clangd.setup {
    on_attach    = on_attach,
    capabilities = capabilities,
    cmd       = { 'clangd', '--background-index', '--clang-tidy' },
    root_dir  = function() return vim.loop.cwd() end
}

-- Rust
nvim_lsp.rust_analyzer.setup {
    on_attach    = on_attach,
    capabilities = capabilities,
}

-- TypeScript
nvim_lsp.tsserver.setup {
    on_attach    = on_attach,
    capabilities = capabilities,
    handlers = {
        ['textDocument/publishDiagnostics'] = function(_, result, ctx, config)
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
    cmd          = { 'codeql', 'execute', 'language-server', '--check-errors', 'ON_CHANGE', '-q' },
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
                library = vim.api.nvim_get_runtime_file('', true),
            },
            -- Do not send telemetry data
            telemetry = { enable = false },
        },
    }
}
