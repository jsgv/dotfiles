vim.cmd([[packadd packer.nvim]])

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use 'arcticicestudio/nord-vim'
    use 'scrooloose/nerdtree'

    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            { 'nvim-lua/popup.nvim'   },
            { 'nvim-lua/plenary.nvim' },
        }
    }

    use 'tpope/vim-fugitive'
    use 'tpope/vim-commentary'

    use 'airblade/vim-gitgutter'
    use 'vim-airline/vim-airline'

    use { 'fatih/vim-go', run = ':GoInstallBinaries' }
    use 'cakebaker/scss-syntax.vim'
    use 'chr4/nginx.vim'

    use 'neovim/nvim-lspconfig'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'

    -- snippets
    use 'saadparwaiz1/cmp_luasnip'
    use 'L3MON4D3/LuaSnip'
    use 'onsails/lspkind-nvim'
    use 'rafamadriz/friendly-snippets'

    -- https://github.com/nvim-treesitter/nvim-treesitter/issues/484
    use {
        'nvim-treesitter/nvim-treesitter',
        branch = '0.5-compat',
        run = ':TSUpdate'
    }

    use 'nvim-treesitter/playground'

    -- CodeQL plugin
    -- use '~/Code/github.com/jsgv/codeql.nvim'
    -- use 'git@github.com:jsgv/codeql.nvim'
    -- use 'jsgv/codeql.nvim'
end)
