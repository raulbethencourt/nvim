-- Plugin Audit Engine for Neovim Optimization
-- Provides tools for categorizing and analyzing plugins

local M = {}

local plugin_manager = require('raBeta.optimization.plugin_manager')

-- Logger utility
local function log(level, message)
    vim.notify('[AuditEngine] ' .. message, level)
end

-- Categorize plugins based on their purpose
-- This is a basic implementation; can be extended with more sophisticated logic
function M.categorize_plugins()
    local inventory = plugin_manager.get_inventory()
    local categories = {
        ui = {},
        lsp = {},
        edit = {},
        dev = {},
        debug = {},
        code = {},
        ai = {},
        other = {},
    }

    -- Simple categorization based on plugin name patterns
    local patterns = {
        ui = { 'ui', 'view', 'mark', 'ccc', 'fidget', 'status', 'tab', 'buffer' },
        lsp = { 'lsp', 'cmp', 'snip', 'mason', 'null-ls', 'none-ls' },
        edit = { 'surround', 'comment', 'tree', 'neo-tree', 'telescope' },
        dev = { 'git', 'diff', 'gitsigns', 'lazygit' },
        debug = { 'dap', 'debug' },
        code = { 'treesitter', 'syntax', 'highlight', 'indent' },
        ai = { 'copilot', 'ai', 'avante', 'codecompanion' },
    }

    for _, plugin in ipairs(inventory) do
        local categorized = false
        local name_lower = plugin.name:lower()

        for category, pats in pairs(patterns) do
            for _, pat in ipairs(pats) do
                if name_lower:find(pat) then
                    table.insert(categories[category], plugin)
                    categorized = true
                    break
                end
            end
            if categorized then break end
        end

        if not categorized then
            table.insert(categories.other, plugin)
        end
    end

    log(vim.log.levels.INFO, 'Plugins categorized')
    return categories
end

-- Get category summary
function M.get_category_summary()
    local categories = M.categorize_plugins()
    local summary = {}

    for cat, plugins in pairs(categories) do
        summary[cat] = #plugins
    end

    return summary
end

-- Identify potentially unused plugins based on usage tracking
function M.identify_unused_plugins()
    local inventory = plugin_manager.get_inventory()
    local usage = plugin_manager.get_usage_stats()
    local unused = {}

    for _, plugin in ipairs(inventory) do
        -- Consider a plugin unused if not loaded and no usage tracked
        if not plugin.loaded and (not usage[plugin.name] or usage[plugin.name] == 0) then
            table.insert(unused, plugin)
        end
    end

    log(vim.log.levels.INFO, string.format('Identified %d potentially unused plugins', #unused))
    return unused
end

-- Simulate plugin removal
-- Returns a simulation report for removing the given plugin names
function M.simulate_removal(plugin_names)
    local inventory = plugin_manager.get_inventory()
    local to_remove = {}
    local impacted_dependencies = {}

    for _, name in ipairs(plugin_names) do
        for _, plugin in ipairs(inventory) do
            if plugin.name == name then
                table.insert(to_remove, plugin)
                -- Check for dependencies
                if plugin.dependencies then
                    for _, dep in ipairs(plugin.dependencies) do
                        if not vim.tbl_contains(impacted_dependencies, dep) then
                            table.insert(impacted_dependencies, dep)
                        end
                    end
                end
                break
            end
        end
    end

    local report = {
        plugins_to_remove = to_remove,
        impacted_dependencies = impacted_dependencies,
        total_removed = #to_remove,
        -- Note: Actual performance impact would require load time data
        estimated_savings = 'Unknown (requires profiling data)',
    }

    log(vim.log.levels.INFO, string.format('Simulated removal of %d plugins', #to_remove))
    return report
end

return M