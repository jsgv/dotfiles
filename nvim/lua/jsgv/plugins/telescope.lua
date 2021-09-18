local actions = require('telescope.actions')

local key_maps = {}
key_maps["<Leader>ff"]  = "<Cmd>Telescope find_files<CR>"
key_maps["<Leader>fg"]  = "<Cmd>Telescope live_grep<CR>"
key_maps["<Leader>fb"]  = "<Cmd>Telescope buffers<CR>"
key_maps["<Leader>fr"]  = "<Cmd>Telescope lsp_references<CR>"
key_maps["<Leader>fi"]  = "<Cmd>Telescope lsp_implementations<CR>"
key_maps["<Leader>fds"] = "<Cmd>Telescope lsp_document_symbols<CR>"

for key, value in pairs(key_maps) do
    vim.api.nvim_set_keymap('n', key, value, { noremap = true })
end

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
            prompt_prefix = " 🔍 ",
            -- find_command = { 'rg' },
        },
    },
}
