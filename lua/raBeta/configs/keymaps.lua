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
keymap('n', '<leader>th', function()
    vim.o.cmdheight = vim.o.cmdheight == 0 and 1 or 0
end, 'toggle [C]ommand height')
keymap('n', '<leader>tm', '<cmd>Markview Toggle<CR>', 'toggle [M]arkview')
keymap('n', '<leader>tc', function()
    local status = require("copilot.client").is_disabled()
    if status then
        vim.cmd("Copilot enable")
        vim.notify("Copilot enable", vim.log.levels.INFO)
    else
        vim.cmd("Copilot disable")
        vim.notify("Copilot disable", vim.log.levels.INFO)
    end
end, 'toggle [C]opilot')

-- Lazy
keymap('n', "<leader>ps", '<cmd>Lazy sync<cr>', 'Lazy [S]ync')
keymap('n', "<leader>pi", '<cmd>Lazy install<cr>', 'Lazy [I]nstall')
keymap('n', "<leader>pu", "<cmd>Lazy update<cr>", 'Lazy [U]update')
keymap('n', "<leader>pc", "<cmd>Lazy clean<cr>", 'Lazy [C]lean')

-- NOTE: code to debug table
-- print(vim.inspect())
-- vim.notify(vim.inspect())

-- CodeCompanion
keymap({ "n", "v" }, "<leader>ac", "<cmd>CodeCompanionActions<cr>", "CodeCompanionActions")
keymap({ "n", "v" }, "<LocalLeader>aa", "<cmd>CodeCompanionChat Toggle<cr>", "CodeCompanionChat")
keymap("v", "ga", "<cmd>CodeCompanionChat Add<cr>")

-- Git
keymap('n', '<leader>gl', function()
    -- TODO: refactor this code...
    local bufnr = vim.fn.winbufnr(0)
    local win = vim.fn.win_findbuf(bufnr)[1]
    local pos = vim.fn.getcurpos(win)
    local line = vim.fn.string(pos[2])
    local file_name = vim.api.nvim_buf_get_name(0)
    local cmd = "git blame -L " .. line .. "," .. line .. " -- " .. file_name
    local blame = vim.fn.string(vim.fn.system(cmd))

    local split_blame = vim.fn.split(blame, ")")
    local part_blame = vim.fn.strpart(split_blame[1], 1)
    local second_split_blame = vim.fn.split(part_blame, "(")
    local split_time_info = vim.fn.split(second_split_blame[2], " +")
    local time_author = vim.fn.split(split_time_info[1], " ")

    local commit = second_split_blame[1]
    local date = ""
    local author = ""

    for i, x in pairs(time_author) do
        if x:match('%d') then
            date = date .. " " .. x
        else
            author = author .. " " .. x
        end
    end

    vim.notify(' GIT Blame\n ---------     \n ' .. author .. '     \n ' .. date .. '     \n ' .. commit .. '    \n ', 2)
end, '[G]it blame [L]ine')

-- Terminal & external commands
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
