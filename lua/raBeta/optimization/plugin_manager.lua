-- Plugin Inventory Module for Neovim Optimization
-- Provides functions to list and analyze installed plugins

local M = {}

-- Usage tracking table
local usage_stats = {}

-- Logger utility
local function log(level, message)
    vim.notify('[PluginManager] ' .. message, level)
end

-- Get plugin inventory with metadata
-- Returns a table of plugin metadata
function M.get_inventory()
    -- Ensure Lazy is loaded
    local ok, lazy = pcall(require, 'lazy')
    if not ok then
        log(vim.log.levels.ERROR, 'Lazy.nvim not found. Cannot retrieve plugin inventory.')
        return {}
    end

    local plugins = lazy.plugins()
    if not plugins then
        log(vim.log.levels.WARN, 'No plugins found in Lazy.')
        return {}
    end

    local inventory = {}
    for _, plugin in ipairs(plugins) do
        local metadata = {
            name = plugin.name or 'unknown',
            url = plugin.url or '',
            dir = plugin.dir or '',
            version = plugin.version or 'unknown',
            loaded = plugin.loaded or false,
            disabled = plugin.disabled or false,
            dependencies = plugin.dependencies or {},
            -- Add more fields as needed
        }
        table.insert(inventory, metadata)
    end

    log(vim.log.levels.INFO, string.format('Retrieved inventory for %d plugins', #inventory))
    return inventory
end

-- Track plugin usage
-- Call this when a plugin is used (e.g., on lazy load)
function M.track_usage(plugin_name)
    usage_stats[plugin_name] = (usage_stats[plugin_name] or 0) + 1
    log(vim.log.levels.DEBUG, string.format('Tracked usage for %s: %d times', plugin_name, usage_stats[plugin_name]))
end

-- Get usage statistics
function M.get_usage_stats()
    return vim.deepcopy(usage_stats)
end

-- Reset usage stats
function M.reset_usage_stats()
    usage_stats = {}
    log(vim.log.levels.INFO, 'Usage stats reset')
end

-- Enable automatic usage tracking via LazyLoad events
function M.enable_usage_tracking()
    vim.api.nvim_create_autocmd('User', {
        pattern = 'LazyLoad',
        callback = function(args)
            local plugin_name = args.data or args.match
            if plugin_name then
                M.track_usage(plugin_name)
            end
        end,
    })
    log(vim.log.levels.INFO, 'Automatic usage tracking enabled')
end

-- Get summary of plugin inventory
function M.get_summary()
    local inventory = M.get_inventory()
    local total = #inventory
    local loaded = 0
    local disabled = 0

    for _, plugin in ipairs(inventory) do
        if plugin.loaded then
            loaded = loaded + 1
        end
        if plugin.disabled then
            disabled = disabled + 1
        end
    end

    return {
        total_plugins = total,
        loaded_plugins = loaded,
        disabled_plugins = disabled,
        active_plugins = loaded - disabled,
    }
end

return M