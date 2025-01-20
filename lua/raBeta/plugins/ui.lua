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
            vim.cmd [[colorscheme gruvbox-material]]
        end,
    },
}
