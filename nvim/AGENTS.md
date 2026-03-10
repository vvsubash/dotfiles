# AGENTS.md - Neovim Configuration

This is a Neovim configuration written in Lua using [lazy.nvim](https://github.com/folke/lazy.nvim) for plugin management.

## Project Overview

- **Language**: Lua
- **Plugin Manager**: lazy.nvim
- **Root**: `/Users/gayatri/dev/dotfiles/nvim/`

### File Layout

```
nvim/
  init.lua                  Entry point -- requires the three modules below
  AGENTS.md                 This file
  lua/
    options.lua             General vim settings (line numbers, indent, leader)
    keymaps.lua             Arrow key training and insert-mode remaps
    lazy_bootstrap.lua      lazy.nvim bootstrap and plugin auto-loader
    plugins/                One file per plugin, each returns a lazy.nvim spec
      rose-pine.lua         Color scheme
      telescope.lua         Fuzzy finder
      treesitter.lua        Syntax highlighting
      neo-tree.lua          File explorer
      opencode.lua          AI assistant integration
```

### Load Order

1. `init.lua` calls `require("options")`, `require("keymaps")`, `require("lazy_bootstrap")`
2. `lazy_bootstrap.lua` bootstraps lazy.nvim and uses `{ import = "plugins" }` to auto-discover every file in `lua/plugins/`
3. Each plugin file returns a table (or list of tables) that lazy.nvim processes

## Build/Lint/Test Commands

Since this is a Neovim configuration (not a software project), there are no traditional build commands.

### Linting

```bash
# Install luacheck for Lua linting
brew install luacheck

# Lint all Lua files
luacheck init.lua lua/
```

### Running Neovim

```bash
# Open Neovim with this config
nvim

# Or use the alias if configured
vim
```

### Single Test

This repository has no tests. If tests were added, they would run via:

```bash
# Example: using plenary.nvim's test harness
nvim --headless -u init.lua -c "PlenaryBustedDirectory tests/ {minimal_init = init.lua}"
```

### Lazy.nvim Commands

```bash
# Sync plugins (install/update)
nvim --headless -c "Lazy sync" -c "qa!"

# Check plugin status
nvim --headless -c "Lazy" -c "qa!"

# Clean unused plugins
nvim --headless -c "Lazy clean" -c "qa!"
```

## Code Style Guidelines

### General Conventions

1. **File Structure**: Modular layout with `init.lua` as entry point and `lua/` for modules
2. **Indentation**: 2 spaces (expandtab enabled)
3. **Line Endings**: Unix (LF)
4. **No trailing whitespace**

### Lua Patterns Used

- **Module require**: Use `require("module")` for loading plugins
- **Error handling**: Use `pcall` for safe require calls
  ```lua
  local ok, module = pcall(require, "module.name")
  if not ok then
    -- handle error
  end
  ```
- **String quotes**: Single quotes `' '` preferred, double quotes `" "` for multi-line strings

### Neovim API Usage

1. **Settings**: Use `vim.opt` for options
   ```lua
   vim.opt.expandtab = true
   vim.opt.shiftwidth = 2
   ```

2. **Keymaps**: Use `vim.keymap.set`
   ```lua
   vim.keymap.set({ "n", "i", "v" }, "<leader>key", "<cmd>Command<cr>", { desc = "Description" })
   ```

3. **Commands**: Use `vim.cmd` or Lua equivalents
   ```lua
   vim.cmd("set relativenumber")
   -- or
   vim.opt.relativenumber = true
   ```

4. **Autocommands**: Use `vim.api.nvim_create_autocmd`
   ```lua
   vim.api.nvim_create_autocmd("BufEnter", {
     pattern = "*.lua",
     callback = function(args) ... end,
   })
   ```

### Naming Conventions

- **Variables**: snake_case (e.g., `local my_var = 1`)
- **Functions**: snake_case (e.g., `function my_function() end`)
- **Tables/Modules**: snake_case
- **Constants**: SCREAMING_SNAKE_CASE (e.g., `local DEFAULT_OPTS = {...}`)
- **File names**: snake_case with hyphens for plugin files matching the plugin name (e.g., `neo-tree.lua`, `rose-pine.lua`)

### Plugin Configuration

Each plugin lives in its own file under `lua/plugins/`. The file must return a lazy.nvim spec table:

```lua
-- lua/plugins/my-plugin.lua
return {
  "owner/repo",
  dependencies = { "dependency/plugin" },
  lazy = false,  -- load at startup
  build = ":Command",
  config = function()
    require("plugin").setup({ option = true })
  end,
  keys = {
    { "<leader>key", "<cmd>Command<cr>", desc = "Description" },
  },
}
```

Guidelines:
1. One plugin per file (file name should match the plugin name)
2. Include dependencies in the `dependencies` table
3. Use `build` for post-install commands (e.g., `build = ":TSUpdate"`)
4. Use `config` function for plugin setup
5. Add keymaps using `vim.keymap.set` with leader prefix
6. Include `desc` in keymap options for documentation

### Error Handling

1. **Plugin loading**: Always use `pcall` or check if module exists
   ```lua
   local ok, builtin = pcall(require, "telescope.builtin")
   if ok and builtin then
     vim.keymap.set("n", "<leader>f", builtin.find_files, {})
   end
   ```

2. **Shell commands**: Check `vim.v.shell_error`
   ```lua
   local out = vim.fn.system({ "git", "clone", repo, target })
   if vim.v.shell_error ~= 0 then
     -- handle error
   end
   ```

3. **Plugin setup**: Wrap in pcall to prevent startup failures
   ```lua
   local ok, err = pcall(require, "plugin").setup
   if not ok then
     vim.notify("Failed to load plugin: " .. err, vim.log.levels.ERROR)
   end
   ```

### Module Organization

Order of `require()` calls in `init.lua`:
1. `options` -- General vim settings
2. `keymaps` -- Key remappings
3. `lazy_bootstrap` -- Plugin manager + all plugins

Within each module:
- Settings modules (`options.lua`, `keymaps.lua`): Plain imperative Lua, no return value needed
- Plugin modules (`lua/plugins/*.lua`): Must return a lazy.nvim spec table

### Treesitter

This config uses nvim-treesitter for syntax highlighting and indentation. When editing:
- Parser files are installed via `:TSUpdate` or lazy.nvim's build
- Supported languages: lua, javascript, typescript, vue, go, gomod, gosum, css

### Common Tasks

**Add a new plugin:**
1. Create a new file in `lua/plugins/` (e.g., `lua/plugins/my-plugin.lua`)
2. Return a lazy.nvim spec table from the file
3. Restart Neovim or run `:Lazy sync`

**Change a keymap:**
1. For general keymaps: edit `lua/keymaps.lua`
2. For plugin-specific keymaps: edit the corresponding `lua/plugins/*.lua` file
3. Use descriptive `desc` field

**Change settings:**
1. Edit `lua/options.lua` for vim settings
2. Edit the corresponding `lua/plugins/*.lua` file for plugin settings

**Update plugins:**
```bash
nvim --headless -c "Lazy sync" -c "qa!"
```

### Testing Changes

1. Open Neovim with this config: `nvim`
2. Test the change manually
3. If adding a plugin, verify it loads: `:Lazy`
4. Check for errors: `:messages`
