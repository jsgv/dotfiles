require('nvim-treesitter.configs').setup {
    ensure_installed = {
        "go",
        "rust",
        "toml",
        "typescript",
        "tsx",
        "ql",
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
