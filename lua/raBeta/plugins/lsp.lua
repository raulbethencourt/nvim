return {
    {
        'kosayoda/nvim-lightbulb',
        event = 'LspAttach',
        config = function()
            ---@diagnostic disable-next-line: missing-fields
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
            {
                "folke/lazydev.nvim",
                ft = "lua",
                opts = {
                    library = {
                        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                    },
                },
            },
            'WhoIsSethDaniel/mason-tool-installer.nvim',
        },
    },
    {
        'saghen/blink.cmp',
        dependencies = 'rafamadriz/friendly-snippets',
        version = '*',
        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            keymap = {
                preset = 'default',
                ['<S-tab>'] = { 'select_prev', 'fallback' },
                ['<tab>'] = { 'select_next', 'fallback' },
                ['<C-c>'] = { 'cancel', 'fallback' },
                ['<C-i>'] = { 'select_and_accept', 'fallback' },
            },
            appearance = {
                use_nvim_cmp_as_default = true,
                nerd_font_variant = 'mono'
            },
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer', 'markdown' },
                providers = {
                    markdown = {
                        name = 'RenderMarkdown',
                        module = 'render-markdown.integ.blink',
                        fallbacks = { 'lsp' },
                    },
                }
            },
            completion = {
                menu = {
                    auto_show = true,
                    border = 'rounded',
                    draw = {
                        treesitter = { 'lsp' },
                        columns = {
                            {
                                "label",
                                "label_description",
                                gap = 1
                            },
                            {
                                "kind_icon",
                                "kind"
                            }
                        }
                    }
                },
                documentation = {
                    auto_show = true,
                    window = { border = 'rounded' }
                },
            },
            signature = { window = { border = 'rounded' } },
        },
        opts_extend = { "sources.default" }
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
        'ray-x/lsp_signature.nvim',
        event = 'BufRead',
        config = function()
            require('lsp_signature').setup()
        end,
    },
}
