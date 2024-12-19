M = {}

---Return a floating window
---@param opts? {[any]?:integer}
---@return [any]
---
M.createFloatingWin = function(opts)
    opts = opts or {}

    -- Create an immutable scratch buffer that is wiped once hidden
    local buf = nil
    opts.buf = opts.buf or -1
    if vim.api.nvim_buf_is_valid(opts.buf) then
        buf = opts.buf
    else
        buf = vim.api.nvim_create_buf(false, true)
    end

    -- Create a floating window using the scratch buffer postioned in the middle
    local height = opts.height or math.ceil(vim.o.lines * 0.9) -- 90% of screen height
    local width = opts.width or math.ceil(vim.o.columns * 0.9) -- 90% of screen width
    local row = math.ceil((vim.o.lines - height) / 2)
    local col = math.ceil((vim.o.columns - width) / 2)

    ---@diagnostic disable-next-line: param-type-mismatch
    local win = vim.api.nvim_open_win(buf, true, {
        style = "minimal",
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        border = 'rounded'
    })
    return { buf = buf, win = win }
end

---Lounch cmd in popup window
---@param cmd? string?
---@param opts? {win?:integer}
---@return nil
---
M.launchCmdInFloatWin = function(cmd, opts)
    opts = opts or {}

    -- Create window to open term
    local win = require('raBeta.utils.utils').createFloatingWin(opts)

    -- Change to the window that is floating to ensure termopen uses correct size
    vim.api.nvim_set_current_win(win.win)

    -- Launch cmd in term
    vim.fn.termopen(cmd, {
        on_exit = function(_, _, _)
            ---@diagnostic disable-next-line: undefined-field
            if opts.close_term == true then
                if vim.api.nvim_win_is_valid(win.win) then
                    vim.api.nvim_win_close(win.win, true)
                end
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
---@return nil
---
M.keymap = function(mode, keys, func, desc)
    if not desc or string.len(desc) == 0 then
        desc = "keymap"
    end

    vim.keymap.set(mode, keys, func, { noremap = true, silent = true, desc = desc })
end

return M
