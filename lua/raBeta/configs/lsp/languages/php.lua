local dap = require 'dap'
local mason_path = vim.fn.glob(vim.fn.stdpath 'data' .. '/mason/')

dap.adapters.php = {
    type = 'executable',
    command = 'node',
    args = { mason_path .. 'packages/php-debug-adapter/extension/out/phpDebug.js' },
}

dap.configurations.php = {
    {
        name = 'Listen for dockerized Xdebug',
        type = 'php',
        request = 'launch',
        port = 9000,
        pathMappings = { ['/var/www/html/'] = "${workspaceFolder}" },
    },
    {
        name = 'Listen for devilbox Xdebug',
        type = 'php',
        request = 'launch',
        port = 9000,
        pathMappings = { ['/shared/httpd/portal/portal'] = "${workspaceFolder}" },
    },
    {
        name = 'Debug dockerized currently open script',
        type = 'php',
        request = 'launch',
        port = 9000,
        cwd = '${fileDirname}',
        program = '${file}',
        runtimeExecutable = 'php',
        pathMappings = { ['/var/www/html/'] = "${workspaceFolder}" },
    },
}
