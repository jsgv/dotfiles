vim.g.NERDTreeShowHidden    = 1
vim.g.NERDTreeIgnore        = { '^.DS_Store$', 'node_modules', '.git$[[dir]]' }
vim.g.NERDTreeMapOpenSplit  = 's'
vim.g.NERDTreeMapOpenVSplit = 'v'

local opts = { noremap = true }

vim.api.nvim_set_keymap('', '<C-b>', ':NERDTreeToggle<CR>',  opts)
