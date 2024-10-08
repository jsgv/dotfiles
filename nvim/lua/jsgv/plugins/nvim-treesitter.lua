if not pcall(require, 'nvim-treesitter.configs') then
    return
end

require("nvim-treesitter.parsers").get_parser_configs().just = {
    install_info = {
        url = "https://github.com/IndianBoy42/tree-sitter-just", -- local path or git repo
        files = { "src/parser.c", "src/scanner.c" },
        branch = "main",
        -- use_makefile = true -- this may be necessary on MacOS (try if you see compiler errors)
    },
    maintainers = { "@IndianBoy42" },
}

local treesitter_configs                                     = require('nvim-treesitter.configs')

vim.opt.foldenable                                           = false
vim.opt.foldmethod                                           = 'expr'
vim.opt.foldexpr                                             = 'nvim_treesitter#foldexpr()'
vim.opt.foldlevel                                            = 1
vim.opt.foldlevelstart                                       = 99

vim.api.nvim_set_keymap('n', '<F9>', 'za', { noremap = true })

treesitter_configs.setup {
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
        'terraform',
        'toml',
        'tsx',
        'terraform',
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
