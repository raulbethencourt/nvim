local keymap = require('raBeta.utils.utils').keymap

return {
    {
        'NickvanDyke/opencode.nvim',
        version = '*', -- Latest stable release.
        config = function()
            local opencode_cmd = 'opencode --port'
            local tmux_pane_id = nil -- tracks the pane for reuse

            ---@type opencode.Opts
            vim.g.opencode_opts = {
                server = {
                    start = function()
                        -- Split a new tmux pane (horizontal, e.g. 35% width on the right)
                        -- Capture the pane ID for later reuse
                        local pane = vim.fn.system('tmux split-window -h -l 45% -P -F "#{pane_id}" ' .. opencode_cmd)
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
                            -- Check if pane still exists
                            local check = vim.fn.system('tmux has-session -t ' .. tmux_pane_id .. ' 2>/dev/null; echo $?')
                            -- More reliable: list panes and check
                            local exists = vim.fn.system 'tmux list-panes -F "#{pane_id}"'
                            if exists:find(tmux_pane_id, 1, true) then
                                vim.fn.system('tmux kill-pane -t ' .. tmux_pane_id)
                                tmux_pane_id = nil
                                return
                            end
                        end
                        -- Start new pane
                        local pane = vim.fn.system('tmux split-window -h -l 45% -P -F "#{pane_id}" ' .. opencode_cmd)
                        tmux_pane_id = vim.trim(pane)
                    end,
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
