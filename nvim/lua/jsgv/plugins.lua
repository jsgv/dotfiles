return {
    -- Colorscheme
    {
        'ellisonleao/gruvbox.nvim',
        priority = 1000,
        config = function()
            require('gruvbox').setup({
                bold = false,
            })
            vim.o.background = 'dark'
            vim.cmd([[colorscheme gruvbox]])
        end,
    },

    -- Statusline
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('lualine').setup({})
        end,
    },

    -- Git
    'airblade/vim-gitgutter',
    {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup()
        end,
    },
    'tpope/vim-fugitive',

    -- Go
    {
        'fatih/vim-go',
        build = ':GoInstallBinaries',
        config = function()
            vim.g.go_template_use_pkg = 1
            vim.g.go_gopls_gofumpt = 1
        end,
    },

    -- Telescope
    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-lua/popup.nvim',
        },
        config = function()
            local actions       = require('telescope.actions')
            local builtin       = require('telescope.builtin')
            local action_layout = require('telescope.actions.layout')

            -- Files
            vim.keymap.set('n', '<Leader>ff', function() builtin.find_files({ hidden = true }) end)
            vim.keymap.set('n', '<Leader>fg', function() builtin.live_grep({ additional_args = { "--hidden" } }) end)
            vim.keymap.set('n', '<Leader>fb', function() builtin.buffers() end)

            -- LSP
            vim.keymap.set('n', '<Leader>fdi', function() builtin.diagnostics({ bufnr = nil }) end)
            vim.keymap.set('n', '<Leader>fi', function() builtin.lsp_implementations() end)
            vim.keymap.set('n', '<Leader>fds', function() builtin.lsp_document_symbols() end)
            vim.keymap.set('n', '<Leader>fws', function() builtin.lsp_dynamic_workspace_symbols() end)
            vim.keymap.set('n', '<Leader>fr',
                function() builtin.lsp_references({ include_current_line = true, show_line = false }) end)

            -- Git
            vim.keymap.set('n', '<Leader>gst', function() builtin.git_status() end)
            vim.keymap.set('n', '<Leader>gcc', function() builtin.git_commits() end)

            -- Extra
            vim.keymap.set('n', '<Leader>ta', function() builtin.builtin() end)

            require('telescope').setup {
                defaults = {
                    layout_strategy = 'horizontal',
                    layout_config = {
                        width           = 0.95,
                        height          = 0.85,
                        prompt_position = 'bottom',

                        horizontal      = {
                            preview_width = function(_, cols, _)
                                return math.floor(cols * 0.6)
                            end,
                        },
                        vertical        = {
                            width          = 0.9,
                            height         = 0.95,
                            preview_height = 0.5,
                        },
                        flex            = {
                            horizontal = {
                                preview_width = 0.9,
                            },
                        },
                    },
                    file_ignore_patterns = {
                        'node_modules/.*',
                        '.git/.*',
                        'venv/.*',
                        '__pycache__/.*',
                    },
                    mappings = {
                        i = {
                            ['<C-k>']             = actions.move_selection_previous,
                            ['<C-j>']             = actions.move_selection_next,
                            ['<C-x>']             = actions.delete_buffer,
                            ['<C-s>']             = actions.file_split,

                            ['<RightMouse>']      = actions.close,
                            ['<LeftMouse>']       = actions.select_default,
                            ['<ScrollWheelDown>'] = actions.move_selection_next,
                            ['<ScrollWheelUp>']   = actions.move_selection_previous,

                            ['<M-p>']             = action_layout.toggle_preview,
                            ['<M-m>']             = action_layout.toggle_mirror,
                        },
                    },
                },
                pickers = {
                    buffers = {
                        sort_lastused = true,
                    },
                },
            }
        end,
    },

    -- LSP
    'neovim/nvim-lspconfig',

    -- Treesitter
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        config = function()
            vim.opt.foldenable     = false
            vim.opt.foldmethod     = 'expr'
            vim.opt.foldexpr       = 'v:lua.vim.treesitter.foldexpr()'
            vim.opt.foldlevel      = 1
            vim.opt.foldlevelstart = 99

            vim.api.nvim_set_keymap('n', '<F9>', 'za', { noremap = true })

            require('nvim-treesitter').setup({
                ensure_installed = {
                    'bash',
                    'comment',
                    'cpp',
                    'css',
                    'dockerfile',
                    'go',
                    'graphql',
                    'hcl',
                    'html',
                    'java',
                    'javascript',
                    'json',
                    'json5',
                    'kotlin',
                    'lua',
                    'markdown',
                    'php',
                    'prisma',
                    'python',
                    'ql',
                    'regex',
                    'rust',
                    'scss',
                    'toml',
                    'tsx',
                    'typescript',
                    'yaml',
                },
            })
        end,
    },

    -- Java
    'mfussenegger/nvim-jdtls',

    -- Completion
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-nvim-lua',
            'onsails/lspkind-nvim',
            'hrsh7th/cmp-vsnip',
            'hrsh7th/vim-vsnip',
        },
    },

    -- Copilot
    'github/copilot.vim',

    -- Prettier
    {
        'prettier/vim-prettier',
        config = function()
            vim.g['prettier#autoformat'] = 1
            vim.g['prettier#autoformat_require_pragma'] = 0
            vim.g['prettier#autoformat_config_present'] = 1
        end,
    },

    -- Editing
    {
        'tpope/vim-commentary',
        config = function()
            local opts = { noremap = true }
            vim.api.nvim_set_keymap('n', '<C-\\>', ':Commentary<CR>', opts)
            vim.api.nvim_set_keymap('x', '<C-\\>', ':Commentary<CR>', opts)
        end,
    },

    -- AI
    -- {
    --     'yetone/avante.nvim',
    --     event = 'VeryLazy',
    --     version = false,
    --     build = 'make',
    --     opts = {
    --         provider = 'claude',
    --         providers = {
    --             claude = {
    --                 endpoint = 'https://api.anthropic.com',
    --                 model = 'claude-sonnet-4-20250514',
    --                 timeout = 30000,
    --                 extra_request_body = {
    --                     temperature = 0.75,
    --                     max_tokens = 20480,
    --                 },
    --             },
    --         },
    --     },
    --     dependencies = {
    --         'nvim-lua/plenary.nvim',
    --         'MunifTanjim/nui.nvim',
    --         'stevearc/dressing.nvim',
    --         'nvim-tree/nvim-web-devicons',
    --         'HakonHarnes/img-clip.nvim',
    --         'MeanderingProgrammer/render-markdown.nvim',
    --     },
    -- },
}
