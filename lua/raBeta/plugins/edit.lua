local keymap = require('raBeta.utils.utils').keymap

return {
    {
        "vhyrro/luarocks.nvim",
        priority = 1001,
        opts = {
            rocks = { "magick" },
        },
    },
    {
        "3rd/image.nvim",
        dependencies = {
            "luarocks.nvim",
            {
                "HakonHarnes/img-clip.nvim",
                event = "VeryLazy",
                opts = {},
                keys = {
                    { "<leader>xi", "<cmd>PasteImage<cr>", desc = "Paste [I]mage from system clipboard" },
                },
            }
        },
        opts = {
            backend = "ueberzug",
            processor = "magick_rock", -- or "magick_cli"
            integrations = {
                markdown = {
                    enabled = true,
                    download_remote_images = true,
                    only_render_image_at_cursor = true,
                    floating_windows = true
                },
                neorg = { enabled = false },
                typst = { enabled = false },
            },
            tmux_show_only_in_active_window = true
        }
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
    { 'bullets-vim/bullets.vim' },
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
        'folke/todo-comments.nvim',
        event = 'BufRead',
        otps = {},
    },
    {
        'kylechui/nvim-surround',
        config = true,
    },
    {
        'numToStr/Comment.nvim',
        opts = true,
        lazy = false,
    },
    {
        'max397574/better-escape.nvim',
        config = true,
    },
}
