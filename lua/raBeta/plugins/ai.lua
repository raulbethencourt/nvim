local keymap = require('raBeta.utils.utils').keymap

return {
    {
        'ThePrimeagen/99',
        config = function()
            local _99 = require '99'

            local cwd = vim.uv.cwd()
            local basename = vim.fs.basename(cwd)
            _99.setup {
                logger = {
                    level = _99.DEBUG,
                    path = '/tmp/' .. basename .. '.99.debug',
                    print_on_error = true,
                },
                completion = {
                    custom_rules = {
                        'custom_rules/',
                    },
                    files = {
                        exclude = {
                            '.env',
                            '.env.*',
                            'node_modules',
                            '.git',
                            'vendor',
                        },
                    },
                    source = 'cmp',
                },
                md_files = {
                    'AGENT.md',
                },
            }
            keymap('v', '<leader>iv', function()
                _99.visual()
            end, '99 ask visual')
            keymap('v', '<leader>is', function()
                _99.stop_all_requests()
            end, '99 stop')
        end,
    },
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

            -- Recommended/example keymaps.
            vim.keymap.set({ 'n', 'x' }, 'go', function()
                return require('opencode').operator '@this '
            end, { expr = true, desc = 'Add range to opencode' })
            vim.keymap.set('n', 'goo', function()
                return require('opencode').operator '@this ' .. '_'
            end, { expr = true, desc = 'Add line to opencode' })

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
            end, 'Session list')
            keymap({ 'n', 't' }, '<leader>oc', function()
                require('opencode').command 'agent.cycle'
            end, 'agent cycle')
            keymap('n', '<S-C-u>', function()
                require('opencode').command 'session.half.page.up'
            end, 'opencode half page up')
            keymap('n', '<S-C-d>', function()
                require('opencode').command 'session.half.page.down'
            end, 'opencode half page down')
        end,
    },
}
