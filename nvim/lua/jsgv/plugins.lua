vim.cmd([[packadd packer.nvim]])

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use 'arcticicestudio/nord-vim'
    use 'scrooloose/nerdtree'

    use 'nvim-lua/popup.nvim'
    use 'nvim-lua/plenary.nvim'
    use 'nvim-telescope/telescope.nvim'

    use 'tpope/vim-fugitive'
    use 'tpope/vim-commentary'
    -- use 'tpope/vim-surround'

    use 'airblade/vim-gitgutter'
    use 'vim-airline/vim-airline'

    use { 'fatih/vim-go', run = ':GoInstallBinaries' }
    use 'cakebaker/scss-syntax.vim'
    use 'chr4/nginx.vim'

    -- https://crispgm.com/page/neovim-is-overpowering.html
    -- https://github.com/neovim/nvim-lspconfig
    use 'neovim/nvim-lspconfig'
    use 'hrsh7th/nvim-compe'

    -- https://github.com/nvim-treesitter/nvim-treesitter/issues/484
    use { 'nvim-treesitter/nvim-treesitter', run = ":TSUpdate" }
    use 'nvim-treesitter/playground'
    -- use 'nvim-lua/completion-nvim'

    -- CodeQL plugin
    -- use '~/Code/github.com/jsgv/codeql.nvim'
    -- use 'git@github.com:jsgv/codeql.nvim'
    -- use 'jsgv/codeql.nvim'
end)
