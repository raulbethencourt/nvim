local keymap = require('raBeta.utils.utils').keymap

return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        ---@type snacks.Config
        opts = {
            bigfile = { enabled = true },
            dashboard = {
                enabled = false,
            },
            notifier = {
                enabled = true,
                timeout = 5000,
            },
            quickfile = { enabled = false },
            statuscolumn = { enabled = true },
            ---@diagnostic disable-next-line: missing-fields
            words = { enabled = true },
            styles = {
                ---@diagnostic disable-next-line: missing-fields
                notification = {
                    ---@diagnostic disable-next-line: missing-fields
                    wo = { wrap = true }
                }
            }
        },
        keys = {
            { "<leader>on", function() Snacks.notifier.show_history() end, desc = "Notification History" },
            { "<leader>oN", function() Snacks.notifier.hide() end,         desc = "Dismiss All Notifications" },
            { "<leader>zb", function() Snacks.bufdelete() end,             desc = "Delete Buffer" },
            { "<leader>oR", function() Snacks.rename.rename_file() end,    desc = "Rename File" },
        },
        init = function()
            vim.api.nvim_create_autocmd("User", {
                pattern = "VeryLazy",
                callback = function()
                    -- Setup some globals for debugging (lazy-loaded)
                    _G.dd = function(...)
                        Snacks.debug.inspect(...)
                    end
                    _G.bt = function()
                        Snacks.debug.backtrace()
                    end
                    vim.print = _G.dd -- Override print to use snacks for `:=` command

                    -- Create some toggle mappings
                    Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>op")
                    Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>ow")
                    Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>or")
                    Snacks.toggle.diagnostics():map("<leader>od")
                    Snacks.toggle.line_number():map("<leader>os")
                    Snacks.toggle.option("conceallevel",
                        { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>oc")
                    Snacks.toggle.treesitter():map("<leader>oT")
                    Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map(
                        "<leader>ob")
                    Snacks.toggle.inlay_hints():map("<leader>oh")
                end,
            })
        end,
    },
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
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup {
                preview_config = {
                    border = 'rounded',
                    style = 'minimal',
                    relative = 'cursor',
                    row = 1,
                    col = 1,
                }
            }
        end,
    },
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
    {
        'folke/flash.nvim',
        event = 'VeryLazy',
        opts = {
            modes = {
                search = {
                    enabled = true,
                }
            }
        },
        keys = {
            {
                's',
                mode = { 'n', 'x', 'o' },
                function()
                    require('flash').jump()
                end,
                desc = 'Flash',
            },
            {
                'S',
                mode = { 'n', 'o', 'x' },
                function()
                    require('flash').treesitter()
                end,
                desc = 'Flash Treesitter',
            },
            {
                'r',
                mode = 'o',
                function()
                    require('flash').remote()
                end,
                desc = 'Remote Flash',
            },
            {
                'R',
                mode = { 'o', 'x' },
                function()
                    require('flash').treesitter_search()
                end,
                desc = 'Treesitter Search',
            },
            {
                '<c-s>',
                mode = { 'c' },
                function()
                    require('flash').toggle()
                end,
                desc = 'Toggle Flash Search',
            },
        },
    },
}
