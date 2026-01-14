-- Safe Plugin Removal Module for Neovim Optimization
-- Provides functions to safely disable/enable plugins with rollback capability

local M = {}

-- Storage for backups: plugin_name -> {file_path, original_content}
local backups = {}

-- Logger utility
local function log(level, message)
    vim.notify('[SafeRemoval] ' .. message, level)
end

-- Find the file containing a plugin spec
local function find_plugin_file(plugin_name)
    -- Use ripgrep via bash to find the file
    local cmd = string.format("cd /home/rabeta/.config/nvim && rg -l '%s' lua/raBeta/plugins/", plugin_name)
    local result = vim.fn.system(cmd)
    if vim.v.shell_error ~= 0 then
        return nil
    end
    local files = vim.split(result, '\n')
    return files[1] and vim.trim(files[1]) or nil
end

-- Backup a plugin's spec
function M.backup_plugin(plugin_name)
    local file_path = find_plugin_file(plugin_name)
    if not file_path then
        log(vim.log.levels.ERROR, 'Plugin ' .. plugin_name .. ' not found in plugin files')
        return false
    end

    -- Read the file
    local content = vim.fn.readfile(file_path)
    backups[plugin_name] = {
        file_path = file_path,
        content = table.concat(content, '\n'),
    }
    log(vim.log.levels.INFO, 'Backed up plugin ' .. plugin_name)
    return true
end

-- Disable a plugin by adding disabled = true to its spec
function M.disable_plugin(plugin_name)
    if not backups[plugin_name] then
        if not M.backup_plugin(plugin_name) then
            return false
        end
    end

    local file_path = backups[plugin_name].file_path
    -- Read current content
    local lines = vim.fn.readfile(file_path)

    -- Find the plugin spec and add disabled = true
    -- Assume the spec starts with { and contains the plugin name
    for i, line in ipairs(lines) do
        if line:find("'" .. plugin_name .. "'") or line:find('"' .. plugin_name .. '"') then
            -- Find the closing } for this spec
            local indent = line:match '^(%s*)'
            local j = i
            local brace_count = 0
            while j <= #lines do
                if lines[j]:find '{' then
                    brace_count = brace_count + 1
                end
                if lines[j]:find '}' then
                    brace_count = brace_count - 1
                end
                if brace_count == 0 then
                    break
                end
                j = j + 1
            end
            -- Insert disabled = true after the plugin name line
            table.insert(lines, i + 1, indent .. '    disabled = true,')
            break
        end
    end

    -- Write back
    vim.fn.writefile(lines, file_path)
    log(vim.log.levels.INFO, 'Disabled plugin ' .. plugin_name .. '. Reload Neovim to apply.')
    return true
end

-- Restore a plugin by reverting the file
function M.restore_plugin(plugin_name)
    if not backups[plugin_name] then
        log(vim.log.levels.ERROR, 'No backup found for plugin ' .. plugin_name)
        return false
    end

    local backup = backups[plugin_name]
    vim.fn.writefile(vim.split(backup.content, '\n'), backup.file_path)
    backups[plugin_name] = nil
    log(vim.log.levels.INFO, 'Restored plugin ' .. plugin_name .. '. Reload Neovim to apply.')
    return true
end

-- List backed up plugins
function M.list_backups()
    local list = {}
    for name, _ in pairs(backups) do
        table.insert(list, name)
    end
    return list
end

return M