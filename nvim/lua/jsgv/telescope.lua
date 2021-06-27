local actions = require('telescope.actions')

require("telescope").setup {
    pickers = {
        buffers = {
            sort_lastused = true,
            mappings = {
                i = {
                    ['<C-k>'] = actions.move_selection_previous,
                    ['<C-j>'] = actions.move_selection_next,
                    ['<C-d>'] = actions.delete_buffer,
                }
            }
        },
    },
}
