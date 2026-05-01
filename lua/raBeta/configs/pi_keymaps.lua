local utils = require 'raBeta.utils.utils'
local keymap = utils.keymap

-- Pi integration (tmux) -------------------------------------------------------

local function get_right_tmux_pane()
    if not vim.env.TMUX then
        return nil, 'Not inside tmux session'
    end

    local panes = vim.fn.system 'tmux list-panes -F "#{pane_id} #{pane_current_command}"'
    for pane_id, cmd in panes:gmatch '(%%[%d]+)%s+(%S+)' do
        if cmd == 'pi' then
            return pane_id
        end
    end

    local fallback = vim.trim(vim.fn.system [[tmux display-message -p -t '{right-of}' '#{pane_id}']])
    if vim.v.shell_error ~= 0 or fallback == '' then
        return nil, 'No pi pane found and no pane to the right'
    end

    return fallback
end

local function send_to_pi(text)
    if not text or vim.trim(text) == '' then
        vim.notify('Nothing to send', vim.log.levels.WARN)
        return
    end

    local pane_id, err = get_right_tmux_pane()
    if not pane_id then
        vim.notify(err, vim.log.levels.ERROR)
        return
    end

    local load_out = vim.fn.system({ 'tmux', 'load-buffer', '-' }, text)
    if vim.v.shell_error ~= 0 then
        vim.notify('Failed to load tmux buffer: ' .. vim.trim(load_out), vim.log.levels.ERROR)
        return
    end

    vim.fn.system { 'tmux', 'paste-buffer', '-d', '-t', pane_id }
    vim.fn.system { 'tmux', 'send-keys', '-t', pane_id, 'Enter' }
end

local function pi_prompt()
    local q = vim.trim(vim.fn.input 'Ask Pi: ')
    return q ~= '' and q or nil
end

local function buf_path()
    local p = vim.api.nvim_buf_get_name(0)
    return (p and p ~= '') and vim.fn.fnamemodify(p, ':p') or nil
end

-- <leader>o — ask Pi with current buffer as context
keymap('n', '<leader>oo', function()
    local question = pi_prompt()
    if not question then
        return
    end
    local path = buf_path()
    if not path then
        vim.notify('Current buffer has no file path', vim.log.levels.ERROR)
        return
    end
    send_to_pi(question .. ' (context file: ' .. path .. ')')
end, '[P]i ask with current [B]uffer path')

-- <leader>o — ask Pi with visual selection line range as context
keymap('x', '<leader>oo', function()
    local s = vim.fn.line 'v'
    local e = vim.fn.line '.'
    if s > e then
        s, e = e, s
    end
    local path = buf_path()

    local question = pi_prompt()
    if not question then
        return
    end
    if not path then
        vim.notify('Current buffer has no file path', vim.log.levels.ERROR)
        return
    end
    send_to_pi(question .. ' (context file: ' .. path .. ', lines ' .. s .. '-' .. e .. ')')
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
end, '[P]i ask with [V]isual selection')

-- <leader>od — send all LSP diagnostics from buffer to pi (with optional prompt)
keymap('n', '<leader>od', function()
    local diagnostics = vim.diagnostic.get(0)
    if #diagnostics == 0 then
        vim.notify('No diagnostics found in current buffer', vim.log.levels.INFO)
        return
    end

    local lines = {}
    for _, d in ipairs(diagnostics) do
        local sev = ({ 'ERROR', 'WARN', 'INFO', 'HINT' })[d.severity] or 'UNKNOWN'
        local src = d.source and (' [' .. d.source .. ']') or ''
        table.insert(lines, string.format('[%s] Line %d:%s %s', sev, d.lnum + 1, src, d.message))
    end

    local diag_text = 'LSP Diagnostics for ' .. (buf_path() or 'current buffer') .. ':\n' .. table.concat(lines, '\n')

    local question = pi_prompt()
    if question then
        send_to_pi(question .. '\n\n' .. diag_text)
    else
        send_to_pi(diag_text)
    end
end, '[P]i send buffer [D]iagnostics')
