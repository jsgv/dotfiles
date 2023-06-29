vim.g.mapleader               = ','
vim.opt.inccommand            = 'split'
vim.opt.mouse                 = 'a'
vim.opt.wrap                  = true
vim.opt.autoindent            = true
vim.opt.autoread              = true
vim.opt.cindent               = true
vim.opt.cursorline            = true
vim.opt.hidden                = true
vim.opt.ignorecase            = true
vim.opt.hlsearch              = true
vim.g.noincsearch             = true
vim.opt.linebreak             = true
vim.opt.breakindent           = true
vim.g.nobackup                = true
vim.g.nowritebackup           = true
vim.opt.number                = true
vim.opt.relativenumber        = true
vim.opt.smartcase             = true
vim.opt.smartindent           = true
vim.opt.smarttab              = true
vim.opt.backspace             = 'indent,eol,start'
vim.opt.clipboard             = 'unnamedplus'
vim.opt.encoding              = 'utf-8'
vim.opt.fileencoding          = 'utf-8'
vim.opt.history               = 50
vim.opt.laststatus            = 2
vim.opt.scroll                = 15
vim.opt.scrolloff             = 10
vim.opt.expandtab             = true
vim.opt.tabstop               = 4
vim.opt.softtabstop           = 4
vim.opt.shiftwidth            = 4
vim.opt.updatetime            = 300
vim.opt.wildmode              = 'list:longest,list:full'
vim.opt.list                  = true
vim.g.python_host_skip_check  = 1
vim.g.python3_host_skip_check = 1
vim.g.python_host_prog        = '/usr/bin/python'
vim.g.python3_host_prog       = '/usr/local/bin/python3'
vim.g.perl_host_prog          = '/usr/local/bin/perl'
vim.o.completeopt             = 'menuone,noselect'
vim.g.loaded_perl_provider    = 0
vim.opt.signcolumn            = 'yes'

vim.cmd([[
    set termguicolors
    set colorcolumn=80
]])

local opts = { noremap = true }

vim.api.nvim_set_keymap('n', '<Leader>w',  ':w<CR>', opts)
vim.api.nvim_set_keymap('n', 'j',          'gj', opts)
vim.api.nvim_set_keymap('n', 'k',          'gk', opts)
vim.api.nvim_set_keymap('i', 'jj',         '<ESC>l', opts)
vim.api.nvim_set_keymap('n', '<C-p>',      ':e#<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>fc', ':NvimTreeFindFile<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>p',  ':!pwd<CR>', opts)

-- [BEGIN testing] checking to see if they work for me

vim.api.nvim_set_keymap('n', 'J', 'mzJ`z', opts)
-- vim.api.nvim_set_keymap('n', 'n', 'nzzzv', opts)
-- vim.api.nvim_set_keymap('n', 'N', 'Nzzzv', opts)
-- vim.api.nvim_set_keymap('i', ',', ',<C-g>u', opts)
-- vim.api.nvim_set_keymap('i', '.', '.<C-g>u', opts)
-- vim.api.nvim_set_keymap('i', '!', '!<C-g>u', opts)
-- vim.api.nvim_set_keymap('i', '?', '?<C-g>u', opts)

-- [END testing]

-- Pane hopping
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', opts)
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', opts)
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', opts)
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', opts)

vim.api.nvim_set_keymap('n', '<C-w>m', '<C-w>_<CR><C-w>|<CR>', opts)

-- Only show relative numbers in the current pane
-- Toggle when switching between panes
vim.cmd([[
    function! SetRelativeNumber() abort
        if (bufname('%') =~ 'NvimTree')
            return
        endif
        set relativenumber
    endfunction

    function! SetNoRelativeNumber() abort
        set norelativenumber
    endfunction

    augroup numbertoggle
        autocmd!
        autocmd BufEnter,FocusGained,InsertLeave * call SetRelativeNumber()
        autocmd BufLeave,FocusLost,InsertEnter   * call SetNoRelativeNumber()
    augroup END
]])
