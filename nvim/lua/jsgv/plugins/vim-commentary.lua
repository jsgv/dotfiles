local opts = { noremap = true }

vim.api.nvim_set_keymap('n', '<C-\\>', ':Commentary<CR>', opts)
vim.api.nvim_set_keymap('x', '<C-\\>', ':Commentary<CR>', opts)
