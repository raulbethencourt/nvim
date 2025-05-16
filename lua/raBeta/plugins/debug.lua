local keymap = require("raBeta.utils.utils").keymap

return {
    'mfussenegger/nvim-dap',
    dependencies = {
        'rcarriga/nvim-dap-ui',
        'williamboman/mason.nvim',
        'theHamsta/nvim-dap-virtual-text',
        'jay-babu/mason-nvim-dap.nvim',
        "nvim-neotest/nvim-nio",
    },
    config = function()
        local dap = require 'dap'
        local dapui = require 'dapui'
        local icons = require 'icons'

        ---@diagnostic disable-next-line: missing-parameter
        require('nvim-dap-virtual-text').setup()

        ---@diagnostic disable-next-line: missing-fields
        require('mason-nvim-dap').setup {
            automatic_setup = true,
            handlers = {},
            ensure_installed = {
                'codelldb',
                'php-debug-adapter',
                'bash-debug-adapter',
            },
        }

        -- NOTE: keymaps for dap
        keymap('n', '<F5>', dap.continue, 'Debug: Start/Continue')
        keymap('n', '<F11>', dap.step_into, 'Debug: Step Into')
        keymap('n', '<s-F11>', dap.step_out, 'Debug: Step Out')
        keymap('n', '<F10>', dap.step_over, 'Debug: Step Over')
        keymap('n', '<s-F10>', dap.step_back, 'Debug: Step Back')
        keymap('n', '<leader>db', dap.toggle_breakpoint, '[D]ebug Toggle [B]reakpoint')
        keymap('n', '<leader>dc', dap.clear_breakpoints, '[D]ebug [C]lear Breakpoints')
        keymap('n', '<leader>dB', function()
            dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
        end, '[D]ebug Set [B]reakpoint')
        keymap('n', '<leader>dt', dapui.toggle, '[D]ebug [T]oggle Ui')
        keymap({ 'v', 'n' }, '<leader>de', '<Cmd>lua require("dapui").eval()<CR>',
            '[D]ebug [E]xpression evaluation')
        keymap('n', '<leader>df', '<Cmd>lua require("dapui").float_element()<CR>',
            '[D]ebug [F]loating element')
        keymap('n', '<leader>ds', '<Cmd>DapDisconnect<CR>',
            '[D]ebug [S]top')
        keymap('n', '<leader>dl', function()
            require "osv".launch({ port = 8086 })
        end, '[D]ebug [L]ua')
        keymap('n', '<leader>dw', function()
            local widgets = require "dap.ui.widgets"
            widgets.hover()
        end, '[D]ebug hover')
        keymap('n', '<leader>dF', function()
            local widgets = require "dap.ui.widgets"
            widgets.centered_float(widgets.frames)
        end, '[D]ebug centered [F]loat')

        ---@diagnostic disable-next-line: missing-fields
        dapui.setup {
            -- Use this to override mappings for specific elements
            element_mappings = {},
            expand_lines = true,
            layouts = {
                {
                    elements = {
                        { id = 'watches',     size = 0.25 },
                        { id = 'scopes',      size = 0.45 },
                        { id = 'stacks',      size = 0.20 },
                        { id = 'breakpoints', size = 0.10 },
                    },
                    size = 0.40,
                    position = 'right',
                },
                {
                    elements = {
                        { id = 'repl',    size = 0.45 },
                        { id = 'console', size = 0.55 },
                    },
                    size = 0.15,
                    position = 'bottom',
                },
            },
            windows = { indent = 1 },
            ---@diagnostic disable-next-line: missing-fields
            render = {
                max_type_length = nil, -- Can be integer or nil.
                max_value_lines = 100, -- Can be integer or nil.
            },
        }
        dap.listeners.after.event_initialized['dapui_config'] = dapui.open
        dap.listeners.before.event_terminated['dapui_config'] = dapui.close
        dap.listeners.before.event_exited['dapui_config'] = dapui.close

        -- NOTE: set up signs style
        vim.fn.sign_define('DapBreakpoint', {
            text = icons.dap.breakpoint,
            texthl = 'WarningMsg',
            linehl = '',
            numhl = '',
        })
        vim.fn.sign_define('DapStopped', {
            text = icons.ui.BoldArrowRight,
            texthl = 'FloatFooter',
            linehl = '',
            numhl = '',
        })
        vim.fn.sign_define('DapBreakpointRejected', {
            text = icons.ui.BoldClose,
            texthl = 'ErrorMsg',
            linehl = '',
            numhl = '',
        })
        vim.fn.sign_define('DapBreakpointCondition', {
            text = icons.dap.breakpoint_condition,
            texthl = 'WarningMsg',
            linehl = '',
            numhl = '',
        })
    end,
}
