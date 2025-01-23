local keymap = require('raBeta.utils.utils').keymap

return {
    {
        'echasnovski/mini.nvim',
        version = false,
        config = function()
            require('mini.ai').setup()
            require('mini.comment').setup({
                mappings = {
                    comment = '<space>/',
                    comment_line = '<space>//',
                    comment_visual = '<space>/',
                    textobject = '<space>/',
                },

            })
            require('mini.operators').setup({
                exchange = {
                    prefix = 'ge',
                    reindent_linewise = true,
                },
                replace = {
                    prefix = 'gp',
                    reindent_linewise = true,
                },
            })
            require('mini.splitjoin').setup()
            require('mini.surround').setup()
        end,
    },
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' },
        config = function()
            require('obsidian').get_client().opts.ui.enable = false
            vim.api.nvim_buf_clear_namespace(0, vim.api.nvim_get_namespaces()['ObsidianUI'], 0, -1)
            require('render-markdown').setup({
                enabled = false,
            })
            keymap('n', '<leader>tm', '<cmd>RenderMarkdown toggle<CR>', 'toggle render []arkdown')
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
                ---@diagnostic disable-next-line: missing-fields
                mappings = {
                    ["<space>os"] = {
                        action = function()
                            return require("obsidian").util.smart_action()
                        end,
                        opts = { buffer = true, expr = true, desc = "[O]bsidian [S]mart action" },
                    }
                }
            })
            keymap('n', '<leader>oh', '<cmd>ObsidianToggleCheckbox<CR>', '[O]bsidian toggle c[H]eckbox')
            keymap('n', '<leader>ob', '<cmd>ObsidianBacklinks<CR>', '[O]bsidian [B]ack links')
            keymap('n', '<leader>ot', '<cmd>ObsidianTags<CR>', '[O]bsidian [T]ags')
            keymap('n', '<leader>od', '<cmd>ObsidianToday<CR>', '[O]bsidian to[D]ay')
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
