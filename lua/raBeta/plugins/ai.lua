return {
    {
        'olimorris/codecompanion.nvim',
        event = 'VeryLazy',
        dependencies = {
            'j-hui/fidget.nvim',
            'nvim-lua/plenary.nvim',
            'nvim-treesitter/nvim-treesitter',
            {
                'OXY2DEV/markview.nvim',
                lazy = false,
                opts = {
                    max_length = 99999,
                    preview = {
                        filetypes = {
                            'md',
                            'markdown',
                            'norg',
                            'rmd',
                            'org',
                            'vimwiki',
                            'codecompanion',
                            'mcphub',
                        },
                        ignore_buftypes = {},
                        condition = function()
                            local ft, bt = vim.bo.filetype, vim.bo.buftype

                            if bt == 'nofile' and ft == 'codecompanion' then
                                return true
                            elseif bt == 'nofile' and ft == 'mcphub' then
                                return true
                            elseif bt == 'nofile' then
                                return false
                            else
                                return true
                            end
                        end,
                    },
                },
            },
            { 'echasnovski/mini.diff', version = '*' },
            {
                'ravitemer/mcphub.nvim',
                dependencies = {
                    'nvim-lua/plenary.nvim',
                },
                cmd = 'MCPHub',
                build = 'npm install -g mcp-hub@latest',
                config = true,
            },
        },
        opts = {
            log_level = 'INFO',
            extensions = {
                mcphub = {
                    callback = 'mcphub.extensions.codecompanion',
                    opts = {
                        make_vars = true,
                        make_slash_commands = true,
                        show_result_in_chat = true,
                    },
                },
            },
            adapters = {
                copilot = function()
                    return require('codecompanion.adapters').extend('copilot', {
                        schema = {
                            model = {
                                default = 'claude-3.7-sonnet',
                            },
                        },
                    })
                end,
            },
            prompt_library = {
                ['Debug Assistant'] = {
                    strategy = 'chat',
                    description = 'Help with debugging code',
                    opts = {
                        mapping = '<leader>aa',
                        modes = { 'v' },
                        auto_submit = true,
                        stop_context_insertion = true,
                        short_name = 'debug',
                    },
                    prompts = {
                        {
                            role = 'system',
                            content = 'You are an expert debugger. Analyze the code and suggest potential issues and solutions.',
                        },
                    },
                },
                ['Symfony'] = {
                    strategy = 'chat',
                    description = 'Working in a Symfony application',
                    prompts = {
                        {
                            role = 'system',
                            content = "You are an expert Symfony programmer, the stack for this code is php8.2, mysql8 and symfony 7.2 lts, don't give me answer out of that, I want you to make propositions for simple and modular code.",
                        },
                        {
                            role = 'user',
                            content = "I'm working in symfony application, can you help me with...",
                        },
                    },
                },
                ['Docusaurus'] = {
                    strategy = 'chat',
                    description = 'Write documentation for me',
                    opts = {
                        mapping = '<leader>ad',
                        modes = { 'v' },
                        index = 11,
                        is_slash_cmd = false,
                        auto_submit = true,
                        stop_context_insertion = true,
                        short_name = 'docs',
                    },
                    prompts = {
                        {
                            role = 'system',
                            content = function(context)
                                return 'I want you to act as a senior ' .. context.filetype .. ' developer.'
                            end,
                        },
                        {
                            role = 'user',
                            content = function(context)
                                local text = require('codecompanion.helpers.actions').get_code(context.start_line, context.end_line)

                                return 'I have the following code:\n\n```'
                                    .. context.filetype
                                    .. '\n'
                                    .. text
                                    .. '\n```\n\n I need to make documentation for my code'
                            end,
                            opts = {
                                contains_code = true,
                            },
                        },
                    },
                },
                ['Code Expert'] = {
                    strategy = 'chat',
                    description = 'Get some special advice from an LLM',
                    opts = {
                        mapping = '<leader>ae',
                        modes = { 'v' },
                        short_name = 'expert',
                        auto_submit = true,
                        stop_context_insertion = true,
                        user_prompt = true,
                    },
                    prompts = {
                        {
                            role = 'system',
                            content = function(context)
                                return 'I want you to act as a senior '
                                    .. context.filetype
                                    .. ' developer. I will ask you specific questions and I want you to return concise explanations and codeblock examples.'
                            end,
                        },
                        {
                            role = 'user',
                            content = function(context)
                                local text = require('codecompanion.helpers.actions').get_code(context.start_line, context.end_line)

                                return 'I have the following code:\n\n```' .. context.filetype .. '\n' .. text .. '\n```\n\n'
                            end,
                            opts = {
                                contains_code = true,
                            },
                        },
                    },
                },
                ['Code Review'] = {
                    strategy = 'chat',
                    description = 'Review code for improvements',
                    prompts = {
                        {
                            role = 'system',
                            content = 'Perform a thorough code review. Check for: security issues, performance optimizations, code clarity, and adherence to best practices.',
                        },
                    },
                },
            },
            strategies = {
                chat = {
                    adapter = 'copilot',
                    roles = {
                        user = 'raBeta',
                    },
                    keymaps = {
                        send = {
                            modes = {
                                i = { '<C-CR>', '<C-s>' },
                            },
                        },
                    },
                    slash_commands = {
                        ['buffer'] = {
                            opts = {
                                keymaps = {
                                    modes = {
                                        i = '<C-b>',
                                    },
                                },
                            },
                        },
                        ['help'] = {
                            opts = {
                                max_lines = 1000,
                            },
                        },
                    },
                    tools = {
                        -- Add specific tool configurations
                        linter = {
                            enabled = true,
                            auto_fix = true,
                        },
                        formatter = {
                            enabled = true,
                            auto_format = true,
                        },
                        opts = {
                            auto_submit_success = true,
                            auto_submit_errors = true,
                            auto_format = true,
                            save_context = true,
                        },
                    },
                },
                inline = { adapter = 'copilot' },
            },
            display = {
                action_palette = {
                    provider = 'default',
                },
                chat = {
                    auto_scroll = false,
                    icons = {
                        pinned_buffer = ' ',
                        watched_buffer = '👀 ',
                    },
                    window = {
                        layout = 'float', -- float|vertical|horizontal|buffer
                        position = 'right', -- left|right|top|bottom
                        border = 'rounded',
                        height = 0.9,
                        width = 0.60,
                        relative = 'editor',
                        full_height = true,
                        title = '', -- Add this line to remove the title
                        opts = {
                            scrolloff = 8,
                            conceallevel = 3,
                            concealcursor = 'nc',
                            breakindent = true,
                            cursorcolumn = false,
                            cursorline = false,
                            foldcolumn = '0',
                            linebreak = true,
                            list = false,
                            numberwidth = 1,
                            signcolumn = 'no',
                            spell = false,
                            wrap = true,
                        },
                    },
                },
                diff = {
                    enabled = true,
                    provider = 'mini_diff',
                },
            },
        },
    },
}
