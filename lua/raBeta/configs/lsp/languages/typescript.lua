local dap = require 'dap'
local utils = require 'dap.utils'
local mason_path = vim.fn.glob(vim.fn.stdpath 'data' .. '/mason/')

if not dap.adapters['pwa-node'] then
    dap.adapters['pwa-node'] = {
        type = 'server',
        host = 'host.docker.internal',
        port = '${port}',
        executable = {
            command = 'node',
            -- 💀 Make sure to update this path to point to your installation
            args = { mason_path .. 'packages/js-debug-adapter/js-debug/src/dapDebugServer.js' },
        },
    }
end
if not dap.adapters['node'] then
    dap.adapters['node'] = function(cb, config)
        if config.type == 'node' then
            config.type = 'pwa-node'
        end
        local nativeAdapter = dap.adapters['pwa-node']
        if type(nativeAdapter) == 'function' then
            nativeAdapter(cb, config)
        else
            cb(nativeAdapter)
        end
    end
end

local js_filetypes = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' }

local vscode = require 'dap.ext.vscode'
vscode.type_to_filetypes['node'] = js_filetypes
vscode.type_to_filetypes['pwa-node'] = js_filetypes

for _, language in ipairs(js_filetypes) do
    if not dap.configurations[language] then
        dap.configurations[language] = {
            {
                type = 'pwa-node',
                request = 'launch',
                name = 'Launch file',
                program = '${file}',
                cwd = '${workspaceFolder}',
                restart = true,
            },
            {
                type = 'pwa-node',
                request = 'attach',
                name = 'Attach',
                cwd = '${workspaceFolder}',
            },
        }
    end
end
