local actions = require('telescope.actions')

local key_maps = {}

key_maps['<Leader>ff']  = '<Cmd>Telescope find_files<CR>'
key_maps['<Leader>fg']  = '<Cmd>Telescope live_grep<CR>'
key_maps['<Leader>fb']  = '<Cmd>Telescope buffers<CR>'
key_maps['<Leader>fr']  = '<Cmd>Telescope lsp_references<CR>'
key_maps['<Leader>fi']  = '<Cmd>Telescope lsp_implementations<CR>'
key_maps['<Leader>fds'] = '<Cmd>Telescope lsp_document_symbols<CR>'

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
