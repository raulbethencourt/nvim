local keymap = require('raBeta.utils.utils').keymap

return {
    {
        'NickvanDyke/opencode.nvim',
        config = function()
            ---@type opencode.Opts
            vim.g.opencode_opts = {
                provider = {
                    enabled = 'tmux',
                    tmux = {},
                },
            }

            -- Recommended/example keymaps.
            vim.keymap.set({ 'n', 'x' }, 'go', function()
                return require('opencode').operator '@this '
            end, { expr = true, desc = 'Add range to opencode' })
            vim.keymap.set('n', 'goo', function()
                return require('opencode').operator '@this ' .. '_'
            end, { expr = true, desc = 'Add line to opencode' })

            keymap({ 'n' }, '<leader>oa', function()
                require('opencode').ask('@buffer: ', { submit = true })
            end, 'Ask opencode')
            keymap({ 'n', 'x' }, '<leader>ok', '<cmd>!pkill opencode<cr>', 'Kill opencode')
            keymap({ 'x' }, '<leader>oA', function()
                require('opencode').ask('@this: ', { submit = true })
            end, 'Ask opencode selection')
            keymap({ 'n', 'x' }, '<leader>os', function()
                require('opencode').select()
            end, 'Execute opencode action…')
            keymap({ 'n', 't' }, '<leader>ot', function()
                require('opencode').toggle()
            end, 'Toggle opencode')
            keymap({ 'n', 't' }, '<leader>oc', function()
                require('opencode').command 'agent.cycle'
            end, 'agent cycle')
            keymap({ 'n', 't' }, '<leader>ol', function()
                require('opencode').command 'session.select'
            end, 'session select')
            keymap({ 'n', 't' }, '<leader>oe', function()
                require('opencode').command 'session.compact'
            end, 'Session compact')

            keymap('n', '<leader>op', function()
                require('opencode').command 'prompt.submit'
            end, 'Prompt submit')
            keymap('n', '<leader>ou', function()
                require('opencode').command 'session.half.page.up'
            end, 'opencode half page up')
            keymap('n', '<leader>od', function()
                require('opencode').command 'session.half.page.down'
            end, 'opencode half page down')
        end,
    },
}
