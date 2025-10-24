# Agent Guidelines for Neovim Config

## Build/Lint/Test Commands

### Linting

- **Lua**: `stylua --check .` (check formatting) or `stylua .` (format)
- **General**: `:lua vim.lsp.buf.format()` in Neovim for LSP formatting
- **Markdown**: `markdownlint *.md` (via none-ls)

### Testing

- **Single test**: No specific test framework configured
- **Load config**: `nvim --headless -c "lua require 'raBeta.configs'" -c "qa"`

## Code Style Guidelines

### Formatting

- **Lua**: 4 spaces indentation, 160 column width, Unix line endings, single quotes preferred
- **General**: 4 spaces indentation, LF line endings, final newline required
- **Tools**: Stylua for Lua, Prettier for web languages (TS/JS/HTML/CSS/SCSS)

### Imports & Structure

- **Lua modules**: Use `require 'module.path'` with dot notation
- **Plugin configs**: Separate config functions with descriptive comments
- **File organization**: `lua/raBeta/` for main config, `lua/vscode/` for VSCode mode

### Naming Conventions

- **Variables**: snake_case (e.g., `local keymap_opts`)
- **Functions**: snake_case with descriptive names
- **Modules**: PascalCase for plugin names, snake_case for internal modules
- **Constants**: UPPER_SNAKE_CASE where applicable

### Types & Error Handling

- **Type checking**: Enabled for Lua with lua_ls diagnostics
- **Error handling**: Use `assert()` for critical operations, check return values
- **Diagnostics**: Prefer LSP diagnostics over custom error messages

### Best Practices

- **Lazy loading**: Use `event`, `ft`, `cmd` triggers for plugin loading
- **Performance**: Minimize global state, use local variables
- **Documentation**: Add `-- NOTE:` comments for complex configurations
- **Security**: Never commit secrets or API keys

## LSP Configuration

- **Type checking**: Enabled with `diagnostics.enable = true`
- **Inlay hints**: Enabled for parameter and type hints
- **Completion**: Word completion disabled, keyword snippets disabled
- **Runtime**: LuaJIT with vim globals recognized