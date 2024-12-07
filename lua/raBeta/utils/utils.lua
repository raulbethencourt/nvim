M = {}

---Return a floating window
---@param opts? {win?:integer}
---@return window
---
M.win = function(opts)
    opts = opts or {}

    -- Create an immutable scratch buffer that is wiped once hidden
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
    vim.api.nvim_set_option_value("modifiable", false, { buf = buf })

    -- Create a floating window using the scratch buffer postioned in the middle
    local height = math.ceil(vim.o.lines * 0.9)  -- 90% of screen height
    local width = math.ceil(vim.o.columns * 0.9) -- 90% of screen width
    local win = vim.api.nvim_open_win(buf, true, {
        style = "minimal",
        relative = "editor",
        width = width,
        height = height,
        row = math.ceil((vim.o.lines - height) / 2),
        col = math.ceil((vim.o.columns - width) / 2),
        border = 'rounded'
    })
    return win
end

---Lounch cmd in popup window
---@param cmd? string?
---@param opts? {win?:integer}
---
M.launchCmdFloatWin = function(cmd, opts)
    opts = opts or {}

    -- Create window to open term
    local win = M.win(opts)

    -- Change to the window that is floating to ensure termopen uses correct size
    vim.api.nvim_set_current_win(win)

    -- Launch cmd in term
    vim.fn.termopen(cmd, {
        on_exit = function(_, _, _)
            if vim.api.nvim_win_is_valid(win) then
                vim.api.nvim_win_close(win, true)
            end
        end
    })

    -- Start in terminal mode
    vim.cmd.startinsert()
end

---Creates alias for keymaps
---@param mode string|string[]
---@param keys string
---@param func string|function
---@param desc? string?
---
M.keymap = function(mode, keys, func, desc)
    if not desc or string.len(desc) == 0 then
        desc = "keymap"
    end

    vim.keymap.set(mode, keys, func, { noremap = true, silent = true, desc = desc })
end

return M
