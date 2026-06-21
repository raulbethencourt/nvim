local keymap = require('raBeta.utils.utils').keymap

return {
    {
        'kosayoda/nvim-lightbulb',
        config = function()
            require('nvim-lightbulb').setup {
                autocmd = {
                    enabled = true,
                },
                sign = {
                    enabled = true,
                    text = '',
                    lens_text = '',
                    hl = 'LightBulbSign',
                },
                number = {
                    enabled = true,
                    hl = 'LightBulbNumber',
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
            'WhoIsSethDaniel/mason-tool-installer.nvim',
            { 'j-hui/fidget.nvim' },
            {
                'ziglang/zig.vim',
                config = function()
                    vim.g.zig_fmt_autosave = 0
                end,
            },
        },
    },
    {
        'ray-x/lsp_signature.nvim',
        event = 'BufRead',
        config = function()
            require('lsp_signature').setup {
                bind = true,
                handler_opts = {
                    border = 'rounded',
                },
            }
        end,
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
            'hrsh7th/cmp-cmdline',
            'hrsh7th/cmp-nvim-lsp-signature-help',
            'onsails/lspkind.nvim',
        },
        config = function()
            require 'raBeta.configs.lsp.cmp'
        end,
    },
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        branch = 'main',
        dependencies = {
            {
                'nvim-treesitter/nvim-treesitter-textobjects',
                branch = 'main',
                event = 'VeryLazy',
            },
            {
                'nvim-treesitter/nvim-treesitter-context',
                event = 'VeryLazy',
                config = function()
                    keymap('n', 'gj', function()
                        require('treesitter-context').go_to_context(vim.v.count1)
                    end)
                end,
            },
        },
        build = ':TSUpdate',
        config = function()
            require 'raBeta.configs.treesitter'
        end,
    },
}
