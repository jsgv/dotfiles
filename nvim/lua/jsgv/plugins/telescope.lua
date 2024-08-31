if not pcall(require, 'telescope') then
  return
end

local actions       = require('telescope.actions')
local builtin       = require('telescope.builtin')
local action_layout = require('telescope.actions.layout')

-- Files
vim.keymap.set('n', '<Leader>ff',  function () builtin.find_files() end)
vim.keymap.set('n', '<Leader>fg',  function () builtin.live_grep() end)
vim.keymap.set('n', '<Leader>fb',  function () builtin.buffers() end)

-- LSP
vim.keymap.set('n', '<Leader>fdi', function () builtin.diagnostics() end)
vim.keymap.set('n', '<Leader>fi',  function () builtin.lsp_implementations() end)
vim.keymap.set('n', '<Leader>fds', function () builtin.lsp_document_symbols() end)
vim.keymap.set('n', '<Leader>fws', function () builtin.lsp_dynamic_workspace_symbols() end)
vim.keymap.set('n', '<Leader>fr',  function () builtin.lsp_references({ include_current_line = true, show_line = false }) end)

-- Git
vim.keymap.set('n', '<Leader>gst', function () builtin.git_status() end)
vim.keymap.set('n', '<Leader>gcc', function () builtin.git_commits() end)

-- Extra
vim.keymap.set('n', '<Leader>ta',  function () builtin.builtin() end)

require('telescope').setup {
    defaults = {
        layout_strategy = 'horizontal',
        layout_config = {
            width  = 0.95,
            height = 0.85,
            prompt_position = 'bottom',

            horizontal = {
                preview_width = function(_, cols, _)
                    return math.floor(cols * 0.6)
                end,
            },

            vertical = {
                width  = 0.9,
                height = 0.95,
                preview_height = 0.5,
            },

            flex = {
                horizontal = {
                    preview_width = 0.9,
                },
            },
        },
        file_ignore_patterns = {
            'node_modules/.*',
            -- 'vendor/.*',
        },
        mappings = {
            i = {
                ['<C-k>'] = actions.move_selection_previous,
                ['<C-j>'] = actions.move_selection_next,
                ['<C-x>'] = actions.delete_buffer,
                ['<C-s>'] = actions.file_split,

                ['<RightMouse>']      = actions.close,
                ['<LeftMouse>']       = actions.select_default,
                ['<ScrollWheelDown>'] = actions.move_selection_next,
                ['<ScrollWheelUp>']   = actions.move_selection_previous,

                ['<M-p>'] = action_layout.toggle_preview,
                ['<M-m>'] = action_layout.toggle_mirror,
            }
        },
    },
    pickers = {
        buffers = {
            sort_lastused = true,
        },
    },
}
