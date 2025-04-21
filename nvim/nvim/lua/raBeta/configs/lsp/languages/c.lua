local dap = require('dap')
local mason_path = vim.fn.glob(vim.fn.stdpath 'data' .. '/mason/')

dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
        command = { mason_path .. 'packages/codelldb/extension/lldb/bin/lldb' },
        args = { "--port", "${port}" },
    },
}

dap.configurations.c = {
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
