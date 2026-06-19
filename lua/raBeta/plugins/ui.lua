local keymap = require('raBeta.utils.utils').keymap
return {
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'nvim-tree/nvim-web-devicons',
        },
        opts = {
            file_types = {
                'md',
                'markdown',
                'norg',
                'rmd',
                'org',
                'vimwiki',
            },
            completions = {
                lsp = {
                    enabled = true,
                },
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
            keymap('n', '<leader>cp', '<cmd>CccPick<CR>', '[C]cc [P]ick')
            keymap('n', '<leader>cc', '<cmd>CccConvert<CR>', '[C]cc [C]onvert')
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
        enabled = false,
        config = function()
            vim.g.gruvbox_material_background = 'hard'
            vim.g.gruvbox_material_foreground = 'material'
            vim.g.gruvbox_material_enable_italic = true
            vim.g.gruvbox_material_better_performance = true
            vim.g.gruvbox_material_transparent_background = 2
            vim.g.gruvbox_material_cursor = 'green'
            vim.g.gruvbox_material_visual = 'green background'
            vim.g.gruvbox_material_ui_contrast = 'low'
            vim.g.gruvbox_material_float_style = 'blend'
            vim.g.gruvbox_material_show_eob = false
            vim.g.gruvbox_material_diagnostic_text_highlight = true
            vim.g.gruvbox_material_diagnostic_line_highlight = true
        end,
    },
    {
        'neanias/everforest-nvim',
        lazy = false,
        priority = 1000,
        enabled = false,
        config = function()
            require('everforest').setup {
                background = 'hard',
                transparent_background_level = 1,
                italics = true,
                spell_foreground = true,
            }
        end,
    },
    {
        'Nirmal314/van-gogh.nvim',
        name = 'van-gogh',
        lazy = false,
        priority = 1000,
        enabled = false,
    },
    {
        'xero/miasma.nvim',
        lazy = false,
        priority = 1000,
        enabled = true,
        config = function()
            -- Override highlight groups for a darker background
            -- Applied via ColorScheme autocmd to persist after colorscheme loads
            local dark_bg = '#151515'
            local highlights = {
                Normal = { bg = dark_bg },
                NormalFloat = { bg = dark_bg },
                NormalNC = { bg = dark_bg },
                SignColumn = { bg = dark_bg },
                LineNr = { bg = dark_bg },
                Folded = { bg = dark_bg },
                FoldColumn = { bg = dark_bg },
                CursorLineNr = { bg = dark_bg },
                VertSplit = { bg = dark_bg },
                StatusLine = { bg = dark_bg },
                StatusLineNC = { bg = dark_bg },
                TabLine = { bg = dark_bg },
                TabLineFill = { bg = dark_bg },
                TabLineSel = { bg = dark_bg },
                Pmenu = { bg = dark_bg },
                PmenuSel = { bg = dark_bg },
                PmenuSbar = { bg = dark_bg },
                PmenuThumb = { bg = dark_bg },
                FloatBorder = { bg = dark_bg },
                EndOfBuffer = { bg = dark_bg },
                NonText = { bg = dark_bg },
                Whitespace = { bg = dark_bg },
                TelescopeNormal = { bg = dark_bg },
                TelescopeBorder = { bg = dark_bg },
                TelescopePromptNormal = { bg = dark_bg },
                TelescopePromptBorder = { bg = dark_bg },
                TelescopePromptTitle = { bg = dark_bg },
                TelescopeResultsNormal = { bg = dark_bg },
                TelescopeResultsBorder = { bg = dark_bg },
                TelescopeResultsTitle = { bg = dark_bg },
                TelescopePreviewNormal = { bg = dark_bg },
                TelescopePreviewBorder = { bg = dark_bg },
                TelescopePreviewTitle = { bg = dark_bg },
                TelescopeTitle = { bg = dark_bg },
                TelescopeSelection = { bg = '#202020' },
                TelescopeMatching = { fg = '#c9a554' },
            }
            local apply_overrides = function()
                for hl_group, opts in pairs(highlights) do
                    vim.api.nvim_set_hl(0, hl_group, opts)
                end
            end
            local augroup = vim.api.nvim_create_augroup('MiasmaOverrides', { clear = true })
            vim.api.nvim_create_autocmd('ColorScheme', {
                group = augroup,
                pattern = '*',
                callback = apply_overrides,
                desc = 'Apply miasma highlight overrides after colorscheme loads',
            })
            -- Apply immediately so overrides take effect on initial load
            apply_overrides()
        end,
    },
}
