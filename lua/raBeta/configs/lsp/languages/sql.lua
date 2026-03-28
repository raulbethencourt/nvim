local function sqls_exec(command, arguments, range, callback)
    local clients = vim.lsp.get_clients { bufnr = 0, name = 'sqls' }
    if #clients == 0 then
        vim.notify('sqls is not attached to this buffer', vim.log.levels.ERROR)
        return
    end
    clients[1]:request('workspace/executeCommand', {
        command = command,
        arguments = arguments or {},
        range = range,
    }, callback or function(err, result)
        if err then
            vim.notify('sqls: ' .. err.message, vim.log.levels.ERROR)
            return
        end
        if result and result ~= '' then
            local lines = vim.split(result, '\n')
            local buf = vim.api.nvim_create_buf(false, true)
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
            vim.bo[buf].filetype = 'sqls_output'
            vim.bo[buf].modifiable = false
            local width = math.min(120, vim.o.columns - 4)
            local height = math.min(#lines + 1, math.floor(vim.o.lines * 0.6))
            vim.api.nvim_open_win(buf, true, {
                relative = 'editor',
                width = width,
                height = height,
                row = math.floor((vim.o.lines - height) / 2),
                col = math.floor((vim.o.columns - width) / 2),
                style = 'minimal',
                border = 'rounded',
                title = ' sqls: ' .. command .. ' ',
                title_pos = 'center',
            })
            vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = buf, silent = true })
        end
    end)
end

local function get_visual_range()
    local s = vim.fn.getpos "'<"
    local e = vim.fn.getpos "'>"
    return {
        start = { line = s[2] - 1, character = s[3] - 1 },
        ['end'] = { line = e[2] - 1, character = e[3] },
    }
end

local function execute_query(range)
    sqls_exec('executeQuery', { vim.uri_from_bufnr(0) }, range)
end

local function switch_database()
    sqls_exec('showDatabases', {}, nil, function(err, result)
        if err or not result then
            return
        end
        local databases = vim.split(vim.trim(result), '\n')
        vim.ui.select(databases, { prompt = 'Switch database:' }, function(choice)
            if choice then
                sqls_exec('switchDatabase', { choice }, nil, function(serr)
                    if serr then
                        vim.notify('sqls: ' .. serr.message, vim.log.levels.ERROR)
                    else
                        vim.notify('sqls: switched to ' .. choice, vim.log.levels.INFO)
                    end
                end)
            end
        end)
    end)
end

local function switch_connection()
    sqls_exec('showConnections', {}, nil, function(err, result)
        if err or not result then
            return
        end
        local connections = vim.split(vim.trim(result), '\n')
        vim.ui.select(connections, { prompt = 'Switch connection:' }, function(choice)
            if choice then
                local id = vim.split(choice, ' ')[1]
                sqls_exec('switchConnections', { id }, nil, function(serr)
                    if serr then
                        vim.notify('sqls: ' .. serr.message, vim.log.levels.ERROR)
                    else
                        vim.notify('sqls: switched to connection ' .. id, vim.log.levels.INFO)
                    end
                end)
            end
        end)
    end)
end

vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'sql', 'mysql' },
    callback = function(args)
        local buf = args.buf
        local opts = { buffer = buf, silent = true }

        -- Execute whole buffer query
        vim.keymap.set('n', '<leader>sq', function()
            execute_query(nil)
        end, vim.tbl_extend('force', opts, { desc = '[S]qls [Q]uery execute buffer' }))

        -- Execute visual selection
        vim.keymap.set('v', '<leader>sq', function()
            execute_query(get_visual_range())
        end, vim.tbl_extend('force', opts, { desc = '[S]qls [Q]uery execute selection' }))

        -- Show tables
        vim.keymap.set('n', '<leader>st', function()
            sqls_exec 'showTables'
        end, vim.tbl_extend('force', opts, { desc = '[S]qls show [T]ables' }))

        -- Switch database
        vim.keymap.set('n', '<leader>sd', switch_database, vim.tbl_extend('force', opts, { desc = '[S]qls switch [D]atabase' }))

        -- Switch connection
        vim.keymap.set('n', '<leader>sc', switch_connection, vim.tbl_extend('force', opts, { desc = '[S]qls switch [C]onnection' }))
    end,
})
