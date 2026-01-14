-- Version History Tracker for Neovim Optimization
-- Provides version control and change tracking for configuration optimizations

local M = {}

local documentation_integrator = require 'raBeta.optimization.documentation_integrator'
local performance_tracker = require 'raBeta.optimization.performance_tracker'

-- Logger utility
local function log(level, message)
    vim.notify('[VersionTracker] ' .. message, level)
end

-- Version history storage
local version_history = {}
local current_version = '1.0.0'

-- Data storage path
local data_dir = vim.fn.stdpath 'config' .. '/_bmad-output'
local version_file = data_dir .. '/version_history.json'

-- Load version history from file
local function load_version_history()
    local file = io.open(version_file, 'r')
    if file then
        local content = file:read '*all'
        file:close()
        local ok, data = pcall(vim.fn.json_decode, content)
        if ok and data then
            version_history = data.history or {}
            current_version = data.current_version or '1.0.0'
            log(vim.log.levels.INFO, 'Loaded version history')
        else
            log(vim.log.levels.WARN, 'Failed to decode version history file')
        end
    end
end

-- Save version history to file
local function save_version_history()
    vim.fn.mkdir(data_dir, 'p')
    local data = {
        current_version = current_version,
        history = version_history,
        last_updated = os.time(),
    }
    local file = io.open(version_file, 'w')
    if file then
        file:write(vim.fn.json_encode(data))
        file:close()
        log(vim.log.levels.INFO, 'Saved version history')
    else
        log(vim.log.levels.ERROR, 'Failed to save version history')
    end
end

-- Initialize version tracking
function M.init()
    load_version_history()
    -- Create initial version if none exists
    if #version_history == 0 then
        M.create_version('Initial optimization setup', {
            plugins_removed = 0,
            performance_baseline = 'established',
            features = { 'plugin audit', 'performance tracking', 'safe removal' },
        })
    end
    log(vim.log.levels.INFO, 'Version tracker initialized')
end

-- Create a new version entry
function M.create_version(description, changes)
    local version_entry = {
        version = current_version,
        timestamp = os.time(),
        description = description,
        changes = changes or {},
        performance_impact = {
            startup_time = performance_tracker.get_startup_stats(),
            memory_usage = performance_tracker.get_memory_stats(),
        },
    }

    table.insert(version_history, version_entry)

    -- Increment version (simple semantic versioning)
    local major, minor, patch = current_version:match '(%d+)%.(%d+)%.(%d+)'
    patch = tonumber(patch) + 1
    current_version = string.format('%s.%s.%d', major, minor, patch)

    save_version_history()
    log(vim.log.levels.INFO, string.format('Created version %s: %s', version_entry.version, description))
    return version_entry
end

-- Get version history
function M.get_history()
    return vim.deepcopy(version_history)
end

-- Get current version
function M.get_current_version()
    return current_version
end

-- Rollback to a specific version
function M.rollback_to_version(target_version)
    -- Find the target version
    local target_entry = nil
    for _, entry in ipairs(version_history) do
        if entry.version == target_version then
            target_entry = entry
            break
        end
    end

    if not target_entry then
        log(vim.log.levels.ERROR, 'Version ' .. target_version .. ' not found')
        return false
    end

    -- This would implement actual rollback logic
    -- For now, we'll just log the intention
    log(vim.log.levels.INFO, string.format('Would rollback to version %s: %s', target_version, target_entry.description))

    -- In a full implementation, this would:
    -- 1. Restore plugin configurations
    -- 2. Revert file changes
    -- 3. Restore performance baselines
    -- 4. Update documentation

    return true
end

-- Compare versions
function M.compare_versions(version1, version2)
    local v1_entry = nil
    local v2_entry = nil

    for _, entry in ipairs(version_history) do
        if entry.version == version1 then
            v1_entry = entry
        end
        if entry.version == version2 then
            v2_entry = entry
        end
    end

    if not v1_entry or not v2_entry then
        return nil
    end

    return {
        version1 = v1_entry,
        version2 = v2_entry,
        time_difference = v2_entry.timestamp - v1_entry.timestamp,
        changes_between = 'Version comparison analysis would go here',
    }
end

-- Generate version report
function M.generate_version_report()
    local report = {
        current_version = current_version,
        total_versions = #version_history,
        version_history = M.get_history(),
        generated_at = os.time(),
    }

    -- Save report
    local report_file = data_dir .. '/version_report.json'
    local file = io.open(report_file, 'w')
    if file then
        file:write(vim.fn.json_encode(report))
        file:close()
        log(vim.log.levels.INFO, 'Generated version report')
    end

    return report
end

return M