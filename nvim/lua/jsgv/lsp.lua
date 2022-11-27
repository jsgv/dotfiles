local nvim_lsp = require('lspconfig')
local lspkind = require('lspkind')
local cmp = require('cmp')

local has_rust_tools, rust_tools = pcall(require, 'rust-tools')

vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
vim.opt.shortmess:append 'c'

local capabilities = require('cmp_nvim_lsp').default_capabilities()

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

 vim.diagnostic.config({
    float = {
        source = 'always'
    }
 })

local on_attach = function(client, bufnr)
    -- local filetype = vim.api.nvim_buf_get_option(0, 'filetype')

    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    local opts_set_keymap = { noremap=true, silent=true }
    buf_set_keymap('n', '[d',         '<Cmd>lua vim.diagnostic.goto_prev({ float =  { border = "single" }})<CR>',         opts_set_keymap)
    buf_set_keymap('n', ']d',         '<Cmd>lua vim.diagnostic.goto_next({ float =  { border = "single" }})<CR>',         opts_set_keymap)
    buf_set_keymap('n', 'E',          '<Cmd>lua vim.diagnostic.open_float(0, { scope = "line", border = "single" })<CR>', opts_set_keymap)
    buf_set_keymap('n', '<C-]>',      '<Cmd>lua vim.lsp.buf.definition()<CR>',               opts_set_keymap)
    buf_set_keymap('n', 'K',          '<Cmd>lua vim.lsp.buf.hover()<CR>',                    opts_set_keymap)
    buf_set_keymap('n', '<Leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>',                   opts_set_keymap)
    buf_set_keymap('n', 'gr',         '<Cmd>lua vim.lsp.buf.references()<CR>',               opts_set_keymap)
    buf_set_keymap('n', 'gh',         '<Cmd>lua vim.lsp.buf.document_highlight()<CR>',       opts_set_keymap)
    buf_set_keymap('n', 'gc',         '<Cmd>lua vim.lsp.buf.clear_references()<CR>',         opts_set_keymap)
    buf_set_keymap('n', 'ge',         '<Cmd>lua vim.diagnostic.set_loclist()<CR>',           opts_set_keymap)
    buf_set_keymap('n', '<space>f',   '<Cmd>lua vim.lsp.buf.formatting_sync(nil, 7500)<CR>', opts_set_keymap)

    local opts_keymap_set = { buffer = bufnr }
    vim.keymap.set('n', '<Leader>ca', vim.lsp.buf.code_action, opts_keymap_set)

    if client.name == 'tsserver' then
        -- Disable formatting capabilities for 'tsserver' since we are using 'diagnosticls' instead.
        -- client.server_capabilities.document_formatting = false
        -- client.server_capabilities.document_range_formatting = false
    elseif client.name == 'rust_analyzer' then
        vim.api.nvim_command([[ autocmd BufWritePre <buffer> :lua vim.lsp.buf.format() ]])

        -- @temp Trying this for now.
        if has_rust_tools then
            vim.keymap.set('n', 'K', rust_tools.hover_actions.hover_actions, opts_keymap_set)
            -- vim.keymap.set('n', '<Leader>ca', rust_tools.code_action_group.code_action_group, { buffer = bufnr })
        end
    elseif client.name == 'diagnosticls' then
        vim.api.nvim_command([[ autocmd BufWritePre <buffer> :lua vim.lsp.buf.format() ]])
        -- client.server_capabilities.document_formatting = true
        -- client.server_capabilities.document_range_formatting = true
    end
end

-- Go
nvim_lsp.gopls.setup {
    on_attach    = on_attach,
    capabilities = capabilities,
    flags        = {
        debounce_text_changes = 200,
    },
    settings  = {
        gopls = {
            gofumpt = true
        }
    }
}

-- C++
nvim_lsp.clangd.setup {
    on_attach    = on_attach,
    capabilities = capabilities,
    cmd       = { 'clangd', '--background-index', '--clang-tidy' },
    root_dir  = function() return vim.loop.cwd() end
}

if has_rust_tools then
    rust_tools.setup({
        tools = {
            autoSetHints = true,
            inlay_hints = {
                show_parameter_hints = false,
                parameter_hints_prefix = '',
                other_hints_prefix = '',
            },
        },
        server = {
            on_attach = on_attach,
            settings  = {
                ['rust-analyzer'] = {
                    checkOnSave = {
                        command = 'clippy'
                    },
                    cargo = {
                        loadOutDirsFromCheck = true
                    },
                    procMacro = {
                        enable = true
                    },
                    diagnostics = {
                        enable = true,
                        enableExperimental = false,
                    },
                    lens = {
                        enable = true,
                    },
                }
            }
        },
    })
end

-- PHP
nvim_lsp.phpactor.setup({})

-- Tailwind CSS
nvim_lsp.tailwindcss.setup({})

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

                    if k ~= nil then
                        -- https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json#L6433-L6436
                        if k.code == 80001 then
                            table.remove(result.diagnostics, i)
                        else
                            i = i + 1
                        end
                    end
                end
            end

            vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
        end,
    },
}

-- Diagnosticls
nvim_lsp.diagnosticls.setup {
    on_attach = on_attach,
    filetypes = {
        'typescript',
        'typescriptreact',
        'javascript',
        'javascriptreact',
        'css',
    },
    init_options = {
        filetypes = {
            typescript = 'eslint',
            typescriptreact = 'eslint',
            javascript = 'eslint',
            javascriptreact = 'eslint',
        },
        linters = {
            eslint = {
                sourceName = 'eslint',
                command = 'npx',
                args = {
                    'eslint',
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
            typescript      = 'prettier',
            typescriptreact = 'prettier',
            javascript      = 'prettier',
            javascriptreact = 'prettier',
            css             = 'prettier',
        },
        formatters = {
            prettier = {
                sourceName = 'prettier',
                command = 'npx',
                args = {
                    'prettier',
                    '--stdin-filepath=%filepath',
                },
                rootPatterns = {
                    'package.json',
                },
            },
        },
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

-- CodeQL
-- nvim_lsp.codeqlls.setup {
--     on_attach    = on_attach,
--     capabilities = capabilities,
--     cmd          = { 'codeql', 'execute', 'language-server', '--check-errors', 'ON_CHANGE', '-q' },
--     settings     = {
--         search_path = {
--             vim.fn.expand('~/codeql-home/codeql-repo'),
--             vim.fn.expand('~/codeql-home/codeql-go'),
--             vim.fn.expand('~/codeql-home/codeql'),
--         }
--     },
-- }

-- Solidity
-- nvim_lsp.solc.setup{
--     on_attach    = on_attach,
--     capabilities = capabilities,
-- }

-- Bash
-- nvim_lsp.bashls.setup {
--     on_attach    = on_attach,
--     capabilities = capabilities,
-- }

-- Haskell
-- nvim_lsp.hls.setup {
--     on_attach    = on_attach,
--     capabilities = capabilities,
-- }

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

local feedkey = function(key, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

cmp.setup {
    preselect = cmp.PreselectMode.None,
    snippet = {
        expand = function(args)
            vim.fn['vsnip#anonymous'](args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-y>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select   = true,
        },
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<Tab>'] = cmp.mapping(function(fallback)
            if vim.fn['vsnip#available'](1) == 1 then
                feedkey('<Plug>(vsnip-expand-or-jump)', '')
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),
    formatting = {
        format = lspkind.cmp_format({
            mode = 'symbol_text',
            menu = {
                nvim_lsp = '[LSP]',
                vsnip    = '[Vsnip]',
                buffer   = '[Buffer]',
                nvim_lua = '[NvimLua]',
                path     = '[Path]',
            },
        }),
    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'vsnip'    },
        { name = 'nvim_lua' },
        { name = 'path'     },
    }, {
        { name = 'buffer', keyword_length = 3 },
    }),
    experimental = {
        native_menu = false,
        ghost_text  = true,
    },
}
