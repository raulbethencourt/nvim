local keymap = require('raBeta.utils.utils').keymap

return {
    {
        'NickvanDyke/opencode.nvim',
        version = '*', -- Latest stable release.
        config = function()
            local opencode_cmd = 'opencode'
            local tmux_pane_id = nil -- tracks the pane for reuse
            local oc = require 'opencode'

            ---@type opencode.Opts
            vim.g.opencode_opts = {
                server = {
                    start = function()
                        -- Split a new tmux pane
                        -- Capture the pane ID for later reuse
                        local pane = vim.fn.system('tmux split-window -dhl 45% -P -F "#{pane_id}" ' .. opencode_cmd)
                        tmux_pane_id = vim.trim(pane)
                    end,
                    stop = function()
                        -- Kill the tracked pane if it exists
                        if tmux_pane_id then
                            vim.fn.system('tmux kill-pane -t ' .. tmux_pane_id)
                            tmux_pane_id = nil
                        end
                    end,
                    toggle = function()
                        -- If no pane exists or pane is dead, start a new one
                        -- If pane exists and is alive, kill it (toggle off)
                        if tmux_pane_id then
                            local exists = vim.fn.system 'tmux list-panes -F "#{pane_id}"'
                            if exists:find(tmux_pane_id, 1, true) then
                                vim.fn.system('tmux kill-pane -t ' .. tmux_pane_id)
                                tmux_pane_id = nil
                                return
                            end
                        end
                        local pane = vim.fn.system('tmux split-window -dhl 45% -P -F "#{pane_id}" ' .. opencode_cmd)
                        tmux_pane_id = vim.trim(pane)
                    end,
                },
            }

            -- Recommended/example keymaps.
            vim.keymap.set({ 'n', 'x' }, 'go', function()
                return oc.operator '@this '
            end, { expr = true, desc = 'Add range to opencode' })
            vim.keymap.set('n', 'goo', function()
                return oc.operator '@this ' .. '_'
            end, { expr = true, desc = 'Add line to opencode' })

            keymap({ 'n' }, '<leader>oa', function()
                oc.ask('@buffer: ', { submit = true })
            end, 'Ask opencode')
            keymap({ 'n', 'x' }, '<leader>ok', '<cmd>!pkill opencode<cr>', 'Kill opencode')
            keymap({ 'x' }, '<leader>oA', function()
                oc.ask('@this: ', { submit = true })
            end, 'Ask opencode selection')
            keymap({ 'n', 'x' }, '<leader>os', function()
                oc.select()
            end, 'Execute opencode action…')
            keymap({ 'n', 't' }, '<leader>ot', function()
                oc.toggle()
            end, 'Toggle opencode')
            keymap({ 'n', 't' }, '<leader>oc', function()
                oc.command 'agent.cycle'
            end, 'agent cycle')
            keymap({ 'n', 't' }, '<leader>ol', function()
                oc.command 'session.select'
            end, 'session select')
            keymap({ 'n', 't' }, '<leader>oe', function()
                oc.command 'session.compact'
            end, 'Session compact')

            keymap('n', '<leader>op', function()
                oc.command 'prompt.submit'
            end, 'Prompt submit')
            keymap('n', '<leader>ou', function()
                oc.command 'session.half.page.up'
            end, 'opencode half page up')
            keymap('n', '<leader>od', function()
                oc.command 'session.half.page.down'
            end, 'opencode half page down')
        end,
    },
}
