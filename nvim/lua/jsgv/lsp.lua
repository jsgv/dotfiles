local nvim_lsp = require('lspconfig')
local lspkind = require('lspkind')

lspkind.init({
    with_test = true,
})

vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
vim.opt.shortmess:append "c"

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

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
    -- https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/config/default.lua#L83
    mapping = {
        ['<C-y>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select   = true,
        },
    },
    formatting = {
        format = lspkind.cmp_format({
            with_text = true,
            menu = {
                nvim_lsp = '[LSP]',
                vsnip    = '[Vsnip]',
                buffer   = '[Buffer]',
                nvim_lua = '[NvimLua]',
                path     = '[Path]',
            },
        }),
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'vsnip'    },
        { name = 'buffer', keyword_length = 3 },
        { name = 'nvim_lua' },
        { name = 'path'     },
    },
    experimental = {
        native_menu = false,
        ghost_text  = true,
    },
}

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
-- on attention
local on_attach = function(client, bufnr)
    local filetype = vim.api.nvim_buf_get_option(0, 'filetype')

    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    local opts = { noremap=true, silent=true }
    buf_set_keymap('n', '[d',         '<Cmd>lua vim.diagnostic.goto_prev({ float =  { border = "single" }})<CR>',         opts)
    buf_set_keymap('n', ']d',         '<Cmd>lua vim.diagnostic.goto_next({ float =  { border = "single" }})<CR>',         opts)
    buf_set_keymap('n', 'E',          '<Cmd>lua vim.diagnostic.open_float(0, { scope = "line", border = "single" })<CR>', opts)
    buf_set_keymap('n', '<C-]>',      '<Cmd>lua vim.lsp.buf.definition()<CR>',               opts)
    buf_set_keymap('n', 'K',          '<Cmd>lua vim.lsp.buf.hover()<CR>',                    opts)
    buf_set_keymap('n', '<Leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>',                   opts)
    buf_set_keymap('n', 'gr',         '<Cmd>lua vim.lsp.buf.references()<CR>',               opts)
    buf_set_keymap('n', 'gh',         '<Cmd>lua vim.lsp.buf.document_highlight()<CR>',       opts)
    buf_set_keymap('n', 'gc',         '<Cmd>lua vim.lsp.buf.clear_references()<CR>',         opts)
    buf_set_keymap('n', 'ge',         '<Cmd>lua vim.diagnostic.set_loclist()<CR>',           opts)
    buf_set_keymap('n', '<Leader>fm', '<Cmd>lua vim.lsp.buf.formatting_sync(nil, 3500)<CR>', opts)

    local web = {
        ['javascript']      = true,
        ['typescript']      = true,
        ['javascriptreact'] = true,
        ['typescriptreact'] = true,
        ['vue']             = true,
    }

    if web[filetype] then
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.document_range_formatting = false
    end
end


-- Bash
nvim_lsp.bashls.setup {
    on_attach    = on_attach,
    capabilities = capabilities,
}

-- Haskell
nvim_lsp.hls.setup {
    on_attach    = on_attach,
    capabilities = capabilities,
}

-- Go
nvim_lsp.gopls.setup {
    on_attach    = on_attach,
    capabilities = capabilities,
    flags        = {
        debounce_text_changes = 200,
    },
}

-- C++
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
    settings     = {
        ["rust-analyzer"] = {
            cargo = {
                loadOutDirsFromCheck = true
            },
        }
    }
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

-- Diagnosticls
nvim_lsp.diagnosticls.setup {
    on_attach = function ()
        --
    end,
    filetypes = {
        'typescriptreact',
        'typescript',
        'javascript',
        'css',
    },
    init_options = {
        filetypes = {
            typescriptreact = 'eslint',
            javascript = 'eslint',
        },
        linters = {
            eslint = {
                sourceName = 'eslint',
                command = 'eslint',
                args = {
                    '--stdin',
                    '--stdin-filename=%filepath',
                    '--format=json',
                },
                rootPatterns = {
                    'package.json',
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
        formatFiletypes = {
            typescriptreact = 'prettier',
            typescript      = 'prettier',
            javascript      = 'prettier',
            css             = 'prettier',
        },
        formatters = {
            prettier = {
                command = 'prettier',
                args = {
                    '--stdin-filepath=%filepath',
                },
                rootPatterns = {
                    'package.json',
                },
            },
        },
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
