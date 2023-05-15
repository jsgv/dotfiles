local actions = require('telescope.actions')
local builtin = require('telescope.builtin')
local sorters = require('telescope.sorters')

vim.keymap.set('n', '<Leader>ta', function () builtin.builtin() end)

vim.keymap.set('n', '<Leader>ff', function () builtin.find_files() end)
vim.keymap.set('n', '<Leader>fg', function () builtin.live_grep() end)
vim.keymap.set('n', '<Leader>fb', function () builtin.buffers() end)
vim.keymap.set('n', '<Leader>fr', function () builtin.lsp_references() end)
vim.keymap.set('n', '<Leader>fi', function () builtin.lsp_implementations() end)
vim.keymap.set('n', '<Leader>fds', function () builtin.lsp_document_symbols() end)
vim.keymap.set('n', '<Leader>fdi', function () builtin.diagnostics({ bufnr = 0 }) end)
-- vim.keymap.set('n', '<Leader>fwd', function () builtin..diagnostics() end)
-- key_maps['<Leader>fdi'] = ':lua require(\'telescope.builtin\').diagnostics({ bufnr: 0 })<CR>'
-- key_maps['<Leader>fwd'] = ':lua require(\'telescope.builtin\').diagnostics()<CR>'

-- Git
vim.keymap.set('n', '<Leader>gst', function () builtin.git_status() end)

require('telescope').setup {
    defaults = {
        file_sorter          = sorters.get_fuzzy_file,
        layout_strategy      = 'vertical',
        file_ignore_patterns = {
            'node_modules/.*',
            'build/.*',
        },
        mappings = {
            i = {
                ['<C-k>'] = actions.move_selection_previous,
                ['<C-j>'] = actions.move_selection_next,
                ['<C-x>'] = actions.delete_buffer,
                ['<C-s>'] = actions.file_split,
            }
        },
    },
    pickers = {
        buffers = {
            sort_lastused = true,
        },
    },
}
