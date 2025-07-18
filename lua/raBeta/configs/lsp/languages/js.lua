local dap = require 'dap'
local mason_path = vim.fn.glob(vim.fn.stdpath 'data' .. '/mason/')

require('dap-vscode-js').setup {
    node_path = 'node', -- Path of node executable. Defaults to $NODE_PATH, and then "node"
    debugger_path = mason_path .. 'packages/js-debug-adapter/js-debug-adapter', -- Path to vscode-js-debug installation.
    debugger_cmd = { 'js-debug-adapter' }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
    adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register in nvim-dap
    -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
    -- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
    -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
}
for _, language in ipairs { 'typescript', 'javascript' } do
    dap.configurations[language] = {
        {
            name = 'Launch',
            type = 'pwa-node',
            request = 'launch',
            program = '${file}',
            rootPath = '${workspaceFolder}',
            cwd = '${workspaceFolder}',
            sourceMaps = true,
            skipFiles = { '<node_internals>/**' },
            protocol = 'inspector',
            console = 'integratedTerminal',
        },
        {
            name = 'Attach to node process',
            type = 'pwa-node',
            request = 'attach',
            rootPath = '${workspaceFolder}',
            processId = require('dap.utils').pick_process,
        },
    }
end
