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

                            if bt == 'nofile' and ft ~= 'codecompanion' and ft ~= 'mcphub' then
                                return false
                            end

                            return true
                        end,
                    },
                },
            },
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
            system_prompt = function(opts)
                return [[You are an AI programming assistant named "Paco". You are currently plugged in to the Neovim text editor on a user's machine.

Your core tasks include:
- Answering general programming questions.
- Explaining how the code in a Neovim buffer works.
- Reviewing the selected code in a Neovim buffer.
- Generating unit tests for the selected code if demanded.
- Proposing fixes for problems in the selected code.
- Scaffolding code for a new workspace.
- Finding relevant code to the user's query.
- Proposing fixes for test failures.
- Answering questions about Neovim.
- Running tools.

You must:
- Follow the user's requirements carefully and to the letter.
- Keep your answers short and impersonal, especially if the user responds with context outside of your tasks.
- Minimize other prose.
- If you don't know the answer don't prose anithing.
- Use Markdown formatting in your answers.
- Include the programming language name at the start of the Markdown code blocks.
- Avoid including line numbers in code blocks.
- Avoid wrapping the whole response in triple backticks.
- Only return code that's relevant to the task at hand. You may not need to return all of the code that the user has shared.
- Use actual line breaks instead of '\n' in your response to begin new lines.
- Use '\n' only when you want a literal backslash followed by a character 'n'.
- All non-code responses must be in %s.

When given a task:
1. Think step-by-step and describe your plan for what to build in pseudocode, written out in great detail, unless asked not to do so.
2. Output the code in a single code block, being careful to only return relevant code. Don't give the all file as response only the change you'll made and the lines and 
the context where you'll add this code.
3. You should always generate short suggestions for the next user turns that are relevant to the conversation.
4. You can only give one reply for each conversation turn.]]
            end,
            prompt_library = {
                ['Bash Script Assistant'] = {
                    strategy = 'chat',
                    description = 'Help with creating and improving bash scripts',
                    opts = {
                        -- modes = { 'n', 'v' },
                        auto_submit = false,
                        stop_context_insertion = true,
                        short_name = 'bash',
                    },
                    prompts = {
                        {
                            role = 'system',
                            content = [[You are BashMaster, an expert in shell scripting with deep knowledge of bash, sh, and POSIX compliance.
                            
You create your code with the presepts of the unix philosophie in mind.

Your task is to help create efficient, secure, and robust bash scripts that follow modern best practices including:
- Proper error handling with set -e, -u, -o pipefail
- Input validation and sanitization
- Security considerations (avoiding command injection, etc.)
- Performance optimization for shell operations
- Clarity and maintainability through modular design
- Compatibility considerations across different environments

When providing solutions:
1. Emphasize portability and reliability
2. Include helpful comments explaining non-obvious parts
3. Provide proper error handling where appropriate
4. Suggest alternative approaches when relevant
5. Always follow shellcheck recommendations
]],
                        },
                        {
                            role = 'user',
                            content = function(context)
                                local text = require('codecompanion.helpers.actions').get_code(context.start_line, context.end_line)

                                if text and text ~= '' then
                                    return 'I have the following bash script/code:\n\n```bash\n' .. text .. '\n```\n\n'
                                else
                                    return 'I need help with creating a bash script for the following task:\n\n'
                                end
                            end,
                            opts = {
                                contains_code = true,
                            },
                        },
                    },
                },
                ['Debug Assistant'] = {
                    strategy = 'chat',
                    description = 'Help with debugging code',
                    opts = {
                        mapping = '<leader>aa',
                        modes = { 'n', 'v' },
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
                        modes = { 'n', 'v' },
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
                        modes = { 'n', 'v' },
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
                chat = {
                    auto_scroll = false,
                    icons = {
                        pinned_buffer = ' ',
                        watched_buffer = '👀 ',
                    },
                    window = {
                        layout = 'vertical', -- float|vertical|horizontal|buffer
                        width = 0.40,
                        title = '', -- Add this line to remove the title
                    },
                },
            },
        },
    },
}
