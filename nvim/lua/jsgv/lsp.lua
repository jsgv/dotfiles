if not pcall(require, 'lspconfig') then
    return
end

if not pcall(require, 'lspkind') then
    return
end

if not pcall(require, 'cmp') then
    return
end

local nvim_lsp = require('lspconfig')
local lspkind = require('lspkind')
local cmp = require('cmp')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
vim.opt.shortmess:append 'c'

vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text     = {
            prefix  = '»',
            spacing = 4,
        },
        signs            = true,
        update_in_insert = false,
    }
)

vim.diagnostic.config({
    float = {
        source = true
    }
})

local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    local opts = { noremap = true, silent = false }

    buf_set_keymap('n', 'E', '<Cmd>lua vim.diagnostic.open_float(0, {scope="line", border="single"})<CR>', opts)
    buf_set_keymap('n', '<C-]>', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gh', '<Cmd>lua vim.lsp.buf.document_highlight()<CR>', opts)
    buf_set_keymap('n', 'gc', '<Cmd>lua vim.lsp.buf.clear_references()<CR>', opts)
    buf_set_keymap('n', 'ge', '<Cmd>lua vim.diagnostic.set_loclist()<CR>', opts)
    buf_set_keymap('n', '<space>f', '<Cmd>lua vim.lsp.buf.format({ timeout_ms = 2000 })<CR>', opts)

    local format_on_save = {
        rust_analyzer = true,
    }

    if format_on_save[client.name] then
        vim.api.nvim_command([[ autocmd BufWritePre <buffer> :lua vim.lsp.buf.format({ timeout_ms = 2000 }) ]])
    end

    -- if client.name == 'ts_ls' then
    --     -- buf_set_keymap('n', '<space>f', '<Cmd>Prettier<CR>', opts_set_keymap)
    -- else
    --     buf_set_keymap('n', '<space>f', '<Cmd>lua vim.lsp.buf.format({ timeout_ms = 2000 })<CR>', opts)
    -- end
end

local go_capabilities = require('cmp_nvim_lsp').default_capabilities()
go_capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Go
nvim_lsp.gopls.setup({
    on_attach    = on_attach,
    capabilities = go_capabilities,
    flags        = {
        debounce_text_changes = 200,
    },
    settings     = {
        gopls = {
            gofumpt = true
        }
    }
})

-- Proto
nvim_lsp.buf_ls.setup({
    on_attach    = on_attach,
    capabilities = capabilities,
})

-- Python
nvim_lsp.pyright.setup({
    on_attach    = on_attach,
    capabilities = capabilities,
})

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
nvim_lsp.ts_ls.setup({
    on_attach    = on_attach,
    capabilities = capabilities,
})

-- C/C++
nvim_lsp.clangd.setup({
    on_attach    = on_attach,
    capabilities = capabilities,
    -- filetypes    = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
    -- cmd       = { 'clangd', '--background-index', '--clang-tidy' },
    -- root_dir  = function() return vim.loop.cwd() end
})

-- Lua
nvim_lsp.lua_ls.setup({
    on_attach    = on_attach,
    capabilities = capabilities,
    settings     = {
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

-- Rust
nvim_lsp.rust_analyzer.setup({
    on_attach = on_attach,
    settings = {
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
})

-- local has_rust_tools, rust_tools = pcall(require, 'rust-tools')
-- if has_rust_tools then
--     rust_tools.setup({
--         tools = {
--             autoSetHints = true,
--             inlay_hints = {
--                 show_parameter_hints = false,
--                 parameter_hints_prefix = '',
--                 other_hints_prefix = '',
--             },
--         },
--         server = {
--             on_attach = on_attach,
--             settings  = {
--                 ['rust-analyzer'] = {
--                     checkOnSave = {
--                         command = 'clippy'
--                     },
--                     cargo = {
--                         loadOutDirsFromCheck = true
--                     },
--                     procMacro = {
--                         enable = true
--                     },
--                     diagnostics = {
--                         enable = true,
--                         enableExperimental = false,
--                     },
--                     lens = {
--                         enable = true,
--                     },
--                     -- remove/enable once fixed:
--                     -- https://github.com/simrat39/rust-tools.nvim/issues/300
--                     inlayHints = {
--                         locationLinks = false
--                     }
--                 }
--             }
--         },
--     })
-- end

cmp.setup {
    preselect = cmp.PreselectMode.None,
    snippet = {
        expand = function(args)
            vim.fn['vsnip#anonymous'](args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-y>'] = cmp.mapping(
            cmp.mapping.confirm {
                behavior = cmp.ConfirmBehavior.Insert,
                select   = true,
            },
            { 'i', 'c' }
        ),
        -- TODO: testing mapping
        ['<M-y>'] = cmp.mapping(
            cmp.mapping.confirm {
                behavior = cmp.ConfirmBehavior.Replace,
                select = false,
            },
            { 'i', 'c' }
        ),
        -- TODO: testing mapping
        ['<C-space>'] = cmp.mapping {
            i = cmp.mapping.complete(),
            c = function(
                _ --[[fallback]]
            )
                if cmp.visible() then
                    if not cmp.confirm { select = true } then
                        return
                    end
                else
                    cmp.complete()
                end
            end,
        },
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-e>'] = cmp.mapping.abort(),
        -- this interferes with GitHub Copilot
        -- ['<Tab>'] = cmp.mapping(
        --     function(fallback)
        --         if vim.fn['vsnip#jumpable'](1) == 1 then
        --             vim.fn.feedkeys(
        --                 vim.api.nvim_replace_termcodes(
        --                     '<Plug>(vsnip-jump-next)',
        --                     true,
        --                     true,
        --                     true
        --                 ),
        --                 ''
        --             )
        --         else
        --             fallback()
        --         end
        --     end,
        --     { 'i', 's' }
        -- ),
        ['<S-Tab>'] = cmp.mapping(
            function(fallback)
                if vim.fn['vsnip#jumpable'](-1) == 1 then
                    vim.fn.feedkeys(
                        vim.api.nvim_replace_termcodes(
                            '<Plug>(vsnip-jump-prev)',
                            true,
                            true,
                            true
                        ),
                        ''
                    )
                else
                    fallback()
                end
            end,
            { 'i', 's' }
        ),
    }),
    formatting = {
        format = lspkind.cmp_format({
            mode = 'symbol_text',
            menu = {
                nvim_lsp = '[nvim_lsp]',
                vsnip    = '[vsnip]',
                buffer   = '[buffer]',
                nvim_lua = '[nvim_lua]',
                path     = '[path]',
            },
        }),
    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
        { name = 'nvim_lua' },
        { name = 'path' },
    }, {
        { name = 'buffer', keyword_length = 3 },
    }),
    sorting = {
        priority_weight = 2,
        comparators = {
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            cmp.config.compare.offset,
            cmp.config.compare.order,
        },
    },
    experimental = {
        native_menu = false,
        ghost_text  = false, -- Does not work well with Copilot
    },
}
