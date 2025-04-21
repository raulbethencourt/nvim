M = {}

M.phpManual = function()
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_open_win(buf, true, {
        relative = 'win',
        row = 4,
        col = 4,
        width = 250,
        height = 60,
        border = 'rounded'
    })

    local cmd =
    'lynx $(find "$HOME/Documents/manuals/php-chunked-xhtml/" | fzf --height=100 --bind=tab:up --bind=btab:down --bind=ctrl-g:first)'

    vim.cmd.terminal(cmd)
end

return M
