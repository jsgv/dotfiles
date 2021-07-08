local actions = require('telescope.actions')

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
