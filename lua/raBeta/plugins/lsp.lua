return {
    {
        "olimorris/codecompanion.nvim", -- The KING of AI programming
        dependencies = {
            "j-hui/fidget.nvim",
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            {
                "ravitemer/mcphub.nvim", -- Manage MCP servers
                cmd = "MCPHub",
                build = "npm install -g mcp-hub@latest",
                config = true,
            },
            -- {
            --     "Davidyz/VectorCode", -- Index and search code in your repositories
            --     version = "*",
            --     build = "pipx upgrade vectorcode --python python3.13",
            --     dependencies = { "nvim-lua/plenary.nvim" },
            -- },
        },
        opts = {
            extensions = {
                mcphub = {
                    callback = "mcphub.extensions.codecompanion",
                    opts = {
                        make_vars = true,
                        make_slash_commands = true,
                        show_result_in_chat = true,
                    },
                },
                -- vectorcode = {
                --     opts = {
                --         add_tool = true,
                --     },
                -- },
            },
            adapters = {
                copilot = function()
                    return require("codecompanion.adapters").extend("copilot", {
                        schema = {
                            model = {
                                default = "claude-3.7-sonnet",
                            },
                        },
                    })
                end,
            },
            prompt_library = {
                ["Test workflow"] = {
                    strategy = "workflow",
                    description = "Use a workflow to test the plugin",
                    opts = {
                        index = 4,
                    },
                    prompts = {
                        {
                            {
                                role = "user",
                                content =
                                "Generate a Python class for managing a book library with methods for adding, removing, and searching books",
                                opts = {
                                    auto_submit = false,
                                },
                            },
                        },
                        {
                            {
                                role = "user",
                                content = "Write unit tests for the library class you just created",
                                opts = {
                                    auto_submit = true,
                                },
                            },
                        },
                        {
                            {
                                role = "user",
                                content = "Create a TypeScript interface for a complex e-commerce shopping cart system",
                                opts = {
                                    auto_submit = true,
                                },
                            },
                        },
                        {
                            {
                                role = "user",
                                content = "Write a recursive algorithm to balance a binary search tree in Java",
                                opts = {
                                    auto_submit = true,
                                },
                            },
                        },
                        {
                            {
                                role = "user",
                                content =
                                "Generate a comprehensive regex pattern to validate email addresses with explanations",
                                opts = {
                                    auto_submit = true,
                                },
                            },
                        },
                        {
                            {
                                role = "user",
                                content = "Create a Rust struct and implementation for a thread-safe message queue",
                                opts = {
                                    auto_submit = true,
                                },
                            },
                        },
                        {
                            {
                                role = "user",
                                content = "Write a GitHub Actions workflow file for CI/CD with multiple stages",
                                opts = {
                                    auto_submit = true,
                                },
                            },
                        },
                        {
                            {
                                role = "user",
                                content = "Create SQL queries for a complex database schema with joins across 4 tables",
                                opts = {
                                    auto_submit = true,
                                },
                            },
                        },
                        {
                            {
                                role = "user",
                                content = "Write a Lua configuration for Neovim with custom keybindings and plugins",
                                opts = {
                                    auto_submit = true,
                                },
                            },
                        },
                        {
                            {
                                role = "user",
                                content = "Generate documentation in JSDoc format for a complex JavaScript API client",
                                opts = {
                                    auto_submit = true,
                                },
                            },
                        },
                    },
                },
            },
            strategies = {
                chat = {
                    adapter = "copilot",
                    roles = {
                        user = "raBeta",
                    },
                    keymaps = {
                        send = {
                            modes = {
                                i = { "<C-CR>", "<C-s>" },
                            },
                        },
                        completion = {
                            modes = {
                                i = "<C-x>",
                            },
                        },
                    },
                    slash_commands = {
                        ["buffer"] = {
                            opts = {
                                keymaps = {
                                    modes = {
                                        i = "<C-b>",
                                    },
                                },
                            },
                        },
                        ["help"] = {
                            opts = {
                                max_lines = 1000,
                            },
                        },
                    },
                    tools = {
                        opts = {
                            auto_submit_success = false,
                            auto_submit_errors = false,
                        },
                    },
                },
                inline = { adapter = "copilot" },
            },
            display = {
                action_palette = {
                    provider = "default",
                },
                chat = {
                    -- show_references = true,
                    -- show_header_separator = false,
                    -- show_settings = false,
                },
                diff = {
                    provider = "mini_diff",
                },
            },
            opts = {
                log_level = "DEBUG",
            },
        }
    },
    -- {
    --     "yetone/avante.nvim",
    --     event = "VeryLazy",
    --     version = false,
    --     opts = {
    --         auto_suggestions_provider = "copilot",
    --         provider = "copilot",
    --         copilot = {
    --             model = "claude-3.7-sonnet",
    --             -- model = "gpt-4.1",
    --             temperature = 0,
    --             max_tokens = 8192,
    --         },
    --         behaviour = {
    --             enable_claude_text_editor_tool_mode = true,
    --         },
    --         windows = {
    --             width = 40,
    --             sidebar_header = {
    --                 enabled = false,
    --             },
    --         },
    --         web_search_engine = {
    --             provider = "tavily",
    --             proxy = nil,
    --         }
    --     },
    --     build = "make",
    --     dependencies = {
    --         "nvim-treesitter/nvim-treesitter",
    --         "stevearc/dressing.nvim",
    --         "nvim-lua/plenary.nvim",
    --         "MunifTanjim/nui.nvim",
    --         "nvim-telescope/telescope.nvim",
    --         "hrsh7th/nvim-cmp",
    --         "nvim-tree/nvim-web-devicons",
    --         {
    --             "zbirenbaum/copilot.lua",
    --             event = "InsertEnter",
    --             config = function()
    --                 require("copilot").setup({
    --                     copilot_model = "cloude-3.7-sonnet",
    --                     panel = {
    --                         enabled = false,
    --                     },
    --                     suggestion = {
    --                         enabled = false,
    --                     },
    --                 })
    --             end,
    --         },
    --         {
    --             "HakonHarnes/img-clip.nvim",
    --             event = "VeryLazy",
    --             opts = {
    --                 default = {
    --                     embed_image_as_base64 = false,
    --                     prompt_for_file_name = false,
    --                     drag_and_drop = {
    --                         insert_mode = true,
    --                     },
    --                 },
    --             },
    --         },
    --         {
    --             "OXY2DEV/markview.nvim",
    --             lazy = false,
    --             ft = { "markdown", "norg", "rmd", "org", "vimwiki", "Avante" },
    --             opts = {
    --                 max_length = 99999,
    --                 preview = {
    --                     icon_provider = "devicons",
    --                     filetypes = { "markdown", "norg", "rmd", "org", "vimwiki", "Avante" },
    --                     buf_ignore = {},
    --                 },
    --             },
    --         },
    --     },
    -- },
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
            {
                "zbirenbaum/copilot-cmp",
                dependencies = { "zbirenbaum/copilot.lua" },
                cmd = "Copilot",
                config = function()
                    require("copilot_cmp").setup({
                        method = "getCompletionsCycling",
                        formatters = {
                            insert_text = function(entry, vim_item)
                                return entry.completion_item.insertText
                            end,
                            label = function(entry, vim_item)
                                return entry.completion_item.label
                            end,
                        },
                    })
                end,
            },
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
