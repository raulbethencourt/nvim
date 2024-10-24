local keymap = require('raBeta.utils.custom').keymap

return {
    {
        "sourcegraph/sg.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require('sg').setup({
                enable_cody = true,
            })
            keymap('n', '<leader>c', '<cmd>CodyToggle<CR>', '[C]ody Toggle')
            keymap('v', '<leader>ce', [[:CodyExplain<cr>]],
                '[C]ody [E]xplain')
        end

    },
    {
        'kosayoda/nvim-lightbulb',
        event = 'LspAttach',
        config = function()
            require('nvim-lightbulb').setup {
                autocmd = { enabled = true },
                sign = {
                    enabled = true,
                    text = require('icons').diagnostics.BoldHint,
                    hl = 'LightBulbSign',
                },
            }
        end,
    },
    {
        'nvimtools/none-ls.nvim',
        event = 'VeryLazy',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require 'raBeta.configs.lsp.none-ls'
        end,
    },
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            { 'williamboman/mason.nvim', config = true },
            'williamboman/mason-lspconfig.nvim',
            'folke/neodev.nvim',
        },
    },
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-nvim-lua',
            'rafamadriz/friendly-snippets',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-nvim-lsp-signature-help',
            'hrsh7th/cmp-vsnip',
        },
        config = function()
            require 'raBeta.configs.lsp.cmp'
        end,
    },
    {
        'nvim-treesitter/nvim-treesitter',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
            'gbprod/php-enhanced-treesitter.nvim',
            { 'derekstride/tree-sitter-sql', build = ':TSInstall sql' },
        },
        build = ':TSUpdate',
        config = function()
            require 'raBeta.configs.treesitter'
        end,
    },
    {
        'saecki/crates.nvim',
        event = { 'BufRead Cargo.toml' },
        opts = {
            src = {
                cmp = { enabled = true },
            },
        },
        config = function()
            require('crates').setup {
                null_ls = {
                    enabled = true,
                    name = 'crates.nvim',
                },
                popup = {
                    border = 'rounded',
                },
            }
        end,
    },
    {
        'ray-x/lsp_signature.nvim',
        event = 'BufRead',
        config = function()
            require('lsp_signature').setup()
        end,
    },
}
