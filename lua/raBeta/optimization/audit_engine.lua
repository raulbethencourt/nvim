-- Bottleneck Analysis Tool for Neovim Optimization
-- Identifies performance bottlenecks in plugin loading and operations

local M = {}

local plugin_manager = require('raBeta.optimization.plugin_manager')
local performance_tracker = require('raBeta.optimization.performance_tracker')

-- Logger utility
local function log(level, message)
    vim.notify('[BottleneckAnalyzer] ' .. message, level)
end

-- Analyze plugin load times (requires Lazy to be instrumented)
function M.analyze_plugin_load_times()
    local inventory = plugin_manager.get_inventory()
    local load_analysis = {}

    for _, plugin in ipairs(inventory) do
        -- Note: Actual load time measurement would require Lazy hooks
        -- This provides a basic analysis based on plugin metadata
        local analysis = {
            name = plugin.name,
            loaded = plugin.loaded,
            has_dependencies = #plugin.dependencies > 0,
            dependency_count = #plugin.dependencies,
            -- Estimated impact based on metadata
            estimated_impact = plugin.loaded and 'loaded' or 'not_loaded',
        }

        -- Simple heuristics for potential bottlenecks
        if plugin.loaded and #plugin.dependencies > 3 then
            analysis.potential_bottleneck = 'high_dependency_count'
        elseif not plugin.loaded then
            analysis.potential_bottleneck = 'lazy_loaded'
        else
            analysis.potential_bottleneck = 'normal'
        end

        table.insert(load_analysis, analysis)
    end

    log(vim.log.levels.INFO, string.format('Analyzed %d plugins for bottlenecks', #load_analysis))
    return load_analysis
end

-- Analyze memory usage patterns
function M.analyze_memory_patterns()
    local memory_stats = performance_tracker.get_memory_stats()
    if memory_stats.count == 0 then
        return { message = "No memory measurements available. Run measure_memory_usage() first." }
    end

    local analysis = {
        current_memory_kb = memory_stats.latest_kb,
        average_memory_kb = memory_stats.average_kb,
        memory_variance = memory_stats.max_kb - memory_stats.min_kb,
        measurements = memory_stats.count,
    }

    -- Memory efficiency assessment
    if analysis.current_memory_kb < 50000 then -- 50MB
        analysis.efficiency = 'excellent'
    elseif analysis.current_memory_kb < 100000 then -- 100MB
        analysis.efficiency = 'good'
    elseif analysis.current_memory_kb < 200000 then -- 200MB
        analysis.efficiency = 'moderate'
    else
        analysis.efficiency = 'high'
    end

    analysis.recommendations = {}
    if analysis.efficiency == 'high' then
        table.insert(analysis.recommendations, 'Consider plugin audit and removal')
        table.insert(analysis.recommendations, 'Review lazy loading configuration')
    elseif analysis.efficiency == 'moderate' then
        table.insert(analysis.recommendations, 'Monitor memory growth over time')
    end

    return analysis
end

-- Analyze startup time patterns
function M.analyze_startup_patterns()
    local startup_stats = performance_tracker.get_startup_stats()
    if startup_stats.count == 0 then
        return { message = "No startup measurements available. Run measure_startup_time() first." }
    end

    local analysis = {
        current_startup_ms = startup_stats.latest_ms,
        average_startup_ms = startup_stats.average_ms,
        startup_variance = startup_stats.max_ms - startup_stats.min_ms,
        measurements = startup_stats.count,
    }

    -- Startup performance assessment
    if analysis.current_startup_ms < 100 then
        analysis.performance = 'excellent'
    elseif analysis.current_startup_ms < 200 then
        analysis.performance = 'good'
    elseif analysis.current_startup_ms < 500 then
        analysis.performance = 'moderate'
    else
        analysis.performance = 'slow'
    end

    analysis.recommendations = {}
    if analysis.performance == 'slow' then
        table.insert(analysis.recommendations, 'Audit plugin loading - consider lazy loading')
        table.insert(analysis.recommendations, 'Review VimEnter autocmds for blocking operations')
        table.insert(analysis.recommendations, 'Consider removing unused plugins')
    elseif analysis.performance == 'moderate' then
        table.insert(analysis.recommendations, 'Monitor startup time trends')
        table.insert(analysis.recommendations, 'Optimize plugin loading order')
    end

    return analysis
end

-- Generate comprehensive bottleneck report
function M.generate_bottleneck_report()
    local report = {
        plugin_analysis = M.analyze_plugin_load_times(),
        memory_analysis = M.analyze_memory_patterns(),
        startup_analysis = M.analyze_startup_patterns(),
        generated_at = os.time(),
    }

    -- Overall assessment
    report.overall_assessment = {
        total_plugins = #report.plugin_analysis,
        loaded_plugins = 0,
        high_dependency_plugins = 0,
        memory_efficiency = report.memory_analysis.efficiency,
        startup_performance = report.startup_analysis.performance,
    }

    for _, plugin in ipairs(report.plugin_analysis) do
        if plugin.loaded then
            report.overall_assessment.loaded_plugins = report.overall_assessment.loaded_plugins + 1
        end
        if plugin.dependency_count > 3 then
            report.overall_assessment.high_dependency_plugins = report.overall_assessment.high_dependency_plugins + 1
        end
    end

    -- Priority recommendations
    report.priority_recommendations = {}

    if report.overall_assessment.startup_performance == 'slow' then
        table.insert(report.priority_recommendations, 'HIGH: Optimize startup time - audit plugin loading')
    end

    if report.overall_assessment.memory_efficiency == 'high' then
        table.insert(report.priority_recommendations, 'HIGH: Reduce memory usage - plugin audit recommended')
    end

    if report.overall_assessment.high_dependency_plugins > 0 then
        table.insert(report.priority_recommendations, string.format('MEDIUM: %d plugins have high dependency counts', report.overall_assessment.high_dependency_plugins))
    end

    -- Save report
    local data_dir = vim.fn.stdpath('config') .. '/_bmad-output'
    vim.fn.mkdir(data_dir, 'p')
    local report_file = data_dir .. '/bottleneck_report.json'
    local file = io.open(report_file, 'w')
    if file then
        file:write(vim.fn.json_encode(report))
        file:close()
        log(vim.log.levels.INFO, 'Bottleneck report saved to ' .. report_file)
    end

    return report
end

-- Quick performance check
function M.quick_performance_check()
    local memory = performance_tracker.measure_memory_usage()
    local startup = performance_tracker.get_startup_stats()

    local check = {
        memory_kb = memory,
        startup_measurements = startup.count,
        latest_startup_ms = startup.latest_ms,
        assessment = 'unknown',
    }

    if startup.count > 0 then
        if check.latest_startup_ms < 200 and memory < 100000 then
            check.assessment = 'good'
        elseif check.latest_startup_ms < 500 or memory < 200000 then
            check.assessment = 'moderate'
        else
            check.assessment = 'needs_attention'
        end
    end

    log(vim.log.levels.INFO, string.format('Quick check: %s performance (%.1f KB memory, %d startup measurements)',
        check.assessment, memory, startup.count))

    return check
end

return M