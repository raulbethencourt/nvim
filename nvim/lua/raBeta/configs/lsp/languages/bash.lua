local dap = require "dap"
local mason_path = vim.fn.glob(vim.fn.stdpath 'data' .. '/mason/')
local bashdb_dir = mason_path .. 'packages/bash-debug-adapter/extension/bashdb_dir'

dap.adapters.sh = {
    type = "executable",
    command = mason_path .. 'bin/bash-debug-adapter',
}
dap.configurations.sh = {
    {
        name = "Launch Bash debugger",
        type = "sh",
        request = "launch",
        program = "${file}",
        cwd = "${fileDirname}",
        pathBashdb = bashdb_dir .. "/bashdb",
        pathBashdbLib = bashdb_dir,
        pathBash = "bash",
        pathCat = "cat",
        pathMkfifo = "mkfifo",
        pathPkill = "pkill",
        env = {},
        args = {},
        showDebugOutput = true,
        trace = true,
    }
}
