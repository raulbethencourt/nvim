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
        'ThePrimeagen/refactoring.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-treesitter/nvim-treesitter',
        },
        lazy = false,
        config = function()
            -- __AUTO_GENERATED_PRINTF_START__
            print [==[config 1]==] -- __AUTO_GENERATED_PRINTF_END__
            require('refactoring').setup {
                prompt_func_return_type = {
                    java = false,
                    cpp = false,
                    h = false,
                    hpp = false,
                    cxx = false,

                    go = true,
                    c = true,
                    php = true,
                    lua = true,
                    javascript = true,
                },
                prompt_func_param_type = {
                    java = false,
                    cpp = false,
                    h = false,
                    hpp = false,
                    cxx = false,

                    go = true,
                    c = true,
                    php = true,
                    lua = true,
                    javascript = true,
                },
                show_success_message = true,
            }

            keymap({ 'n', 'x' }, '<leader>re', function()
                return require('refactoring').refactor 'Extract Function'
            end, '[R]efactoring [E]xtract function')
            keymap({ 'n', 'x' }, '<leader>rf', function()
                return require('refactoring').refactor 'Extract Function To File'
            end, '[R]efactoring extract function to [F]ile')
            keymap({ 'n', 'x' }, '<leader>rv', function()
                return require('refactoring').refactor 'Extract Variable'
            end, '[R]efactoring [V]ariable')
            keymap({ 'n', 'x' }, '<leader>rI', function()
                return require('refactoring').refactor 'Inline Function'
            end, '[R]efactoring [I]nline function')
            keymap({ 'n', 'x' }, '<leader>ri', function()
                return require('refactoring').refactor 'Inline Variable'
            end, '[R]efactoring [I]nline variable')

            keymap({ 'n', 'x' }, '<leader>rbb', function()
                return require('refactoring').refactor 'Extract Block'
            end, '[R]efactoring extract [B]lock')
            keymap({ 'n', 'x' }, '<leader>rbf', function()
                return require('refactoring').refactor 'Extract Block To File'
            end, '[R]efactoring extract [B]lock to [File]')

            require('telescope').load_extension 'refactoring'
            keymap({ 'n', 'x' }, '<leader>rr', function()
                require('telescope').extensions.refactoring.refactors()
            end, '[R]efactoring telescope [R]efactors')

            keymap('n', '<leader>rdp', function()
                require('refactoring').debug.printf { below = false }
            end, '[R]efactoring [D]ebug [P]rintf')

            keymap({ 'x', 'n' }, '<leader>rdv', function()
                require('refactoring').debug.print_var()
            end, '[R]efactoring [D]ebug print [V]ar')

            keymap('n', '<leader>rdc', function()
                require('refactoring').debug.cleanup {}
            end, '[R]efactoring [D]ebug [C]leanup')
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
        priority = 950,
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        build = ':TSUpdate',
        config = function()
            require 'raBeta.configs.treesitter'
        end,
    },
}
