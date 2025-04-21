return {
    {
        "yetone/avante.nvim",
        event = "VeryLazy",
        version = false, -- Never set this value to "*"! Never!
        opts = {
            auto_suggestions_provider = "copilot",
            provider = "copilot",
            copilot = {
                model = "claude-3.5-sonnet",
                temperature = 0,
                max_tokens = 8192,
            },
        },
        build = "make",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "stevearc/dressing.nvim",
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
            "hrsh7th/nvim-cmp",              -- autocompletion for avante commands and mentions
            "ibhagwan/fzf-lua",              -- for file_selector provider fzf
            "nvim-tree/nvim-web-devicons",   -- or echasnovski/mini.icons
            {
                "zbirenbaum/copilot.lua",
                cmd = "Copilot",
                event = "InsertEnter",
                config = function()
                    require("copilot").setup({
                        panel = {
                            enabled = true,
                            auto_refresh = false,
                            keymap = {
                                jump_prev = "[[",
                                jump_next = "]]",
                                accept = "<CR>",
                                refresh = "gr",
                                open = "<M-CR>"
                            },
                            layout = {
                                position = "right", -- | top | left | right | horizontal | vertical
                                ratio = 0.4
                            },
                        },
                        suggestion = {
                            enabled = true,
                            auto_trigger = true,
                            hide_during_completion = false,
                            debounce = 75,
                            trigger_on_accept = true,
                            keymap = {
                                accept = "<M-l>",
                                accept_word = false,
                                accept_line = false,
                                next = "<M-]>",
                                prev = "<M-[>",
                                dismiss = "<C-]>",
                            },
                        },
                    })
                end,
            },
            {
                -- support for image pasting
                "HakonHarnes/img-clip.nvim",
                event = "VeryLazy",
                opts = {
                    -- recommended settings
                    default = {
                        embed_image_as_base64 = false,
                        prompt_for_file_name = false,
                        drag_and_drop = {
                            insert_mode = true,
                        },
                        -- required for Windows users
                        use_absolute_path = true,
                    },
                },
            },
            {
                "OXY2DEV/markview.nvim",
                lazy = false,
                ft = { "markdown", "norg", "rmd", "org", "vimwiki", "Avante" },
                opts = {
                    max_length = 99999,
                    preview = {
                        enable = false,
                        icon_provider = "devicons", -- "mini" or "devicons"
                        filetypes = { "markdown", "norg", "rmd", "org", "vimwiki", "Avante" },
                        buf_ignore = {},
                    },
                    markdown = {
                        enable = false,
                    },
                },
            },
        },
    },
    {
        'nvimtools/none-ls.nvim',
        event = 'VeryLazy',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require 'raBeta.configs.lsp.none-ls'
        end,
    },
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            { 'williamboman/mason.nvim', config = true },
            'williamboman/mason-lspconfig.nvim',
            {
                "folke/lazydev.nvim",
                ft = "lua",
                opts = {
                    library = {
                        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                    },
                },
            },
            'WhoIsSethDaniel/mason-tool-installer.nvim',
            { 'j-hui/fidget.nvim' },
        },
    },
    {
        'ray-x/lsp_signature.nvim',
        event = 'BufRead',
        config = function()
            require('lsp_signature').setup({
                bind = true,
                handler_opts = {
                    border = "rounded"
                }
            })
        end,
    },
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-nvim-lua',
            'rafamadriz/friendly-snippets',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'hrsh7th/cmp-nvim-lsp-signature-help',
            'hrsh7th/cmp-vsnip',
            'onsails/lspkind.nvim',
            -- {
            -- "zbirenbaum/copilot-cmp",
            -- dependencies = { "zbirenbaum/copilot.lua" },
            -- config = function()
            --     require("copilot_cmp").setup({
            --         method = "getCompletionsCycling",
            --         formatters = {
            --             insert_text = function(entry, vim_item)
            --                 return entry.completion_item.insertText
            --             end,
            --             label = function(entry, vim_item)
            --                 return entry.completion_item.label
            --             end,
            --         },
            --     })
            -- end,
            -- },
        },
        config = function()
            require('raBeta.configs.lsp.cmp')
        end,
    },
    {
        'nvim-treesitter/nvim-treesitter',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
            'gbprod/php-enhanced-treesitter.nvim',
            { 'derekstride/tree-sitter-sql', build = ':TSInstall sql' },
        },
        build = ':TSUpdate',
        config = function()
            require 'raBeta.configs.treesitter'
        end,
    },
}
