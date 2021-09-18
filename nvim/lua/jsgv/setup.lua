-- autocmd VimEnter,VimResume  * set guicursor=n-v-c-sm:block,i-ci-ve:ver25-Cursor,r-cr-o:hor20
-- autocmd VimLeave,VimSuspend * set guicursor=a:hor20

vim.g.mapleader               = ","
vim.opt.inccommand            = "split"
vim.opt.mouse                 = "a"
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
vim.opt.backspace             = "indent,eol,start"
vim.opt.clipboard             = "unnamedplus"
vim.opt.encoding              = "utf-8"
vim.opt.fileencoding          = "utf-8"
vim.opt.history               = 50
vim.opt.laststatus            = 2
vim.opt.scroll                = 15
vim.opt.scrolloff             = 10
vim.opt.expandtab             = true
vim.opt.tabstop               = 4
vim.opt.softtabstop           = 4
vim.opt.shiftwidth            = 4
vim.opt.updatetime            = 300
vim.opt.wildmode              = "list:longest,list:full"
vim.opt.list                  = true
vim.g.python_host_skip_check  = 1
vim.g.python3_host_skip_check = 1
vim.g.python_host_prog        = '/usr/bin/python'
vim.g.python3_host_prog       = '/usr/local/bin/python3'
vim.g.perl_host_prog          = '/usr/local/bin/perl'
vim.o.completeopt             = 'menuone,noselect'
vim.g.loaded_perl_provider    = 0
vim.opt.signcolumn              = "yes"

local opts = { noremap = true }

vim.api.nvim_set_keymap('n', '<Leader>w', ':w<CR>', opts)
vim.api.nvim_set_keymap('n', 'j',         'gj',     opts)
vim.api.nvim_set_keymap('n', 'k',         'gk',     opts)
vim.api.nvim_set_keymap('i', 'jj',        '<ESC>l', opts)

-- [BEGIN testing]
-- checking to see if they work for me
vim.api.nvim_set_keymap('n', 'Y', 'y$', opts)
vim.api.nvim_set_keymap('n', 'n', 'nzzzv', opts)
vim.api.nvim_set_keymap('n', 'N', 'Nzzzv', opts)
vim.api.nvim_set_keymap('n', 'J', 'mzJ`z', opts)

vim.api.nvim_set_keymap('i', ',', ',<C-g>u', opts)
vim.api.nvim_set_keymap('i', '.', '.<C-g>u', opts)
vim.api.nvim_set_keymap('i', '!', '!<C-g>u', opts)
vim.api.nvim_set_keymap('i', '?', '?<C-g>u', opts)

vim.api.nvim_set_keymap('v', 'J',     ':m \'>+1<CR>gv=gv', opts)
vim.api.nvim_set_keymap('v', 'K',     ':m \'<-2<CR>gv=gv', opts)
-- vim.api.nvim_set_keymap('i', '<C-j>', '<ESC>:m .+1<CR>==', opts)
-- vim.api.nvim_set_keymap('i', '<C-k>', '<ESC>:m .-2<CR>==', opts)
vim.api.nvim_set_keymap('n', '<Leader>j', ':m .+1<CR>==', opts)
vim.api.nvim_set_keymap('n', '<Leader>k', ':m .-2<CR>==', opts)
-- [END testing]

-- Pane hopping
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', opts)
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', opts)
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', opts)
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', opts)

vim.api.nvim_exec([[
    autocmd StdinReadPre * let s:std_in=1
    autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | else | NERDTree | wincmd p | endif
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

-- Nord colorscheme
vim.cmd([[
    augroup nord_theme_overrides
        autocmd!
        autocmd ColorScheme nord highlight ExtraWhitespace ctermfg=11 guifg=#bf616a
        autocmd ColorScheme nord match ExtraWhiteSpace /\s\+$/
    augroup END

    set termguicolors
    let g:nord_italic_comments = 1
    let g:nord_underline = 1
    let g:nord_italic = 1
    colorscheme nord
    set cc=80
]])
