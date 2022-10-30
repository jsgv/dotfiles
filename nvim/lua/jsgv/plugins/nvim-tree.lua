local tree_cb = require('nvim-tree.config').nvim_tree_callback

require('nvim-tree').setup({
    git = {
        enable = false,
        ignore = false,
    },
    view = {
        width = 30,
        mappings = {
            custom_only = false,
            list = {
                { key = {'<CR>', 'o', '<2-LeftMouse>'}, cb = tree_cb('edit') },
                { key = {'<2-RightMouse>', '<C-]>'},    cb = tree_cb('cd') },
                { key = 'v',                            cb = tree_cb('vsplit') },
                { key = 's',                            cb = tree_cb('split') },
                { key = 'r',                            cb = tree_cb('rename') },
                { key = 'p',                            cb = tree_cb('parent_node') },
            },
        }
    },
    renderer = {
        highlight_git = false,
        root_folder_modifier = ':t',

        -- disable special highlighting for 'special' files.
        special_files = {},
    },
    filters = {
        custom = {
            '.DS_Store'
        },
    },
})

vim.api.nvim_set_keymap('', '<C-b>', ':NvimTreeToggle<CR>', { noremap = true })
