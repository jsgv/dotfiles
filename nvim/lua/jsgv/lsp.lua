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
    buf_set_keymap('n', '<space>f',   '<Cmd>lua vim.lsp.buf.format({ timeout_ms = 2000 })<CR>', opts_set_keymap)

    -- @todo
    -- local format_file = function()
    --     print("going to format_file")
    -- end
    -- buf_set_keymap('n', '<space>f',   [[ <Cmd>lua format_file()<CR> ]], opts_set_keymap)

    local opts_keymap_set = { buffer = bufnr }
    vim.keymap.set('n', '<Leader>ca', vim.lsp.buf.code_action, opts_keymap_set)

    local format_on_save = {
        -- diagnosticls=true,
        tsserver=true,
        terraformls=true,
        prismals=true,
        bufls=true,
        rust_analyzer=true,
    }

    if format_on_save[client.name] then
        vim.api.nvim_command([[ autocmd BufWritePre <buffer> :lua vim.lsp.buf.format({ timeout_ms = 2000 }) ]])
    end
end

-- Go
nvim_lsp.gopls.setup({
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
})

-- Proto
nvim_lsp.bufls.setup({
    on_attach    = on_attach,
    capabilities = capabilities,
})

-- GraphQL
nvim_lsp.graphql.setup({
    on_attach    = on_attach,
    capabilities = capabilities,
})

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
                    -- remove/enable once fixed:
                    -- https://github.com/simrat39/rust-tools.nvim/issues/300
                    inlayHints = {
                        locationLinks = false
                    }
                }
            }
        },
    })
end

-- Python
nvim_lsp.pyright.setup({
    on_attach    = on_attach,
    capabilities = capabilities,
})

-- PHP
-- nvim_lsp.phpactor.setup({
--     on_attach    = on_attach,
--     capabilities = capabilities,
-- })


-- Prisma
nvim_lsp.prismals.setup({
    on_attach    = on_attach,
    capabilities = capabilities,
})

-- Tailwind CSS
nvim_lsp.tailwindcss.setup({
    on_attach    = on_attach,
    capabilities = capabilities,
})

-- Terraform
nvim_lsp.terraformls.setup({
    on_attach    = on_attach,
    capabilities = capabilities,
})

-- Java
nvim_lsp.jdtls.setup({
    on_attach    = on_attach,
    capabilities = capabilities,
})

-- TypeScript
nvim_lsp.tsserver.setup({
    on_attach    = on_attach,
    capabilities = capabilities,
    settings = {
        typescript = {
            format = {
                baseIndentSize = 0,
                indentSize = 4,
                convertTabsToSpaces = true,
                semicolons = 'insert',
                -- insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = true,
                -- insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets = true,
                -- insertSpaceAfterOpeningAndBeforeClosingNonemptyParenthesis = true,
                insertSpaceAfterOpeningAndBeforeClosingTemplateStringBraces = true,
                insertSpaceBeforeFunctionParenthesis = true,
                trimTrailingWhitespace = true,
            }
        }
    },
    init_options = {
        hostInfo = "neovim",
        preferences = {
            quotePreference = "single",
        }
    },
})

-- C++
-- nvim_lsp.clangd.setup({
--     on_attach    = on_attach,
--     capabilities = capabilities,
--     filetypes    = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
--     cmd       = { 'clangd', '--background-index', '--clang-tidy' },
--     root_dir  = function() return vim.loop.cwd() end
-- })

-- nvim_lsp.kotlin_language_server.setup({
--     on_attach    = on_attach,
--     capabilities = capabilities,
-- })

-- Diagnosticls
-- nvim_lsp.diagnosticls.setup({
--     on_attach = on_attach,
--     filetypes = {
--         'typescript',
--         'typescriptreact',
--         'javascript',
--         'javascriptreact',
--         'css',
--     },
--     init_options = {
--         filetypes = {
--             typescript = 'eslint',
--             typescriptreact = 'eslint',
--             javascript = 'eslint',
--             javascriptreact = 'eslint',
--         },
--         linters = {
--             eslint = {
--                 sourceName = 'eslint',
--                 command = 'npx',
--                 args = {
--                     'eslint',
--                     '--stdin',
--                     '--stdin-filename=%filepath',
--                     '--format=json',
--                 },
--                 rootPatterns = {
--                     'package.json',
--                 },
--                 parseJson = {
--                     errorsRoot = '[0].messages',
--                     line = 'line',
--                     column = 'column',
--                     endLine = 'endLine',
--                     endColumn = 'endColumn',
--                     message = '${message} [${ruleId}]',
--                     security = 'severity',
--                 },
--                 securities = {
--                     [2] = 'error',
--                     [1] = 'warning',
--                 },
--             },
--         },
--         formatFiletypes = {
--             typescript      = 'prettier',
--             typescriptreact = 'prettier',
--             javascript      = 'prettier',
--             javascriptreact = 'prettier',
--             css             = 'prettier',
--         },
--         formatters = {
--             prettier = {
--                 sourceName = 'prettier',
--                 command = 'npx',
--                 args = {
--                     'prettier',
--                     '--stdin-filepath=%filepath',
--                 },
--                 rootPatterns = {
--                     'package.json',
--                 },
--             },
--         },
--     },
-- })

-- Lua
nvim_lsp.lua_ls.setup({
    on_attach    = on_attach,
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
            },
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME
                }
            }
        }
    }
})

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
        ghost_text  = false, -- Does not work well with Copilot
    },
}
