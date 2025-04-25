vim.cmd([[packadd packer.nvim]])

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }

    -- use {
    --     'AlexvZyl/nordic.nvim',
    --     config = function()
    --         vim.cmd('colorscheme nordic')
    --     end
    -- }

    use {
        'ellisonleao/gruvbox.nvim',
        config = function()
            require('gruvbox').setup({
                bold = false
            })
            vim.o.background = 'dark'
            vim.cmd([[colorscheme gruvbox]])
        end
    }

    use 'airblade/vim-gitgutter'
    use {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup()
        end
    }

    use {
        'fatih/vim-go',
        run = ':GoInstallBinaries'
    }

    use { 'nvim-telescope/telescope.nvim' }
    use { 'nvim-lua/plenary.nvim' }
    use { 'nvim-lua/popup.nvim' }

    -- LSP
    use 'neovim/nvim-lspconfig'
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }

    use "IndianBoy42/tree-sitter-just"

    -- Languages
    -- use 'simrat39/rust-tools.nvim'

    -- Completion
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-nvim-lua'
    use 'onsails/lspkind-nvim'

    -- Snippets
    use 'hrsh7th/cmp-vsnip'
    use 'hrsh7th/vim-vsnip'

    use 'github/copilot.vim'
    use 'prettier/vim-prettier'

    use 'tpope/vim-fugitive'
    use 'tpope/vim-commentary'
    use 'tpope/vim-surround'

    -- use 'kyazdani42/nvim-tree.lua'
    -- use 'kyazdani42/nvim-web-devicons'
end)
