local actions = require('telescope.actions')

local key_maps = {}

key_maps['<Leader>ff']  = ':lua require(\'telescope.builtin\').find_files()<CR>'
key_maps['<Leader>fg']  = ':lua require(\'telescope.builtin\').live_grep()<CR>'
key_maps['<Leader>fb']  = ':lua require(\'telescope.builtin\').buffers()<CR>'
key_maps['<Leader>fr']  = ':lua require(\'telescope.builtin\').lsp_references()<CR>'
key_maps['<Leader>fi']  = ':lua require(\'telescope.builtin\').lsp_implementations()<CR>'
key_maps['<Leader>fds'] = ':lua require(\'telescope.builtin\').lsp_document_symbols()<CR>'
key_maps['<Leader>gst'] = ':lua require(\'telescope.builtin\').git_status()<CR>'
key_maps['<Leader>fwd'] = ':lua require(\'telescope.builtin\').diagnostics()<CR>'

for key, value in pairs(key_maps) do
    vim.api.nvim_set_keymap('n', key, value, { noremap = true })
end

require('telescope').setup {
    defaults = {
        file_sorter     = require('telescope.sorters').get_generic_fuzzy_sorter,
        layout_strategy = 'vertical',
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
