M = {}

local utils = require("raBeta.utils.utils")
local keymap = utils.keymap

-- NOTE: stop space normal
keymap({ 'n', 'v' }, '<Space>', '<Nop>')

-- NOTE: toogle lualine
local hidden_all = 0
keymap('n', '<F7>', function()
    if hidden_all == 0 then
        hidden_all = 1
        vim.cmd 'set ls=0'
    else
        hidden_all = 0
        vim.cmd 'set ls=2'
    end
end, 'Toggle Hidde Statusline')

-- NOTE: TAB in general mode will move to text buffer
keymap('n', '<TAB>', '<cmd>bnext<cr>', 'Bnext')
keymap('n', '<S-TAB>', '<cmd>bprev<cr>', 'Bprev')
keymap('n', '<space>xf', ':source %<cr>', 'Source [F]ile')
keymap('n', '<leader>ts', function()
    if vim.o.spell == true then
        vim.o.spell = false
    else
        vim.o.spell = true
    end
end, 'toggle [S]pell')
keymap('n', '<leader>zb', ':bp<bar>sp<bar>bn<bar>bd!<cr>', '[B]uffer delete')
keymap('n', '<leader>zv', function()
    vim.cmd([[bp
    sp
    bn
    bd!
    q]])
end, '[B]uffer delete')

-- NOTE: Lazy
keymap('n', "<leader>ps", '<cmd>Lazy sync<cr>', 'Lazy [S]ync')
keymap('n', "<leader>pi", '<cmd>Lazy install<cr>', 'Lazy [I]nstall')
keymap('n', "<leader>pu", "<cmd>Lazy update<cr>", 'Lazy [U]update')
keymap('n', "<leader>pc", "<cmd>Lazy clean<cr>", 'Lazy [C]lean')

-- NOTE: Git
keymap('n', '<leader>gs', require('telescope.builtin').git_status, '[G]it [S]tatus')
keymap('n', '<leader>gr', require('telescope.builtin').git_branches, '[G]it b[R]anches')
keymap('n', '<leader>gb', '<cmd>Gitsigns blame_line<cr>', '[G]itsigns [B]lame line')
keymap('n', '<leader>gd', '<cmd>Gitsigns diffthis<cr>', '[G]itsigns [D]iff this')
keymap('n', '<leader>gl', function()
    utils.launch_cmd_in_floating_win(
        "git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset' --date=short",
        { close_term = false }
    )
end, '[G]it [L]ogs')

-- NOTE: Terminal & external commandes
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

-- NOTE: Gnereral
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

keymap('v', '<leader>/', '<Plug>(comment_toggle_linewise_visual)', 'Comments')
keymap('n', '<leader>/', '<Plug>(comment_toggle_linewise_current)', 'Comments')

keymap('n', '<C-Up>', ':resize +2<cr>')
keymap('n', '<C-Down>', ':resize -2<cr>')
keymap('n', '<C-Left>', ':vertical resize +2<cr>')
keymap('n', '<C-Right>', ':vertical resize -2<CR>')

keymap('v', '<', '<gv')
keymap('v', '>', '>gv')
keymap('i', '<A-j>', '<Esc>:m .+1<cr>==gi')
keymap('i', '<A-k>', '<Esc>:m .-2<cr>==gi')
keymap('v', '<A-j>', ":m '>+1<cr>gv-gv")
keymap('v', '<A-k>', ":m '<-2<cr>gv-gv")
keymap('v', 'p', '"_dP')
keymap('x', '<leader>p', [["_dP]])
keymap('n', '<C-d>', '<C-d>zz')
keymap('n', '<C-u>', '<C-u>zz')
keymap('n', 'n', 'nzzzv')
keymap('n', 'N', 'Nzzzv')

-- NOTE: Documentations
M.show_documentation = function()
    local filetype = vim.bo.filetype
    if vim.tbl_contains({ 'vim', 'help' }, filetype) then
        vim.cmd('h ' .. vim.fn.expand '<cword>')
    elseif vim.tbl_contains({ 'man' }, filetype) then
        vim.cmd('Man ' .. vim.fn.expand '<cword>')
    elseif vim.fn.expand '%:t' == 'Cargo.toml' then
        require('crates').show_popup()
    else
        vim.lsp.buf.hover()
    end
end
keymap('n', 'K', ":lua require('raBeta.configs.keymaps').show_documentation()<cr>")

return M
