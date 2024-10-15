local dap = require('dap')
local mason_path = vim.fn.glob(vim.fn.stdpath 'data' .. '/mason/')

dap.adapters.lldb = {
    type = 'executable',
    command = { mason_path .. 'packages/codelldb/extension/lldb/bin/lldb' },
    name = 'lldb'
}

dap.configurations.zig = {
    {
        name = 'Launch',
        type = 'lldb',
        request = 'launch',
        program = '${workspaceFolder}/zig-out/bin/zig_hello_world.exe',
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},
    },
}
