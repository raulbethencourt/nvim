-- NOTE: hidde lualine
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
    pattern = { '*' },
    command = 'set ls=0',
})

--NOTE:  hidde vim tabline
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
    pattern = { '*' },
    command = 'set showtabline=0 ',
})

-- NOTE: enable wrap mode for json files only
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
    pattern = { '*' },
    command = 'set fcs=eob:\\ ',
})

--NOTE: let treesitter use bash highlight for zsh files as well
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'zsh',
    callback = function()
        vim.treesitter.start(0, 'bash')
    end,
})

--NOTE: let treesitter use javascript highlight for hbs files as well
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'hbs',
    callback = function()
        vim.treesitter.start(0, 'javascript')
    end,
})

--NOTE: let treesitter understand all patterns for twig
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'twig',
    callback = function()
        vim.treesitter.start(0, 'twig')
    end,
})

-- NOTE: Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
})

-- NOTE: enter insert mode when opening terminal
vim.api.nvim_create_autocmd('TermOpen', {
    pattern = '*',
    command = 'startinsert',
})

-- NOTE: Claude tmux connection -- focus the pane actually running `claude` after a send
vim.api.nvim_create_autocmd('User', {
    pattern = 'ClaudeCodeSendComplete',
    callback = function(ev)
        -- ev.data.file_path / ev.data.start_line / ev.data.end_line / ev.data.context
        if not vim.env.TMUX then
            return
        end
        local pane_id = require('raBeta.utils.utils').find_tmux_pane_by_cmd 'claude'
        if pane_id then
            vim.fn.system { 'tmux', 'select-pane', '-t', pane_id }
        end
    end,
})
