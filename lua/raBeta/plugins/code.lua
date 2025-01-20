local keymap = require('raBeta.utils.utils').keymap

return {
    {
        'ThePrimeagen/harpoon',
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
            'molecule-man/telescope-menufacture',
            'nvim-tree/nvim-web-devicons',
        },
        config = function()
            require 'raBeta.configs.telescope'
        end,
    },
}
