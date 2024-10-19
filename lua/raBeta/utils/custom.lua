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

M.keymap = function(mode, keys, func, desc)
    if desc then
        desc = desc
    end

    vim.keymap.set(mode, keys, func, { noremap = true, silent = true, desc = desc })
end


return M
