local icons = require 'icons'

return {
    {
        'sainnhe/gruvbox-material',
        lazy = false,
        priority = 1000,
        enabled = true,
        config = function()
            vim.g.gruvbox_material_background = 'hard'
            vim.g.gruvbox_material_better_performance = true
            vim.g.gruvbox_material_transparent_background = 2
            vim.g.gruvbox_material_cursor = 'green'
            vim.g.gruvbox_material_ui_contrast = 'low'
            vim.g.gruvbox_material_float_style = 'dim'
            -- vim.cmd [[colorscheme gruvbox-material]]
        end,
    },
    {
        'sainnhe/everforest',
        lazy = false,
        priority = 1000,
        enabled = true,
        config = function()
            vim.g.everforest_background = 'hard'
            vim.g.everforest_better_performance = true
            vim.g.everforest_transparent_background = 2
            vim.g.everforest_cursor = 'green'
            vim.g.everforest_ui_contrast = 'low'
            vim.g.everforest_float_style = 'dim'
            vim.cmd [[colorscheme everforest]]
        end,
    },
    {
        'stevearc/dressing.nvim',
        lazy = true,
        init = function()
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.select = function(...)
                require('lazy').load { plugins = { 'dressing.nvim' } }
                return vim.ui.select(...)
            end
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.input = function(...)
                require('lazy').load { plugins = { 'dressing.nvim' } }
                return vim.ui.input(...)
            end
        end,
        config = function()
            require('dressing').setup({
                win_options = {
                    winblend = 10,
                    winhighlight =
                    'Normal:DressingInputNormalFloat,NormalFloat:DressingInputNormalFloat,FloatBorder:DressingInputFloatBorder',
                },
                input = {
                    enabled = true,
                    default_prompt = 'Input:',
                    prompt_align = 'left',
                    insert_only = true,
                    start_in_insert = true,
                    border = 'rounded',
                    relative = 'cursor',
                    prefer_width = 40,
                    width = nil,
                    max_width = { 140, 0.9 },
                    min_width = { 20, 0.2 },
                    get_config = nil,
                },
                select = {
                    enabled = true,
                    backend = { 'telescope', 'fzf_lua', 'fzf', 'nui', 'builtin' },
                    trim_prompt = true,
                },
            })
        end
    },
    {
        'folke/noice.nvim',
        event = 'VeryLazy',
        opts = {},
        dependencies = {
            { 'MunifTanjim/nui.nvim', lazy = true },
            {
                'rcarriga/nvim-notify',
                keys = {
                    {
                        '<leader>un',
                        function()
                            require('notify').dismiss { silent = true, pending = true }
                        end,
                        desc = 'Dismiss all Notifications',
                    },
                },
                opts = {
                    timeout = 3500,
                    background_colour = '#000000',
                    render = 'compact',
                },
            },
        },
        config = function()
            require('noice').setup {
                cmdline = {
                    view = "cmdline_popup", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
                    format = {
                        cmdline = { pattern = "^:", icon = icons.ChevronShortRight, lang = "vim", title = "" },
                    }
                },
                lsp = {
                    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                    override = {
                        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
                        ['vim.lsp.util.stylize_markdown'] = true,
                        ['cmp.entry.get_documentation'] = true,
                    },
                    signature = {
                        enabled = false,
                    },
                },
                messages = {
                    enabled = true,  -- enables the Noice messages UI
                    view = 'notify', -- default view for messages
                },
                routes = {
                    {
                        filter = {
                            event = 'msg_showmode',
                        },
                        view = 'notify',
                    },
                },
                -- you can enable a preset for easier configuration
                presets = {
                    bottom_search = true,         -- use a classic bottom cmdline for search
                    command_palette = false,      -- position the cmdline and popupmenu together
                    long_message_to_split = true, -- long messages will be sent to a split
                    inc_rename = false,           -- enables an input dialog for inc-rename.nvim
                    lsp_doc_border = 'rounded',   -- add a border to hover docs and signature help
                },
                views = {
                    cmdline_popup = {
                        border = {
                            style = 'rounded',
                            padding = { 1, 2 },
                        },
                        filter_options = {},
                        win_options = {
                            winhighlight = 'NormalFloat:NormalFloat,FloatBorder:FloatBorder',
                        },
                        position = {
                            row = 10,
                            col = '50%',
                        },
                        size = {
                            width = 100,
                            height = 'auto',
                        },
                    },
                    popupmenu = {
                        relative = 'editor',
                        position = {
                            row = 15,
                            col = '50%',
                        },
                        size = {
                            width = 100,
                            height = 10,
                        },
                        border = {
                            style = 'rounded',
                            padding = { 1, 2 },
                        },
                        win_options = {
                            winhighlight = { Normal = 'Normal', FloatBorder = 'DiagnosticInfo' },
                        },
                    },
                },
            }
        end,
    },
    {
        'folke/lsp-colors.nvim',
        config = function()
            require('lsp-colors').setup {
                Error = '#db4b4b',
                Warning = '#e0af68',
                Information = '#0db9d7',
                Hint = '#10B981',
            }
        end,
    },
    {
        'norcalli/nvim-colorizer.lua',
        config = function()
            require('colorizer').setup({ '*' }, {
                RGB = true,      -- #RGB hex codes
                RRGGBB = true,   -- #RRGGBB hex codes
                RRGGBBAA = true, -- #RRGGBBAA hex codes
                rgb_fn = true,   -- CSS rgb() and rgba() functions
                hsl_fn = true,   -- CSS hsl() and hsla() functions
                css = true,      -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
                css_fn = true,   -- Enable all CSS *functions*: rgb_fn, hsl_fn
            })
        end,
    },
}
