local utils = require("raBeta.utils.utils")
local keymap = utils.keymap

-- stop space normal
keymap({ 'n', 'v' }, '<Space>', '<Nop>')

-- TAB in general mode will move to text buffer
keymap('n', '<TAB>', '<cmd>bnext<cr>', 'Bnext')
keymap('n', '<S-TAB>', '<cmd>bprev<cr>', 'Bprev')
keymap('n', '<space>xf', ':source %<cr>', 'Source [F]ile')
keymap('n', '<leader>zb', ':bp<bar>sp<bar>bn<bar>bd!<cr>', '[B]uffer delete')
keymap('n', '<leader>zv', function()
    vim.cmd([[bp
    sp
    bn
    bd!
    q]])
end, '[B]uffer delete')

-- Toggles
keymap('n', '<leader>ts', function()
    vim.o.spell = not vim.o.spell
end, 'toggle [S]pell')
keymap('n', '<leader>tr', function()
    vim.o.relativenumber = not vim.o.relativenumber
end, 'toggle [R]elativenumber')
keymap('n', '<leader>tl', function()
    vim.o.ls = vim.o.ls == 0 and 2 or 0
end, 'toggle status[L]ine')
keymap('n', '<leader>tc', function()
    vim.o.cmdheight = vim.o.cmdheight == 0 and 1 or 0
end, 'toggle [C]ommand height')

-- Render Markdown
keymap('n', '<leader>tm', '<cmd>RenderMarkdown toggle<CR>', 'toggle render [M]arkdown')

-- Lazy
keymap('n', "<leader>ps", '<cmd>Lazy sync<cr>', 'Lazy [S]ync')
keymap('n', "<leader>pi", '<cmd>Lazy install<cr>', 'Lazy [I]nstall')
keymap('n', "<leader>pu", "<cmd>Lazy update<cr>", 'Lazy [U]update')
keymap('n', "<leader>pc", "<cmd>Lazy clean<cr>", 'Lazy [C]lean')

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
keymap('n', '<leader>zp', ':lua print(unpack(vim.api.nvim_win_get_cursor(0)))<cr>', 'Cursor [P]osition')
keymap('v', '<leader>zs', [[:'<,'>!awk '{s+=$1} END {print s}'<cr>]], 'Visual [S]um')
keymap('v', '<leader>zm', [[:'<,'>!awk '{s*=$1} END {print s}'<cr>]], 'Visual [M]ultiplication')

keymap('n', '<leader>v', '<cmd>vsplit<cr>', '[V]split')
keymap('n', '<leader>h', '<cmd>split<cr>', 'Split')

-- resize windows
keymap('n', '<C-Up>', ':resize +2<cr>')
keymap('n', '<C-Down>', ':resize -2<cr>')
keymap('n', '<C-Left>', ':vertical resize +2<cr>')
keymap('n', '<C-Right>', ':vertical resize -2<CR>')

-- move text up & down
keymap('i', '<A-j>', '<Esc>:m .+1<cr>==gi')
keymap('i', '<A-k>', '<Esc>:m .-2<cr>==gi')
keymap('v', '<A-j>', ":m '>+1<cr>gv-gv")
keymap('v', '<A-k>', ":m '<-2<cr>gv-gv")

keymap('v', '<', '<gv')
keymap('v', '>', '>gv')
keymap('v', 'p', '"_dP')
keymap('x', '<leader>p', [["_dP]])
keymap('n', '<C-d>', '<C-d>zz')
keymap('n', '<C-u>', '<C-u>zz')
keymap('n', 'n', 'nzzzv')
keymap('n', 'N', 'Nzzzv')
