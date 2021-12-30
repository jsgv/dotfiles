vim.opt.foldenable      = false
vim.opt.foldmethod      = 'expr'
vim.opt.foldexpr        = 'nvim_treesitter#foldexpr()'
vim.opt.foldlevel       = 1
vim.opt.foldlevelstart  = 99

vim.api.nvim_set_keymap('n', '<F9>', 'za', { noremap = true })

require('nvim-treesitter.configs').setup {
    ensure_installed = {
        'bash',
        'cpp',
        'css',
        'go',
        'graphql',
        'html',
        'javascript',
        'json',
        'json5',
        'lua',
        'php',
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

    highlight = {
        enable = true,
    },

    playground = {
        enable                    = true,
        toggle_query_editor       = 'o',
        toggle_hl_groups          = 'i',
        toggle_injected_languages = 't',
        toggle_anonymous_nodes    = 'a',
        toggle_language_display   = 'I',
        focus_language            = 'f',
        unfocus_language          = 'F',
        update                    = 'R',
        goto_node                 = '<cr>',
        show_help                 = '?',
    },
}
