if not pcall(require, 'lspconfig') then
    return
end

if not pcall(require, 'lspkind') then
    return
end

if not pcall(require, 'cmp') then
    return
end

-- local nvim_lsp = require('lspconfig')
-- local nvim_lsp = vim.lsp.config
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
    local function keymap_set(mode, lhs, rhs)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr })
    end

    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- https://neovim.io/doc/user/lsp.html#_global-defaults
    -- gra = vim.lsp.buf.code_action()

    keymap_set('n', 'E', function() vim.diagnostic.open_float({ scope = "line" }) end)
    keymap_set('n', '<C-]>', function() vim.lsp.buf.definition() end)
    -- keymap_set('n', 'K', function() vim.lsp.buf.hover({ close_events = { "BufWinLeave" } }) end)
    keymap_set('n', 'K', function() vim.lsp.buf.hover() end)
    keymap_set('n', 'gh', function() vim.lsp.buf.document_highlight() end)
    keymap_set('n', 'gc', function() vim.lsp.buf.clear_references() end)
    keymap_set('n', 'ge', function() vim.diagnostic.set_loclist() end)
    keymap_set('n', '<space>f', function() vim.lsp.buf.format({ timeout_ms = 2000 }) end)

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
vim.lsp.config('gopls', {
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
vim.lsp.enable('gopls')

-- Proto
-- vim.lsp.config('buf_ls', {
--     on_attach    = on_attach,
--     capabilities = capabilities,
-- })

-- Python
-- vim.lsp.config('pyright', {
--     on_attach    = on_attach,
--     capabilities = capabilities,
-- })

-- Prisma
-- vim.lsp.config('prismals', {
--     on_attach    = on_attach,
--     capabilities = capabilities,
-- })

-- Tailwind CSS
vim.lsp.config('tailwindcss', {
    on_attach    = on_attach,
    capabilities = capabilities,
})
vim.lsp.enable('tailwindcss')

-- Terraform
vim.lsp.config('terraformls', {
    on_attach    = on_attach,
    capabilities = capabilities,
})
vim.lsp.enable('terraformls')

-- Java
vim.lsp.config('jdtls', {
    on_attach    = on_attach,
    capabilities = capabilities,
})
vim.lsp.enable('jdtls')

-- TypeScript
vim.lsp.config('ts_ls', {
    on_attach    = on_attach,
    capabilities = capabilities,
})
vim.lsp.enable('ts_ls')

-- C/C++
-- vim.lsp.config('clangd', {
--     on_attach    = on_attach,
--     capabilities = capabilities,
--     -- filetypes    = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
--     -- cmd       = { 'clangd', '--background-index', '--clang-tidy' },
--     -- root_dir  = function() return vim.loop.cwd() end
-- })

-- Lua
vim.lsp.config('lua_ls', {
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
vim.lsp.enable('lua_ls')

-- Rust
vim.lsp.config('rust_analyzer', {
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
vim.lsp.enable('rust_analyzer')

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
