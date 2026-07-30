return {
    'coder/claudecode.nvim',
    dependencies = { 'folke/snacks.nvim' },
    config = true,
    opts = {
        terminal_cmd = '~/.local/bin/claude',
        terminal = {
            provider = 'none',
        },
    },
    cmd = {
        'ClaudeCode',
        'ClaudeCodeFocus',
        'ClaudeCodeSelectModel',
        'ClaudeCodeAdd',
        'ClaudeCodeSend',
        'ClaudeCodeTreeAdd',
        'ClaudeCodeStatus',
        'ClaudeCodeStart',
        'ClaudeCodeStop',
        'ClaudeCodeOpen',
        'ClaudeCodeClose',
        'ClaudeCodeDiffAccept',
        'ClaudeCodeDiffDeny',
        'ClaudeCodeCloseAllDiffs',
    },
    keys = {
        { '<leader>c', nil, desc = 'AI/Claude Code' },
        {
            '<leader>cc',
            function()
                local utils = require 'raBeta.utils.utils'
                local pane_id = utils.find_tmux_pane_by_cmd 'claude'
                if pane_id then
                    vim.fn.system { 'tmux', 'select-pane', '-t', pane_id }
                    return
                end

                if not vim.env.TMUX then
                    vim.notify('Not inside a tmux session', vim.log.levels.ERROR)
                    return
                end

                vim.fn.system { 'tmux', 'split-window', '-h', 'claude --ide' }
            end,
            desc = 'Open/Focus Claude (tmux)',
        },
        {
            '<leader>cf',
            function()
                local utils = require 'raBeta.utils.utils'
                local pane_id, err = utils.find_tmux_pane_by_cmd 'claude'
                if pane_id then
                    vim.fn.system { 'tmux', 'select-pane', '-t', pane_id }
                else
                    vim.notify(err, vim.log.levels.WARN)
                end
            end,
            desc = 'Focus Claude (tmux pane)',
        },
        {
            '<leader>cr',
            function()
                local utils = require 'raBeta.utils.utils'
                local pane_id = utils.find_tmux_pane_by_cmd 'claude'
                if pane_id then
                    vim.notify('Claude is already running; --resume only applies at startup', vim.log.levels.WARN)
                    return
                end

                if not vim.env.TMUX then
                    vim.notify('Not inside a tmux session', vim.log.levels.ERROR)
                    return
                end

                vim.fn.system { 'tmux', 'split-window', '-h', 'claude --ide --resume' }
            end,
            desc = 'Resume Claude (tmux)',
        },
        {
            '<leader>cC',
            function()
                local utils = require 'raBeta.utils.utils'
                local pane_id = utils.find_tmux_pane_by_cmd 'claude'
                if pane_id then
                    vim.notify('Claude is already running; --continue only applies at startup', vim.log.levels.WARN)
                    return
                end

                if not vim.env.TMUX then
                    vim.notify('Not inside a tmux session', vim.log.levels.ERROR)
                    return
                end

                vim.fn.system { 'tmux', 'split-window', '-h', 'claude --ide --continue' }
            end,
            desc = 'Continue Claude (tmux)',
        },
        { '<leader>cm', '<cmd>ClaudeCodeSelectModel<cr>', desc = 'Select Claude model' },
        { '<leader>cb', '<cmd>ClaudeCodeAdd %<cr>', desc = 'Add current buffer' },
        { '<leader>cs', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'Send to Claude' },
        {
            '<leader>cs',
            '<cmd>ClaudeCodeTreeAdd<cr>',
            desc = 'Add file',
            ft = { 'NvimTree', 'neo-tree', 'oil', 'minifiles', 'netrw', 'snacks_picker_list' },
        },
        -- Diff management
        { '<leader>ca', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept diff' },
        { '<leader>cd', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Deny diff' },
    },
}
