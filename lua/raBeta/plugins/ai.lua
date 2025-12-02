local keymap = require('raBeta.utils.utils').keymap

return {
    {
        'NickvanDyke/opencode.nvim',
        dependencies = {},
        config = function()
            ---@type opencode.Opts
            vim.g.opencode_opts = {
                provider = {
                    enabled = 'tmux',
                    tmux = {},
                },
            }

            vim.o.autoread = true

            keymap({ 'n', 'x' }, '<leader>oa', function()
                require('opencode').ask('@this: ', { submit = true })
            end, 'Ask opencode')
            keymap({ 'n', 'x' }, '<leader>os', function()
                require('opencode').select()
            end, 'Execute opencode action…')
            keymap({ 'n', 'x' }, '<leader>op', function()
                require('opencode').prompt '@this'
            end, 'Add to opencode')
            keymap({ 'n', 't' }, '<leader>ot', function()
                require('opencode').toggle()
            end, 'Toggle opencode')
            keymap({ 'n', 't' }, '<leader>ol', function()
                require('opencode').command 'session.list'
            end, 'Toggle opencode')
            keymap('n', '<S-C-u>', function()
                require('opencode').command 'session.half.page.up'
            end, 'opencode half page up')
            keymap('n', '<S-C-d>', function()
                require('opencode').command 'session.half.page.down'
            end, 'opencode half page down')
        end,
    },
}
