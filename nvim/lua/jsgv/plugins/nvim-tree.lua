local tree_cb = require('nvim-tree.config').nvim_tree_callback

vim.g.nvim_tree_root_folder_modifier = ':t'
vim.g.nvim_tree_git_hl = 0
vim.g.nvim_tree_git_hl = 0

-- Disable special highlighting for certain files.
vim.g.nvim_tree_special_files = {}

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
    }
})

vim.api.nvim_set_keymap('', '<C-b>', ':NvimTreeToggle<CR>', { noremap = true })
