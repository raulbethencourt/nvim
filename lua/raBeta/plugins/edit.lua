local keymap = require('raBeta.utils.utils').keymap

return {
    {
        'L3MON4D3/LuaSnip',
        keys = function()
            -- Disable default tab keybinding in LuaSnip
            return {}
        end,
    },
    {
        'folke/flash.nvim',
        event = 'VeryLazy',
        opts = {
            modes = {
                search = {
                    enabled = true,
                },
            },
        },
        keys = {
            {
                'S',
                mode = { 'n', 'x', 'o' },
                function()
                    require('flash').jump()
                end,
                desc = 'Flash',
            },
            {
                'SS',
                mode = { 'n', 'o', 'x' },
                function()
                    require('flash').treesitter()
                end,
                desc = 'Flash Treesitter',
            },
        },
    },
    {
        'echasnovski/mini.ai',
        version = false,
        config = function()
            require('mini.ai').setup()
        end,
    },
    {
        'echasnovski/mini.splitjoin',
        version = false,
        config = function()
            require('mini.splitjoin').setup()
        end,
    },
    {
        'echasnovski/mini.surround',
        version = false,
        config = function()
            require('mini.surround').setup()
        end,
    },
    {
        'echasnovski/mini.comment',
        version = false,
        config = function()
            require('mini.comment').setup {
                mappings = {
                    comment = '<space>/',
                    comment_line = '<space>//',
                    comment_visual = '<space>/',
                    textobject = '<space>/',
                },
            }
        end,
    },
    {
        'epwalsh/obsidian.nvim',
        event = 'VeryLazy',
        version = '*', -- recommended, use latest release instead of latest commit
        ft = 'markdown',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope.nvim',
            'nvim-treesitter/nvim-treesitter',
        },
        config = function()
            require('obsidian').setup {
                ui = {
                    enable = false, -- set to false to disable all additional syntax features
                },
                workspaces = {
                    {
                        name = 'personal',
                        path = '~/vaults',
                    },
                },
                ---@diagnostic disable-next-line: missing-fields
                attachments = {
                    img_folder = 'assets',
                },
                ---@diagnostic disable-next-line: missing-fields
                daily_notes = {
                    folder = 'Daily',
                    template = 'daily_template',
                },
                ---@diagnostic disable-next-line: missing-fields
                templates = {
                    folder = 'Templates',
                    -- A map for custom variables, the key should be the variable and the value a function
                    substitutions = {},
                },
                ---@diagnostic disable-next-line: missing-fields
                mappings = {
                    ['<space>os'] = {
                        action = function()
                            return require('obsidian').util.smart_action()
                        end,
                        opts = { buffer = true, expr = true, desc = '[O]bsidian [S]mart action' },
                    },
                },
            }
            keymap('n', '<leader>ad', '<cmd>ObsidianToday<CR>', '[O]bsidian to[D]ay')
        end,
    },
    {
        'max397574/better-escape.nvim',
        event = 'VeryLazy',
        config = true,
    },
}
