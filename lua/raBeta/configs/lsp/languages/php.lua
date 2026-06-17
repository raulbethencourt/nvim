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
        pathMappings = { ['/var/www/html/'] = '${workspaceFolder}' },
        log = true,
    },
    {
        name = 'Listen for Portal devilbox Xdebug',
        type = 'php',
        request = 'launch',
        port = 9003,
        pathMappings = { ['/shared/httpd/portal/app/'] = '${workspaceFolder}' },
        log = true,
    },
    {
        name = 'Listen for SuiteCrm devilbox Xdebug',
        type = 'php',
        request = 'launch',
        port = 9003,
        pathMappings = { ['/shared/httpd/suitecrm8/app/'] = '${workspaceFolder}' },
        log = true,
    },
    {
        name = 'Listen for External PHPUnit Tests',
        type = 'php',
        request = 'launch',
        port = 9003,
        pathMappings = function()
            local cwd = vim.fn.getcwd()
            return { [cwd] = cwd }
        end,
        log = true,
    },
    {
        name = 'Listen for External PHPUnit (Auto-detect)',
        type = 'php',
        request = 'launch',
        port = 9003,
        pathMappings = function()
            -- Auto-detect common project structures
            local cwd = vim.fn.getcwd()
            local home = vim.fn.expand('~')

            -- If we're in a subfolder of home, create mapping
            if string.find(cwd, home, 1, true) then
                return { [cwd] = cwd }
            end

            -- Fallback to current working directory
            return { [cwd] = cwd }
        end,
        log = true,
        stopOnEntry = false,
    },
    {
        name = 'PHPUnit - Debug All Tests',
        type = 'php',
        request = 'launch',
        port = 9003,
        program = '${workspaceFolder}/vendor/bin/phpunit',
        args = {},
        cwd = '${workspaceFolder}',
        runtimeExecutable = 'php',
        runtimeArgs = {
            '-dxdebug.mode=debug',
            '-dxdebug.start_with_request=yes',
            '-dxdebug.client_port=9003',
        },
        env = {
            XDEBUG_CONFIG = 'idekey=VSCODE',
        },
        console = 'integratedTerminal',
        log = true,
    },
    {
        name = 'PHPUnit - Debug Current Test File',
        type = 'php',
        request = 'launch',
        port = 9003,
        program = '${workspaceFolder}/vendor/bin/phpunit',
        args = { '${file}' },
        cwd = '${workspaceFolder}',
        runtimeExecutable = 'php',
        runtimeArgs = {
            '-dxdebug.mode=debug',
            '-dxdebug.start_with_request=yes',
            '-dxdebug.client_port=9003',
        },
        env = {
            XDEBUG_CONFIG = 'idekey=VSCODE',
        },
        console = 'integratedTerminal',
        log = true,
    },
}
