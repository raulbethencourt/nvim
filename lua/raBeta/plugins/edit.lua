local keymap = require('raBeta.utils.utils').keymap

return {
    {
        'echasnovski/mini.nvim',
        version = false,
        config = function()
            require('mini.ai').setup()
            require('mini.move').setup()
            require('mini.comment').setup({
                mappings = {
                    comment = '<space>/',
                    comment_line = '<space>//',
                    comment_visual = '<space>/',
                    textobject = '<space>/',
                },

            })
            require('mini.operators').setup()
            require('mini.surround').setup()
            require('mini.splitjoin').setup()
            require('mini.notify').setup({
                window = {
                    config = {
                        style = 'minimal',
                        border = 'rounded'
                    },
                }
            })
        end,
    },
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('obsidian').get_client().opts.ui.enable = false
            vim.api.nvim_buf_clear_namespace(0, vim.api.nvim_get_namespaces()['ObsidianUI'], 0, -1)
            require('render-markdown').setup({})
            keymap('n', '<leader>r', '<cmd>RenderMarkdown toggle<CR>', '[R]ender markdown toggle')
        end,
    },
    {
        "epwalsh/obsidian.nvim",
        version = "*", -- recommended, use latest release instead of latest commit
        lazy = true,
        ft = "markdown",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("obsidian").setup({
                workspaces = {
                    {
                        name = "personal",
                        path = "~/vaults",
                    },
                },
            })
            keymap('n', '<leader>oh', '<cmd>ObsidianToggleCheckbox<CR>', '[O]bsidian toggle c[H]eckbox')
            keymap('n', '<leader>os', '<cmd>ObsidianQuickSwitch<CR>', '[O]bsidian quick [S]witch')
            keymap('n', '<leader>ob', '<cmd>ObsidianBacklinks<CR>', '[O]bsidian [B]ack links')
            keymap('n', '<leader>ot', '<cmd>ObsidianTags<CR>', '[O]bsidian [T]ags')
            keymap('n', '<leader>oi', '<cmd>ObsidianPasteImg<CR>', '[O]bsidian paste [I]mage')
            keymap('n', '<leader>ow', '<cmd>ObsidianWorkspace<CR>', '[O]bsidian [W]orkspace')
            keymap('n', '<leader>oo', '<cmd>ObsidianOpen<CR>', '[O]bsidian [O]pen')
            keymap('n', '<leader>oe', '<cmd>ObsidianTemplate<CR>', '[O]bsidian t[E]mplate')
        end
    },
    {
        'max397574/better-escape.nvim',
        config = true,
    },
}
