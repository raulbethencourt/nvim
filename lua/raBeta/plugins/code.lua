local keymap = require('raBeta.utils.utils').keymap

return {
    {
        'stevearc/oil.nvim',
        opts = {},
        -- Optional dependencies
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require('oil').setup {
                skip_confirm_for_simple_edits = true,
                keymaps = {
                    ['<C-h>'] = false,
                    ['<C-l>'] = false,
                    ['<C-d>'] = "actions.preview_scroll_down",
                    ['<C-u>'] = "actions.preview_scroll_up",
                    ["<C-v>"] = { "actions.select", opts = { vertical = true }, desc = "Open the entry in a vertical split" },
                    ["<esc>"] = "actions.close",
                },
                view_options = {
                    show_hidden = true,
                },
                float = {
                    padding = 5,
                    max_width = 0,
                    max_height = 0,
                    win_options = {
                        winhl = "Normal:Normal,NormalFloat:Normal,FloatBorder:Normal,FloatTitle:Normal",
                    },
                },
                preview_win = {
                    win_options = {
                        winhl = "Normal:Normal,NormalFloat:Normal,FloatBorder:Normal,FloatTitle:Normal",
                    },
                },
                progress = {
                    win_options = {
                        winhl = "Normal:Normal,NormalFloat:Normal,FloatBorder:Normal,FloatTitle:Normal",
                    },
                },
            }
            keymap('n', '<leader>e', require('oil').toggle_float,
                '[O]il [T]oggle float')
        end,
    },
    {
        'ThePrimeagen/harpoon',
        event = 'VeryLazy',
        branch = 'harpoon2',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local harpoon = require 'harpoon'

            harpoon:setup {
                settings = {
                    save_on_toggle = true,
                    sync_on_ui_close = true,
                    key = function()
                        ---@diagnostic disable-next-line: return-type-mismatch
                        return vim.loop.cwd()
                    end,
                },
            }

            vim.keymap.set('n', '<leader>fs', function()
                harpoon:list():add()
            end, { desc = 'Add file' })
            vim.keymap.set('n', '<leader>fd', function()
                harpoon.ui:toggle_quick_menu(harpoon:list())
            end, { desc = 'Menu' })

            vim.keymap.set('n', '<leader>fj', function()
                harpoon:list():select(1)
            end, { desc = 'File 1' })
            vim.keymap.set('n', '<leader>fk', function()
                harpoon:list():select(2)
            end, { desc = 'File 2' })
            vim.keymap.set('n', '<leader>fl', function()
                harpoon:list():select(3)
            end, { desc = 'File 3' })
            vim.keymap.set('n', '<leader>fm', function()
                harpoon:list():select(4)
            end, { desc = 'File 4' })

            vim.keymap.set('n', '<leader>fp', function()
                harpoon:list():prev()
            end)
            vim.keymap.set('n', '<leader>fn', function()
                harpoon:list():next()
            end)
        end,
    },
    {
        'mbbill/undotree',
        event = 'VeryLazy',
        config = function()
            keymap('n', '<leader>u', '<cmd>UndotreeToggle<CR>', 'Toggle [U]ndoTree')
        end
    },
    {
        'folke/which-key.nvim',
        event = "VeryLazy",
        dependencies = {
            'nvim-tree/nvim-web-devicons',
        },
        opts = {
            win = {
                border = 'rounded',
                title = false
            }
        },
    },
    {
        'aserowy/tmux.nvim',
        config = true,
    },
    {
        'nvim-telescope/telescope.nvim',
        event = 'VeryLazy',
        tag = '0.1.8',
        dependencies = {
            'nvim-lua/plenary.nvim',
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'make'
            },
            {
                'nvim-telescope/telescope-live-grep-args.nvim',
                version = '^1.0.0',
            },
            'nvim-telescope/telescope-ui-select.nvim',
            'nvim-tree/nvim-web-devicons',
        },
        config = function()
            require 'raBeta.configs.telescope'
        end,
    }
}
