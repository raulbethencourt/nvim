local utils = require("config.utils")
local keymap = utils.keymap

keymap("n", "<space>xf", ":source %<cr>", "Source [F]ile")

-- Terminal & external commands
keymap('n', '<leader>cp', function()
    utils.launch_cmd_in_floating_win(
        'lynx $(find "$HOME/Documents/manuals/php-chunked-xhtml/" | fzf --height=100 --bind=tab:up --bind=btab:down --bind=ctrl-g:first)',
        { close_term = true }
    )
end, '[C]md [P]hp manual')
keymap('n', '<leader>ci', function()
    local cmd = vim.fn.input("Write your cmd : ")
    utils.launch_cmd_in_floating_win(cmd, { close_term = false })
end, '[C]md [I]nput')

-- General
keymap('n', '<leader>ze', ':messages<cr>', 'Messages')
keymap('n', '<leader>zf', ':lua print(vim.api.nvim_buf_get_name(0))<cr>', 'Full path')
keymap('n', '<leader>zi', '<C-w>|', 'Maximize')
keymap('n', '<leader>zn', ':nohlsearch<cr>', '[N]o highlights')
keymap('n', '<leader>zo', '<C-w>=', 'Equilify')
keymap('v', '<leader>zs', [[:'<,'>!awk '{s+=$1} END {print s}'<cr>]], 'Visual [S]um')
keymap('v', '<leader>zm', [[:'<,'>!awk '{s*=$1} END {print s}'<cr>]], 'Visual [M]ultiplication')
keymap('n', '<C-d>', '<C-d>zz')
keymap('n', '<C-u>', '<C-u>zz')
keymap('n', 'n', 'nzzzv')
keymap('n', 'N', 'Nzzzv')

