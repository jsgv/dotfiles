local actions = require('telescope.actions')

local opts = { noremap = true }

vim.api.nvim_set_keymap('n', '<Leader>ff', '<Cmd>Telescope find_files<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>fg', '<Cmd>Telescope live_grep<CR>',  opts)
vim.api.nvim_set_keymap('n', '<Leader>fh', '<Cmd>Telescope help_tags<CR>',  opts)
vim.api.nvim_set_keymap('n', '<Leader>fb', '<Cmd>Telescope buffers<CR>',    opts)
vim.api.nvim_set_keymap('n', '<Leader>fds', '<Cmd>Telescope lsp_document_symbols<CR>',    opts)

-- set buffers window to open in normal in order to quickly select buffer (currently does not work)
-- ref: https://github.com/nvim-telescope/telescope.nvim/issues/750
-- vim.api.nvim_set_keymap('n', '<Leader>fb', '<Cmd>Telescope buffers initial_mode=normal<CR>',    opts)

require("telescope").setup {
    defaults = {
        mappings = {
            i = {
                ['<C-k>'] = actions.move_selection_previous,
                ['<C-j>'] = actions.move_selection_next,
                ['<C-d>'] = actions.delete_buffer,
            }
        },
    },
    pickers = {
        buffers = {
            sort_lastused = true,
        },
        find_files = {
            prompt_prefix = "🔍",
            -- find_command = { 'rg' },
        },
    },
}
