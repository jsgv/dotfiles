vim.cmd([[packadd packer.nvim]])

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    use 'nvim-lualine/lualine.nvim'

    use {
        'EdenEast/nightfox.nvim',
        config = function ()
          vim.opt.background = 'dark'
          vim.cmd("colorscheme nightfox")
        end
    }

    use 'kyazdani42/nvim-tree.lua'
    use 'kyazdani42/nvim-web-devicons'

    use 'airblade/vim-gitgutter'
    use {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup()
        end
    }

    use 'tpope/vim-fugitive'
    use 'tpope/vim-commentary'

    use {
        'fatih/vim-go',
        run = ':GoInstallBinaries'
    }

    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            { 'nvim-lua/popup.nvim' },
            { 'nvim-lua/plenary.nvim' },
        }
    }

    -- LSP
    use 'neovim/nvim-lspconfig'

    -- Languages
    use 'simrat39/rust-tools.nvim'

    -- Completion
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-nvim-lua'
    use 'onsails/lspkind-nvim'

    -- Snippets
    use 'hrsh7th/cmp-vsnip'
    use 'hrsh7th/vim-vsnip'

    use 'nvim-treesitter/nvim-treesitter'
    use 'prettier/vim-prettier'

    use 'github/copilot.vim'
    use 'ThePrimeagen/git-worktree.nvim'

    -- use { '~/Code/github.com/jsgv/git-worktree.nvim' }
    -- use {
    --     '~/Code/github.com/jsgv/github-theme.nvim',
    --     -- 'jsgv/github-theme.nvim',
    --     config = function ()
    --         require('github-theme').setup({
    --             theme = 'dark'
    --         })
    --     end
    -- }
end)
