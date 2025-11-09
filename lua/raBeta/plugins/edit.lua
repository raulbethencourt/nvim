local keymap = require('raBeta.utils.utils').keymap

return {
    {
        'abecodes/tabout.nvim',
        lazy = false,
        config = function()
            require('tabout').setup {
                tabkey = '<C-t>', -- key to trigger tabout, set to an empty string to disable
                backwards_tabkey = '<C-d>', -- key to trigger backwards tabout, set to an empty string to disable
                act_as_tab = true, -- shift content if tab out is not possible
                act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
                default_tab = '<Tab>', -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
                default_shift_tab = '<S-Tab>', -- reverse shift default action,
                enable_backwards = true, -- well ...
                completion = false, -- if the tabkey is used in a completion pum
                tabouts = {
                    { open = "'", close = "'" },
                    { open = '"', close = '"' },
                    { open = '`', close = '`' },
                    { open = '(', close = ')' },
                    { open = '[', close = ']' },
                    { open = '{', close = '}' },
                },
                ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
                exclude = {}, -- tabout will ignore these filetypes
            }
        end,
        dependencies = { -- These are optional
            'nvim-treesitter/nvim-treesitter',
            'L3MON4D3/LuaSnip',
            'hrsh7th/nvim-cmp',
        },
        opt = true, -- Set this to true if the plugin is optional
        event = 'InsertCharPre', -- Set the event to 'InsertCharPre' for better compatibility
        priority = 1000,
    },
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
            keymap('n', '<leader>ah', '<cmd>ObsidianToggleCheckbox<CR>', '[O]bsidian toggle c[H]eckbox')
            keymap('n', '<leader>ab', '<cmd>ObsidianBacklinks<CR>', '[O]bsidian [B]ack links')
            keymap('n', '<leader>at', '<cmd>ObsidianTags<CR>', '[O]bsidian [T]ags')
            keymap('n', '<leader>ad', '<cmd>ObsidianToday<CR>', '[O]bsidian to[D]ay')
            keymap('n', '<leader>ai', '<cmd>ObsidianPasteImg<CR>', '[O]bsidian paste [I]mage')
            keymap('n', '<leader>aw', '<cmd>ObsidianWorkspace<CR>', '[O]bsidian [W]orkspace')
            keymap('n', '<leader>ao', '<cmd>ObsidianOpen<CR>', '[O]bsidian [O]pen')
            keymap('n', '<leader>ae', '<cmd>ObsidianTemplate<CR>', '[O]bsidian t[E]mplate')
        end,
    },
    {
        'max397574/better-escape.nvim',
        event = 'VeryLazy',
        config = true,
    },
}
