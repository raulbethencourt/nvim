return {
    {
        'yetone/avante.nvim',
        build = vim.fn.has 'win32' ~= 0 and 'powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false' or 'make',
        event = 'VeryLazy',
        version = false,
        opts = {
            selection = {
                hint_display = 'none',
            },
            instructions_file = 'avante.md',
            provider = 'copilot',
            providers = {
                copilot = {
                    -- model = 'claude-sonnet-4',
                    model = 'claude-3.7-sonnet',
                },
            },
            behaviour = {
                auto_apply_diff_after_generation = false, -- Disable automatic diff application
                auto_suggestions = false, -- Disable auto suggestions
                support_paste_from_clipboard = false,
                auto_approve_tool_permissions = false,
            },
            windows = {
                border = 'rounded',
                width = 40,
                height = 80,
            },
            shortcuts = {
                {
                    name = 'bash',
                    description = 'Bash Script Assistant',
                    details = 'Expert bash scripting with security and best practices',
                    prompt = [[You are BashMaster, an expert in shell scripting with deep knowledge of bash, sh, and POSIX compliance.

You create your code with the precepts of the unix philosophy in mind.

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
5. Always follow shellcheck recommendations]],
                },
                {
                    name = 'debug',
                    description = 'Debug Assistant',
                    details = 'Help debug code issues and suggest solutions',
                    prompt = 'You are an expert debugger. Analyze the code and suggest potential issues and solutions. Focus on identifying bugs, performance issues, and providing clear explanations with actionable fixes.',
                },
                {
                    name = 'symfony',
                    description = 'Symfony Expert',
                    details = 'Symfony 7.2 LTS development assistance',
                    prompt = [[You are an expert Symfony programmer working with PHP 8.2, MySQL 8, and Symfony 7.2 LTS. 

Provide simple and modular code solutions following Symfony best practices:
- Use proper dependency injection
- Follow Symfony coding standards
- Implement proper error handling
- Use Doctrine best practices
- Follow security guidelines
- Write maintainable and testable code]],
                },
                {
                    name = 'sugar',
                    description = 'SugarCRM Expert',
                    details = 'SugarCRM 25 LTS development assistance',
                    prompt = [[You are an expert SugarCRM programmer working with PHP 8.2, MySQL 5.7, and SugarCRM 25 LTS.

Provide simple and modular code solutions following SugarCRM best practices:
- Use proper SugarCRM architecture patterns
- Follow SugarCRM coding standards
- Implement proper customization strategies
- Use SugarCRM APIs effectively
- Focus on upgrade-safe customizations]],
                },
                {
                    name = 'suite',
                    description = 'SuiteCRM Expert',
                    details = 'SuiteCRM 8 development assistance',
                    prompt = [[You are an expert SuiteCRM programmer working with PHP 8.2, MySQL 5.7, and SuiteCRM 8.

Provide simple and modular code solutions following SuiteCRM best practices:
- Use proper SuiteCRM architecture patterns
- Follow SuiteCRM coding standards
- Implement proper customization strategies
- Use SuiteCRM APIs effectively
- Focus on maintainable customizations]],
                },
                {
                    name = 'docs',
                    description = 'Documentation Assistant',
                    details = 'Generate comprehensive documentation',
                    prompt = 'Generate comprehensive documentation for the provided code. Include purpose, parameters, return values, usage examples, and any important notes. Format using clear headings and code blocks.',
                },
                {
                    name = 'expert',
                    description = 'Code Expert Analysis',
                    details = 'Get expert analysis and advice',
                    prompt = 'Act as a senior developer expert. Provide concise explanations and practical code examples. Focus on best practices, potential improvements, and answering specific technical questions with actionable advice.',
                },
                {
                    name = 'review',
                    description = 'Code Review',
                    details = 'Thorough code review with improvements',
                    prompt = 'Perform a thorough code review. Check for: security issues, performance optimizations, code clarity, adherence to best practices, potential bugs, and maintainability concerns. Provide specific suggestions for improvement.',
                },
            },
        },
        system_prompt = function(opts)
            local language = opts.language or 'English'
            return string.format(
                [[You are an AI programming assistant named "Paco". You are currently plugged in to the Neovim text editor on a user's machine.

    Your core tasks include:
    - Answering general programming questions.
    - Answering always in english.
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
    - Never change files directly.
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
    4. You can only give one reply for each conversation turn.]],
                language
            )
        end,
        dependencies = {
            'nvim-lua/plenary.nvim',
            'MunifTanjim/nui.nvim',
            'echasnovski/mini.pick',
            'nvim-telescope/telescope.nvim',
            'hrsh7th/nvim-cmp',
            'stevearc/dressing.nvim',
            'nvim-tree/nvim-web-devicons',
            'zbirenbaum/copilot.lua',
            {
                'HakonHarnes/img-clip.nvim',
                event = 'VeryLazy',
                opts = {
                    default = {
                        embed_image_as_base64 = false,
                        prompt_for_file_name = false,
                        drag_and_drop = {
                            insert_mode = true,
                        },
                    },
                },
            },
            {
                'OXY2DEV/markview.nvim',
                lazy = false,
                ft = { 'markdown', 'norg', 'rmd', 'org', 'vimwiki', 'Avante' },
                opts = {
                    max_length = 99999,
                    code_blocks = {
                        style = 'language',
                        border_hl = 'markview_code_block',
                    },
                    preview = {
                        filetypes = {
                            'md',
                            'markdown',
                            'norg',
                            'rmd',
                            'org',
                            'vimwiki',
                            'codecompanion',
                            'Avante',
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
        },
    },
}
