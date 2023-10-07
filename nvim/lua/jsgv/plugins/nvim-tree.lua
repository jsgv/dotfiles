local function on_attach(bufnr)
  local api = require('nvim-tree.api')

  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  api.config.mappings.default_on_attach(bufnr)

  vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))
  vim.keymap.set('n', 'o', api.node.open.edit, opts('Open'))
  vim.keymap.set('n', '<2-LeftMouse>', api.node.open.edit, opts('Open'))
  vim.keymap.set('n', '<2-RightMouse>', api.tree.change_root_to_node, opts('CD'))
  vim.keymap.set('n', '<C-]>', api.tree.change_root_to_node, opts('CD'))
  vim.keymap.set('n', 'v', api.node.open.vertical, opts('Open: Vertical Split'))
  vim.keymap.set('n', 's', api.node.open.horizontal, opts('Open: Horizontal Split'))
  vim.keymap.set('n', 'r', api.fs.rename, opts('Rename'))
  vim.keymap.set('n', 'p', api.node.navigate.parent, opts('Parent Directory'))
end

require('nvim-tree').setup({
    on_attach = on_attach,
    git = {
        enable = false,
        ignore = false,
    },
    view = {
        width = 30,
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
    -- update_focused_file = {
    --     enable = true,
    -- },
})

vim.api.nvim_set_keymap('', '<C-b>', ':NvimTreeToggle<CR>', { noremap = true })
