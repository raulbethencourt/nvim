return {
    {
        'OXY2DEV/markview.nvim',
        lazy = false,
        ft = { 'markdown', 'norg', 'rmd', 'org', 'vimwiki', 'Avante' },
        opts = {
            experimental = {
                prefer_nvim = true,
            },
            max_length = 99999,
            yaml = {
                enable = true,
            },
            preview = {
                icon_provider = 'devicons',
                filetypes = {
                    'md',
                    'markdown',
                    'norg',
                    'rmd',
                    'org',
                    'vimwiki',
                    'Avante',
                },
                ignore_buftypes = {},
                condition = function()
                    local ft, bt = vim.bo.filetype, vim.bo.buftype

                    return (bt == 'nofile' and ft ~= 'Avante') and false or true
                end,
            },
        },
    },
    {
        'uga-rosa/ccc.nvim',
        config = function()
            require('ccc').setup {
                highlighter = {
                    auto_enable = true,
                    lsp = true,
                },
            }
            vim.keymap.set('n', '<leader>cp', '<cmd>CccPick<CR>', { desc = '[C]cc [P]ick' })
            vim.keymap.set('n', '<leader>cc', '<cmd>CccConvert<CR>', { desc = '[C]cc [C]onvert' })
        end,
    },
    {
        'j-hui/fidget.nvim',
        opts = {
            notification = {
                override_vim_notify = true,
                view = { group_separator_hl = 'Normal' },
                window = {
                    normal_hl = 'Normal',
                    winblend = 0,
                    border = 'rounded',
                    border_hl = 'Normal',
                    align = 'top',
                    relative = 'editor',
                    x_padding = 3,
                    y_padding = 1,
                },
            },
        },
    },
    {
        'sainnhe/gruvbox-material',
        lazy = false,
        priority = 1000,
        enabled = true,
        config = function()
            vim.g.gruvbox_material_background = 'hard'
            vim.g.gruvbox_material_foreground = 'material'
            vim.g.gruvbox_material_enable_italic = true
            vim.g.gruvbox_material_better_performance = true
            vim.g.gruvbox_material_transparent_background = 2
            vim.g.gruvbox_material_cursor = 'green'
            vim.g.gruvbox_material_visual = 'green background'
            vim.g.gruvbox_material_ui_contrast = 'low'
            vim.g.gruvbox_material_float_style = 'dim'
            vim.g.gruvbox_material_show_eob = false
            vim.g.gruvbox_material_diagnostic_text_highlight = true
            vim.g.gruvbox_material_diagnostic_line_highlight = true
            vim.cmd.colorscheme 'gruvbox-material'
        end,
    },
}
