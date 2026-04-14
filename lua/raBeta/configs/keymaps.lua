local utils = require 'raBeta.utils.utils'
local keymap = utils.keymap

-- stop space normal
keymap({ 'n', 'v' }, '<Space>', '<Nop>')

-- TAB in general mode will move to text buffer
keymap('n', '<TAB>', '<cmd>bnext<cr>', 'Bnext')
keymap('n', '<S-TAB>', '<cmd>bprev<cr>', 'Bprev')
keymap('n', '<space>zz', ':source %<cr>', 'Source [F]ile')
keymap('n', '<leader>zb', ':bp<bar>sp<bar>bn<bar>bd!<cr>', '[B]uffer delete')
keymap('n', '<leader>zv', function()
    vim.cmd [[bp
    sp
    bn
    bd!
    q]]
end, '[B]uffer delete')

-- Toggles
keymap('n', '<leader>ts', function()
    vim.o.spell = not vim.o.spell
end, 'toggle [S]pell')
keymap('n', '<leader>tr', function()
    vim.o.relativenumber = not vim.o.relativenumber
end, 'toggle [R]elativenumber')
keymap('n', '<leader>tj', function()
    vim.o.cmdheight = vim.o.cmdheight == 0 and 1 or 0
    vim.o.ls = vim.o.ls == 0 and 2 or 0
end, 'toggle command [H]eight and show line')
keymap('n', '<leader>tm', '<cmd>RenderMarkdown toggle<CR>', 'toggle [M]arkview')
-- IMPORTANT: Need inlyne installed to make it works
keymap('n', '<leader>ti', ':!inlyne view "%" -t dark<CR>', 'toggle [I]nlyne')
-- IMPORTANT: Need obisdian installed to make it works
keymap('n', '<leader>to', '<cmd>ObsidianOpen<CR>', 'toggle [I]nlyne')


-- Quickfix
keymap('n', '<leader>qn', '<cmd>cnext<cr>', '[Q]uickfix [N]ext')
keymap('n', '<leader>qp', '<cmd>cprevious<cr>', '[Q]uickfix [P]revius')
keymap('n', '<leader>qf', '<cmd>cfirst<cr>', '[Q]uickfix [F]irst')
keymap('n', '<leader>ql', '<cmd>clast<cr>', '[Q]uickfix [L]ast')
keymap('n', '<leader>qt', function()
    local qf_exists = false
    for _, win in pairs(vim.fn.getwininfo()) do
        if win.quickfix == 1 then
            qf_exists = true
            break
        end
    end
    vim.cmd(qf_exists and 'cclose' or 'copen')
end, '[Q]uickfix [T]oggle')

-- Lazy
keymap('n', '<leader>ps', '<cmd>Lazy sync<cr>', 'Lazy [S]ync')
keymap('n', '<leader>pi', '<cmd>Lazy install<cr>', 'Lazy [I]nstall')
keymap('n', '<leader>pu', '<cmd>Lazy update<cr>', 'Lazy [U]update')
keymap('n', '<leader>pc', '<cmd>Lazy clean<cr>', 'Lazy [C]lean')

-- Git
keymap('n', '<leader>gl', function()
    -- TODO: refactor this code...
    local bufnr = vim.fn.winbufnr(0)
    local win = vim.fn.win_findbuf(bufnr)[1]
    local pos = vim.fn.getcurpos(win)
    local line = vim.fn.string(pos[2])
    local file_name = vim.api.nvim_buf_get_name(0)
    local cmd = 'git blame -L ' .. line .. ',' .. line .. ' -- ' .. file_name
    local blame = vim.fn.string(vim.fn.system(cmd))

    local split_blame = vim.fn.split(blame, ')')
    local part_blame = vim.fn.strpart(split_blame[1], 1)
    local second_split_blame = vim.fn.split(part_blame, '(')
    local split_time_info = vim.fn.split(second_split_blame[2], ' +')
    local time_author = vim.fn.split(split_time_info[1], ' ')

    local commit = second_split_blame[1]
    local date = ''
    local author = ''

    for i, x in pairs(time_author) do
        if x:match '%d' then
            date = date .. ' ' .. x
        else
            author = author .. ' ' .. x
        end
    end

    vim.notify(' GIT Blame\n ---------     \n ' .. author .. '     \n ' .. date .. '     \n ' .. commit .. '    \n ', 2)
end, '[G]it blame [L]ine')

-- Terminal & external commands
keymap('n', '<leader>ci', function()
    local cmd = vim.fn.input 'Write your cmd : '

    utils.launch_cmd_in_floating_win(cmd, { close_term = false })
end, '[C]md [I]nput')

-- General
keymap('n', '<leader>ze', function()
    vim.cmd 'messages | Fidget history'
end, 'Messages and notifications')
keymap('n', '<leader>zf', ':%s/\\%x1b\\[27;5;106\\~ \\?/\\r/g<CR>', 'Fix paste escape sequences')
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

-- Fix Ctrl+V paste in insert mode (modifyOtherKeys terminal issue)
keymap('i', '<C-v>', '<C-r>+', 'Paste from clipboard')

keymap('n', '<C-d>', '<C-d>zz')
keymap('n', '<C-u>', '<C-u>zz')
keymap('n', 'n', 'nzzzv')
keymap('n', 'N', 'Nzzzv')

-- Optimization
-- Plugin Analysis
keymap('n', '<leader>wa', ':lua vim.notify(vim.inspect(require("raBeta.optimization.plugin_manager").get_summary()))<cr>', 'Plugin summary')
keymap('n', '<leader>wb', ':lua vim.notify(vim.inspect(require("raBeta.optimization.audit_engine").analyze_plugin_load_times()))<cr>', 'Plugin categories')
keymap('n', '<leader>wc', ':lua vim.notify(vim.inspect(require("raBeta.optimization.plugin_manager").get_usage_stats()))<cr>', 'Usage statistics')
keymap('n', '<leader>wd', ':lua vim.notify("Unused plugins analysis not implemented yet")<cr>', 'Unused plugins')

-- Performance Measurement
keymap('n', '<leader>wpm', ':lua require("raBeta.optimization.performance_tracker").measure_memory_usage()<cr>', 'Memory usage')
keymap('n', '<leader>wps', ':lua require("raBeta.optimization.performance_tracker").measure_startup_time()<cr>', 'Startup time')
keymap('n', '<leader>wpr', ':lua require("raBeta.optimization.performance_tracker").generate_report()<cr>', 'Performance report')
keymap('n', '<leader>wpb', ':lua vim.notify(vim.inspect(require("raBeta.optimization.audit_engine").quick_performance_check()))<cr>', 'Quick performance check')

-- Plugin Management
keymap('n', '<leader>wrs', ':lua local plugin = vim.fn.input("Plugin name: "); vim.notify("Simulate removal for " .. plugin)<cr>', 'Simulate plugin removal')
keymap('n', '<leader>wrd', ':lua vim.notify(vim.inspect(require("raBeta.optimization.documentation_integrator").list_rationales()))<cr>', 'Removal rationales')

-- Documentation
keymap('n', '<leader>wdd', ':lua require("raBeta.optimization.documentation_integrator").generate_documentation()<cr>', 'Generate documentation')
keymap('n', '<leader>wdr', ':lua vim.notify(vim.inspect(require("raBeta.optimization.documentation_integrator").list_rationales()))<cr>', 'Plugin rationales')

-- Version Tracking
keymap('n', '<leader>wvc', ':lua local desc = vim.fn.input("Version description: "); require("raBeta.optimization.version_tracker").create_version(desc)<cr>', 'Create version')
keymap('n', '<leader>wvh', ':lua vim.notify(vim.inspect(require("raBeta.optimization.version_tracker").get_history()))<cr>', 'Version history')
keymap('n', '<leader>wvv', ':lua vim.notify("Current version: " .. require("raBeta.optimization.version_tracker").get_current_version())<cr>', 'Current version')
keymap('n', '<leader>wvr', ':lua local ver = vim.fn.input("Target version: "); require("raBeta.optimization.version_tracker").rollback_to_version(ver)<cr>', 'Rollback version')

-- General Optimization
keymap('n', '<leader>woa', ':lua require("raBeta.optimization.audit_engine").generate_bottleneck_report()<cr>', 'Complete audit')
keymap('n', '<leader>wor', ':lua require("raBeta.optimization.audit_engine").generate_bottleneck_report()<cr>', 'Full optimization report')
