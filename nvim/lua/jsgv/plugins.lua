vim.cmd([[packadd packer.nvim]])

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    use {
        'hoob3rt/lualine.nvim',
        config = function()
            require('lualine').setup {
                options = {
                    theme = 'github'
                }
            }
        end
    }

    use {
        'projekt0n/github-nvim-theme',
        commit = '771ac5b'
    }

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
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'

    -- Snippets
    use 'hrsh7th/cmp-vsnip'
    use 'hrsh7th/vim-vsnip'
    use 'onsails/lspkind-nvim'

    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }
end)
