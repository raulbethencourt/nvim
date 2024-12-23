local utils = require('raBeta.utils.utils')
local state = {
    floating = {
        buf = -1,
        win = -1
    }
}

local toggleTerminal = function()
    if not vim.api.nvim_win_is_valid(state.floating.win) then
        state.floating = utils.createFloatingWin { buf = state.floating.buf }
        if vim.bo[state.floating.buf].buftype ~= "terminal" then
            vim.cmd.term()
        end
    else
        vim.api.nvim_win_hide(state.floating.win)
    end
end

-- Create flating terminal
vim.api.nvim_create_user_command("Floaterm", toggleTerminal, {})
utils.keymap({ 'n', 't' }, '<space>ot', '<cmd>Floaterm<CR>', '[F]loaterm')
