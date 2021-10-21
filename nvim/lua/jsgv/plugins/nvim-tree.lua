local tree_cb = require('nvim-tree.config').nvim_tree_callback

local list = {
    { key = {'<CR>', 'o', '<2-LeftMouse>'}, cb = tree_cb('edit') },
    { key = {'<2-RightMouse>', '<C-]>'},    cb = tree_cb('cd') },
    { key = 'v',                            cb = tree_cb('vsplit') },
    { key = 's',                            cb = tree_cb('split') },
    { key = 'r',                            cb = tree_cb('rename') },
}

require('nvim-tree').setup({
    view = {
        width = 30,
        auto_resize = true,
        mappings = {
            custom_only = false,
            list = list,
        }
    }
})

vim.api.nvim_set_keymap('', '<C-b>', ':NvimTreeToggle<CR>', { noremap = true })
