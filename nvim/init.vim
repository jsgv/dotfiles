lua << EOF
    -- vim.lsp.set_log_level("debug")
EOF

lua require('jsgv.plugins')
lua require('jsgv.setup')
lua require('jsgv.lsp')
lua require('jsgv.treesitter')
lua require('jsgv.telescope')

autocmd VimEnter,VimResume  * set guicursor=n-v-c-sm:block,i-ci-ve:ver25-Cursor,r-cr-o:hor20
autocmd VimLeave,VimSuspend * set guicursor=a:hor20

" ColorScheme Nord - TODO: port to Lua
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
" ColorScheme Nord

