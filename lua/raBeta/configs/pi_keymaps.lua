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

    local bracketed_text = '\27[200~' .. text .. '\27[201~'
    local load_out = vim.fn.system({ 'tmux', 'load-buffer', '-' }, bracketed_text)
    if vim.v.shell_error ~= 0 then
        vim.notify('Failed to load tmux buffer: ' .. vim.trim(load_out), vim.log.levels.ERROR)
        return
    end

    vim.fn.system { 'tmux', 'paste-buffer', '-d', '-r', '-t', pane_id }
    vim.fn.system { 'tmux', 'send-keys', '-t', pane_id, 'Enter' }
end

---@class PiPromptWindow
---@field buf integer
---@field win integer
local function pi_prompt(on_submit)
    local width = math.min(math.max(math.floor(vim.o.columns * 0.6), 60), vim.o.columns - 4)
    local height = math.min(10, vim.o.lines - 4)
    ---@type PiPromptWindow
    local prompt_window = utils.create_floting_win {
        width = width,
        height = height,
        ---@diagnostic disable-next-line: assign-type-mismatch
        border = 'rounded',
    }

    local buf = prompt_window.buf
    local win_id = prompt_window.win

    vim.bo[buf].buftype = 'nofile'
    vim.bo[buf].bufhidden = 'wipe'
    vim.bo[buf].swapfile = false
    vim.bo[buf].filetype = 'markdown'
    vim.bo[buf].modifiable = true
    vim.wo[win_id].wrap = true
    vim.wo[win_id].linebreak = true
    vim.wo[win_id].cursorline = false
    vim.wo[win_id].signcolumn = 'no'
    vim.wo[win_id].number = false
    vim.wo[win_id].relativenumber = false
    vim.wo[win_id].statusline = ' Ask Pi - Ctrl-s submit, Esc cancel '

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { '' })

    local done = false
    local function close_prompt()
        if vim.api.nvim_win_is_valid(win_id) then
            vim.api.nvim_win_close(win_id, true)
        end
    end

    local function finish(text)
        if done then
            return
        end
        done = true
        close_prompt()
        on_submit(text)
    end

    local function submit()
        local text = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), '\n')
        text = vim.trim(text)
        finish(text ~= '' and text or nil)
    end

    local function cancel()
        finish(false)
    end

    vim.keymap.set({ 'i', 'n' }, '<C-s>', submit, { buffer = buf, silent = true, nowait = true, desc = 'Submit Pi prompt' })
    vim.keymap.set('n', '<CR>', submit, { buffer = buf, silent = true, nowait = true, desc = 'Submit Pi prompt' })
    vim.keymap.set({ 'i', 'n' }, '<Esc>', cancel, { buffer = buf, silent = true, nowait = true, desc = 'Cancel Pi prompt' })

    vim.api.nvim_create_autocmd('WinClosed', {
        pattern = tostring(win_id),
        once = true,
        callback = function()
            if not done then
                done = true
                on_submit(false)
            end
        end,
    })

    vim.api.nvim_set_current_win(win_id)
    vim.cmd.startinsert()
end

local function buf_path()
    local p = vim.api.nvim_buf_get_name(0)
    return (p and p ~= '') and vim.fn.fnamemodify(p, ':p') or nil
end

-- <leader>o — ask Pi with current buffer as context
keymap('n', '<leader>oo', function()
    local path = buf_path()
    if not path then
        vim.notify('Current buffer has no file path', vim.log.levels.ERROR)
        return
    end

    pi_prompt(function(question)
        if not question then
            return
        end
        send_to_pi(question .. ' (context file: ' .. path .. ')')
    end)
end, '[P]i ask with current [B]uffer path')

-- <leader>o — ask Pi with visual selection line range as context
keymap('x', '<leader>oo', function()
    local s = vim.fn.line 'v'
    local e = vim.fn.line '.'
    if s > e then
        s, e = e, s
    end

    local path = buf_path()
    if not path then
        vim.notify('Current buffer has no file path', vim.log.levels.ERROR)
        return
    end

    pi_prompt(function(question)
        if not question then
            return
        end
        send_to_pi(question .. ' (context file: ' .. path .. ', lines ' .. s .. '-' .. e .. ')')
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
    end)
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

    pi_prompt(function(question)
        if question == false then
            return
        end
        if question then
            send_to_pi(question .. '\n\n' .. diag_text)
        else
            send_to_pi(diag_text)
        end
    end)
end, '[P]i send buffer [D]iagnostics')
