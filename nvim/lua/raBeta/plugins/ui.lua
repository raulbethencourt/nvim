return {
    {
        'MeanderingProgrammer/render-markdown.nvim',
        cmd = 'RenderMarkdown',
        event = 'VeryLazy',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('obsidian').get_client().opts.ui.enable = false
            vim.api.nvim_buf_clear_namespace(0, vim.api.nvim_get_namespaces()['ObsidianUI'], 0, -1)
            require('render-markdown').setup({
                enabled = false,
            })
        end,
    },
    {
        "j-hui/fidget.nvim",
        opts = {
            notification = {
                override_vim_notify = true,
                view = { group_separator_hl = "Normal", },
                window = {
                    normal_hl = "Normal",
                    border = "rounded",
                    align = "top",
                    relative = "editor",
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
            vim.g.gruvbox_material_better_performance = true
            vim.g.gruvbox_material_transparent_background = 2
            vim.g.gruvbox_material_cursor = 'green'
            vim.g.gruvbox_material_ui_contrast = 'low'
            vim.g.gruvbox_material_float_style = 'dim'
            vim.cmd [[colorscheme gruvbox-material]]
        end,
    },
}
