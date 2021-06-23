vim.g.mapleader = ","
vim.opt.inccommand = "split"
vim.opt.mouse = "a"
vim.opt.wrap = true
vim.opt.autoindent = true
vim.opt.autoread = true
vim.opt.cindent = true
vim.opt.cursorline = true
vim.opt.hidden = true
vim.opt.ignorecase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.g.nobackup = true
vim.g.nowritebackup = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.backspace = "indent,eol,start"
vim.opt.clipboard = "unnamedplus"
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.history = 50
vim.opt.laststatus = 2
vim.opt.scroll = 15
vim.opt.scrolloff = 10
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.updatetime = 300
vim.opt.wildmode = "list:longest,list:full"
vim.opt.list = true

vim.g.python_host_skip_check = 1
vim.g.python3_host_skip_check = 1
vim.g.python_host_prog = '/usr/bin/python'
vim.g.python3_host_prog = '/usr/local/bin/python3'
vim.g.perl_host_prog = '/usr/local/bin/perl'

vim.o.completeopt = "menuone,noselect"

local opts = { noremap = true }

vim.api.nvim_set_keymap('n', '<Leader>w', ':w<CR>', opts)
vim.api.nvim_set_keymap('n', 'j', 'gj', opts)
vim.api.nvim_set_keymap('n', 'k', 'gk', opts)
vim.api.nvim_set_keymap('i', 'jj', '<ESC>l', opts)

-- Pane hopping
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', opts)
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', opts)
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', opts)
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', opts)

-- Vim commentary
vim.api.nvim_set_keymap('n', '<C-\\>', ':Commentary<CR>', opts)
vim.api.nvim_set_keymap('x', '<C-\\>', ':Commentary<CR>', opts)

-- Telescope
vim.api.nvim_set_keymap('n', '<Leader>ff', '<Cmd>Telescope find_files<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>fg', '<Cmd>Telescope live_grep<CR>',  opts)
vim.api.nvim_set_keymap('n', '<Leader>fb', '<Cmd>Telescope buffers<CR>',    opts)
vim.api.nvim_set_keymap('n', '<Leader>fh', '<Cmd>Telescope help_tags<CR>',  opts)

-- NERDTree
vim.g.NERDTreeShowHidden = 1
vim.g.NERDTreeIgnore = { '^.DS_Store$', 'node_modules', '.git$[[dir]]' }
vim.g.NERDTreeMapOpenSplit = 's'
vim.g.NERDTreeMapOpenVSplit = 'v'
vim.api.nvim_set_keymap('', '<C-b>', ':NERDTreeToggle<CR>',  opts)

-- Start NERDTree when Vim is started without file arguments.
vim.api.nvim_exec([[
    autocmd StdinReadPre * let s:std_in=1
    autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif
]], false)

-- Only show relative numbers in the current pane
-- Toggle when switching between panes
vim.api.nvim_exec([[
    function! SetRelativeNumber() abort
        if (bufname("%") =~ "NERD_Tree_")
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
]], false)
