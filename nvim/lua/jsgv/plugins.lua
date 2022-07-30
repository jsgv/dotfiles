vim.cmd([[packadd packer.nvim]])

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    use {
        'nvim-lualine/lualine.nvim',
    }

    use {
        'EdenEast/nightfox.nvim',
        config = function ()
          vim.cmd("colorscheme nightfox")
        end
    }

    -- use {
    --     '~/Code/github.com/jsgv/github-theme.nvim',
    --     -- 'jsgv/github-theme.nvim',
    --     config = function ()
    --         require('github-theme').setup({
    --             theme = 'dark_dimmed'
    --         })
    --     end
    -- }

    use 'kyazdani42/nvim-tree.lua'
    use 'kyazdani42/nvim-web-devicons'

    use 'airblade/vim-gitgutter'

    use 'tpope/vim-fugitive'
    use 'tpope/vim-commentary'

    use {
        'fatih/vim-go',
        run = ':GoInstallBinaries'
    }

    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            { 'nvim-lua/popup.nvim'   },
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

    -- Snippets
    use 'hrsh7th/cmp-vsnip'
    use 'hrsh7th/vim-vsnip'
    use 'onsails/lspkind-nvim'

    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }

    use 'nvim-treesitter/playground'
end)
